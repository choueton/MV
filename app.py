from flask import Flask, render_template, url_for, request, redirect, session
import pyodbc
import os
from werkzeug.utils import secure_filename
from flask_paginate import Pagination, get_page_parameter
from werkzeug.security import generate_password_hash, check_password_hash


app = Flask(__name__)

UPLOAD_FOLDER = "uploads"
ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg", "gif"}

app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER

app.secret_key = "votre_clé_secrète"
# Configuration de la connexion à SQL Server
app.config["SQL_SERVER_CONNECTION_STRING"] = """
    Driver={SQL Server};
    Server=DESKTOP-6RB7ER5\SQLEXPRESS;
    Database=MV;
    Trusted_Connection=yes;"""





####################

# La route doit être définie avant la fonction associée
# @app.route("/loue_maison", methods=['GET', 'POST'])
# def loue_maison():
#     page = request.args.get(get_page_parameter(), type=int, default=1)

#     # Définir le nombre d'éléments par page
#     per_page = 4  # Vous pouvez ajuster cela en fonction de vos besoins

#     # Établir une connexion à la base de données
#     conn = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
#     cur = conn.cursor()

#     # Exécuter la requête SQL avec la pagination
#     query = """
#         SELECT *
#         FROM (
#             SELECT *, ROW_NUMBER() OVER (ORDER BY IdLocations) AS RowNum
#             FROM Locations
#         ) AS paginated
#         WHERE RowNum BETWEEN ? AND ?
#     """
#     cur.execute(query, ((page - 1) * per_page + 1, page * per_page))

#     loc_afi = cur.fetchall()
#     cur.close()
#     conn.close()

#     # Obtenir le nombre total d'éléments (utile pour la pagination)
#     conn = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
#     cur = conn.cursor()
#     total = cur.execute("SELECT COUNT(*) FROM Locations").fetchone()[0]
#     cur.close()
#     conn.close()

#     # Créer l'objet Pagination
#     pagination = Pagination(page=page, per_page=per_page, total=total, record_name='locations', css_framework='bootstrap5')

#     return render_template("/page/loue_maison.html", location=loc_afi, pagination=pagination)



# @app.route("/loue_maison", methods=['GET', 'POST'])
# def loue_maison():
#     page = request.args.get(get_page_parameter(), type=int, default=1)

#     # Définir le nombre d'éléments par page
#     per_page = 4  # Vous pouvez ajuster cela en fonction de vos besoins

#     # Récupérer les paramètres de filtre du formulaire
#     ville = request.form.get('Ville')
#     commune = request.form.get('Commune')
#     nombre_de_pieces = request.form.get('Nombre_de_pieces')
#     prix_min = request.form.get('Prix_mensuel')
#     prix_max = request.form.get('Prix_mensuel')

#     # Construire la requête SQL avec les paramètres de filtre
#     query = """
#         SELECT *
#         FROM (
#             SELECT *, ROW_NUMBER() OVER (ORDER BY IdLocations) AS RowNum
#             FROM Locations
#             WHERE (? IS NULL OR Ville = ?)
#             AND (? IS NULL OR Commune = ?)
#             AND (? IS NULL OR Nombre_de_pieces = ?)
#             AND (? IS NULL OR Prix_mensuel >= ?)
#             AND (? IS NULL OR Prix_mensuel <= ?)
#         ) AS paginated
#         WHERE RowNum BETWEEN ? AND ?
#     """

#     # Établir une connexion à la base de données
#     conn = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
#     cur = conn.cursor()

#     # Exécuter la requête SQL avec la pagination et les filtres
#     cur.execute(query, (ville, ville, commune, commune, nombre_de_pieces, nombre_de_pieces,
#                         prix_min, prix_min, prix_max, prix_max, (page - 1) * per_page + 1, page * per_page))

#     loc_afi = cur.fetchall()
#     cur.close()
#     conn.close()

#     # Obtenir le nombre total d'éléments (utile pour la pagination)
#     conn = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
#     cur = conn.cursor()
#     total = cur.execute("SELECT COUNT(*) FROM Locations WHERE (? IS NULL OR Ville = ?) AND (? IS NULL OR Commune = ?) AND (? IS NULL OR Nombre_de_pieces = ?) AND (? IS NULL OR Prix_mensuel >= ?) AND (? IS NULL OR Prix_mensuel <= ?)",
#                         (ville, ville, commune, commune, nombre_de_pieces, nombre_de_pieces, prix_min, prix_min, prix_max, prix_max)).fetchone()[0]
#     cur.close()
#     conn.close()

#     # Créer l'objet Pagination
#     pagination = Pagination(page=page, per_page=per_page, total=total, record_name='locations', css_framework='bootstrap5')

#     return render_template("/page/loue_maison.html", location=loc_afi, pagination=pagination)







###############



#################################################################


@app.route("/")
def index():
    
    return render_template("index.html")


