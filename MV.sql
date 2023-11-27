DROP DATABASE IF EXISTS MV
CREATE DATABASE MV


DROP TABLE IF EXISTS Administrateur
CREATE TABLE Administrateur (
IdAdministrateur  INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Nom_et_prenoms VARCHAR(50),
Email VARCHAR(50),
Mot_de_pass VARCHAR(20),
Telephone VARCHAR(20)
)

DROP TABLE IF EXISTS Utilisateur
CREATE TABLE Utilisateur (
IdUtilisateur INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Nom_et_prenoms VARCHAR(50),
Email VARCHAR(50),
Mot_de_pass VARCHAR(20),
Adresse VARCHAR(20),
Telephone VARCHAR(20)
)

DROP TABLE IF EXISTS Maison
CREATE TABLE Maison (
IdMaison INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Ville VARCHAR(20),
Commune VARCHAR(20),
Nombre_de_pieces INT,
Prix_unitaire FLOAT,
Descriptions VARCHAR(20),
Type_de_maison VARCHAR(20),
Statut_maison VARCHAR(20),
GPS VARCHAR(20),
IdUtilisateur INT NOT NULL,
FOREIGN KEY  (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)


DROP TABLE IF EXISTS Locations
CREATE TABLE Locations (
IdLocations INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Ville VARCHAR(20),
Commune VARCHAR(20),
Nombre_de_pieces INT,
Prix_mensuel FLOAT,
Caution FLOAT,
Avance FLOAT,
Descriptions VARCHAR(20),
Type_de_maison VARCHAR(20),
Statut_maison VARCHAR(20),
GPS VARCHAR(20),
IdUtilisateur INT NOT NULL,
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)


DROP TABLE IF EXISTS Servives
CREATE TABLE Servives (
IdServives INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Type_de_services VARCHAR(20),
Ville VARCHAR(20),
Commune VARCHAR(20),
Descriptions VARCHAR(20),
Dates date,
Statut_servives VARCHAR(20),
GPS VARCHAR(20),
IdUtilisateur INT NOT NULL,
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)

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


DROP TABLE IF EXISTS Historique_servives
CREATE TABLE Historique_servives (
IdHist_servives INT NOT NULL PRIMARY KEY IDENTITY(1,1),
IdUtilisateur INT NOT NULL,
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)
