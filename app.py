from datetime import datetime
from functools import wraps
from flask import (
    Flask,
    render_template,
    url_for,
    request,
    redirect,
    session,
    flash,
    jsonify,
    make_response,
)
import pyodbc
import os
from werkzeug.utils import secure_filename
from flask_paginate import Pagination, get_page_parameter
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime, timedelta
import random
import pandas as pd
import pickle

app = Flask(__name__)

UPLOAD_FOLDER1 = "static/uploads/maison/"
UPLOAD_FOLDER = "static/uploads/location/"

ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg", "gif"}

app.secret_key = "votre_clé_secrète"

app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.config["UPLOAD_FOLDER1"] = UPLOAD_FOLDER1
app.config["PERMANENT_SESSION_LIFETIME"] = timedelta(
    days=1
)  # Durée de vie des sessions de 1 jour

# Configuration de la connexion à SQL Server
app.config[
    "SQL_SERVER_CONNECTION_STRING"
] = """
    Driver={SQL Server};
    Server=DESKTOP-JK6D8G9\SQLEXPRESS;
    Database=MV;
    Trusted_Connection=yes;"""


# Charger le pipeline
with open('best_pipeline.pkl', 'rb') as file:
    loaded_pipeline = pickle.load(file)



######## connexion / inscription  ###########


