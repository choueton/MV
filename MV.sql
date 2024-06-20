DROP DATABASE IF EXISTS MV
CREATE DATABASE MV


DROP TABLE IF EXISTS Administrateur
CREATE TABLE Administrateur (
IdAdministrateur  INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Nom_et_prenoms VARCHAR(500),
Mot_de_pass VARCHAR(200),
Telephone VARCHAR(200)
)

DROP TABLE IF EXISTS Utilisateur
CREATE TABLE Utilisateur (
IdUtilisateur INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Nom_et_prenoms VARCHAR(500),
Email VARCHAR(500),
Mot_de_pass VARCHAR(200),
Adresse VARCHAR(200),
Telephone VARCHAR(200)
)

DROP TABLE IF EXISTS Maison
CREATE TABLE Maison (
IdMaison INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Ville VARCHAR(200),
Commune VARCHAR(200),
Nombre_de_pieces INT,
Prix_unitaire FLOAT,
Descriptions VARCHAR(MAX),
Type_de_maison VARCHAR(200),
Statut_maison VARCHAR(200),
GPS VARCHAR(200),
Image1 VARCHAR(MAX),
IdUtilisateur INT NOT NULL,
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)


DROP TABLE IF EXISTS Locations
CREATE TABLE Locations (
IdLocations INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Ville VARCHAR(200),
Commune VARCHAR(200),
Nombre_de_pieces INT,
Prix_mensuel FLOAT,
Caution FLOAT,
Avance FLOAT,
Descriptions VARCHAR(MAX),
Type_de_maison VARCHAR(200),
Statut_maison VARCHAR(200),
GPS VARCHAR(200),
Image1 VARCHAR(MAX),
IdUtilisateur INT NOT NULL,
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)


DROP TABLE IF EXISTS Services_demande;
CREATE TABLE Services_demande (
    IdServices_demande INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    nom_et_prenom VARCHAR(200),
    Type_de_services VARCHAR(200),
    lieu_debitation VARCHAR(200),
    telephonne VARCHAR(200),
    Descriptions VARCHAR(200),
    Dates DATETIME,
    Statut_services VARCHAR(200),
);

DROP TABLE IF EXISTS interesse;
CREATE TABLE interesse (
    IdServices_demande INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    nom VARCHAR(200),
    prenom VARCHAR(200),
    Email VARCHAR(200),
    telephonne VARCHAR(200),
    Descriptions VARCHAR(200),
    IdLocations INT,
    IdMaison INT,
    FOREIGN KEY (IdLocations) REFERENCES Locations (IdLocations),
    FOREIGN KEY (IdMaison) REFERENCES Maison (IdMaison),
);


DROP TABLE IF EXISTS contacte;
CREATE TABLE contacte (
    idcontacte INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    nom VARCHAR(200),
    prenom VARCHAR(200),
    Email VARCHAR(200),
    telephonne VARCHAR(200),
    Descriptions VARCHAR(200),
);


DROP TABLE IF EXISTS Vendu
CREATE TABLE Vendu (
IdVendu INT NOT NULL PRIMARY KEY IDENTITY(1,1),
IdMaison INT NOT NULL,
IdUtilisateur INT NOT NULL,
FOREIGN KEY (IdMaison) REFERENCES Maison (IdMaison),
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)

DROP TABLE IF EXISTS Loué
CREATE TABLE Loué (
IdLoué INT NOT NULL PRIMARY KEY IDENTITY(1,1),
IdMaison INT NOT NULL,
IdUtilisateur INT NOT NULL,
FOREIGN KEY (IdMaison) REFERENCES Maison (IdMaison),
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)

DROP TABLE IF EXISTS Historique_servives
CREATE TABLE Historique_servives (
IdHist_servives INT NOT NULL PRIMARY KEY IDENTITY(1,1),
IdUtilisateur INT NOT NULL,
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)








