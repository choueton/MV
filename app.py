from datetime import datetime
from functools import wraps
from flask import Flask, render_template, url_for, request, redirect, session,flash
import pyodbc
import os
from werkzeug.utils import secure_filename
from flask_paginate import Pagination, get_page_parameter
from werkzeug.security import generate_password_hash, check_password_hash


app = Flask(__name__)

UPLOAD_FOLDER1 = "static/uploads/maison/"
UPLOAD_FOLDER = "static/uploads/location/"

ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg", "gif"}

app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.config["UPLOAD_FOLDER1"] = UPLOAD_FOLDER1





app.secret_key = "votre_clé_secrète"
# Configuration de la connexion à SQL Server
app.config["SQL_SERVER_CONNECTION_STRING"] = """
    Driver={SQL Server};
    Server=DESKTOP-6RB7ER5\SQLEXPRESS;
    Database=MV;
    Trusted_Connection=yes;"""




def allowed_file1(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS

def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


# configuration de l'authentification requise pour toutes les pages
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user' not in session:
            flash('Veuillez vous connecter pour accéder à cette page.', 'danger')
            return redirect(url_for('connexion'))
        return f(*args, **kwargs)

###################################
@app.template_filter('add_line_breaks')
def add_line_breaks(s, width):

    """
    Ajoutez des sauts de ligne à une chaîne après une largeur spécifiée.

    Parameters:
    - s (str): Input string.
    - width (int): Maximum width before line break.

    Returns:
    - str: String with line breaks added.
    """
    return '\n'.join([s[i:i+width] for i in range(0, len(s), width)])

###########################################################################################################################################################

#################################################################
@app.route("/")
def index():
    return render_template("index.html")

@app.route('/loue_maison', methods=['GET', 'POST'])
def loue_maison():
    # Connexion à la base de données
    conn = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
    cursor = conn.cursor()

    # Récupération de la page actuelle depuis l'URL
    page = request.args.get(get_page_parameter(), type=int, default=1)

    # Nombre d'éléments à afficher par page
    per_page = 5

    ville = request.args.get('Ville')
    commune = request.args.get('Commune')
    nombre_de_pieces = request.args.get('Nombre_de_pieces')
    prix_min = request.args.get('Prix_min')
    prix_max = request.args.get('Prix_max')

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
    query_select = "SELECT * FROM Locations WHERE 1=1"
    params_select = []

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
        images = row.Image1.split(',') if row.Image1 else []
        # Append a dictionary with the processed data to the locations list
        locations.append({
            'row': row,
            'images': images
        })

    # Configuration de la pagination avec le nombre total d'éléments et le nombre d'éléments par page
    pagination = Pagination(page=page, total=total_count, per_page=per_page, css_framework='bootstrap5')

    # Fermeture du curseur et de la connexion
    cursor.close()
    conn.close()

    # Rendu du template avec les données récupérées et la pagination
    return render_template("/page/loue_maison.html", locations=locations, pagination=pagination,)

@app.route("/achete_maison",methods=['GET', 'POST'])
def achete_maison():

    # Connexion à la base de données
    conn = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
    cursor = conn.cursor()

    # Récupération de la page actuelle depuis l'URL
    page = request.args.get(get_page_parameter(), type=int, default=1)

    # Nombre d'éléments à afficher par page
    per_page = 5

    # Définition des filtres
    ville = request.args.get('Ville')
    commune = request.args.get('Commune')
    nombre_de_pieces = request.args.get('Nombre_de_pieces')
    prix_min = request.args.get('Prix_min')
    prix_max = request.args.get('Prix_max')

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
    query_select = "SELECT * FROM Maison WHERE 1=1"
    params_select = []

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
        images = row.Image1.split(',') if row.Image1 else []
        # Append a dictionary with the processed data to the locations list
        maison.append({
            'row': row,
            'images': images
        })
    # Configuration de la pagination avec le nombre total d'éléments et le nombre d'éléments par page
    pagination = Pagination(page=page, total=total_count, per_page=per_page, css_framework='bootstrap5')

    # Fermeture du curseur et de la connexion
    cursor.close()
    conn.close()

    return render_template("/page/achete_maison.html", maison_ifo=maison, pagination=pagination )

@app.route("/contacte", methods=['GET', 'POST'])
def contacte():

    if request.method =="POST":
        prenom = request.form['prenom']
        nom = request.form['nom']
        email = request.form['email']
        phone = request.form['phone']
        message = request.form['message']

        connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
        cursor = connection.cursor()
        # Utilisez le format de la date et heure approprié dans la requête SQL
        cursor.execute(
            "INSERT INTO contacte (nom, prenom, email, telephonne, Descriptions) VALUES (?, ?, ?, ?, ?)",
            (nom, prenom, email, phone, message,))
        
        connection.commit()
        flash('L\'adresse e-mail existe déjà. Veuillez choisir une autre adresse e-mail.', 'error')
        cursor.close()
        connection.close()
    
    return render_template("/page/contacte.html")

@app.route('/service', methods=['GET', 'POST'])
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

        connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
        cursor = connection.cursor()
        
        # Utilisez le format de la date et heure approprié dans la requête SQL
        cursor.execute("INSERT INTO Services_demande (nom_et_prenom, Type_de_services, lieu_debitation, telephonne, Descriptions, Dates) VALUES (?, ?, ?, ?, ?, ?)",
                       (nom_et_prenom, Type_de_services, lieu_debitation, telephonne, Descriptions, Dates))

        connection.commit()

        cursor.close()
        connection.close()
        return render_template('/page/service.html')

    return render_template('/page/service.html')

@app.route('/a_propos')
def a_propos():
    return render_template('/page/a_propos.html')

#### profile ###

@app.route('/profile_user')
def profile_user():

    IdUtilisateur = session.get('IdUtilisateur')

    connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM Utilisateur WHERE IdUtilisateur=?", (IdUtilisateur,))
    utilisateur_info = cursor.fetchone()
    cursor.execute("SELECT * FROM Locations WHERE IdUtilisateur=?", (IdUtilisateur,))
    loc = cursor.fetchall()
    cursor.execute("SELECT * FROM Maison WHERE IdUtilisateur=?", (IdUtilisateur,))
    mvm = cursor.fetchall()
    connection.close()

    return render_template('/profile/profile_user.html', utilisateur_info=utilisateur_info, loc=loc, mvm=mvm)

######## maison ###########

@app.route("/profile_maison_en_vente/<int:IdMaison>", methods=['GET', 'POST'])
def profile_maison_en_vente(IdMaison):
    connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM Maison WHERE IdMaison=?", (IdMaison,))
    maison_info = cursor.fetchone()
    images =  maison_info.Image1.split(',') if  maison_info.Image1 else []
    cursor.close()

    if request.method == "POST":

        nom = request.form["nom"]
        prenom = request.form["prenom"]
        email = request.form["email"]
        telephonne = request.form["telephonne"]
        Descriptions = request.form["Descriptions"]

        connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
        cursor = connection.cursor()

        # Utilisez l'ID de la location associée
        cursor.execute("INSERT INTO interesse (nom, prenom, email, telephonne, Descriptions, IdMaison) VALUES (?, ?, ?, ?, ?, ?)",
                        (nom, prenom, email, telephonne, Descriptions, IdMaison))

        connection.commit()

        cursor.close()
        connection.close()

    return render_template("/profile/profile_maison.html", row= maison_info, image=images)

@app.route("/mise_en_vente_maison", methods=["GET", "POST"])
def mise_en_vente_maison():
    if request.method == "POST":
        Ville = request.form["Ville"]
        Commune = request.form["Commune"]
        Nombre_de_pieces = request.form["Nombre_de_pieces"]
        Prix_unitaire = request.form["Prix_unitaire"]
        Descriptions = request.form["message"]
        Type_de_maison = request.form["Type_de_maison"]
        Statut_maison = request.form["Statut_maison"]
        GPS = request.form["GPS"]
        IdUtilisateur = session.get('IdUtilisateur')

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
        cursor.execute("""
            INSERT INTO Maison 
                (IdUtilisateur, Ville, Commune, Nombre_de_pieces, Prix_unitaire, Descriptions, 
                Type_de_maison, Statut_maison, GPS, Image1)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            IdUtilisateur,
            Ville,
            Commune,
            Nombre_de_pieces,
            Prix_unitaire,
            Descriptions,
            Type_de_maison,
            Statut_maison,
            GPS,
            ",".join(image_urls) if image_urls else None,
        ))
        
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
        Nombre_de_pieces = request.form["Nombre_de_pieces"]
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
               SET Ville=?, Commune=?, Nombre_de_pieces=?, Prix_unitaire=?, Descriptions=?, 
                   Type_de_maison=?, Statut_maison=?, GPS=?, Image1=?
               WHERE IdMaison=?""", 
        (
            Ville,
            Commune,
            Nombre_de_pieces,
            Prix_unitaire,
            Descriptions,
            Type_de_maison,
            Statut_maison,
            GPS,
            ",".join(image_urls) if image_urls else None,
            IdMaison,
        ))

        connection.commit()
        cursor.close()
        connection.close()

        return redirect(url_for("profile_user"))

    return render_template("/formulaire/modifier/modifier_mise_en_vente_maison.html", Maison_data=Maison_data)

@app.route("/supprimer_mise_en_vente_maison/<int:IdMaison>", methods=["GET", "POST"])
def supprimer_mise_en_vente_maison(IdMaison):
    connexion = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connexion.cursor()
    app.config['SQL_SERVER'] = connexion
    cursor.execute('DELETE FROM Maison WHERE IdMaison = ?', (IdMaison,))
    cursor.commit()
    cursor.close()
    return redirect(url_for("profile_user"))

#### loue_maison ###################

@app.route("/profile_location/<int:IdLocations>", methods=["GET", "POST"])
def profile_location(IdLocations):
    connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM Locations WHERE IdLocations=?", (IdLocations,))
    Locations_info = cursor.fetchone()
    images = Locations_info.Image1.split(',') if Locations_info.Image1 else []
    cursor.close()

    if request.method == "POST":
        nom = request.form["nom"]
        prenom = request.form["prenom"]
        email = request.form["email"]
        telephonne = request.form["telephonne"]
        Descriptions = request.form["Descriptions"]

        connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
        cursor = connection.cursor()

        # Utilisez l'ID de la location associée
        cursor.execute("INSERT INTO interesse (nom, prenom, email, telephonne, Descriptions, IdLocations) VALUES (?, ?, ?, ?, ?, ?)",
                       (nom, prenom, email, telephonne, Descriptions, IdLocations))

        connection.commit()

        cursor.close()
        connection.close()

    return render_template("/profile/profile_location.html", row=Locations_info, image=images)


@app.route("/mise_en_location", methods=["GET", "POST"])
def mise_en_location():
    if request.method == "POST":
        Ville = request.form["Ville"]
        Commune = request.form["Commune"]
        Nombre_de_pieces = request.form["Nombre_de_pieces"]
        Prix_mensuel = request.form["Prix_mensuel"]
        Caution = request.form["Caution"]
        Avance = request.form["Avance"]
        Descriptions = request.form["message"]
        Type_de_maison = request.form["Type_de_maison"]
        Statut_maison = request.form["Statut_maison"]
        GPS = request.form["GPS"]
        IdUtilisateur = session.get('IdUtilisateur')

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
                        (IdUtilisateur, Ville, Commune, Nombre_de_pieces, Prix_mensuel, Caution, Avance, Descriptions, 
                        Type_de_maison, Statut_maison, GPS, Image1)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
            (
                IdUtilisateur,
                Ville,
                Commune,
                Nombre_de_pieces,
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
        Nombre_de_pieces = request.form["Nombre_de_pieces"]
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
               SET Ville=?, Commune=?, Nombre_de_pieces=?, Prix_mensuel=?, Caution=?, Avance=?, Descriptions=?, 
                   Type_de_maison=?, Statut_maison=?, GPS=?, Image1=?
               WHERE IdLocations=?""",
            (
                Ville,
                Commune,
                Nombre_de_pieces,
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

    return render_template("/formulaire/modifier/modifier_mise_en_location.html", location_data=location_data)

@app.route("/supprimer_mise_en_location/<int:IdLocations>", methods=["GET", "POST"])
def supprimer_mise_en_location(IdLocations):
    connexion = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connexion.cursor()
    app.config['SQL_SERVER'] = connexion
    cursor.execute('DELETE FROM Locations WHERE IdLocations = ?', (IdLocations,))
    cursor.commit()
    cursor.close()
    return redirect(url_for("profile_user"))

###########################################################################

@app.route("/ajout_service")
def add_service():
    return render_template("/formulaire/ajoute/ajout_service.html")


@app.route("/modifier_service")
def modifier_service():
    return render_template("/formulaire/modifier/modifier_service.html")


@app.route("/supprimer_service")
def supprimer_service():
    return render_template("service.html")


######## connexion / inscription  ###########


# @app.route("/connexion", methods=["GET", "POST"])
# def connexion():
#     if request.method == 'POST':

#         Email = request.form['Email']
#         password = request.form['Mot_de_pass']

#         connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
#         cursor = connection.cursor()
#         cursor.execute("SELECT * FROM Utilisateur WHERE Email = ?", (Email,))
#         user = cursor.fetchone()

#         if user and check_password_hash(user.Mot_de_pass, password):  # Accès au mot de passe directement par le nom de colonne
#             session['IdUtilisateur'] = user.IdUtilisateur
#             print(session['IdUtilisateur'])
#             session['user'] = user.Email
#             print(session['IdUtilisateur'])
#             return redirect(url_for('index'))
#         else:
#             print('Mauvaise adresse e-mail ou mot de passe.')
            
#     return render_template("./formulaire/connexion/login.html")


# @app.route("/register", methods=['GET', 'POST'])
# def register():
#     if request.method == 'POST':
#         Nom_et_prenoms = request.form['Nom_et_prenoms']
#         Email = request.form['Email']
#         Mot_de_pass = request.form['Mot_de_pass']
#         Adresse = request.form['Adresse']
#         Telephone = request.form['Telephone']

#         # Hacher le mot de passe
#         hashed_password = generate_password_hash(Mot_de_pass)

#         connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
#         cursor = connection.cursor()
#         cursor.execute("INSERT INTO Utilisateur (Nom_et_prenoms, Email, Mot_de_pass, Adresse, Telephone) VALUES (?, ?, ?, ?, ?)", (Nom_et_prenoms, Email, hashed_password, Adresse, Telephone))
#         connection.commit()

#         # Récupérer l'ID de l'utilisateur après l'insertion
#         cursor.execute("SELECT IdUtilisateur FROM Utilisateur WHERE Email=?", (Email,))
#         IdUtilisateur = cursor.fetchone()[0]

#         session['IdUtilisateur'] = IdUtilisateur
#         session['user'] = Email

#         cursor.close()
#         connection.close()

#         return redirect(url_for('index'))

#     return render_template("./formulaire/connexion/register.html")


@app.route("/connexion", methods=["GET", "POST"])
def connexion():
    if request.method == 'POST':
        Email = request.form['Email']
        password = request.form['Mot_de_pass']

        connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM Utilisateur WHERE Email = ?", (Email,))
        user = cursor.fetchone()

        if user and check_password_hash(user.Mot_de_pass, password):
            session['IdUtilisateur'] = user.IdUtilisateur
            session['user'] = user.Email
            return redirect(url_for('index'))
        else:
            print('Mauvaise adresse e-mail ou mot de passe.')

    return render_template("./formulaire/connexion/login.html")

@app.route("/register", methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        Nom_et_prenoms = request.form['Nom_et_prenoms']
        Email = request.form['Email']
        Mot_de_pass = request.form['Mot_de_pass']
        Adresse = request.form['Adresse']
        Telephone = request.form['Telephone']

        # Vérifier si l'email existe déjà
        connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
        cursor = connection.cursor()
        cursor.execute("SELECT IdUtilisateur FROM Utilisateur WHERE Email=?", (Email,))
        existing_user = cursor.fetchone()

        if existing_user:
            flash('L\'adresse e-mail existe déjà. Veuillez choisir une autre adresse e-mail.', 'error')
            return redirect(url_for('register'))

        # Hacher le mot de passe
        hashed_password = generate_password_hash(Mot_de_pass)

        # Effectuer l'insertion uniquement si l'email n'existe pas
        cursor.execute("INSERT INTO Utilisateur (Nom_et_prenoms, Email, Mot_de_pass, Adresse, Telephone) VALUES (?, ?, ?, ?, ?)", (Nom_et_prenoms, Email, hashed_password, Adresse, Telephone))
        connection.commit()

        # Récupérer l'ID de l'utilisateur après l'insertion
        cursor.execute("SELECT IdUtilisateur FROM Utilisateur WHERE Email=?", (Email,))
        IdUtilisateur = cursor.fetchone()[0]

        session['IdUtilisateur'] = IdUtilisateur
        session['user'] = Email

        cursor.close()
        connection.close()

        return redirect(url_for('index'))

    return render_template("./formulaire/connexion/register.html")

@app.route('/deconnection')
def deconnection():
    session.pop('user', None)
    session.pop('IdUtilisateur', None)
    return redirect(url_for('index'))


if __name__ == "__main__":
    app.run(debug=True)
