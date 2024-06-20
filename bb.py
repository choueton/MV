# Route pour gérer les actions de like/dislike
# @app.route('/like/<int:IdLocations>', methods=["GET", "POST"])
# def like_location(IdLocations):
#     # data = request.json
#     location_id = IdLocations

#     # Récupérer l'ID de l'utilisateur
#     user_id = get_user_id()

#     # Connexion à la base de données
#     conn = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
#     cursor = conn.cursor()

#     # Vérification si l'utilisateur a déjà aimé ou non cet emplacement
#     cursor.execute("SELECT type_action FROM like_location WHERE idutilisateur = ? AND IdLocations = ?", (user_id, location_id))
#     previous_action = cursor.fetchone()

#     if previous_action:
#         if previous_action[0] == 'like':
#             action = 'dislike'
#             cursor.execute("UPDATE like_location SET type_action = ? WHERE idutilisateur = ? AND IdLocations = ?", (action, user_id, location_id))
#             # Réduire le nombre de likes dans la table Locations
#             cursor.execute("UPDATE Locations SET Likes = Likes - 1 WHERE IdLocations = ?", (location_id,))
#         else:
#             action = 'like'
#             cursor.execute("UPDATE like_location SET type_action = ? WHERE idutilisateur = ? AND IdLocations = ?", (action, user_id, location_id))
#             # Augmenter le nombre de likes dans la table Locations
#             cursor.execute("UPDATE Locations SET Likes = Likes + 1 WHERE IdLocations = ?", (location_id,))
#     else:
#         # Ajoute une nouvelle entrée pour l'utilisateur
#         action = 'like'
#         cursor.execute("INSERT INTO like_location (idutilisateur, IdLocations, type_action) VALUES (?, ?, ?)", (user_id, location_id, action))
#         # Augmenter le nombre de likes dans la table Locations
#         cursor.execute("UPDATE Locations SET Likes = Likes + 1 WHERE IdLocations = ?", (location_id,))

#     # Commit et fermeture de la connexion à la base de données
#     conn.commit()
#     conn.close()
    
#     # Si l'utilisateur est connecté, mettre à jour l'identifiant dans la base de données
#     if 'IdUtilisateur' in session:
#         cursor = conn.cursor()
#         cursor.execute("UPDATE like_location SET idutilisateur = ? WHERE idutilisateur = ?", (session['IdUtilisateur'], user_id))
#         conn.commit()
#         conn.close()
#         # Supprimer le cookie car l'utilisateur est connecté
#         session.pop("Idcooki", None)

#     return redirect(url_for("loue_maison"))





# @app.route("/loue_maison", methods=["GET", "POST"])
# def loue_maison():
#     # Connexion à la base de données
#     conn = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
#     cursor = conn.cursor()

#     # Récupération de la page actuelle depuis l'URL
#     page = request.args.get(get_page_parameter(), type=int, default=1)
#     per_page = 5  # Nombre d'éléments à afficher par page

#     # Récupérer les filtres
#     ville = request.args.get("Ville")
#     commune = request.args.get("Commune")
#     nombre_de_pieces = request.args.get("Nombre_de_pieces")
#     prix_min = request.args.get("Prix_min")
#     prix_max = request.args.get("Prix_max")

#     # Construction de la requête SQL en fonction des filtres
#     query_count = "SELECT COUNT(*) FROM Locations WHERE 1=1"
#     params_count = []
#     if ville:
#         query_count += " AND Ville = ?"
#         params_count.append(ville)
#     if commune:
#         query_count += " AND Commune = ?"
#         params_count.append(commune)
#     if nombre_de_pieces:
#         query_count += " AND Nombre_de_pieces = ?"
#         params_count.append(nombre_de_pieces)
#     if prix_min:
#         query_count += " AND Prix_mensuel >= ?"
#         params_count.append(prix_min)
#     if prix_max:
#         query_count += " AND Prix_mensuel <= ?"
#         params_count.append(prix_max)

#     # Exécution de la requête pour obtenir le nombre total d'éléments
#     cursor.execute(query_count, params_count)
#     total_count = cursor.fetchone()[0]

#     # Calcul de l'offset à partir de la page et du nombre d'éléments par page
#     offset = (page - 1) * per_page

#     # Construction de la requête SQL pour récupérer les éléments à afficher
#     query_select = """
#     SELECT l.*, COALESCE(ul.type_action, 'none') as type_action
#     FROM Locations l
#     LEFT JOIN user_like ul ON l.IdLocations = ul.IdLocations AND ul.idutilisateur = ?
#     WHERE 1=1
#     """
#     params_select = [get_user_id()]
#     if ville:
#         query_select += " AND Ville = ?"
#         params_select.append(ville)
#     if commune:
#         query_select += " AND Commune = ?"
#         params_select.append(commune)
#     if nombre_de_pieces:
#         query_select += " AND Nombre_de_pieces = ?"
#         params_select.append(nombre_de_pieces)
#     if prix_min:
#         query_select += " AND Prix_mensuel >= ?"
#         params_select.append(prix_min)
#     if prix_max:
#         query_select += " AND Prix_mensuel <= ?"
#         params_select.append(prix_max)
    