@app.route("/connexion", methods=["GET", "POST"])
def connexion():
    if request.method == "POST":
        Email = request.form["Email"]
        password = request.form["Mot_de_pass"]

        connection = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM Utilisateur WHERE Email = ?", (Email,))
        user = cursor.fetchone()

        if user and check_password_hash(user.Mot_de_pass, password):
            session["IdUtilisateur"] = user.IdUtilisateur
            session["user"] = user.Email
            return redirect(url_for("index"))
        else:
            print("Mauvaise adresse e-mail ou mot de passe.")

    return render_template("./formulaire/connexion/login.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        Nom_et_prenoms = request.form["Nom_et_prenoms"]
        Email = request.form["Email"]
        Mot_de_pass = request.form["Mot_de_pass"]
        Adresse = request.form["Adresse"]
        Telephone = request.form["Telephone"]

        # Vérifier si l'email existe déjà
        connection = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
        cursor = connection.cursor()
        cursor.execute("SELECT IdUtilisateur FROM Utilisateur WHERE Email=?", (Email,))
        existing_user = cursor.fetchone()

        if existing_user:
            flash(
                "L'adresse e-mail existe déjà. Veuillez choisir une autre adresse e-mail.",
                "error",
            )
            return redirect(url_for("register"))

        # Hacher le mot de passe
        hashed_password = generate_password_hash(Mot_de_pass)

        # Effectuer l'insertion uniquement si l'email n'existe pas
        cursor.execute(
            "INSERT INTO Utilisateur (Nom_et_prenoms, Email, Mot_de_pass, Adresse, Telephone) VALUES (?, ?, ?, ?, ?)",
            (Nom_et_prenoms, Email, hashed_password, Adresse, Telephone),
        )
        connection.commit()

        # Récupérer l'ID de l'utilisateur après l'insertion
        cursor.execute("SELECT IdUtilisateur FROM Utilisateur WHERE Email=?", (Email,))
        IdUtilisateur = cursor.fetchone()[0]

        session["IdUtilisateur"] = IdUtilisateur
        session["user"] = Email

        cursor.close()
        connection.close()

        return redirect(url_for("index"))

    return render_template("./formulaire/connexion/register.html")


def allowed_file1(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


# configuration de l'authentification requise pour toutes les pages
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "user" not in session:
            flash("Veuillez vous connecter pour accéder à cette page.", "danger")
            return redirect(url_for("connexion"))
        return f(*args, **kwargs)


###################################
@app.template_filter("add_line_breaks")
def add_line_breaks(s, width):
    """
    Ajoutez des sauts de ligne à une chaîne après une largeur spécifiée.

    Parameters:
    - s (str): Input string.
    - width (int): Maximum width before line break.

    Returns:
    - str: String with line breaks added.
    """
    return "\n".join([s[i : i + width] for i in range(0, len(s), width)])


###########################################################################################################################################################


#################################################################
@app.route("/")
def index():
    return render_template("index.html")


@app.route('/model_IA', methods=['GET', 'POST'])
def model_IA():
    predicted_price = None
    form_data = {}
    
    if request.method == 'POST':
        # Récupérer les données du formulaire
        form_data = {
            'Nombre_de_pieces': int(request.form['nombre_de_pieces']),
            'Nombre_de_chambres': int(request.form['nombre_de_chambres']),
            'Nombre_de_salles_de_bain': int(request.form['nombre_de_salles_de_bain']),
            'metre_carre': float(request.form['metre_carre']),
            'Ville': request.form['ville'],
            'Commune': request.form['commune'],
            'Quartier': request.form['quartier'],
            'Type_de_maison': request.form['type_de_maison'],
            'Descriptions': request.form['description']
        }

        # Créer un DataFrame pour la nouvelle maison
        new_house = pd.DataFrame([form_data])

        # Prédire le prix
        predicted_price = loaded_pipeline.predict(new_house)[0]

    return render_template('/formulaire/model_IA.html', predicted_price=predicted_price, form_data=form_data)

@app.route("/loue_maison", methods=["GET", "POST"])
def loue_maison():
    # Connexion à la base de données
    conn = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
    cursor = conn.cursor()

    # Récupération de la page actuelle depuis l'URL
    page = request.args.get(get_page_parameter(), type=int, default=1)
    per_page = 5  # Nombre d'éléments à afficher par page

    # Récupérer les filtres
    ville = request.args.get("Ville")
    commune = request.args.get("Commune")
    nombre_de_pieces = request.args.get("Nombre_de_pieces")
    prix_min = request.args.get("Prix_min")
    prix_max = request.args.get("Prix_max")

    # Construction de la requête SQL en fonction des filtres
    query_count = "SELECT COUNT(*) FROM Locations WHERE 1=1"
    params_count = []
    if ville:
        query_count += " AND Ville = ?"
        params_count.append(ville)
    if commune:
        query_count += " AND Commune = ?"
        params_count.append(commune)
    if nombre_de_pieces:
        query_count += " AND Nombre_de_pieces = ?"
        params_count.append(nombre_de_pieces)
    if prix_min:
        query_count += " AND Prix_mensuel >= ?"
        params_count.append(prix_min)
    if prix_max:
        query_count += " AND Prix_mensuel <= ?"
        params_count.append(prix_max)

    # Exécution de la requête pour obtenir le nombre total d'éléments
    cursor.execute(query_count, params_count)
    total_count = cursor.fetchone()[0]

    # Calcul de l'offset à partir de la page et du nombre d'éléments par page
    offset = (page - 1) * per_page

    # Construction de la requête SQL pour récupérer les éléments à afficher
    query_select = """
    SELECT l.*, COALESCE(ul.type_action, 'none') as type_action
    FROM Locations l
    LEFT JOIN user_like ul ON l.IdLocations = ul.IdLocations AND ul.idutilisateur = ?
    WHERE 1=1
    """
    params_select = [get_user_id()]
    if ville:
        query_select += " AND Ville = ?"
        params_select.append(ville)
    if commune:
        query_select += " AND Commune = ?"
        params_select.append(commune)
    if nombre_de_pieces:
        query_select += " AND Nombre_de_pieces = ?"
        params_select.append(nombre_de_pieces)
    if prix_min:
        query_select += " AND Prix_mensuel >= ?"
        params_select.append(prix_min)
    if prix_max:
        query_select += " AND Prix_mensuel <= ?"
        params_select.append(prix_max)

    query_select += " ORDER BY IdLocations OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
    params_select += [offset, per_page]

    # Exécution de la requête pour obtenir les éléments à afficher
    cursor.execute(query_select, params_select)
    loc_afi = cursor.fetchall()

    # Initialize an empty list to store processed data
    locations = []

    for row in loc_afi:
        # Process each row and extract the Image1 attribute
        images = row.Image1.split(",") if row.Image1 else []
        # Append a dictionary with the processed data to the locations list
        locations.append(
            {"row": row, "images": images, "liked": row.type_action == "like"}
        )

    # Configuration de la pagination avec le nombre total d'éléments et le nombre d'éléments par page
    pagination = Pagination(
        page=page, total=total_count, per_page=per_page, css_framework="bootstrap5"
    )

    # Fermeture du curseur et de la connexion
    cursor.close()
    conn.close()

    # Rendu du template avec les données récupérées et la pagination
    return render_template(
        "/page/loue_maison.html", locations=locations, pagination=pagination
    )


# Fonction pour récupérer l'ID utilisateur ou générer un cookie
# def get_user_id():
#     # Vérifier si l'utilisateur est connecté
#     if "IdUtilisateur" in session:
#         return session["IdUtilisateur"]
#     # Vérifier s'il existe déjà un cookie
#     elif "user_id" in session:
#         return session["user_id"]
#     else:
#         # Générer un cookie aléatoire pour identifier l'utilisateur et Stocker le cookie dans la session
#         session["user_id"] = random.randint(1, 1000000)
#         session.permanent = True  # Rendre la session permanente pour appliquer PERMANENT_SESSION_LIFETIME
#         return session["user_id"]



@app.route("/achete_maison", methods=["GET", "POST"])
def achete_maison():

    # Connexion à la base de données
    conn = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
    cursor = conn.cursor()

    # Récupération de la page actuelle depuis l'URL
    page = request.args.get(get_page_parameter(), type=int, default=1)

    # Nombre d'éléments à afficher par page
    per_page = 5

    # Définition des filtres
    ville = request.args.get("Ville")
    commune = request.args.get("Commune")
    nombre_de_pieces = request.args.get("Nombre_de_pieces")
    prix_min = request.args.get("Prix_min")
    prix_max = request.args.get("Prix_max")

    # Construction de la requête SQL en fonction des filtres
    query_count = "SELECT COUNT(*) FROM Maison WHERE 1=1"
    params_count = []

    if ville:
        query_count += " AND Ville = ?"
        params_count.append(ville)
    if commune:
        query_count += " AND Commune = ?"
        params_count.append(commune)
    if nombre_de_pieces:
        query_count += " AND Nombre_de_pieces = ?"
        params_count.append(nombre_de_pieces)
    if prix_min:
        query_count += " AND Prix_unitaire >= ?"
        params_count.append(prix_min)
    if prix_max:
        query_count += " AND Prix_unitaire <= ?"
        params_count.append(prix_max)

    # Exécution de la requête pour obtenir le nombre total d'éléments
    cursor.execute(query_count, params_count)
    total_count = cursor.fetchone()[0]

    # Calcul de l'offset à partir de la page et du nombre d'éléments par page
    offset = (page - 1) * per_page

    # Construction de la requête SQL pour récupérer les éléments à afficher
    query_select = """
    SELECT m.*, COALESCE(ul.type_action, 'none') as type_action
    FROM Maison m
    LEFT JOIN user_like ul ON m.IdMaison = ul.IdMaison AND ul.idutilisateur = ?
    WHERE 1=1
    """
    params_select = [get_user_id()]

    if ville:
        query_select += " AND Ville = ?"
        params_select.append(ville)
    if commune:
        query_select += " AND Commune = ?"
        params_select.append(commune)
    if nombre_de_pieces:
        query_select += " AND Nombre_de_pieces = ?"
        params_select.append(nombre_de_pieces)
    if prix_min:
        query_select += " AND Prix_unitaire >= ?"
        params_select.append(prix_min)
    if prix_max:
        query_select += " AND Prix_unitaire <= ?"
        params_select.append(prix_max)

    query_select += " ORDER BY IdMaison OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
    params_select += [offset, per_page]

    # Exécution de la requête pour obtenir les éléments à afficher
    cursor.execute(query_select, params_select)
    maison_ifo = cursor.fetchall()

    maison = []

    for row in maison_ifo:
        # Process each row and extract the Image1 attribute
        images = row.Image1.split(",") if row.Image1 else []
        # Append a dictionary with the processed data to the locations list
        maison.append({"row": row, "images": images})
    # Configuration de la pagination avec le nombre total d'éléments et le nombre d'éléments par page
    pagination = Pagination(
        page=page, total=total_count, per_page=per_page, css_framework="bootstrap5"
    )

    # Fermeture du curseur et de la connexion
    cursor.close()
    conn.close()

    return render_template(
        "/page/achete_maison.html", maison_ifo=maison, pagination=pagination
    )


@app.route("/like", methods=["POST"])
def like():
    data = request.json
    user_id = get_user_id()
    location_id = data.get("location_id")
    maison_id = data.get("maison_id")

    conn = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
    cursor = conn.cursor()

    if location_id:
        # Vérifier si un like existe déjà pour cet utilisateur et cette location
        cursor.execute(
            "SELECT type_action FROM user_like WHERE IdUtilisateur = ? AND IdLocations = ?",
            (user_id, location_id),
        )
        like = cursor.fetchone()
        if like:
            if like.type_action == "like":
                # Si déjà liké, le passer à 'none'
                cursor.execute(
                    "UPDATE user_like SET type_action = 'none' WHERE IdUtilisateur = ? AND IdLocations = ?",
                    (user_id, location_id),
                )
            else:
                # Sinon, le passer à 'like'
                cursor.execute(
                    "UPDATE user_like SET type_action = 'like' WHERE IdUtilisateur = ? AND IdLocations = ?",
                    (user_id, location_id),
                )
        else:
            # Sinon, créer un nouveau like
            cursor.execute(
                "INSERT INTO user_like (IdUtilisateur, IdLocations, type_action) VALUES (?, ?, 'like')",
                (user_id, location_id),
            )
    elif maison_id:
        # Vérifier si un like existe déjà pour cet utilisateur et cette maison
        cursor.execute(
            "SELECT type_action FROM user_like WHERE IdUtilisateur = ? AND IdMaison = ?",
            (user_id, maison_id),
        )
        like = cursor.fetchone()
        if like:
            if like.type_action == "like":
                # Si déjà liké, le passer à 'none'
                cursor.execute(
                    "UPDATE user_like SET type_action = 'none' WHERE IdUtilisateur = ? AND IdMaison = ?",
                    (user_id, maison_id),
                )
            else:
                # Sinon, le passer à 'like'
                cursor.execute(
                    "UPDATE user_like SET type_action = 'like' WHERE IdUtilisateur = ? AND IdMaison = ?",
                    (user_id, maison_id),
                )
        else:
            # Sinon, créer un nouveau like
            cursor.execute(
                "INSERT INTO user_like (IdUtilisateur, IdMaison, type_action) VALUES (?, ?, 'like')",
                (user_id, maison_id),
            )

    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({"status": "success"})



@app.route("/contacte", methods=["GET", "POST"])
def contacte():

    if request.method == "POST":
        prenom = request.form["prenom"]
        nom = request.form["nom"]
        email = request.form["email"]
        phone = request.form["phone"]
        message = request.form["message"]

        connection = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
        cursor = connection.cursor()
        # Utilisez le format de la date et heure approprié dans la requête SQL
        cursor.execute(
            "INSERT INTO contacte (nom, prenom, email, telephonne, Descriptions) VALUES (?, ?, ?, ?, ?)",
            (
                nom,
                prenom,
                email,
                phone,
                message,
            ),
        )

        connection.commit()
        flash(
            "L'adresse e-mail existe déjà. Veuillez choisir une autre adresse e-mail.",
            "error",
        )
        cursor.close()
        connection.close()

    return render_template("/page/contacte.html")


@app.route("/service", methods=["GET", "POST"])
def service():
    if request.method == "POST":
        nom_et_prenom = request.form["nom_et_prenom"]
        Type_de_services = request.form["Type_de_services"]
        lieu_debitation = request.form["lieu_debitation"]
        telephonne = request.form["telephonne"]
        Descriptions = request.form["Descriptions"]
        Dates_str = request.form["Dates"]

        # Convertissez la chaîne de date en objet datetime
        Dates = datetime.fromisoformat(Dates_str)

        connection = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
        cursor = connection.cursor()

        # Utilisez le format de la date et heure approprié dans la requête SQL
        cursor.execute(
            "INSERT INTO Services_demande (nom_et_prenom, Type_de_services, lieu_debitation, telephonne, Descriptions, Dates, en_cours) VALUES (?, ?, ?, ?, ?, ?, en_cours)",
            (
                nom_et_prenom,
                Type_de_services,
                lieu_debitation,
                telephonne,
                Descriptions,
                Dates,
            ),
        )

        connection.commit()

        cursor.close()
        connection.close()
        return render_template("/page/service.html")

    return render_template("/page/service.html")


@app.route("/a_propos")
def a_propos():
    return render_template("/page/a_propos.html")


#### profile ###


@app.route("/profile_user")
def profile_user():

    IdUtilisateur = session.get("IdUtilisateur")

    connection = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM Utilisateur WHERE IdUtilisateur=?", (IdUtilisateur,))
    utilisateur_info = cursor.fetchone()
    cursor.execute("SELECT * FROM Locations WHERE IdUtilisateur=?", (IdUtilisateur,))
    loc = cursor.fetchall()
    cursor.execute("SELECT * FROM Maison WHERE IdUtilisateur=?", (IdUtilisateur,))
    mvm = cursor.fetchall()
    connection.close()

    return render_template(
        "/profile/profile_user.html",
        utilisateur_info=utilisateur_info,
        loc=loc,
        mvm=mvm,
    )


######## maison ###########


@app.route("/profile_maison_en_vente/<int:IdMaison>", methods=["GET", "POST"])
def profile_maison_en_vente(IdMaison):
    connection = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
    cursor = connection.cursor()

    user_id = get_user_id()  # Remplacez par la logique pour obtenir l'ID de l'utilisateur connecté

    # Vérifier si l'utilisateur a déjà vu cette maison
    cursor.execute(
        "SELECT COUNT(*) FROM user_vue WHERE IdMaison = ? AND IdUtilisateur = ?",
        (IdMaison, user_id)
    )
    user_view_count = cursor.fetchone()[0]

    if user_view_count == 0:
        # Incrémenter le compteur de vues si l'utilisateur n'a pas encore vu cette maison
        cursor.execute("UPDATE Maison SET Nombre_de_vue = Nombre_de_vue + 1 WHERE IdMaison = ?", (IdMaison,))
        connection.commit()

        # Enregistrer la vue dans la table user_vue
        cursor.execute(
            "INSERT INTO user_vue (IdMaison, IdUtilisateur) VALUES (?, ?)",
            (IdMaison, user_id)
        )
        connection.commit()

    cursor.execute("SELECT * FROM Maison WHERE IdMaison = ?", (IdMaison,))
    maison_info = cursor.fetchone()
    images = maison_info.Image1.split(",") if maison_info.Image1 else []
    
    cursor.close()

    if request.method == "POST":
        nom = request.form["nom"]
        prenom = request.form["prenom"]
        email = request.form["email"]
        telephonne = request.form["telephonne"]
        Descriptions = request.form["Descriptions"]

        cursor = connection.cursor()

        # Utilisez l'ID de la maison associée
        cursor.execute(
            "INSERT INTO interesse (nom, prenom, email, telephonne, Descriptions, IdMaison) VALUES (?, ?, ?, ?, ?, ?)",
            (nom, prenom, email, telephonne, Descriptions, IdMaison),
        )

        connection.commit()
        cursor.close()
        connection.close()

    return render_template("/profile/profile_maison.html", row=maison_info, image=images)


@app.route("/mise_en_vente_maison", methods=["GET", "POST"])
def mise_en_vente_maison():
    if request.method == "POST":
        Ville = request.form["Ville"]
        Commune = request.form["Commune"]
        Quartier =  request.form["Quartier"]
        Nombre_de_pieces = request.form["Nombre_de_pieces"]
        Nombre_de_chambres = request.form["Nombre_de_chambres"]
        Nombre_de_salles_de_bain = request.form["Nombre_de_salles_de_bain"]
        metre_carre = request.form["metre_carre"]
        Prix_unitaire = request.form["Prix_unitaire"]
        Descriptions = request.form["message"]
        Type_de_maison = request.form["Type_de_maison"]
        Statut_maison = "En vente"
        GPS = request.form["GPS"]
        IdUtilisateur = session.get("IdUtilisateur")

        # Traitement des images
        image_urls = []
        if "myfiles[]" in request.files:
            image_files = request.files.getlist("myfiles[]")
            for image_file in image_files:
                if image_file and allowed_file(image_file.filename):
                    filename = secure_filename(image_file.filename)
                    image_path = os.path.join(app.config["UPLOAD_FOLDER1"], filename)
                    image_file.save(image_path)
                    image_urls.append(image_path)

        connection = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
        cursor = connection.cursor()

        # Correction de la requête SQL
        cursor.execute(
            """
            INSERT INTO Maison 
                (IdUtilisateur, Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_salles_de_bain, Nombre_de_chambres, metre_carre, Prix_unitaire, Descriptions, 
                Type_de_maison, Statut_maison, GPS, Image1)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
            (
                IdUtilisateur,
                Ville,
                Commune,
                Quartier,
                Nombre_de_pieces,
                Nombre_de_chambres,
                Nombre_de_salles_de_bain,
                metre_carre,
                Prix_unitaire,
                Descriptions,
                Type_de_maison,
                Statut_maison,
                GPS,
                ",".join(image_urls) if image_urls else None,
            ),
        )

        connection.commit()
        cursor.close()
        connection.close()

        return redirect(url_for("profile_user"))

    return render_template("/formulaire/ajoute/mise_en_vente_maison.html")


@app.route("/modifier_mise_en_vente_maison/<int:IdMaison>", methods=["GET", "POST"])
def modifier_mise_en_vente_maison(IdMaison):

    # Fetch existing data to pre-fill the form
    connection = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM Maison WHERE IdMaison=?", (IdMaison,))
    Maison_data = cursor.fetchone()
    cursor.close()
    connection.close()

    if request.method == "POST":
        Ville = request.form["Ville"]
        Commune = request.form["Commune"]
        Quartier =  request.form["Quartier"]
        Nombre_de_pieces = request.form["Nombre_de_pieces"]
        Nombre_de_chambres = request.form["Nombre_de_chambres"]
        Nombre_de_salles_de_bain = request.form["Nombre_de_salles_de_bain"]
        metre_carre = request.form["metre_carre"]
        Prix_unitaire = request.form["Prix_unitaire"]
        Descriptions = request.form["message"]
        Type_de_maison = request.form["Type_de_maison"]
        Statut_maison = request.form["Statut_maison"]
        GPS = request.form["GPS"]

        # Traitement des images
        image_urls = []
        if "myfiles[]" in request.files:
            image_files = request.files.getlist("myfiles[]")
            for image_file in image_files:
                if image_file and allowed_file(image_file.filename):
                    filename = secure_filename(image_file.filename)
                    image_path = os.path.join(app.config["UPLOAD_FOLDER1"], filename)
                    image_file.save(image_path)
                    image_urls.append(image_path)

        connection = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
        cursor = connection.cursor()

        # Correction de la requête SQL
        cursor.execute(
            """UPDATE Maison 
               SET Ville=?, Commune=?, Quartier=?, Nombre_de_pieces=?, Nombre_de_chambres=?, Nombre_de_salles_de_bain=?, metre_carre=?, Prix_unitaire=?, Descriptions=?, 
                   Type_de_maison=?, Statut_maison=?, GPS=?, Image1=?
               WHERE IdMaison=?"""
            (
                Ville,
                Commune,
                Quartier,
                Nombre_de_pieces,
                Nombre_de_chambres,
                Nombre_de_salles_de_bain,
                metre_carre,
                Prix_unitaire,
                Descriptions,
                Type_de_maison,
                Statut_maison,
                GPS,
                ",".join(image_urls) if image_urls else None,
                IdMaison,
            ),
        )

        connection.commit()
        cursor.close()
        connection.close()

        return redirect(url_for("profile_user"))

    return render_template(
        "/formulaire/modifier/modifier_mise_en_vente_maison.html",
        Maison_data=Maison_data,
    )


@app.route("/supprimer_mise_en_vente_maison/<int:IdMaison>", methods=["GET", "POST"])
def supprimer_mise_en_vente_maison(IdMaison):
    connexion = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
    cursor = connexion.cursor()
    app.config["SQL_SERVER"] = connexion
    cursor.execute("DELETE FROM user_vue WHERE IdIdMaison = ?", (IdMaison,))
    cursor.execute("DELETE FROM user_like WHERE IdIdMaison = ?", (IdMaison,))
    cursor.execute("DELETE FROM Maison WHERE IdMaison = ?", (IdMaison,))
    cursor.commit()
    cursor.close()
    return redirect(url_for("profile_user"))


#### loue_maison ###################

@app.route("/profile_location/<int:IdLocation>", methods=["GET", "POST"])
def profile_location(IdLocation):
    connection = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
    cursor = connection.cursor()

    user_id = get_user_id()  # Replace with the logic to get the logged-in user ID


    # Check if the user has already viewed this location
    cursor.execute(
        "SELECT COUNT(*) FROM user_vue WHERE IdLocations = ? AND IdUtilisateur = ?",
        (IdLocation, user_id)
    )
    user_view_count = cursor.fetchone()[0]

    if user_view_count == 0:
        # Increment view count if the user has not yet viewed this location
        cursor.execute("UPDATE Locations SET Nombre_de_vue = Nombre_de_vue + 1 WHERE IdLocations = ?", (IdLocation,))
        connection.commit()

        # Record the view in the user_vue table
        cursor.execute(
            "INSERT INTO user_vue (IdLocations, IdUtilisateur) VALUES (?, ?)",
            (IdLocation, user_id)
        )
        connection.commit()

    cursor.execute("SELECT * FROM Locations WHERE IdLocations = ?", (IdLocation,))
    location_info = cursor.fetchone()
    images = location_info.Image1.split(",") if location_info.Image1 else []
    
    if request.method == "POST":
        nom = request.form["nom"]
        prenom = request.form["prenom"]
        email = request.form["email"]
        telephonne = request.form["telephonne"]
        Descriptions = request.form["Descriptions"]

        cursor.execute(
            "INSERT INTO interesse (nom, prenom, email, telephonne, Descriptions, IdLocation) VALUES (?, ?, ?, ?, ?, ?)",
            (nom, prenom, email, telephonne, Descriptions, IdLocation)
        )

        connection.commit()

    cursor.close()
    connection.close()

    return render_template("/profile/profile_location.html", row=location_info, image=images)



@app.route("/mise_en_location", methods=["GET", "POST"])
def mise_en_location():
    if request.method == "POST":
        Ville = request.form["Ville"]
        Commune = request.form["Commune"]
        Quartier =  request.form["Quartier"]
        Nombre_de_pieces = request.form["Nombre_de_pieces"]
        Nombre_de_chambres = request.form["Nombre_de_chambres"]
        Nombre_de_salles_de_bain = request.form["Nombre_de_salles_de_bain"]
        metre_carre = request.form["metre_carre"]
        Prix_mensuel = request.form["Prix_mensuel"]
        Caution = request.form["Caution"]
        Avance = request.form["Avance"]
        Descriptions = request.form["message"]
        Type_de_maison = request.form["Type_de_maison"]
        Statut_maison = request.form["Statut_maison"]
        GPS = request.form["GPS"]

        IdUtilisateur = session.get("IdUtilisateur")

        # Traitement des images
        image_urls = []
        if "myfiles[]" in request.files:
            image_files = request.files.getlist("myfiles[]")
            for image_file in image_files:
                if image_file and allowed_file(image_file.filename):
                    filename = secure_filename(image_file.filename)
                    image_path = os.path.join(app.config["UPLOAD_FOLDER"], filename)
                    image_file.save(image_path)
                    image_urls.append(image_path)

        connection = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
        cursor = connection.cursor()
        cursor.execute(
            """INSERT INTO Locations 
                        (IdUtilisateur, Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_mensuel, Caution, Avance, Descriptions, Type_de_maison, Statut_maison, GPS, Image1)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
            (
                IdUtilisateur,
                Ville,
                Commune,
                Quartier,
                Nombre_de_pieces,
                Nombre_de_chambres,
                Nombre_de_salles_de_bain,
                metre_carre,
                Prix_mensuel,
                Caution,
                Avance,
                Descriptions,
                Type_de_maison,
                Statut_maison,
                GPS,
                ",".join(image_urls) if image_urls else None,
            ),
        )


        connection.commit()
        cursor.close()
        connection.close()

        return redirect(url_for("profile_user"))
    return render_template("/formulaire/ajoute/mise_en_location.html")


@app.route("/modifier_mise_en_location/<int:IdLocations>", methods=["GET", "POST"])
def modifier_mise_en_location(IdLocations):

    if request.method == "POST":
        Ville = request.form["Ville"]
        Commune = request.form["Commune"]
        Quartier =  request.form["Quartier"]
        Nombre_de_pieces = request.form["Nombre_de_pieces"]
        Nombre_de_chambres = request.form["Nombre_de_chambres"]
        Nombre_de_salles_de_bain = request.form["Nombre_de_salles_de_bain"]
        metre_carre = request.form["metre_carre"]
        Prix_mensuel = request.form["Prix_mensuel"]
        Caution = request.form["Caution"]
        Avance = request.form["Avance"]
        Descriptions = request.form["message"]
        Type_de_maison = request.form["Type_de_maison"]
        Statut_maison = request.form["Statut_maison"]
        GPS = request.form["GPS"]

        # Traitement des images
        image_urls = []
        if "myfiles[]" in request.files:
            image_files = request.files.getlist("myfiles[]")
            for image_file in image_files:
                if image_file and allowed_file(image_file.filename):
                    filename = secure_filename(image_file.filename)
                    image_path = os.path.join(app.config["UPLOAD_FOLDER"], filename)
                    image_file.save(image_path)
                    image_urls.append(image_path)

        connection = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
        cursor = connection.cursor()

        cursor.execute(
            """UPDATE Locations 
               SET Ville=?, Commune=?, Quartier=?, Nombre_de_pieces=?, Nombre_de_chambres=?, Nombre_de_salles_de_bain=?, metre_carre=?, Prix_mensuel=?, Caution=?, Avance=?, Descriptions=?, 
                   Type_de_maison=?, Statut_maison=?, GPS=?, Image1=?
               WHERE IdLocations=?""",
            (
                Ville,
                Commune,
                Quartier,
                Nombre_de_pieces,
                Nombre_de_chambres,
                Nombre_de_salles_de_bain,
                metre_carre,
                Prix_mensuel,
                Caution,
                Avance,
                Descriptions,
                Type_de_maison,
                Statut_maison,
                GPS,
                ",".join(image_urls) if image_urls else None,
                IdLocations,
            ),
        )

        connection.commit()
        cursor.close()
        connection.close()

        return redirect(url_for("profile_user"))

    # Fetch existing data to pre-fill the form
    connection = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM Locations WHERE IdLocations=?", (IdLocations,))
    location_data = cursor.fetchone()
    cursor.close()
    connection.close()

    return render_template(
        "/formulaire/modifier/modifier_mise_en_location.html",
        location_data=location_data,
    )

# @app.route("/modifier_mise_en_location/<int:IdLocations>", methods=["GET", "POST"])
# def modifier_mise_en_location(IdLocations):
#     if request.method == "POST":
#         Ville = request.form["Ville"]
#         Commune = request.form["Commune"]
#         Quartier = request.form["Quartier"]
#         Nombre_de_pieces = request.form["Nombre_de_pieces"]
#         Nombre_de_chambres = request.form["Nombre_de_chambres"]
#         Nombre_de_salles_de_bain = request.form["Nombre_de_salles_de_bain"]
#         metre_carre = request.form["metre_carre"]
#         Prix_mensuel = request.form["Prix_mensuel"]
#         Caution = request.form["Caution"]
#         Avance = request.form["Avance"]
#         Descriptions = request.form["message"]
#         Type_de_maison = request.form["Type_de_maison"]
#         Statut_maison = request.form["Statut_maison"]
#         GPS = request.form["GPS"]

#         # Traitement des images
#         image_urls = []
#         if "myfiles[]" in request.files:
#             image_files = request.files.getlist("myfiles[]")
#             for image_file in image_files:
#                 if image_file and allowed_file(image_file.filename):
#                     filename = secure_filename(image_file.filename)
#                     image_path = os.path.join(app.config["UPLOAD_FOLDER"], filename)
#                     image_file.save(image_path)
#                     image_urls.append(image_path)

#         connection = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
#         cursor = connection.cursor()

#         # Construction de la requête SQL avec paramètres
#         sql_query = """
#             UPDATE Locations 
#             SET Ville=?, Commune=?, Quartier=?, Nombre_de_pieces=?, Nombre_de_chambres=?, 
#                 Nombre_de_salles_de_bain=?, metre_carre=?, Prix_mensuel=?, Caution=?, 
#                 Avance=?, Descriptions=?, Type_de_maison=?, Statut_maison=?, GPS=?, Image1=?
#             WHERE IdLocations=?
#         """
        
#         # Convertir image_urls en une chaîne séparée par des virgules
#         image_urls_str = ",".join(image_urls) if image_urls else None
        
#         # Exécuter la requête avec les paramètres
#         cursor.execute(sql_query, (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres,
#                                    Nombre_de_salles_de_bain, metre_carre, Prix_mensuel, Caution,
#                                    Avance, Descriptions, Type_de_maison, Statut_maison, GPS,
#                                    image_urls_str, IdLocations))

#         connection.commit()
#         cursor.close()
#         connection.close()

#         return redirect(url_for("profile_user"))

#     # Fetch existing data to pre-fill the form
#     connection = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
#     cursor = connection.cursor()
#     cursor.execute("SELECT * FROM Locations WHERE IdLocations=?", (IdLocations,))
#     location_data = cursor.fetchone()
#     cursor.close()
#     connection.close()

#     return render_template(
#         "/formulaire/modifier/modifier_mise_en_location.html",
#         location_data=location_data,
#     )




@app.route("/supprimer_mise_en_location/<int:IdLocations>", methods=["GET", "POST"])
def supprimer_mise_en_location(IdLocations):
    connexion = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
    cursor = connexion.cursor()
    app.config["SQL_SERVER"] = connexion
    cursor.execute("DELETE FROM user_vue WHERE IdLocations = ?", (IdLocations,))
    cursor.execute("DELETE FROM user_like WHERE IdLocations = ?", (IdLocations,))
    cursor.execute("DELETE FROM Locations WHERE IdLocations = ?", (IdLocations,))
    cursor.commit()
    cursor.close()
    return redirect(url_for("profile_user"))


###########################################################################


@app.route("/deconnection")
def deconnection():
    session.pop("user", None)
    session.pop("IdUtilisateur", None)
    return redirect(url_for("index"))


def get_user_id():
    # Vérifier si l'utilisateur est connecté
    if "IdUtilisateur" in session:
        return session["IdUtilisateur"]
    # Vérifier s'il existe déjà un ID d'utilisateur invité
    elif "guest_user_id" in session:
        return session["guest_user_id"]
    else:
        # Générer un nouvel ID d'utilisateur invité préfixé par 'n' et le stocker dans la session
        guest_user_id = f"n{random.randint(1, 1000000)}"
        session["guest_user_id"] = guest_user_id
        session.permanent = True  # Rendre la session permanente pour appliquer PERMANENT_SESSION_LIFETIME
        return guest_user_id


if __name__ == "__main__":
    app.run(debug=True, port=8888)
