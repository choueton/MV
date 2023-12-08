from flask import Flask, render_template, url_for, request, redirect
import pyodbc
import os
from werkzeug.utils import secure_filename

app = Flask(__name__)

UPLOAD_FOLDER = "uploads"
ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg", "gif"}

app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER

app.secret_key = "votre_clé_secrète"
# Configuration de la connexion à SQL Server
app.config[
    "SQL_SERVER_CONNECTION_STRING"
] = """
    Driver={SQL Server};
    Server=DESKTOP-JK6D8G9\\SQLEXPRESS;
    Database=MV;
    Trusted_Connection=yes;"""


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


def save_image_to_storage(image_file):
    if image_file and allowed_file(image_file.filename):
        filename = secure_filename(image_file.filename)
        filepath = os.path.join(app.config["UPLOAD_FOLDER"], filename)
        image_file.save(filepath)
        return filepath  # Vous souhaiterez peut-être renvoyer une URL au lieu du chemin du fichier


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


#################################################################


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/a_propos")
def a_propos():
    return render_template("/page/a_propos.html")


@app.route("/service")
def service():
    return render_template("/page/service.html")


@app.route("/achete_maison")
def achete_maison():
    return render_template("/page/achete_maison.html")


@app.route("/loue_maison")
def loue_maison():
    return render_template("/page/loue_maison.html")


@app.route("/contacte")
def contacte():
    return render_template("/page/contacte.html")


############################################################################

#### profile ###


@app.route("/profile_user")
def profile_user():
    return render_template("/profile/profile_user.html")


######## maison ###########


@app.route("/mise_en_vente_maison")
def add_mise_en_vente_maison():
    return render_template("/formulaire/ajoute/mise_en_vente_maison.html")


@app.route("/modifier_mise_en_vente_maison")
def modifier_mise_en_vente_maison():
    return render_template("/formulaire/modifier/modifier_mise_en_vente_maison.html")


@app.route("/supprimer_mise_en_vente_maison")
def supprimer_mise_en_vente_maison():
    return


@app.route("/profile_maison_en_vente")
def profile_maison_en_vente():
    return render_template("/profile/profile_maison.html")


#### loue_maison ###################

# @app.route('/mise_en_location', methods=["GET", "POST"])
# def mise_en_location():

#     if request.method == "POST":
#         Ville = request.form['Ville']
#         Commune = request.form['Commune']
#         Nombre_de_pieces = request.form['Nombre_de_pieces']
#         Prix_mensuel = request.form['Prix_mensuel']
#         Caution = request.form['Caution']
#         Avance = request.form['Avance']
#         Descriptions = request.form['message']
#         Type_de_maison = request.form['Type_de_maison']
#         Statut_maison = request.form['Statut_maison']
#         GPS = request.form['GPS']

#         connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
#         cursor = connection.cursor()
#         images = []
#         for i in range(1, 11):
#             image_key = f'myfiles-{i}'
#             if image_key in request.files:
#                 image_file = request.files[image_key]
#                 if image_file.filename != '':
#                     # Enregistrez l'image sur un système de stockage et obtenez l'URL
#                     image_url = save_image_to_storage(image_file)
#                     images.append(image_url)

#         # Mettre à jour la requête SQL pour inclure les colonnes d'URL d'image
#         cursor.execute("""INSERT INTO Locations
#                             (Ville, Commune, Nombre_de_pieces, Prix_mensuel, Caution, Avance, Descriptions,
#                             Type_de_maison, Statut_maison, GPS, Image1, Image2, Image3, Image4, Image5,
#                             Image6, Image7, Image8, Image9, Image10)
#                             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
#                             (Ville, Commune, Nombre_de_pieces, Prix_mensuel, Caution, Avance, Descriptions,
#                             Type_de_maison, Statut_maison, GPS, *images, *[''] * (10 - len(images))))


#         connection.commit()
#         cursor.close()
#         connection.close()

#         return redirect(url_for('profile_user'))

#     return render_template('/formulaire/ajoute/mise_en_location.html')


@app.route("/profile_location")
def profile_location():
    return render_template("/profile/profile_location.html")


@app.route("/modifier_mise_en_location")
def modifier_mise_en_location():
    return render_template("/formulaire/modifier/modifier_mise_en_location.html")


@app.route("/supprimer_mise_en_location")
def supprimer_mise_en_location():
    return


######## service  ###########


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


@app.route("/connexion")
def connexion():
    return render_template("./formulaire/connexion/login.html")


@app.route("/register")
def register():
    return render_template("./formulaire/connexion/register.html")


if __name__ == "__main__":
    app.run(debug=True)