#     query_select += " ORDER BY IdLocations OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
#     params_select += [offset, per_page]

#     # Exécution de la requête pour obtenir les éléments à afficher
#     cursor.execute(query_select, params_select)
#     loc_afi = cursor.fetchall()

#     # Initialize an empty list to store processed data
#     locations = []

#     for row in loc_afi:
#         # Process each row and extract the Image1 attribute
#         images = row.Image1.split(",") if row.Image1 else []
#         # Append a dictionary with the processed data to the locations list
#         locations.append({"row": row, "images": images, "liked": row.type_action == 'like'})

#     # Configuration de la pagination avec le nombre total d'éléments et le nombre d'éléments par page
#     pagination = Pagination(page=page, total=total_count, per_page=per_page, css_framework="bootstrap5")

#     # Fermeture du curseur et de la connexion
#     cursor.close()
#     conn.close()

#     # Rendu du template avec les données récupérées et la pagination
#     return render_template("/page/loue_maison.html", locations=locations, pagination=pagination)



# @app.route("/achete_maison", methods=["GET", "POST"])
# def achete_maison():

#     # Connexion à la base de données
#     conn = pyodbc.connect(app.config["SQL_SERVER_CONNECTION_STRING"])
#     cursor = conn.cursor()

#     # Récupération de la page actuelle depuis l'URL
#     page = request.args.get(get_page_parameter(), type=int, default=1)

#     # Nombre d'éléments à afficher par page
#     per_page = 5

#     # Définition des filtres
#     ville = request.args.get("Ville")
#     commune = request.args.get("Commune")
#     nombre_de_pieces = request.args.get("Nombre_de_pieces")
#     prix_min = request.args.get("Prix_min")
#     prix_max = request.args.get("Prix_max")

#     # Construction de la requête SQL en fonction des filtres
#     query_count = "SELECT COUNT(*) FROM Maison WHERE 1=1"
#     params_count = []

#     if ville:
#         query_count += " AND Ville = ?"
#         params_count.append(ville)
#     if commune:
#         query_count += " AND Commune = ?"
#         params_count.append(commune)
#     if nombre_de_pieces:
#         query_count += " AND Nombre_de_pieces = ?"
#         params_count.append(nombre_de_pieces)
#     if prix_min:
#         query_count += " AND Prix_unitaire >= ?"
#         params_count.append(prix_min)
#     if prix_max:
#         query_count += " AND Prix_unitaire <= ?"
#         params_count.append(prix_max)

#     # Exécution de la requête pour obtenir le nombre total d'éléments
#     cursor.execute(query_count, params_count)
#     total_count = cursor.fetchone()[0]

#     # Calcul de l'offset à partir de la page et du nombre d'éléments par page
#     offset = (page - 1) * per_page

#     # Construction de la requête SQL pour récupérer les éléments à afficher
#     query_select = """
#     SELECT m.*, COALESCE(ul.type_action, 'none') as type_action
#     FROM Maison m
#     LEFT JOIN user_like ul ON m.IdMaison = ul.IdMaison AND ul.idutilisateur = ?
#     WHERE 1=1
#     """
#     params_select = [get_user_id()]

#     if ville:
#         query_select += " AND Ville = ?"
#         params_select.append(ville)
#     if commune:
#         query_select += " AND Commune = ?"
#         params_select.append(commune)
#     if nombre_de_pieces:
#         query_select += " AND Nombre_de_pieces = ?"
#         params_select.append(nombre_de_pieces)
#     if prix_min:
#         query_select += " AND Prix_unitaire >= ?"
#         params_select.append(prix_min)
#     if prix_max:
#         query_select += " AND Prix_unitaire <= ?"
#         params_select.append(prix_max)

#     query_select += " ORDER BY IdMaison OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
#     params_select += [offset, per_page]

#     # Exécution de la requête pour obtenir les éléments à afficher
#     cursor.execute(query_select, params_select)
#     maison_ifo = cursor.fetchall()

#     maison = []

#     for row in maison_ifo:
#         # Process each row and extract the Image1 attribute
#         images = row.Image1.split(",") if row.Image1 else []
#         # Append a dictionary with the processed data to the locations list
#         maison.append({"row": row, "images": images})
#     # Configuration de la pagination avec le nombre total d'éléments et le nombre d'éléments par page
#     pagination = Pagination(
#         page=page, total=total_count, per_page=per_page, css_framework="bootstrap5"
#     )

#     # Fermeture du curseur et de la connexion
#     cursor.close()
#     conn.close()

#     return render_template(
#         "/page/achete_maison.html", maison_ifo=maison, pagination=pagination
#     )




import re

def get_location_by_link(map_link):
    match = re.search(r'@(-?\d+\.\d+),(-?\d+\.\d+)', map_link)
    if match:
        return "{}, {}".format(match.group(1), match.group(2))
    return None

GPS = get_location_by_link('https://maps.app.goo.gl/fyuCm1aefsdrWskNA')

print(GPS)