@app.route("/loue_maison", methods=['GET', 'POST'])
def loue_maison():
    page = request.args.get(get_page_parameter(), type=int, default=1)

    # Définir le nombre d'éléments par page
    per_page = 4  # Vous pouvez ajuster cela en fonction de vos besoins

    # Récupérer les paramètres de filtre du formulaire
    ville = request.form.get('Ville')
    commune = request.form.get('Commune')
    nombre_de_pieces = request.form.get('Nombre_de_pieces')
    prix_min = request.form.get('Prix_mensuel')
    prix_max = request.form.get('Prix_mensuel')

    # Construire la requête SQL avec les paramètres de filtre
    query = """
        SELECT *
        FROM (
            SELECT *, ROW_NUMBER() OVER (ORDER BY IdLocations) AS RowNum
            FROM Locations
            WHERE (? IS NULL OR Ville = ?)
            AND (? IS NULL OR Commune = ?)
            AND (? IS NULL OR Nombre_de_pieces = ?)
            AND (? IS NULL OR Prix_mensuel >= ?)
            AND (? IS NULL OR Prix_mensuel <= ?)
        ) AS paginated
        WHERE RowNum BETWEEN ? AND ?
    """

    # Établir une connexion à la base de données
    conn = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
    cur = conn.cursor()

    # Exécuter la requête SQL avec la pagination et les filtres
    cur.execute(query, (ville, ville, commune, commune, nombre_de_pieces, nombre_de_pieces,
                        prix_min, prix_min, prix_max, prix_max, (page - 1) * per_page + 1, page * per_page))

    loc_afi = cur.fetchall()
    cur.close()
    conn.close()

    # Obtenir le nombre total d'éléments (utile pour la pagination)
    conn = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
    cur = conn.cursor()
    total = cur.execute("SELECT COUNT(*) FROM Locations WHERE (? IS NULL OR Ville = ?) AND (? IS NULL OR Commune = ?) AND (? IS NULL OR Nombre_de_pieces = ?) AND (? IS NULL OR Prix_mensuel >= ?) AND (? IS NULL OR Prix_mensuel <= ?)",
                        (ville, ville, commune, commune, nombre_de_pieces, nombre_de_pieces, prix_min, prix_min, prix_max, prix_max)).fetchone()[0]
    cur.close()
    conn.close()

    # Créer l'objet Pagination
    pagination = Pagination(page=page, per_page=per_page, total=total, record_name='locations', css_framework='bootstrap5')

    return render_template("/page/loue_maison.html", location=loc_afi, pagination=pagination)

@app.route("/achete_maison")
def achete_maison():
    return render_template("/page/achete_maison.html")

@app.route("/contacte")
def contacte():
    return render_template("/page/contacte.html")

@app.route("/profile_maison_en_vente")
def profile_maison_en_vente():
    return render_template("/profile/profile_maison.html")


#### loue_maison ###################

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
                        (Ville, Commune, Nombre_de_pieces, Prix_mensuel, Caution, Avance, Descriptions, 
                        Type_de_maison, Statut_maison, GPS, Image1)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
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
            ),
        )

        connection.commit()
        cursor.close()
        connection.close()

        return redirect(url_for("profile_user"))

    return render_template("/formulaire/ajoute/mise_en_location.html")

def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS

def save_image_to_storage(image_file):
    if image_file and allowed_file(image_file.filename):
        filename = secure_filename(image_file.filename)
        filepath = os.path.join(app.config["UPLOAD_FOLDER"], filename)
        image_file.save(filepath)
        return filepath  # Vous souhaiterez peut-être renvoyer une URL au lieu du chemin du fichier


@app.route("/profile_location")
def profile_location():
    return render_template("/profile/profile_location.html")

@app.route('/modifier_mise_en_location', methods=['POST','GET'])
def modifier_mise_en_location(IdLocations):
    
    connexion = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connexion.cursor()
    app.config['SQL_SERVER'] = connexion
    info_locs = cursor.execute('SELECT * FROM Locations WHERE IdLocations = ?', IdLocations)
    locs = cursor.fetchall()
    cursor.close()
    
    print(locs)
    
     # Récupérer les données du formulaire
    if request.method == 'POST':
        data = info_locs.fetchone()
        Ville = request.form['Ville']
        Commune = request.form['Commune']
        Nombre_de_pieces = request.form['Nombre_de_pieces']
        Caution = request.form['Caution']
        Avance = request.form['Avance']
        Descriptions = request.form['message']
        Type_de_maison = request.form['Type_de_maison']
        Statut_maison = request.form['Statut_maison']
        GPS = request.form['GPS']
        
        cursor.execute("""UPDATE Locations SET Ville = ?, Commune = ?, Nombre_de_pieces = ?, Caution = ?, Avance = ?, Descriptions = ?, Statut_maison= ? Type_de_maison = ? GPS = ? WHERE IdLocations = ?""",
                      ( Ville, Commune,Nombre_de_pieces,Caution,Avance,Descriptions,Type_de_maison,Statut_maison, GPS)) 
        connexion.commit()
        connexion.close()
        
        print(f"Ville: {Ville}, Commune: {Commune}, Nombre de pièces: {Nombre_de_pieces},Caution: {Caution}, Avance: {Avance}, Descriptions: {Descriptions},Type de maison: {Type_de_maison}, Statut maison: {Statut_maison}, GPS: {GPS}")
        return redirect(url_for('modifier_mise_en_location'))
    
    return render_template('/formulaire/modifier/modifier_mise_en_location.html', data=data)


@app.route("/supprimer_mise_en_location/<int:IdLocations>", methods=["GET", "POST"])
def supprimer_mise_en_location(IdLocations):
    IdLocations = int(IdLocations)
    connexion = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connexion.cursor()
    app.config['SQL_SERVER'] = connexion
    cursor.execute('DELETE * FROM Locations WHERE IdLocations = ?', (IdLocations,))
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


@app.route("/connexion", methods=["GET", "POST"])
def connexion():
    if request.method == 'POST':

        Email = request.form['Email']
        password = request.form['Mot_de_pass']

        connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM Utilisateur WHERE Email = ?", (Email,))
        user = cursor.fetchone()

        if user and check_password_hash(user.Mot_de_pass, password):  # Accès au mot de passe directement par le nom de colonne
            session['user_id'] = user.IdUtilisateur
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

        # Hacher le mot de passe
        hashed_password = generate_password_hash(Mot_de_pass)

        connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
        cursor = connection.cursor()
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
    return redirect(url_for('index'))



if __name__ == "__main__":
    app.run(debug=True)