INSERT INTO Maison (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_unitaire, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Cocody', 'Angré', 5, 3, 2, '200', 120000000, 'Villa de luxe avec piscine et jardin', 'Villa', 'En vente', '5.3470, -4.0245', 2, 30, 150),
('San-Pédro', 'Bardot', 'Zone Industrielle', 4, 3, 2, '180', 95000000, 'Maison spacieuse proche du port', 'Maison', 'Vendu', '4.7477, -6.6356', 5, 45, 120),
('Bouaké', 'Ahougnansou', 'Belleville', 3, 2, 1, '150', 85000000, 'Maison moderne avec jardin', 'Maison', 'En vente', '7.6908, -5.0326', 1, 27, 200),
('Yamoussoukro', 'Kokrenou', 'Quartier Présidentiel', 4, 3, 2, '220', 115000000, 'Grande villa avec garage et piscine', 'Villa', 'Vendu', '6.8201, -5.2768', 3, 35, 180),
('Daloa', 'Gbatta', 'Quartier Résidentiel', 2, 1, 1, '100', 65000000, 'Petit appartement rénové', 'Appartement', 'En vente', '6.8782, -6.4527', 6, 14, 90),
('Man', 'Libreville', 'Camp Militaire', 3, 2, 1, '140', 75000000, 'Maison familiale avec cour', 'Maison', 'Vendu', '7.4142, -7.5535', 7, 22, 110),
('Gagnoa', 'Garahio', 'Quartier Sogefiha', 2, 1, 1, '120', 60000000, 'Petit appartement lumineux', 'Appartement', 'En vente', '6.1321, -5.9509', 4, 19, 80),
('Korhogo', 'Pelengana', 'Haute Ville', 3, 2, 2, '170', 92000000, 'Maison avec terrasse', 'Maison', 'Vendu', '9.4579, -5.6293', 2, 25, 140),
('Abengourou', 'Akan', 'Quartier Bellevue', 3, 2, 1, '130', 70000000, 'Appartement rénové en centre-ville', 'Appartement', 'En vente', '6.7305, -3.4915', 3, 20, 70),
('Aboisso', 'Aboisso Ville', 'Quartier Administratif', 4, 3, 2, '180', 105000000, 'Villa moderne avec piscine', 'Villa', 'Vendu', '5.4725, -3.2063', 4, 28, 200),
('Divo', 'Bada', 'Quartier Résidentiel', 2, 1, 1, '100', 58000000, 'Maison proche du marché', 'Maison', 'En vente', '5.8375, -5.3580', 5, 15, 60),
('Abidjan', 'Marcory', 'Zone 4', 4, 3, 2, '160', 95000000, 'Maison spacieuse avec jardin', 'Maison', 'Vendu', '5.3056, -3.9985', 6, 29, 210),
('San-Pédro', 'Sewe', 'Quartier Résidentiel', 3, 2, 1, '140', 75000000, 'Appartement proche de la plage', 'Appartement', 'En vente', '4.7480, -6.6355', 7, 22, 160),
('Yamoussoukro', 'Attiégouakro', 'Quartier Industriel', 3, 2, 1, '130', 70000000, 'Maison moderne avec jardin', 'Maison', 'Vendu', '6.8250, -5.2781', 1, 18, 130),
('Bouaké', 'Zone 4', 'Quartier Commercial', 4, 3, 2, '200', 100000000, 'Grande villa avec garage', 'Villa', 'En vente', '7.6880, -5.0310', 2, 24, 190),
('Man', 'Libreville', 'Quartier Militaire', 2, 1, 1, '110', 65000000, 'Petit appartement avec vue sur la montagne', 'Appartement', 'Vendu', '7.4160, -7.5561', 3, 12, 50),
('Gagnoa', 'Sogefiha', 'Quartier des Écoles', 3, 2, 1, '140', 75000000, 'Maison familiale avec cour', 'Maison', 'En vente', '6.1319, -5.9500', 4, 16, 70),
('Korhogo', 'Soba', 'Quartier Résidentiel', 3, 2, 2, '150', 80000000, 'Maison moderne avec terrasse', 'Maison', 'Vendu', '9.4580, -5.6296', 5, 21, 120),
('Abidjan', 'Adjame', 'Quartier Commercial', 2, 1, 1, '100', 65000000, 'Appartement proche des commodités', 'Appartement', 'En vente', '5.3470, -4.0370', 6, 23, 80),
('Daloa', 'Grandes Terres', 'Quartier Administratif', 4, 3, 2, '180', 90000000, 'Maison avec vue sur les montagnes', 'Maison', 'Vendu', '6.8785, -6.4525', 7, 26, 110);

INSERT INTO Maison (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_unitaire, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Cocody', 'Riviera', 5, 4, 3, '250', 130000000, 'Grande villa avec piscine et garage', 'Villa', 'En vente', '5.3581, -3.9983', 1, 40, 220),
('San-Pédro', 'Bardot', 'Zone Portuaire', 3, 2, 1, '150', 85000000, 'Maison moderne près du port', 'Maison', 'Vendu', '4.7511, -6.6364', 2, 25, 150),
('Bouaké', 'Nimbo', 'Quartier Résidentiel', 4, 3, 2, '180', 90000000, 'Maison avec jardin et garage', 'Maison', 'En vente', '7.6903, -5.0327', 3, 30, 180),
('Yamoussoukro', 'Morofé', 'Quartier des Ambassades', 5, 4, 3, '300', 140000000, 'Villa de prestige avec piscine', 'Villa', 'Vendu', '6.8218, -5.2769', 4, 50, 240),
('Daloa', 'Brébo', 'Quartier Administratif', 3, 2, 1, '130', 80000000, 'Appartement spacieux avec balcon', 'Appartement', 'En vente', '6.8792, -6.4531', 5, 20, 130),
('Man', 'Abattoir', 'Quartier Militaire', 4, 3, 2, '200', 95000000, 'Maison familiale avec grande cour', 'Maison', 'Vendu', '7.4165, -7.5563', 6, 35, 160),
('Gagnoa', 'Gagnoa', 'Quartier Commercial', 2, 1, 1, '100', 70000000, 'Petit appartement moderne', 'Appartement', 'En vente', '6.1328, -5.9512', 7, 15, 90),
('Korhogo', 'Péléforo', 'Quartier Central', 3, 2, 2, '160', 85000000, 'Maison avec terrasse et jardin', 'Maison', 'Vendu', '9.4583, -5.6295', 1, 28, 150),
('Abengourou', 'Indénié', 'Quartier Administratif', 3, 2, 1, '140', 75000000, 'Appartement rénové', 'Appartement', 'En vente', '6.7320, -3.4918', 2, 18, 100),
('Aboisso', 'Bia Sud', 'Quartier Administratif', 5, 4, 3, '240', 120000000, 'Grande villa avec piscine', 'Villa', 'Vendu', '5.4730, -3.2065', 3, 38, 200),
('Divo', 'Gogobro', 'Quartier Résidentiel', 2, 1, 1, '90', 60000000, 'Maison près du marché', 'Maison', 'En vente', '5.8380, -5.3582', 4, 13, 80),
('Abidjan', 'Plateau', 'Centre-ville', 4, 3, 2, '180', 100000000, 'Appartement de luxe avec vue', 'Appartement', 'Vendu', '5.3043, -4.0027', 5, 30, 190),
('San-Pédro', 'Balmer', 'Quartier Résidentiel', 3, 2, 1, '150', 80000000, 'Appartement proche de la plage', 'Appartement', 'En vente', '4.7490, -6.6359', 6, 20, 110),
('Yamoussoukro', 'Koffikro', 'Quartier Industriel', 4, 3, 2, '200', 90000000, 'Maison moderne avec jardin', 'Maison', 'Vendu', '6.8252, -5.2783', 7, 25, 140),
('Bouaké', 'Ahougnansou', 'Quartier Commercial', 3, 2, 1, '130', 80000000, 'Appartement avec balcon', 'Appartement', 'En vente', '7.6881, -5.0311', 1, 22, 100),
('Man', 'Libreville', 'Quartier Industriel', 2, 1, 1, '90', 60000000, 'Petit appartement avec vue', 'Appartement', 'Vendu', '7.4165, -7.5562', 2, 12, 70),
('Gagnoa', 'Garahio', 'Quartier des Écoles', 4, 3, 2, '180', 90000000, 'Maison familiale avec cour', 'Maison', 'En vente', '6.1316, -5.9507', 3, 18, 110),
('Korhogo', 'Soba', 'Quartier Industriel', 3, 2, 2, '140', 85000000, 'Maison avec terrasse et jardin', 'Maison', 'Vendu', '9.4584, -5.6292', 4, 21, 120),
('Abidjan', 'Adjame', 'Quartier Commercial', 2, 1, 1, '100', 75000000, 'Appartement proche des commodités', 'Appartement', 'En vente', '5.3471, -4.0371', 5, 20, 90),
('Daloa', 'Grandes Terres', 'Quartier Administratif', 5, 4, 3, '220', 110000000, 'Villa avec vue sur les montagnes', 'Villa', 'Vendu', '6.8786, -6.4526', 6, 40, 210);


INSERT INTO Maison (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_unitaire, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Cocody', 'Angré', 4, 3, 2, '200', 120000000, 'Maison moderne avec piscine', 'Maison', 'En vente', '5.3386, -3.9598', 1, 30, 200),
('San-Pédro', 'Sewe', 'Quartier Balmer', 3, 2, 1, '150', 85000000, 'Maison proche de la plage', 'Maison', 'Vendu', '4.7500, -6.6350', 2, 20, 150),
('Bouaké', 'Dar-Es-Salam', 'Quartier Résidentiel', 4, 3, 2, '180', 100000000, 'Maison avec grand jardin', 'Maison', 'En vente', '7.6880, -5.0290', 3, 25, 180),
('Yamoussoukro', 'Kokrenou', 'Quartier des Ministres', 5, 4, 3, '300', 140000000, 'Villa luxueuse avec piscine', 'Villa', 'Vendu', '6.8090, -5.2760', 4, 50, 250),
('Daloa', 'Orly', 'Quartier Industriel', 3, 2, 1, '140', 85000000, 'Appartement avec vue', 'Appartement', 'En vente', '6.8770, -6.4520', 5, 20, 140),
('Man', 'Zérégbo', 'Quartier Industriel', 4, 3, 2, '200', 95000000, 'Maison avec grande cour', 'Maison', 'Vendu', '7.4200, -7.5600', 6, 35, 160),
('Gagnoa', 'Dioulabougou', 'Quartier Industriel', 2, 1, 1, '100', 70000000, 'Petit appartement moderne', 'Appartement', 'En vente', '6.1300, -5.9500', 7, 15, 90),
('Korhogo', 'Koko', 'Quartier des Écoles', 3, 2, 2, '160', 85000000, 'Maison avec terrasse', 'Maison', 'Vendu', '9.4500, -5.6300', 1, 28, 150),
('Abengourou', 'Belleville', 'Quartier Administratif', 3, 2, 1, '140', 75000000, 'Appartement bien situé', 'Appartement', 'En vente', '6.7300, -3.4900', 2, 18, 100),
('Aboisso', 'Abradine', 'Quartier des Affaires', 5, 4, 3, '240', 120000000, 'Villa avec grande piscine', 'Villa', 'Vendu', '5.4700, -3.2050', 3, 38, 200),
('Divo', 'Texaco', 'Quartier Industriel', 2, 1, 1, '90', 60000000, 'Maison près du centre', 'Maison', 'En vente', '5.8400, -5.3600', 4, 13, 80),
('Abidjan', 'Treichville', 'Quartier des Affaires', 4, 3, 2, '180', 100000000, 'Appartement de luxe', 'Appartement', 'Vendu', '5.3000, -4.0000', 5, 30, 190),
('San-Pédro', 'Balmer', 'Zone Résidentielle', 3, 2, 1, '150', 80000000, 'Maison avec petit jardin', 'Maison', 'En vente', '4.7500, -6.6350', 6, 20, 110),
('Yamoussoukro', 'Attiégouakro', 'Quartier Industriel', 4, 3, 2, '200', 90000000, 'Maison avec jardin', 'Maison', 'Vendu', '6.8250, -5.2781', 7, 25, 140),
('Bouaké', 'Ahougnansou', 'Quartier Industriel', 3, 2, 1, '130', 80000000, 'Appartement avec balcon', 'Appartement', 'En vente', '7.6881, -5.0311', 1, 22, 100),
('Man', 'Libreville', 'Quartier Industriel', 2, 1, 1, '90', 60000000, 'Petit appartement avec vue', 'Appartement', 'Vendu', '7.4165, -7.5562', 2, 12, 70),
('Gagnoa', 'Garahio', 'Quartier des Écoles', 4, 3, 2, '180', 90000000, 'Maison familiale avec cour', 'Maison', 'En vente', '6.1316, -5.9507', 3, 18, 110),
('Korhogo', 'Soba', 'Quartier Industriel', 3, 2, 2, '140', 85000000, 'Maison avec terrasse', 'Maison', 'Vendu', '9.4584, -5.6292', 4, 21, 120),
('Abidjan', 'Adjame', 'Quartier Commercial', 2, 1, 1, '100', 75000000, 'Appartement proche des commodités', 'Appartement', 'En vente', '5.3471, -4.0371', 5, 20, 90),
('Daloa', 'Grandes Terres', 'Quartier Administratif', 5, 4, 3, '220', 110000000, 'Villa avec vue sur les montagnes', 'Villa', 'Vendu', '6.8786, -6.4526', 6, 40, 210);


INSERT INTO Maison (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_unitaire, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Cocody', 'Riviera', 4, 3, 2, '180', 110000000, 'Maison avec vue sur la lagune', 'Maison', 'En vente', '5.3456, -3.9857', 1, 28, 220),
('San-Pédro', 'Balmer', 'Quartier des Pêcheurs', 3, 2, 1, '130', 85000000, 'Maison proche de la mer', 'Maison', 'Vendu', '4.7512, -6.6375', 2, 19, 140),
('Bouaké', 'Zone Industrielle', 'Quartier Industriel', 4, 3, 2, '170', 95000000, 'Maison moderne avec garage', 'Maison', 'En vente', '7.6900, -5.0298', 3, 24, 175),
('Yamoussoukro', 'Kokrenou', 'Quartier des Ministres', 5, 4, 3, '290', 150000000, 'Villa avec jardin et piscine', 'Villa', 'Vendu', '6.8100, -5.2770', 4, 48, 245),
('Daloa', 'Orly', 'Quartier Industriel', 3, 2, 1, '150', 90000000, 'Appartement avec balcon', 'Appartement', 'En vente', '6.8785, -6.4532', 5, 21, 160),
('Man', 'Zérégbo', 'Quartier Industriel', 4, 3, 2, '200', 100000000, 'Maison avec cour et jardin', 'Maison', 'Vendu', '7.4205, -7.5605', 6, 33, 180),
('Gagnoa', 'Dioulabougou', 'Quartier Résidentiel', 2, 1, 1, '95', 75000000, 'Appartement moderne', 'Appartement', 'En vente', '6.1301, -5.9510', 7, 16, 85),
('Korhogo', 'Koko', 'Quartier des Écoles', 3, 2, 2, '150', 90000000, 'Maison avec terrasse', 'Maison', 'Vendu', '9.4501, -5.6301', 1, 27, 145),
('Abengourou', 'Bellevue', 'Quartier Administratif', 3, 2, 1, '135', 80000000, 'Appartement bien situé', 'Appartement', 'En vente', '6.7301, -3.4910', 2, 17, 95),
('Aboisso', 'Abradine', 'Quartier des Affaires', 5, 4, 3, '230', 125000000, 'Villa avec piscine et garage', 'Villa', 'Vendu', '5.4701, -3.2051', 3, 37, 210),
('Divo', 'Texaco', 'Quartier Résidentiel', 2, 1, 1, '85', 65000000, 'Maison près du centre-ville', 'Maison', 'En vente', '5.8401, -5.3601', 4, 14, 75),
('Abidjan', 'Treichville', 'Quartier des Affaires', 4, 3, 2, '170', 105000000, 'Appartement de luxe avec vue', 'Appartement', 'Vendu', '5.3001, -4.0001', 5, 29, 180),
('San-Pédro', 'Balmer', 'Zone Résidentielle', 3, 2, 1, '145', 85000000, 'Maison avec jardin', 'Maison', 'En vente', '4.7501, -6.6351', 6, 19, 115),
('Yamoussoukro', 'Attiégouakro', 'Quartier Résidentiel', 4, 3, 2, '190', 95000000, 'Maison avec jardin et terrasse', 'Maison', 'Vendu', '6.8251, -5.2782', 7, 23, 135),
('Bouaké', 'Ahougnansou', 'Quartier Industriel', 3, 2, 1, '140', 85000000, 'Appartement avec balcon et vue', 'Appartement', 'En vente', '7.6882, -5.0312', 1, 21, 105),
('Man', 'Libreville', 'Quartier Militaire', 2, 1, 1, '95', 70000000, 'Appartement avec vue sur la montagne', 'Appartement', 'Vendu', '7.4167, -7.5562', 2, 11, 65),
('Gagnoa', 'Garahio', 'Quartier des Écoles', 4, 3, 2, '190', 95000000, 'Maison familiale avec cour et jardin', 'Maison', 'En vente', '6.1316, -5.9501', 3, 17, 115),
('Korhogo', 'Soba', 'Quartier Résidentiel', 3, 2, 2, '150', 85000000, 'Maison moderne avec grande terrasse', 'Maison', 'Vendu', '9.4585, -5.6293', 4, 20, 125),
('Abidjan', 'Adjame', 'Quartier Commercial', 2, 1, 1, '95', 80000000, 'Appartement proche des commodités', 'Appartement', 'En vente', '5.3471, -4.0371', 5, 19, 85),
('Daloa', 'Grandes Terres', 'Quartier Administratif', 5, 4, 3, '220', 115000000, 'Villa avec vue sur les montagnes', 'Villa', 'Vendu', '6.8786, -6.4526', 6, 39, 220);

INSERT INTO Maison (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_unitaire, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Cocody', 'Angré', 5, 4, 3, '250', 125000000, 'Villa luxueuse avec piscine', 'Villa', 'En vente', '5.3399, -4.0330', 1, 45, 210),
('San-Pédro', 'San Pedro Ville', 'Quartier Plage', 3, 2, 1, '130', 90000000, 'Maison vue sur mer', 'Maison', 'Vendu', '4.7450, -6.6420', 2, 26, 150),
('Bouaké', 'Dar-Es-Salam', 'Quartier Administratif', 4, 3, 2, '160', 98000000, 'Maison moderne avec grand jardin', 'Maison', 'En vente', '7.6902, -5.0295', 3, 30, 170),
('Yamoussoukro', 'Kokrenou', 'Quartier Industriel', 5, 4, 3, '220', 140000000, 'Grande villa avec piscine', 'Villa', 'Vendu', '6.8102, -5.2772', 4, 50, 250),
('Daloa', 'Lobia', 'Quartier Administratif', 3, 2, 1, '140', 87000000, 'Appartement avec grande terrasse', 'Appartement', 'En vente', '6.8802, -6.4529', 5, 23, 140),
('Man', 'Dompleu', 'Quartier Résidentiel', 4, 3, 2, '180', 95000000, 'Maison spacieuse avec jardin', 'Maison', 'Vendu', '7.4161, -7.5570', 6, 34, 190),
('Gagnoa', 'Barreau', 'Quartier des Affaires', 2, 1, 1, '90', 72000000, 'Appartement moderne proche des commerces', 'Appartement', 'En vente', '6.1302, -5.9511', 7, 15, 90),
('Korhogo', 'Kapielahio', 'Quartier Commercial', 3, 2, 2, '150', 93000000, 'Maison moderne avec terrasse', 'Maison', 'Vendu', '9.4503, -5.6303', 1, 28, 160),
('Abengourou', 'Akan', 'Quartier des Affaires', 3, 2, 1, '130', 80000000, 'Appartement bien situé', 'Appartement', 'En vente', '6.7312, -3.4921', 2, 18, 100),
('Aboisso', 'Aboisso Ville', 'Quartier Industriel', 5, 4, 3, '240', 120000000, 'Villa avec garage et piscine', 'Villa', 'Vendu', '5.4712, -3.2052', 3, 35, 210),
('Divo', 'Abia', 'Quartier Résidentiel', 2, 1, 1, '85', 68000000, 'Appartement proche du centre-ville', 'Appartement', 'En vente', '5.8362, -5.3590', 4, 14, 80),
('Abidjan', 'Marcory', 'Quartier des Affaires', 4, 3, 2, '170', 108000000, 'Appartement de luxe avec vue', 'Appartement', 'Vendu', '5.3070, -4.0040', 5, 32, 190),
('San-Pédro', 'San Pedro Ville', 'Zone Industrielle', 3, 2, 1, '150', 85000000, 'Maison avec petit jardin', 'Maison', 'En vente', '4.7480, -6.6350', 6, 20, 110),
('Yamoussoukro', 'Attiégouakro', 'Quartier Résidentiel', 4, 3, 2, '190', 95000000, 'Maison avec grande terrasse', 'Maison', 'Vendu', '6.8255, -5.2780', 7, 24, 140),
('Bouaké', 'Zone 3', 'Quartier Commercial', 3, 2, 1, '150', 85000000, 'Appartement moderne avec balcon', 'Appartement', 'En vente', '7.6881, -5.0318', 1, 22, 120),
('Man', 'Libreville', 'Quartier Militaire', 2, 1, 1, '95', 70000000, 'Appartement avec vue sur montagne', 'Appartement', 'Vendu', '7.4167, -7.5560', 2, 12, 70),
('Gagnoa', 'Garahio', 'Quartier Résidentiel', 4, 3, 2, '190', 92000000, 'Maison familiale avec cour', 'Maison', 'En vente', '6.1319, -5.9507', 3, 19, 120),
('Korhogo', 'Soba', 'Quartier Industriel', 3, 2, 2, '150', 90000000, 'Maison moderne avec terrasse', 'Maison', 'Vendu', '9.4585, -5.6291', 4, 23, 130),
('Abidjan', 'Adjame', 'Quartier Commercial', 2, 1, 1, '90', 80000000, 'Appartement proche commodités', 'Appartement', 'En vente', '5.3472, -4.0372', 5, 18, 90),
('Daloa', 'Grandes Terres', 'Quartier Administratif', 5, 4, 3, '220', 115000000, 'Villa avec vue sur montagnes', 'Villa', 'Vendu', '6.8786, -6.4523', 6, 40, 230);


INSERT INTO Maison (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_unitaire, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Cocody', 'Angré', 4, 3, 2, '150', 150000000, 'Villa avec piscine et jardin', 'Villa', 'En vente', '5.3526, -3.9865', 1, 40, 250),
('San-Pédro', 'Balmer', 'Zone Portuaire', 3, 2, 1, '120', 100000000, 'Maison avec vue sur la mer', 'Maison', 'Vendu', '4.7500, -6.6400', 2, 20, 190),
('Bouaké', 'Zone 4', 'Quartier Résidentiel', 5, 4, 3, '200', 130000000, 'Grande villa avec piscine', 'Villa', 'En vente', '7.6921, -5.0303', 3, 35, 220),
('Yamoussoukro', 'Kokrenou', 'Quartier Administratif', 3, 2, 1, '130', 95000000, 'Maison près du palais présidentiel', 'Maison', 'Vendu', '6.8180, -5.2752', 4, 15, 140),
('Daloa', 'Orly', 'Quartier Industriel', 4, 3, 2, '180', 110000000, 'Maison avec grand jardin', 'Maison', 'En vente', '6.8756, -6.4449', 5, 28, 160),
('Man', 'Masion', 'Quartier Résidentiel', 3, 2, 1, '130', 100000000, 'Maison avec belle vue', 'Maison', 'Vendu', '7.4111, -7.5543', 6, 25, 150),
('Gagnoa', 'Barouhi', 'Quartier des Écoles', 2, 1, 1, '100', 80000000, 'Appartement près des commodités', 'Appartement', 'En vente', '6.1324, -5.9508', 7, 10, 80),
('Korhogo', 'Koni', 'Quartier Résidentiel', 4, 3, 2, '170', 120000000, 'Maison moderne avec terrasse', 'Maison', 'Vendu', '9.4534, -5.6202', 1, 30, 200),
('Abengourou', 'Indénié', 'Quartier des Affaires', 3, 2, 1, '140', 90000000, 'Appartement bien situé', 'Appartement', 'En vente', '6.7262, -3.4931', 2, 18, 120),
('Aboisso', 'Djiboua', 'Quartier Administratif', 5, 4, 3, '230', 140000000, 'Grande villa avec piscine', 'Villa', 'Vendu', '5.4725, -3.2043', 3, 32, 240),
('Divo', 'Gozo', 'Quartier Résidentiel', 2, 1, 1, '90', 70000000, 'Petit appartement au calme', 'Appartement', 'En vente', '5.8353, -5.3607', 4, 15, 80),
('Abidjan', 'Plateau', 'Quartier des Affaires', 3, 2, 1, '150', 120000000, 'Appartement de luxe', 'Appartement', 'Vendu', '5.3175, -4.0212', 5, 25, 200),
('San-Pédro', 'Krindjabo', 'Zone Résidentielle', 2, 1, 1, '100', 80000000, 'Petit appartement avec jardin', 'Appartement', 'En vente', '4.7485, -6.6350', 6, 12, 70),
('Yamoussoukro', 'Dadiassé', 'Quartier Industriel', 4, 3, 2, '180', 100000000, 'Maison moderne avec garage', 'Maison', 'Vendu', '6.8150, -5.2781', 7, 20, 130),
('Bouaké', 'Zone 3', 'Quartier Résidentiel', 3, 2, 1, '140', 100000000, 'Maison familiale avec cour', 'Maison', 'En vente', '7.6874, -5.0293', 1, 22, 110),
('Man', 'Louhiri', 'Quartier Militaire', 2, 1, 1, '90', 70000000, 'Appartement avec vue sur montagne', 'Appartement', 'Vendu', '7.4123, -7.5550', 2, 13, 70),
('Gagnoa', 'Brégbo', 'Quartier des Écoles', 3, 2, 1, '130', 85000000, 'Maison familiale avec cour', 'Maison', 'En vente', '6.1295, -5.9493', 3, 15, 100),
('Korhogo', 'Kangala', 'Quartier Industriel', 4, 3, 2, '160', 110000000, 'Maison moderne avec terrasse', 'Maison', 'Vendu', '9.4521, -5.6231', 4, 18, 150),
('Abidjan', 'Yopougon', 'Quartier Populaire', 2, 1, 1, '90', 80000000, 'Appartement proche des commodités', 'Appartement', 'En vente', '5.3276, -4.1125', 5, 12, 90),
('Daloa', 'Nouveau Quartier', 'Quartier Administratif', 5, 4, 3, '220', 130000000, 'Grande villa avec jardin', 'Villa', 'Vendu', '6.8760, -6.4511', 6, 35, 230),
('San-Pédro', 'Sassandra', 'Quartier Industriel', 3, 2, 1, '130', 90000000, 'Maison avec terrasse', 'Maison', 'En vente', '4.7479, -6.6337', 7, 16, 100),
('Yamoussoukro', 'Dioulabougou', 'Quartier Résidentiel', 4, 3, 2, '180', 115000000, 'Maison spacieuse avec jardin', 'Maison', 'Vendu', '6.8174, -5.2775', 1, 25, 150),
('Bouaké', 'Zone 5', 'Quartier Commercial', 2, 1, 1, '100', 80000000, 'Appartement moderne avec balcon', 'Appartement', 'En vente', '7.6881, -5.0301', 2, 17, 90),
('Man', 'Glanleu', 'Quartier Militaire', 3, 2, 1, '140', 90000000, 'Appartement avec vue sur montagne', 'Appartement', 'Vendu', '7.4110, -7.5564', 3, 20, 110),
('Gagnoa', 'Dioulabougou', 'Quartier des Écoles', 4, 3, 2, '160', 95000000, 'Maison familiale avec cour', 'Maison', 'En vente', '6.1319, -5.9505', 4, 19, 120);

INSERT INTO Maison (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_unitaire, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Marcory', 'Zone 4C', 5, 4, 3, '250', 300000000, 'Villa moderne avec piscine et jardin', 'Villa', 'En vente', '5.3166, -3.9821', 1, 45, 300),
('San-Pédro', 'Lacroix', 'Quartier Industriel', 3, 2, 1, '120', 90000000, 'Maison proche du port', 'Maison', 'Vendu', '4.7495, -6.6331', 2, 25, 180),
('Bouaké', 'Nimbo', 'Quartier Commercial', 4, 3, 2, '180', 140000000, 'Grande maison avec magasin', 'Maison', 'En vente', '7.6933, -5.0305', 3, 38, 240),
('Yamoussoukro', 'Habitat', 'Quartier Résidentiel', 3, 2, 1, '150', 105000000, 'Maison près de la basilique', 'Maison', 'Vendu', '6.8167, -5.2781', 4, 18, 160),
('Daloa', 'Boulevards', 'Quartier Central', 4, 3, 2, '190', 125000000, 'Maison avec cour et garage', 'Maison', 'En vente', '6.8759, -6.4448', 5, 30, 170),
('Man', 'Nanakaha', 'Quartier Résidentiel', 3, 2, 1, '140', 95000000, 'Maison avec vue sur les montagnes', 'Maison', 'Vendu', '7.4134, -7.5556', 6, 22, 140),
('Gagnoa', 'Commerce', 'Quartier Marché', 2, 1, 1, '100', 80000000, 'Petit appartement près des commerces', 'Appartement', 'En vente', '6.1333, -5.9500', 7, 12, 90),
('Korhogo', 'Bora', 'Quartier Industriel', 4, 3, 2, '180', 130000000, 'Maison moderne avec grand jardin', 'Maison', 'Vendu', '9.4509, -5.6250', 1, 28, 210),
('Abengourou', 'Aniassué', 'Quartier Industriel', 3, 2, 1, '150', 100000000, 'Maison près des écoles', 'Maison', 'En vente', '6.7280, -3.4918', 2, 20, 130),
('Aboisso', 'Ehania', 'Quartier Résidentiel', 5, 4, 3, '220', 150000000, 'Grande villa avec piscine et garage', 'Villa', 'Vendu', '5.4752, -3.2024', 3, 35, 250),
('Divo', 'Djidji', 'Quartier Administratif', 2, 1, 1, '100', 85000000, 'Appartement au centre-ville', 'Appartement', 'En vente', '5.8361, -5.3600', 4, 18, 100),
('Abidjan', 'Treichville', 'Quartier Commercial', 3, 2, 1, '160', 110000000, 'Appartement de luxe', 'Appartement', 'Vendu', '5.3195, -4.0158', 5, 28, 220),
('San-Pédro', 'Grand-Béréby', 'Quartier Industriel', 2, 1, 1, '110', 80000000, 'Petit appartement avec jardin', 'Appartement', 'En vente', '4.7511, -6.6342', 6, 15, 80),
('Yamoussoukro', 'Logbakro', 'Quartier Administratif', 4, 3, 2, '170', 115000000, 'Maison moderne avec terrasse', 'Maison', 'Vendu', '6.8178, -5.2774', 7, 25, 150),
('Bouaké', 'Koko', 'Quartier Résidentiel', 3, 2, 1, '150', 95000000, 'Maison avec cour et jardin', 'Maison', 'En vente', '7.6891, -5.0289', 1, 22, 110),
('Man', 'Fahafou', 'Quartier Administratif', 2, 1, 1, '90', 75000000, 'Appartement avec vue sur la montagne', 'Appartement', 'Vendu', '7.4118, -7.5552', 2, 12, 70),
('Gagnoa', 'Sogebaf', 'Quartier des Écoles', 3, 2, 1, '130', 90000000, 'Maison familiale avec grand jardin', 'Maison', 'En vente', '6.1304, -5.9497', 3, 16, 100),
('Korhogo', 'Kimbirila', 'Quartier Industriel', 4, 3, 2, '160', 125000000, 'Maison moderne avec piscine', 'Maison', 'Vendu', '9.4518, -5.6228', 4, 25, 160),
('Abidjan', 'Yopougon', 'Toit Rouge', 2, 1, 1, '90', 85000000, 'Appartement proche des commodités', 'Appartement', 'En vente', '5.3296, -4.1111', 5, 18, 90),
('Daloa', 'Kadia', 'Quartier Industriel', 5, 4, 3, '240', 145000000, 'Grande villa avec jardin et piscine', 'Villa', 'Vendu', '6.8767, -6.4510', 6, 40, 260),
('San-Pédro', 'Sassandra', 'Quartier Industriel', 3, 2, 1, '140', 90000000, 'Maison avec terrasse', 'Maison', 'En vente', '4.7482, -6.6349', 7, 20, 110),
('Yamoussoukro', 'Nanan', 'Quartier Résidentiel', 4, 3, 2, '190', 130000000, 'Maison spacieuse avec grand jardin', 'Maison', 'Vendu', '6.8185, -5.2780', 1, 30, 170),
('Bouaké', 'Belleville', 'Quartier Commercial', 2, 1, 1, '100', 85000000, 'Appartement moderne avec balcon', 'Appartement', 'En vente', '7.6902, -5.0302', 2, 20, 100),
('Man', 'Biankouma', 'Quartier Militaire', 3, 2, 1, '140', 95000000, 'Appartement avec vue sur montagne', 'Appartement', 'Vendu', '7.4137, -7.5561', 3, 22, 120),
('Gagnoa', 'Digbeu', 'Quartier des Écoles', 4, 3, 2, '160', 100000000, 'Maison familiale avec cour', 'Maison', 'En vente', '6.1311, -5.9503', 4, 18, 130);

INSERT INTO Maison (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_unitaire, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Cocody', 'Angré', 4, 3, 2, '150', 180000000, 'Maison moderne avec jardin', 'Maison', 'En vente', '5.3520, -3.9860', 1, 50, 320),
('Bouaké', 'Belleville', 'Centre', 3, 2, 1, '120', 90000000, 'Appartement proche des commerces', 'Appartement', 'Vendu', '7.6902, -5.0302', 2, 30, 180),
('Yamoussoukro', 'Kokrenou', 'Quartier Résidentiel', 5, 4, 3, '250', 250000000, 'Grande villa avec piscine', 'Villa', 'En vente', '6.8133, -5.2740', 3, 40, 260),
('San-Pédro', 'Seweke', 'Quartier Industriel', 4, 3, 2, '180', 140000000, 'Maison avec vue sur mer', 'Maison', 'Vendu', '4.7490, -6.6335', 4, 20, 200),
('Korhogo', 'Koko', 'Quartier Administratif', 3, 2, 1, '140', 85000000, 'Maison proche des écoles', 'Maison', 'En vente', '9.4515, -5.6227', 5, 18, 120),
('Man', 'Kasirim', 'Centre Ville', 4, 3, 2, '160', 125000000, 'Maison spacieuse avec garage', 'Maison', 'Vendu', '7.4140, -7.5558', 6, 25, 190),
('Gagnoa', 'Dioulabougou', 'Quartier Marché', 3, 2, 1, '130', 110000000, 'Maison avec grande cour', 'Maison', 'En vente', '6.1307, -5.9502', 7, 22, 160),
('Abengourou', 'Amaffou', 'Quartier Résidentiel', 2, 1, 1, '90', 70000000, 'Petit appartement moderne', 'Appartement', 'Vendu', '6.7282, -3.4915', 1, 12, 90),
('Daloa', 'Gblapleu', 'Centre Ville', 5, 4, 3, '220', 200000000, 'Grande maison avec piscine', 'Villa', 'En vente', '6.8760, -6.4445', 2, 35, 240),
('San-Pédro', 'Daleu', 'Quartier Industriel', 3, 2, 1, '150', 100000000, 'Maison proche du port', 'Maison', 'Vendu', '4.7488, -6.6344', 3, 20, 170),
('Bouaké', 'Nimbo', 'Quartier Administratif', 4, 3, 2, '180', 145000000, 'Maison familiale avec jardin', 'Maison', 'En vente', '7.6935, -5.0304', 4, 28, 210),
('Yamoussoukro', 'Habitat', 'Quartier Résidentiel', 3, 2, 1, '120', 95000000, 'Maison moderne près de la basilique', 'Maison', 'Vendu', '6.8170, -5.2782', 5, 18, 140),
('Abidjan', 'Plateau', 'Centre Ville', 4, 3, 2, '170', 180000000, 'Appartement de luxe avec vue sur la lagune', 'Appartement', 'En vente', '5.3166, -4.0228', 6, 50, 290),
('Man', 'Danané', 'Quartier Commercial', 2, 1, 1, '90', 75000000, 'Petit appartement avec balcon', 'Appartement', 'Vendu', '7.4142, -7.5562', 7, 15, 100),
('Gagnoa', 'Gnagbodougnoa', 'Quartier des Écoles', 3, 2, 1, '130', 90000000, 'Maison près des commerces', 'Maison', 'En vente', '6.1315, -5.9499', 1, 20, 110),
('Korhogo', 'Ferké', 'Quartier Industriel', 4, 3, 2, '180', 135000000, 'Maison moderne avec piscine', 'Maison', 'Vendu', '9.4510, -5.6232', 2, 25, 200),
('San-Pédro', 'Krindjabo', 'Quartier Résidentiel', 3, 2, 1, '140', 110000000, 'Maison avec terrasse', 'Maison', 'En vente', '4.7513, -6.6346', 3, 22, 130),
('Daloa', 'Goh', 'Quartier Administratif', 5, 4, 3, '200', 220000000, 'Grande villa avec garage et piscine', 'Villa', 'Vendu', '6.8770, -6.4450', 4, 40, 270),
('Bouaké', 'Dar Es Salam', 'Quartier Marché', 3, 2, 1, '140', 105000000, 'Maison avec cour', 'Maison', 'En vente', '7.6925, -5.0301', 5, 18, 150),
('Abengourou', 'Indénié', 'Quartier Résidentiel', 2, 1, 1, '90', 80000000, 'Appartement moderne', 'Appartement', 'Vendu', '6.7275, -3.4912', 6, 14, 80),
('Man', 'Bangolo', 'Quartier Central', 4, 3, 2, '160', 125000000, 'Maison avec vue sur les montagnes', 'Maison', 'En vente', '7.4148, -7.5555', 7, 22, 150),
('Gagnoa', 'Bracodi', 'Quartier Administratif', 5, 4, 3, '220', 180000000, 'Grande villa avec piscine et jardin', 'Villa', 'Vendu', '6.1319, -5.9507', 1, 35, 230),
('Korhogo', 'Nafoun', 'Quartier Industriel', 3, 2, 1, '140', 110000000, 'Maison moderne avec terrasse', 'Maison', 'En vente', '9.4507, -5.6240', 2, 20, 150),
('San-Pédro', 'Loba', 'Quartier Industriel', 4, 3, 2, '160', 140000000, 'Maison spacieuse avec jardin', 'Maison', 'Vendu', '4.7512, -6.6350', 3, 25, 180),
('Yamoussoukro', 'Attiegouakro', 'Quartier Résidentiel', 2, 1, 1, '100', 90000000, 'Petit appartement moderne', 'Appartement', 'En vente', '6.8182, -5.2776', 4, 18, 90);

INSERT INTO Maison (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_unitaire, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Cocody', 'Angré', 4, 3, 2, '150', 180000000, 'Maison moderne avec jardin', 'Maison', 'En vente', '5.3520, -3.9860', 1, 50, 320),
('Bouaké', 'Belleville', 'Centre', 3, 2, 1, '120', 90000000, 'Appartement proche des commerces', 'Appartement', 'Vendu', '7.6902, -5.0302', 2, 30, 180),
('Yamoussoukro', 'Kokrenou', 'Quartier Résidentiel', 5, 4, 3, '250', 250000000, 'Grande villa avec piscine', 'Villa', 'En vente', '6.8133, -5.2740', 3, 40, 260),
('San-Pédro', 'Seweke', 'Quartier Industriel', 4, 3, 2, '180', 140000000, 'Maison avec vue sur mer', 'Maison', 'Vendu', '4.7490, -6.6335', 4, 20, 200),
('Korhogo', 'Koko', 'Quartier Administratif', 3, 2, 1, '140', 85000000, 'Maison proche des écoles', 'Maison', 'En vente', '9.4515, -5.6227', 5, 18, 120),
('Man', 'Kasirim', 'Centre Ville', 4, 3, 2, '160', 125000000, 'Maison spacieuse avec garage', 'Maison', 'Vendu', '7.4140, -7.5558', 6, 25, 190),
('Gagnoa', 'Dioulabougou', 'Quartier Marché', 3, 2, 1, '130', 110000000, 'Maison avec grande cour', 'Maison', 'En vente', '6.1307, -5.9502', 7, 22, 160),
('Abengourou', 'Amaffou', 'Quartier Résidentiel', 2, 1, 1, '90', 70000000, 'Petit appartement moderne', 'Appartement', 'Vendu', '6.7282, -3.4915', 1, 12, 90),
('Daloa', 'Gblapleu', 'Centre Ville', 5, 4, 3, '220', 200000000, 'Grande maison avec piscine', 'Villa', 'En vente', '6.8760, -6.4445', 2, 35, 240),
('San-Pédro', 'Daleu', 'Quartier Industriel', 3, 2, 1, '150', 100000000, 'Maison proche du port', 'Maison', 'Vendu', '4.7488, -6.6344', 3, 20, 170),
('Bouaké', 'Nimbo', 'Quartier Administratif', 4, 3, 2, '180', 145000000, 'Maison familiale avec jardin', 'Maison', 'En vente', '7.6935, -5.0304', 4, 28, 210),
('Yamoussoukro', 'Habitat', 'Quartier Résidentiel', 3, 2, 1, '120', 95000000, 'Maison moderne près de la basilique', 'Maison', 'Vendu', '6.8170, -5.2782', 5, 18, 140),
('Abidjan', 'Plateau', 'Centre Ville', 4, 3, 2, '170', 180000000, 'Appartement de luxe avec vue sur la lagune', 'Appartement', 'En vente', '5.3166, -4.0228', 6, 50, 290),
('Man', 'Danané', 'Quartier Commercial', 2, 1, 1, '90', 75000000, 'Petit appartement avec balcon', 'Appartement', 'Vendu', '7.4142, -7.5562', 7, 15, 100),
('Gagnoa', 'Gnagbodougnoa', 'Quartier des Écoles', 3, 2, 1, '130', 90000000, 'Maison près des commerces', 'Maison', 'En vente', '6.1315, -5.9499', 1, 20, 110),
('Korhogo', 'Ferké', 'Quartier Industriel', 4, 3, 2, '180', 135000000, 'Maison moderne avec piscine', 'Maison', 'Vendu', '9.4510, -5.6232', 2, 25, 200),
('San-Pédro', 'Krindjabo', 'Quartier Résidentiel', 3, 2, 1, '140', 110000000, 'Maison avec terrasse', 'Maison', 'En vente', '4.7513, -6.6346', 3, 22, 130),
('Daloa', 'Goh', 'Quartier Administratif', 5, 4, 3, '200', 220000000, 'Grande villa avec garage et piscine', 'Villa', 'Vendu', '6.8770, -6.4450', 4, 40, 270),
('Bouaké', 'Dar Es Salam', 'Quartier Marché', 3, 2, 1, '140', 105000000, 'Maison avec cour', 'Maison', 'En vente', '7.6925, -5.0301', 5, 18, 150),
('Abengourou', 'Indénié', 'Quartier Résidentiel', 2, 1, 1, '90', 80000000, 'Appartement moderne', 'Appartement', 'Vendu', '6.7275, -3.4912', 6, 14, 80),
('Man', 'Bangolo', 'Quartier Central', 4, 3, 2, '160', 125000000, 'Maison avec vue sur les montagnes', 'Maison', 'En vente', '7.4148, -7.5555', 7, 22, 150),
('Gagnoa', 'Bracodi', 'Quartier Administratif', 5, 4, 3, '220', 180000000, 'Grande villa avec piscine et jardin', 'Villa', 'Vendu', '6.1319, -5.9507', 1, 35, 230),
('Korhogo', 'Nafoun', 'Quartier Industriel', 3, 2, 1, '140', 110000000, 'Maison moderne avec terrasse', 'Maison', 'En vente', '9.4507, -5.6240', 2, 20, 150),
('San-Pédro', 'Loba', 'Quartier Industriel', 4, 3, 2, '160', 140000000, 'Maison spacieuse avec jardin', 'Maison', 'Vendu', '4.7512, -6.6350', 3, 25, 180),
('Yamoussoukro', 'Attiegouakro', 'Quartier Résidentiel', 2, 1, 1, '100', 90000000, 'Petit appartement moderne', 'Appartement', 'En vente', '6.8182, -5.2776', 4, 18, 90);


-- ____________________________________________________________________________________________________________________________________________________________________________________



INSERT INTO Locations (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_mensuel, Caution, Avance, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Cocody', 'Angré', 3, 2, 1, '120', 300000, 1, 1, 'Appartement moderne avec balcon', 'Appartement', 'Libre', '5.3520, -3.9860', 1, 20, 150),
('Bouaké', 'Belleville', 'Centre', 2, 1, 1, '90', 180000, 1, 1, 'Petit appartement proche des commerces', 'Appartement', 'Occupée', '7.6902, -5.0302', 2, 15, 100),
('Yamoussoukro', 'Kokrenou', 'Quartier Résidentiel', 4, 3, 2, '200', 400000, 2, 2, 'Maison spacieuse avec jardin', 'Maison', 'Libre', '6.8133, -5.2740', 3, 25, 170),
('San-Pédro', 'Seweke', 'Quartier Industriel', 3, 2, 1, '150', 250000, 1, 1, 'Maison avec vue sur mer', 'Maison', 'Occupée', '4.7490, -6.6335', 4, 18, 140),
('Korhogo', 'Koko', 'Quartier Administratif', 2, 1, 1, '100', 200000, 1, 1, 'Appartement proche des écoles', 'Appartement', 'Libre', '9.4515, -5.6227', 5, 12, 90),
('Man', 'Kasirim', 'Centre Ville', 3, 2, 1, '130', 220000, 1, 1, 'Appartement spacieux avec garage', 'Appartement', 'Occupée', '7.4140, -7.5558', 6, 18, 110),
('Gagnoa', 'Dioulabougou', 'Quartier Marché', 4, 3, 2, '160', 350000, 2, 2, 'Maison avec grande cour', 'Maison', 'Libre', '6.1307, -5.9502', 7, 22, 150),
('Abengourou', 'Amaffou', 'Quartier Résidentiel', 2, 1, 1, '80', 150000, 1, 1, 'Petit appartement moderne', 'Appartement', 'Occupée', '6.7282, -3.4915', 1, 10, 70),
('Daloa', 'Gblapleu', 'Centre Ville', 5, 4, 3, '240', 500000, 2, 2, 'Grande maison avec piscine', 'Villa', 'Libre', '6.8760, -6.4445', 2, 35, 180),
('San-Pédro', 'Daleu', 'Quartier Industriel', 3, 2, 1, '140', 260000, 1, 1, 'Maison proche du port', 'Maison', 'Occupée', '4.7488, -6.6344', 3, 20, 130),
('Bouaké', 'Nimbo', 'Quartier Administratif', 4, 3, 2, '180', 400000, 2, 2, 'Maison familiale avec jardin', 'Maison', 'Libre', '7.6935, -5.0304', 4, 28, 160),
('Yamoussoukro', 'Habitat', 'Quartier Résidentiel', 3, 2, 1, '120', 250000, 1, 1, 'Maison moderne près de la basilique', 'Maison', 'Occupée', '6.8170, -5.2782', 5, 15, 110),
('Abidjan', 'Plateau', 'Centre Ville', 4, 3, 2, '150', 450000, 2, 2, 'Appartement de luxe avec vue sur la lagune', 'Appartement', 'Libre', '5.3166, -4.0228', 6, 40, 200),
('Man', 'Danané', 'Quartier Commercial', 2, 1, 1, '80', 160000, 1, 1, 'Petit appartement avec balcon', 'Appartement', 'Occupée', '7.4142, -7.5562', 7, 12, 90),
('Gagnoa', 'Gnagbodougnoa', 'Quartier des Écoles', 3, 2, 1, '120', 230000, 1, 1, 'Maison près des commerces', 'Maison', 'Libre', '6.1315, -5.9499', 1, 18, 100),
('Korhogo', 'Ferké', 'Quartier Industriel', 4, 3, 2, '160', 330000, 2, 2, 'Maison moderne avec piscine', 'Maison', 'Occupée', '9.4510, -5.6232', 2, 25, 140),
('San-Pédro', 'Krindjabo', 'Quartier Résidentiel', 3, 2, 1, '140', 270000, 1, 1, 'Maison avec terrasse', 'Maison', 'Libre', '4.7513, -6.6346', 3, 22, 120),
('Daloa', 'Goh', 'Quartier Administratif', 5, 4, 3, '200', 550000, 2, 2, 'Grande villa avec garage et piscine', 'Villa', 'Occupée', '6.8770, -6.4450', 4, 40, 240),
('Bouaké', 'Dar Es Salam', 'Quartier Marché', 3, 2, 1, '130', 250000, 1, 1, 'Maison avec cour', 'Maison', 'Libre', '7.6925, -5.0301', 5, 18, 120),
('Abengourou', 'Indénié', 'Quartier Résidentiel', 2, 1, 1, '80', 160000, 1, 1, 'Appartement moderne', 'Appartement', 'Occupée', '6.7275, -3.4912', 6, 14, 70),
('Man', 'Bangolo', 'Quartier Central', 4, 3, 2, '150', 320000, 2, 2, 'Maison avec vue sur les montagnes', 'Maison', 'Libre', '7.4148, -7.5555', 7, 22, 140),
('Gagnoa', 'Bracodi', 'Quartier Administratif', 5, 4, 3, '210', 500000, 2, 2, 'Grande villa avec piscine et jardin', 'Villa', 'Occupée', '6.1319, -5.9507', 1, 35, 200),
('Korhogo', 'Nafoun', 'Quartier Industriel', 3, 2, 1, '140', 270000, 1, 1, 'Maison moderne avec terrasse', 'Maison', 'Libre', '9.4507, -5.6240', 2, 20, 130),
('San-Pédro', 'Loba', 'Quartier Industriel', 4, 3, 2, '160', 320000, 2, 2, 'Maison spacieuse avec jardin', 'Maison', 'Occupée', '4.7512, -6.6350', 3, 25, 150),
('Yamoussoukro', 'Attiegouakro', 'Quartier Résidentiel', 2, 1, 1, '90', 180000, 1, 1, 'Petit appartement moderne', 'Appartement', 'Libre', '6.8182, -5.2776', 4, 18, 80);



INSERT INTO Locations (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_mensuel, Caution, Avance, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Marcory', 'Zone 4', 3, 2, 1, '120', 250000, 1, 1, 'Appartement moderne avec balcon', 'Appartement', 'Libre', '5.3170, -3.9840', 1, 20, 100),
('San-Pédro', 'Lacroix', 'Quartier Industriel', 4, 3, 2, '150', 300000, 1, 1, 'Maison spacieuse près du port', 'Maison', 'Occupée', '4.7491, -6.6329', 2, 25, 130),
('Bouaké', 'Nimbo', 'Quartier Commercial', 5, 4, 3, '200', 350000, 2, 2, 'Grande maison avec magasin', 'Maison', 'Libre', '7.6937, -5.0300', 3, 40, 180),
('Yamoussoukro', 'Habitat', 'Quartier Résidentiel', 3, 2, 1, '130', 280000, 1, 1, 'Maison avec jardin', 'Maison', 'Occupée', '6.8169, -5.2783', 4, 18, 110),
('Daloa', 'Boulevards', 'Quartier Central', 4, 3, 2, '170', 320000, 2, 2, 'Maison avec cour et garage', 'Maison', 'Libre', '6.8761, -6.4452', 5, 22, 150),
('Man', 'Nanakaha', 'Quartier Résidentiel', 2, 1, 1, '90', 200000, 1, 1, 'Appartement avec vue sur les montagnes', 'Appartement', 'Occupée', '7.4132, -7.5550', 6, 15, 80),
('Gagnoa', 'Commerce', 'Quartier Marché', 3, 2, 1, '110', 250000, 1, 1, 'Appartement près des commerces', 'Appartement', 'Libre', '6.1331, -5.9501', 7, 20, 100),
('Korhogo', 'Bora', 'Quartier Industriel', 4, 3, 2, '160', 350000, 2, 2, 'Maison moderne avec jardin', 'Maison', 'Occupée', '9.4512, -5.6251', 1, 25, 140),
('Abengourou', 'Aniassué', 'Quartier Industriel', 3, 2, 1, '130', 270000, 1, 1, 'Maison près des écoles', 'Maison', 'Libre', '6.7278, -3.4916', 2, 18, 110),
('Aboisso', 'Ehania', 'Quartier Résidentiel', 5, 4, 3, '200', 400000, 2, 2, 'Grande villa avec piscine', 'Villa', 'Occupée', '5.4750, -3.2020', 3, 35, 160),
('Divo', 'Djidji', 'Quartier Administratif', 2, 1, 1, '100', 180000, 1, 1, 'Appartement au centre-ville', 'Appartement', 'Libre', '5.8360, -5.3598', 4, 15, 90),
('Abidjan', 'Treichville', 'Quartier Commercial', 3, 2, 1, '130', 290000, 1, 1, 'Appartement de luxe', 'Appartement', 'Occupée', '5.3193, -4.0160', 5, 20, 120),
('San-Pédro', 'Grand-Béréby', 'Quartier Industriel', 2, 1, 1, '110', 210000, 1, 1, 'Petit appartement avec jardin', 'Appartement', 'Libre', '4.7510, -6.6340', 6, 10, 70),
('Yamoussoukro', 'Logbakro', 'Quartier Administratif', 4, 3, 2, '160', 300000, 1, 1, 'Maison moderne avec terrasse', 'Maison', 'Occupée', '6.8180, -5.2773', 7, 25, 140),
('Bouaké', 'Koko', 'Quartier Résidentiel', 3, 2, 1, '140', 280000, 1, 1, 'Maison avec cour et jardin', 'Maison', 'Libre', '7.6890, -5.0288', 1, 22, 100),
('Man', 'Fahafou', 'Quartier Administratif', 2, 1, 1, '100', 200000, 1, 1, 'Appartement avec vue sur la montagne', 'Appartement', 'Occupée', '7.4115, -7.5551', 2, 12, 70),
('Gagnoa', 'Sogebaf', 'Quartier des Écoles', 3, 2, 1, '120', 250000, 1, 1, 'Maison familiale avec jardin', 'Maison', 'Libre', '6.1302, -5.9498', 3, 18, 90),
('Korhogo', 'Kimbirila', 'Quartier Industriel', 4, 3, 2, '160', 300000, 1, 1, 'Maison moderne avec piscine', 'Maison', 'Occupée', '9.4515, -5.6230', 4, 20, 130),
('Abidjan', 'Yopougon', 'Toit Rouge', 2, 1, 1, '90', 200000, 1, 1, 'Appartement proche des commodités', 'Appartement', 'Libre', '5.3290, -4.1110', 5, 10, 80),
('Daloa', 'Kadia', 'Quartier Industriel', 5, 4, 3, '200', 370000, 2, 2, 'Grande villa avec jardin et piscine', 'Villa', 'Occupée', '6.8763, -6.4513', 6, 40, 190),
('San-Pédro', 'Sassandra', 'Quartier Industriel', 3, 2, 1, '140', 280000, 1, 1, 'Maison avec terrasse', 'Maison', 'Libre', '4.7480, -6.6347', 7, 15, 110),
('Yamoussoukro', 'Nanan', 'Quartier Résidentiel', 4, 3, 2, '170', 320000, 2, 2, 'Maison spacieuse avec jardin', 'Maison', 'Occupée', '6.8184, -5.2778', 1, 30, 150),
('Bouaké', 'Belleville', 'Quartier Commercial', 2, 1, 1, '100', 200000, 1, 1, 'Appartement moderne avec balcon', 'Appartement', 'Libre', '7.6898, -5.0304', 2, 15, 90),
('Man', 'Biankouma', 'Quartier Militaire', 3, 2, 1, '130', 250000, 1, 1, 'Appartement avec vue sur montagne', 'Appartement', 'Occupée', '7.4130, -7.5559', 3, 20, 120),
('Gagnoa', 'Digbeu', 'Quartier des Écoles', 4, 3, 2, '160', 300000, 1, 1, 'Maison familiale avec cour', 'Maison', 'Libre', '6.1315, -5.9502', 4, 18, 130);


INSERT INTO Locations (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_mensuel, Caution, Avance, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Cocody', 'Angré', 2, 1, 1, '100', 220000, 1, 1, 'Petit appartement avec balcon', 'Appartement', 'Libre', '5.3526, -3.9865', 1, 15, 80),
('San-Pédro', 'Balmer', 'Zone Portuaire', 3, 2, 1, '130', 280000, 1, 1, 'Maison avec vue sur la mer', 'Maison', 'Occupée', '4.7500, -6.6400', 2, 20, 90),
('Bouaké', 'Zone 4', 'Quartier Résidentiel', 4, 3, 2, '170', 350000, 2, 1, 'Grande villa avec piscine', 'Villa', 'Libre', '7.6921, -5.0303', 3, 30, 110),
('Yamoussoukro', 'Kokrenou', 'Quartier Administratif', 2, 1, 1, '90', 180000, 1, 1, 'Appartement proche du palais', 'Appartement', 'Occupée', '6.8180, -5.2752', 4, 12, 70),
('Daloa', 'Orly', 'Quartier Industriel', 3, 2, 1, '140', 250000, 1, 1, 'Maison avec grand jardin', 'Maison', 'Libre', '6.8756, -6.4449', 5, 18, 90),
('Man', 'Masion', 'Quartier Résidentiel', 4, 3, 2, '180', 320000, 2, 2, 'Maison avec belle vue', 'Maison', 'Occupée', '7.4111, -7.5543', 6, 22, 110),
('Gagnoa', 'Barouhi', 'Quartier des Écoles', 2, 1, 1, '80', 160000, 1, 1, 'Petit appartement près des commodités', 'Appartement', 'Libre', '6.1324, -5.9508', 7, 10, 50),
('Korhogo', 'Koni', 'Quartier Résidentiel', 3, 2, 1, '150', 300000, 1, 1, 'Maison moderne avec terrasse', 'Maison', 'Occupée', '9.4534, -5.6202', 1, 16, 100),
('Abengourou', 'Indénié', 'Quartier des Affaires', 4, 3, 2, '160', 320000, 2, 1, 'Appartement bien situé', 'Appartement', 'Libre', '6.7262, -3.4931', 2, 20, 110),
('Aboisso', 'Djiboua', 'Quartier Administratif', 3, 2, 1, '130', 260000, 1, 1, 'Appartement avec balcon', 'Appartement', 'Occupée', '5.4725, -3.2043', 3, 18, 100),
('Divo', 'Gozo', 'Quartier Résidentiel', 2, 1, 1, '90', 170000, 1, 1, 'Petit appartement au calme', 'Appartement', 'Libre', '5.8353, -5.3607', 4, 12, 70),
('Abidjan', 'Plateau', 'Quartier des Affaires', 5, 4, 3, '200', 500000, 3, 2, 'Appartement de luxe', 'Appartement', 'Occupée', '5.3175, -4.0212', 5, 40, 150),
('San-Pédro', 'Krindjabo', 'Zone Résidentielle', 4, 3, 2, '180', 350000, 2, 2, 'Maison avec jardin', 'Maison', 'Libre', '4.7485, -6.6350', 6, 25, 120),
('Yamoussoukro', 'Dadiassé', 'Quartier Industriel', 3, 2, 1, '130', 270000, 1, 1, 'Maison moderne avec garage', 'Maison', 'Occupée', '6.8150, -5.2781', 7, 17, 90),
('Bouaké', 'Zone 3', 'Quartier Résidentiel', 2, 1, 1, '80', 160000, 1, 1, 'Appartement familial', 'Appartement', 'Libre', '7.6874, -5.0293', 1, 10, 50),
('Man', 'Louhiri', 'Quartier Militaire', 4, 3, 2, '170', 330000, 2, 2, 'Appartement avec vue sur montagne', 'Appartement', 'Occupée', '7.4123, -7.5550', 2, 22, 120),
('Gagnoa', 'Brégbo', 'Quartier des Écoles', 3, 2, 1, '140', 280000, 1, 1, 'Maison familiale avec cour', 'Maison', 'Libre', '6.1295, -5.9493', 3, 15, 90),
('Korhogo', 'Kangala', 'Quartier Industriel', 5, 4, 3, '200', 400000, 3, 2, 'Maison moderne avec terrasse', 'Maison', 'Occupée', '9.4521, -5.6231', 4, 30, 140),
('Abidjan', 'Yopougon', 'Quartier Populaire', 2, 1, 1, '90', 170000, 1, 1, 'Appartement proche des commodités', 'Appartement', 'Libre', '5.3276, -4.1125', 5, 13, 80),
('Daloa', 'Nouveau Quartier', 'Quartier Administratif', 4, 3, 2, '180', 320000, 2, 2, 'Grande maison avec jardin', 'Maison', 'Occupée', '6.8760, -6.4511', 6, 22, 110),
('San-Pédro', 'Sassandra', 'Quartier Industriel', 3, 2, 1, '150', 290000, 1, 1, 'Maison avec terrasse', 'Maison', 'Libre', '4.7479, -6.6337', 7, 18, 100),
('Yamoussoukro', 'Dioulabougou', 'Quartier Résidentiel', 5, 4, 3, '200', 420000, 3, 2, 'Grande maison spacieuse', 'Maison', 'Occupée', '6.8174, -5.2775', 1, 35, 150),
('Bouaké', 'Zone 2', 'Quartier Commercial', 3, 2, 1, '130', 270000, 1, 1, 'Appartement moderne', 'Appartement', 'Libre', '7.6881, -5.0301', 2, 18, 100),
('Man', 'Glanleu', 'Quartier Militaire', 4, 3, 2, '160', 310000, 2, 2, 'Appartement avec vue sur montagne', 'Appartement', 'Occupée', '7.4110, -7.5564', 3, 25, 120),
('Gagnoa', 'Dioulabougou', 'Quartier des Écoles', 2, 1, 1, '90', 180000, 1, 1, 'Petit appartement familial', 'Appartement', 'Libre', '6.1319, -5.9505', 4, 10, 60);



INSERT INTO Locations (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_mensuel, Caution, Avance, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Cocody', 'Angré', 3, 2, 1, '110', 280000, 1, 1, 'Appartement moderne avec balcon', 'Appartement', 'Libre', '5.3399, -4.0330', 1, 19, 90),
('San-Pédro', 'San Pedro Ville', 'Quartier Plage', 2, 1, 1, '85', 200000, 1, 1, 'Petit appartement proche de la plage', 'Appartement', 'Occupée', '4.7450, -6.6420', 2, 12, 70),
('Bouaké', 'Dar-Es-Salam', 'Quartier Administratif', 3, 2, 1, '120', 260000, 1, 1, 'Maison avec jardin', 'Maison', 'Libre', '7.6902, -5.0295', 3, 15, 100),
('Yamoussoukro', 'Kokrenou', 'Quartier Industriel', 4, 3, 2, '160', 370000, 2, 2, 'Grande villa avec piscine', 'Villa', 'Occupée', '6.8102, -5.2772', 4, 24, 150),
('Daloa', 'Lobia', 'Quartier Administratif', 2, 1, 1, '75', 180000, 1, 1, 'Appartement rénové', 'Appartement', 'Libre', '6.8802, -6.4529', 5, 13, 60),
('Man', 'Dompleu', 'Quartier Résidentiel', 3, 2, 1, '120', 270000, 1, 1, 'Maison familiale avec cour', 'Maison', 'Occupée', '7.4161, -7.5570', 6, 17, 110),
('Gagnoa', 'Barreau', 'Quartier des Affaires', 2, 1, 1, '95', 200000, 1, 1, 'Petit appartement moderne', 'Appartement', 'Libre', '6.1302, -5.9511', 7, 11, 80),
('Korhogo', 'Kapielahio', 'Quartier Commercial', 3, 2, 1, '130', 250000, 1, 1, 'Maison moderne', 'Maison', 'Occupée', '9.4503, -5.6303', 1, 16, 90),
('Abengourou', 'Akan', 'Quartier des Affaires', 2, 1, 1, '90', 180000, 1, 1, 'Appartement proche des commodités', 'Appartement', 'Libre', '6.7312, -3.4921', 2, 13, 70),
('Aboisso', 'Aboisso Ville', 'Quartier Industriel', 4, 3, 2, '180', 350000, 2, 2, 'Maison avec grand jardin', 'Maison', 'Occupée', '5.4712, -3.2052', 3, 22, 140),
('Divo', 'Abia', 'Quartier Résidentiel', 2, 1, 1, '80', 170000, 1, 1, 'Appartement confortable', 'Appartement', 'Libre', '5.8362, -5.3590', 4, 10, 50),
('Abidjan', 'Marcory', 'Quartier des Affaires', 3, 2, 1, '130', 320000, 1, 1, 'Appartement avec vue sur la ville', 'Appartement', 'Occupée', '5.3070, -4.0040', 5, 20, 120),
('San-Pédro', 'San Pedro Ville', 'Zone Industrielle', 2, 1, 1, '95', 190000, 1, 1, 'Petit appartement', 'Appartement', 'Libre', '4.7480, -6.6350', 6, 12, 60),
('Yamoussoukro', 'Attiégouakro', 'Quartier Résidentiel', 4, 3, 2, '160', 340000, 2, 2, 'Maison spacieuse avec jardin', 'Maison', 'Occupée', '6.8255, -5.2780', 7, 22, 130),
('Bouaké', 'Zone 3', 'Quartier Commercial', 2, 1, 1, '100', 220000, 1, 1, 'Appartement moderne avec balcon', 'Appartement', 'Libre', '7.6881, -5.0318', 1, 14, 80),
('Man', 'Libreville', 'Quartier Militaire', 2, 1, 1, '90', 180000, 1, 1, 'Appartement avec vue sur montagne', 'Appartement', 'Occupée', '7.4167, -7.5560', 2, 12, 70),
('Gagnoa', 'Garahio', 'Quartier Résidentiel', 3, 2, 1, '130', 270000, 1, 1, 'Maison familiale avec cour', 'Maison', 'Libre', '6.1319, -5.9507', 3, 18, 90),
('Korhogo', 'Soba', 'Quartier Industriel', 3, 2, 2, '150', 290000, 1, 1, 'Maison moderne avec terrasse', 'Maison', 'Occupée', '9.4585, -5.6291', 4, 20, 110),
('Abidjan', 'Adjame', 'Quartier Commercial', 2, 1, 1, '80', 180000, 1, 1, 'Appartement proche commodités', 'Appartement', 'Libre', '5.3472, -4.0372', 5, 12, 60),
('Daloa', 'Grandes Terres', 'Quartier Administratif', 4, 3, 2, '160', 350000, 2, 2, 'Maison avec vue sur montagnes', 'Maison', 'Occupée', '6.8786, -6.4523', 6, 25, 150);


INSERT INTO Locations (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_mensuel, Caution, Avance, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Yopougon', 'Toit Rouge', 3, 2, 1, '110', 300000, 1, 1, 'Appartement moderne avec balcon', 'Appartement', 'Libre', '5.3362, -4.0731', 1, 18, 90),
('San-Pédro', 'Sewe', 'Zone Industrielle', 2, 1, 1, '90', 220000, 1, 1, 'Petit appartement confortable', 'Appartement', 'Occupée', '4.7502, -6.6365', 2, 12, 70),
('Bouaké', 'Ahougnansou', 'Quartier Industriel', 3, 2, 1, '140', 250000, 1, 1, 'Maison avec petit jardin', 'Maison', 'Libre', '7.6909, -5.0325', 3, 16, 100),
('Yamoussoukro', 'Morofé', 'Quartier des Ambassades', 4, 3, 2, '170', 350000, 2, 2, 'Grande villa avec garage et piscine', 'Villa', 'Occupée', '6.8218, -5.2767', 4, 21, 150),
('Daloa', 'Brébo', 'Quartier Administratif', 2, 1, 1, '80', 200000, 1, 1, 'Appartement rénové', 'Appartement', 'Libre', '6.8793, -6.4528', 5, 14, 60),
('Man', 'Abattoir', 'Quartier Militaire', 3, 2, 1, '120', 280000, 1, 1, 'Maison familiale avec cour', 'Maison', 'Occupée', '7.4166, -7.5564', 6, 17, 110),
('Gagnoa', 'Garahio', 'Quartier Sogefiha', 2, 1, 1, '100', 220000, 1, 1, 'Petit appartement lumineux', 'Appartement', 'Libre', '6.1323, -5.9508', 7, 11, 80),
('Korhogo', 'Koko', 'Zone Résidentielle', 3, 2, 1, '150', 270000, 1, 1, 'Maison avec jardin', 'Maison', 'Occupée', '9.4504, -5.6312', 1, 22, 90),
('Abengourou', 'Bellevue', 'Quartier Résidentiel', 3, 2, 1, '130', 250000, 1, 1, 'Appartement bien situé', 'Appartement', 'Libre', '6.7321, -3.4930', 2, 13, 70),
('Aboisso', 'Abradine', 'Quartier Administratif', 4, 3, 2, '180', 380000, 2, 2, 'Villa moderne avec garage', 'Villa', 'Occupée', '5.4741, -3.2071', 3, 23, 130),
('Divo', 'Bada', 'Quartier Résidentiel', 2, 1, 1, '85', 200000, 1, 1, 'Petit appartement confortable', 'Appartement', 'Libre', '5.8372, -5.3578', 4, 12, 60),
('Abidjan', 'Treichville', 'Quartier des Affaires', 4, 3, 2, '160', 400000, 2, 2, 'Grand appartement avec vue', 'Appartement', 'Occupée', '5.3008, -4.0012', 5, 25, 150),
('San-Pédro', 'Sewe', 'Zone Résidentielle', 3, 2, 1, '140', 260000, 1, 1, 'Maison avec jardin', 'Maison', 'Libre', '4.7490, -6.6344', 6, 18, 100),
('Yamoussoukro', 'Kokrenou', 'Quartier des Ministres', 4, 3, 2, '190', 370000, 2, 2, 'Maison moderne avec terrasse', 'Maison', 'Occupée', '6.8240, -5.2790', 7, 20, 140),
('Bouaké', 'Zone 4', 'Quartier Commercial', 2, 1, 1, '110', 220000, 1, 1, 'Appartement avec balcon', 'Appartement', 'Libre', '7.6882, -5.0315', 1, 16, 70),
('Man', 'Libreville', 'Quartier Militaire', 2, 1, 1, '100', 220000, 1, 1, 'Appartement avec vue sur la montagne', 'Appartement', 'Occupée', '7.4160, -7.5561', 2, 14, 50),
('Gagnoa', 'Dioulabougou', 'Quartier des Écoles', 3, 2, 1, '140', 260000, 1, 1, 'Maison familiale avec cour', 'Maison', 'Libre', '6.1319, -5.9500', 3, 20, 90),
('Korhogo', 'Koko', 'Quartier Résidentiel', 3, 2, 2, '150', 280000, 1, 1, 'Maison moderne avec terrasse', 'Maison', 'Occupée', '9.4580, -5.6296', 4, 22, 110),
('Abidjan', 'Adjame', 'Quartier Commercial', 2, 1, 1, '90', 200000, 1, 1, 'Appartement proche des commodités', 'Appartement', 'Libre', '5.3470, -4.0370', 5, 12, 60),
('Daloa', 'Grandes Terres', 'Quartier Administratif', 4, 3, 2, '180', 350000, 2, 2, 'Maison avec vue sur les montagnes', 'Maison', 'Occupée', '6.8785, -6.4525', 6, 18, 100);


INSERT INTO Locations (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_mensuel, Caution, Avance, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Yopougon', 'Toit Rouge', 3, 2, 1, '110', 300000, 1, 1, 'Appartement moderne avec balcon', 'Appartement', 'Libre', '5.3362, -4.0731', 1, 18, 90),
('San-Pédro', 'Sewe', 'Zone Industrielle', 2, 1, 1, '90', 220000, 1, 1, 'Petit appartement confortable', 'Appartement', 'Occupée', '4.7502, -6.6365', 2, 12, 70),
('Bouaké', 'Ahougnansou', 'Quartier Industriel', 3, 2, 1, '140', 250000, 1, 1, 'Maison avec petit jardin', 'Maison', 'Libre', '7.6909, -5.0325', 3, 16, 100),
('Yamoussoukro', 'Morofé', 'Quartier des Ambassades', 4, 3, 2, '170', 350000, 2, 2, 'Grande villa avec garage et piscine', 'Villa', 'Occupée', '6.8218, -5.2767', 4, 21, 150),
('Daloa', 'Brébo', 'Quartier Administratif', 2, 1, 1, '80', 200000, 1, 1, 'Appartement rénové', 'Appartement', 'Libre', '6.8793, -6.4528', 5, 14, 60),
('Man', 'Abattoir', 'Quartier Militaire', 3, 2, 1, '120', 280000, 1, 1, 'Maison familiale avec cour', 'Maison', 'Occupée', '7.4166, -7.5564', 6, 17, 110),
('Gagnoa', 'Garahio', 'Quartier Sogefiha', 2, 1, 1, '100', 220000, 1, 1, 'Petit appartement lumineux', 'Appartement', 'Libre', '6.1323, -5.9508', 7, 11, 50),
('Korhogo', 'Pelengana', 'Haute Ville', 3, 2, 2, '150', 300000, 2, 2, 'Maison moderne avec jardin', 'Maison', 'Occupée', '9.4579, -5.6293', 1, 18, 90),
('Abengourou', 'Akan', 'Quartier Bellevue', 2, 1, 1, '80', 180000, 1, 1, 'Appartement en centre-ville', 'Appartement', 'Libre', '6.7305, -3.4915', 2, 10, 40),
('Aboisso', 'Aboisso Ville', 'Quartier Administratif', 4, 3, 2, '180', 400000, 2, 2, 'Villa moderne avec piscine', 'Villa', 'Occupée', '5.4725, -3.2063', 3, 25, 130),
('Divo', 'Bada', 'Quartier Résidentiel', 2, 1, 1, '90', 220000, 1, 1, 'Appartement proche du marché', 'Appartement', 'Libre', '5.8375, -5.3580', 4, 13, 60),
('Abidjan', 'Marcory', 'Zone 4', 3, 2, 1, '140', 350000, 2, 2, 'Maison spacieuse avec jardin', 'Maison', 'Occupée', '5.3056, -3.9985', 5, 19, 90),
('San-Pédro', 'Sewe', 'Quartier Résidentiel', 2, 1, 1, '100', 230000, 1, 1, 'Studio proche de la plage', 'Studio', 'Libre', '4.7480, -6.6355', 6, 16, 70),
('Yamoussoukro', 'Attiégouakro', 'Quartier Industriel', 4, 3, 2, '160', 400000, 2, 2, 'Maison moderne avec jardin', 'Maison', 'Occupée', '6.8250, -5.2781', 7, 18, 100),
('Bouaké', 'Zone 4', 'Quartier Commercial', 3, 2, 1, '130', 270000, 1, 1, 'Appartement avec balcon', 'Appartement', 'Libre', '7.6880, -5.0310', 1, 15, 80),
('Man', 'Libreville', 'Quartier Militaire', 2, 1, 1, '100', 220000, 1, 1, 'Appartement avec vue sur la montagne', 'Appartement', 'Occupée', '7.4160, -7.5561', 2, 14, 50),
('Gagnoa', 'Sogefiha', 'Quartier des Écoles', 3, 2, 1, '140', 260000, 1, 1, 'Maison familiale avec cour', 'Maison', 'Libre', '6.1319, -5.9500', 3, 20, 90),
('Korhogo', 'Soba', 'Quartier Résidentiel', 3, 2, 2, '150', 280000, 1, 1, 'Maison moderne avec terrasse', 'Maison', 'Occupée', '9.4580, -5.6296', 4, 22, 110),
('Abidjan', 'Adjame', 'Quartier Commercial', 2, 1, 1, '90', 200000, 1, 1, 'Appartement proche des commodités', 'Appartement', 'Libre', '5.3470, -4.0370', 5, 12, 60),
('Daloa', 'Grandes Terres', 'Quartier Administratif', 4, 3, 2, '180', 350000, 2, 2, 'Maison avec vue sur les montagnes', 'Maison', 'Occupée', '6.8785, -6.4525', 6, 18, 100);



INSERT INTO Locations (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_mensuel, Caution, Avance, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Yopougon', 'Toit Rouge', 3, 2, 1, '110', 300000, 1, 1, 'Appartement moderne avec balcon', 'Appartement', 'Libre', '5.3362, -4.0731', 1, 18, 90),
('San-Pédro', 'Sewe', 'Zone Industrielle', 2, 1, 1, '90', 220000, 1, 1, 'Petit appartement confortable', 'Appartement', 'Occupée', '4.7502, -6.6365', 2, 12, 70),
('Bouaké', 'Ahougnansou', 'Quartier Industriel', 3, 2, 1, '140', 250000, 1, 1, 'Maison avec petit jardin', 'Maison', 'Libre', '7.6909, -5.0325', 3, 16, 100),
('Yamoussoukro', 'Morofé', 'Quartier des Ambassades', 4, 3, 2, '170', 350000, 2, 2, 'Grande villa avec garage et piscine', 'Villa', 'Occupée', '6.8218, -5.2767', 4, 21, 150),
('Daloa', 'Brébo', 'Quartier Administratif', 2, 1, 1, '80', 200000, 1, 1, 'Appartement rénové', 'Appartement', 'Libre', '6.8793, -6.4528', 5, 14, 60),
('Man', 'Abattoir', 'Quartier Militaire', 3, 2, 1, '120', 280000, 1, 1, 'Maison familiale avec cour', 'Maison', 'Occupée', '7.4166, -7.5564', 6, 17, 110),
('Gagnoa', 'Garahio', 'Quartier Sogefiha', 2, 1, 1, '100', 220000, 1, 1, 'Petit appartement lumineux', 'Appartement', 'Libre', '6.1323, -5.9508', 7, 11, 50),
('Korhogo', 'Pelengana', 'Haute Ville', 3, 2, 2, '140', 240000, 1, 1, 'Maison avec terrasse', 'Maison', 'Libre', '9.4579, -5.6293', 2, 15, 80),
('Abengourou', 'Akan', 'Quartier Bellevue', 2, 1, 1, '80', 180000, 1, 1, 'Appartement en centre-ville', 'Appartement', 'Occupée', '6.7305, -3.4915', 3, 10, 40),
('Aboisso', 'Aboisso Ville', 'Quartier Administratif', 4, 3, 2, '180', 400000, 2, 1, 'Villa moderne avec piscine', 'Villa', 'Libre', '5.4725, -3.2063', 4, 25, 130),
('Divo', 'Bada', 'Quartier Résidentiel', 2, 1, 1, '90', 220000, 1, 1, 'Appartement proche du marché', 'Appartement', 'Occupée', '5.8375, -5.3580', 5, 13, 60),
('Abidjan', 'Marcory', 'Zone 4', 3, 2, 1, '140', 350000, 2, 1, 'Maison spacieuse avec jardin', 'Maison', 'Libre', '5.3056, -3.9985', 6, 19, 90),
('San-Pédro', 'Sewe', 'Quartier Résidentiel', 2, 1, 1, '100', 230000, 1, 1, 'Studio proche de la plage', 'Studio', 'Occupée', '4.7480, -6.6355', 7, 16, 70),
('Yamoussoukro', 'Attiégouakro', 'Quartier Industriel', 4, 3, 2, '160', 400000, 2, 2, 'Maison moderne avec jardin', 'Maison', 'Libre', '6.8250, -5.2781', 1, 18, 100),
('Bouaké', 'Zone 4', 'Quartier Commercial', 3, 2, 1, '130', 270000, 1, 1, 'Appartement avec balcon', 'Appartement', 'Occupée', '7.6880, -5.0310', 2, 15, 80),
('Man', 'Libreville', 'Quartier Militaire', 2, 1, 1, '100', 220000, 1, 1, 'Appartement avec vue sur la montagne', 'Appartement', 'Libre', '7.4160, -7.5561', 3, 14, 50),
('Gagnoa', 'Sogefiha', 'Quartier des Écoles', 3, 2, 1, '140', 260000, 1, 1, 'Maison familiale avec cour', 'Maison', 'Occupée', '6.1319, -5.9500', 4, 20, 90),
('Korhogo', 'Soba', 'Quartier Résidentiel', 3, 2, 2, '150', 280000, 1, 1, 'Maison moderne avec terrasse', 'Maison', 'Libre', '9.4580, -5.6296', 5, 22, 110),
('Abidjan', 'Adjame', 'Quartier Commercial', 2, 1, 1, '90', 200000, 1, 1, 'Appartement proche des commodités', 'Appartement', 'Occupée', '5.3470, -4.0370', 6, 12, 60),
('Daloa', 'Grandes Terres', 'Quartier Administratif', 4, 3, 2, '180', 350000, 2, 1, 'Maison avec vue sur les montagnes', 'Maison', 'Libre', '6.8785, -6.4525', 7, 18, 100);


INSERT INTO Locations (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_mensuel, Caution, Avance, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Yopougon', 'Niangon', 3, 2, 1, '120', 300000, 1, 1, 'Appartement moderne avec balcon', 'Appartement', 'Libre', '5.3364, -4.0732', 1, 18, 90),
('San-Pédro', 'Sewe', 'Quartier Industriel', 2, 1, 1, '90', 220000, 1, 1, 'Petit appartement confortable', 'Appartement', 'Occupée', '4.7501, -6.6364', 2, 12, 70),
('Bouaké', 'Ahougnansou', 'Belleville', 3, 2, 1, '140', 250000, 1, 1, 'Maison avec petit jardin', 'Maison', 'Libre', '7.6908, -5.0326', 3, 16, 100),
('Yamoussoukro', 'Attiégouakro', 'Quartier Industriel', 4, 3, 2, '170', 350000, 2, 2, 'Grande villa avec garage et piscine', 'Villa', 'Occupée', '6.8201, -5.2768', 4, 21, 150),
('Daloa', 'Gbatta', 'Quartier Résidentiel', 2, 1, 1, '80', 200000, 1, 1, 'Appartement rénové', 'Appartement', 'Libre', '6.8782, -6.4527', 5, 14, 60),
('Man', 'Libreville', 'Quartier Militaire', 3, 2, 1, '120', 280000, 1, 1, 'Maison familiale avec cour', 'Maison', 'Occupée', '7.4142, -7.5535', 6, 17, 110),
('Gagnoa', 'Garahio', 'Quartier Sogefiha', 2, 1, 1, '100', 220000, 1, 1, 'Petit appartement lumineux', 'Appartement', 'Libre', '6.1321, -5.9509', 7, 11, 50),
('Korhogo', 'Pelengana', 'Haute Ville', 3, 2, 2, '140', 240000, 1, 1, 'Maison avec terrasse', 'Maison', 'Libre', '9.4579, -5.6293', 2, 15, 80),
('Abengourou', 'Akan', 'Quartier Bellevue', 2, 1, 1, '80', 180000, 1, 1, 'Appartement en centre-ville', 'Appartement', 'Occupée', '6.7305, -3.4915', 3, 10, 40),
('Aboisso', 'Aboisso Ville', 'Quartier Administratif', 4, 3, 2, '180', 400000, 2, 1, 'Villa moderne avec piscine', 'Villa', 'Libre', '5.4725, -3.2063', 4, 25, 130),
('Divo', 'Bada', 'Quartier Résidentiel', 2, 1, 1, '90', 220000, 1, 1, 'Appartement proche du marché', 'Appartement', 'Occupée', '5.8375, -5.3580', 5, 13, 60),
('Abidjan', 'Marcory', 'Zone 4', 3, 2, 1, '140', 350000, 2, 1, 'Maison spacieuse avec jardin', 'Maison', 'Libre', '5.3056, -3.9985', 6, 19, 90),
('San-Pédro', 'Sewe', 'Quartier Résidentiel', 2, 1, 1, '100', 230000, 1, 1, 'Studio proche de la plage', 'Studio', 'Occupée', '4.7480, -6.6355', 7, 16, 70),
('Yamoussoukro', 'Attiégouakro', 'Quartier Industriel', 4, 3, 2, '160', 400000, 2, 2, 'Maison moderne avec jardin', 'Maison', 'Libre', '6.8250, -5.2781', 1, 18, 100),
('Bouaké', 'Zone 4', 'Quartier Commercial', 3, 2, 1, '130', 270000, 1, 1, 'Appartement avec balcon', 'Appartement', 'Occupée', '7.6880, -5.0310', 2, 15, 80),
('Man', 'Libreville', 'Quartier Militaire', 2, 1, 1, '100', 220000, 1, 1, 'Appartement avec vue sur la montagne', 'Appartement', 'Libre', '7.4160, -7.5561', 3, 14, 50),
('Gagnoa', 'Sogefiha', 'Quartier des Écoles', 3, 2, 1, '140', 260000, 1, 1, 'Maison familiale avec cour', 'Maison', 'Occupée', '6.1319, -5.9500', 4, 20, 90),
('Korhogo', 'Soba', 'Quartier Résidentiel', 3, 2, 2, '150', 280000, 1, 1, 'Maison moderne avec terrasse', 'Maison', 'Libre', '9.4580, -5.6296', 5, 22, 110),
('Abidjan', 'Adjame', 'Quartier Commercial', 2, 1, 1, '90', 200000, 1, 1, 'Appartement proche des commodités', 'Appartement', 'Occupée', '5.3470, -4.0370', 6, 12, 60),
('Daloa', 'Grandes Terres', 'Quartier Administratif', 4, 3, 2, '180', 350000, 2, 1, 'Maison avec vue sur les montagnes', 'Maison', 'Libre', '6.8785, -6.4525', 7, 18, 100);

INSERT INTO Locations (Ville, Commune, Quartier, Nombre_de_pieces, Nombre_de_chambres, Nombre_de_salles_de_bain, metre_carre, Prix_mensuel, Caution, Avance, Descriptions, Type_de_maison, Statut_maison, GPS, IdUtilisateur, Likes, Nombre_de_vue)
VALUES
('Abidjan', 'Cocody', 'Riviera', 2, 1, 1, '100', 220000, 1, 1, 'Petit appartement avec balcon', 'Appartement', 'Libre', '5.3399, -4.0345', 1, 15, 80),
('San-Pédro', 'Balmer', 'Quartier Plage', 3, 2, 1, '130', 280000, 1, 1, 'Maison avec vue sur mer', 'Maison', 'Occupée', '4.7492, -6.6369', 2, 18, 90),
('Bouaké', 'Koko', 'Quartier des Affaires', 4, 3, 2, '160', 320000, 2, 1, 'Appartement moderne', 'Appartement', 'Libre', '7.6882, -5.0338', 3, 20, 110),
('Yamoussoukro', 'Zambakro', 'Quartier Administratif', 2, 1, 1, '90', 180000, 1, 1, 'Appartement proche du centre', 'Appartement', 'Occupée', '6.8050, -5.2798', 4, 12, 70),
('Daloa', 'Tazibouo', 'Quartier Industriel', 3, 2, 1, '140', 250000, 1, 1, 'Maison avec grand jardin', 'Maison', 'Libre', '6.8760, -6.4452', 5, 16, 90),
('Man', 'Glanleu', 'Quartier Résidentiel', 4, 3, 2, '180', 320000, 2, 2, 'Maison avec belle vue', 'Maison', 'Occupée', '7.4090, -7.5542', 6, 20, 110),
('Gagnoa', 'Libreville', 'Quartier des Écoles', 2, 1, 1, '80', 160000, 1, 1, 'Petit appartement', 'Appartement', 'Libre', '6.1345, -5.9488', 7, 10, 50),
('Korhogo', 'Soba', 'Quartier Industriel', 3, 2, 1, '130', 240000, 1, 1, 'Maison avec terrasse', 'Maison', 'Occupée', '9.4510, -5.6260', 1, 14, 80),
('Abengourou', 'Akan', 'Quartier des Affaires', 4, 3, 2, '150', 280000, 2, 1, 'Appartement bien situé', 'Appartement', 'Libre', '6.7381, -3.4890', 2, 18, 100),
('Aboisso', 'Adouko', 'Quartier Administratif', 2, 1, 1, '90', 190000, 1, 1, 'Petit appartement', 'Appartement', 'Occupée', '5.4738, -3.2041', 3, 12, 60),
('Divo', 'Gnamon', 'Quartier Résidentiel', 3, 2, 1, '120', 220000, 1, 1, 'Appartement calme', 'Appartement', 'Libre', '5.8310, -5.3602', 4, 15, 80),
('Abidjan', 'Plateau', 'Quartier des Affaires', 4, 3, 2, '170', 350000, 2, 2, 'Appartement de luxe', 'Appartement', 'Occupée', '5.3204, -4.0165', 5, 25, 120),
('San-Pédro', 'Bardo', 'Quartier Résidentiel', 2, 1, 1, '80', 150000, 1, 1, 'Petit appartement avec jardin', 'Appartement', 'Libre', '4.7490, -6.6356', 6, 10, 50),
('Yamoussoukro', 'Morofé', 'Quartier Industriel', 3, 2, 1, '130', 240000, 1, 1, 'Maison moderne avec garage', 'Maison', 'Occupée', '6.8185, -5.2780', 7, 17, 90),
('Bouaké', 'Zone 5', 'Quartier Résidentiel', 4, 3, 2, '160', 300000, 2, 2, 'Maison familiale', 'Maison', 'Libre', '7.6888, -5.0299', 1, 22, 110),
('Man', 'Logoualé', 'Quartier Militaire', 2, 1, 1, '90', 160000, 1, 1, 'Petit appartement', 'Appartement', 'Occupée', '7.4155, -7.5553', 2, 12, 60),
('Gagnoa', 'Dioulabougou', 'Quartier des Écoles', 3, 2, 1, '120', 220000, 1, 1, 'Maison familiale', 'Maison', 'Libre', '6.1310, -5.9500', 3, 15, 80),
('Korhogo', 'Koko', 'Quartier Industriel', 4, 3, 2, '160', 280000, 2, 2, 'Maison moderne', 'Maison', 'Occupée', '9.4579, -5.6280', 4, 20, 100),
('Abidjan', 'Yopougon', 'Quartier Populaire', 2, 1, 1, '80', 170000, 1, 1, 'Appartement proche des commodités', 'Appartement', 'Libre', '5.3261, -4.1131', 5, 13, 70),
('Daloa', 'Petits Pois', 'Quartier Administratif', 3, 2, 1, '140', 250000, 1, 1, 'Appartement avec balcon', 'Appartement', 'Occupée', '6.8750, -6.4509', 6, 18, 90),
('San-Pédro', 'Séwé', 'Quartier Industriel', 4, 3, 2, '170', 300000, 2, 2, 'Maison avec terrasse', 'Maison', 'Libre', '4.7481, -6.6352', 7, 23, 110),
('Yamoussoukro', 'Kossou', 'Quartier Résidentiel', 2, 1, 1, '90', 160000, 1, 1, 'Petit appartement', 'Appartement', 'Occupée', '6.8190, -5.2782', 1, 12, 60),
('Bouaké', 'Zone 2', 'Quartier Commercial', 3, 2, 1, '130', 240000, 1, 1, 'Appartement moderne', 'Appartement', 'Libre', '7.6896, -5.0304', 2, 17, 90),
('Man', 'Lelouma', 'Quartier Militaire', 4, 3, 2, '160', 280000, 2, 2, 'Maison avec vue sur montagne', 'Maison', 'Occupée', '7.4160, -7.5562', 3, 21, 110),
('Gagnoa', 'Babré', 'Quartier des Écoles', 2, 1, 1, '80', 160000, 1, 1, 'Petit appartement', 'Appartement', 'Libre', '6.1325, -5.9510', 4, 10, 50);
