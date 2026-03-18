CREATE DATABASE gestion_bibliotheque;
USE gestion_bibliotheque;

-- Table AUTEUR
CREATE TABLE AUTEUR (
    id_auteur INT IDENTITY(1,1) PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100),
    nationalite VARCHAR(50)
);

-- Table CATEGORIE
CREATE TABLE CATEGORIE (
    id_cat INT IDENTITY(1,1) PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table USAGE (ou USAGER)
CREATE TABLE USAGE (
    id_usage INT IDENTITY (1,1) PRIMARY KEY ,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100),
    type VARCHAR(50)
);

-- Table BIBLIOTHECAIRE
CREATE TABLE BIBLIOTHECAIRE (
    id_staff INT IDENTITY (1,1) PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    poste VARCHAR(100)
);



-- Table LIVRE (Liée à CATEGORIE via "classer")
CREATE TABLE LIVRE (
    id_livre INT IDENTITY(1,1) PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    annee_publication INT 
);

-- Table EXEMPLAIRE (Liée à LIVRE via "Possede")
CREATE TABLE EXEMPLAIRE (
    id_exemplaire INT IDENTITY (1,1) PRIMARY KEY,
    etat VARCHAR(50),
    date_achat DATE,
    isbn VARCHAR(20),
    FOREIGN KEY (isbn) REFERENCES LIVRE(isbn)
);

-- Table EMPRUNTE (Liée à EXEMPLAIRE, USAGE et BIBLIOTHECAIRE)
CREATE TABLE EMPRUNTE (
    id_emprunt INT IDENTITY (1,1) PRIMARY KEY,
    date_sortie DATE NOT NULL,
    date_ret_prev DATE,
    date_ret_eff DATE,
    id_exemplaire INT,
    id_usage INT,
    id_staff INT,
    FOREIGN KEY (id_exemplaire) REFERENCES EXEMPLAIRE(id_exemplaire),
    FOREIGN KEY (id_usage) REFERENCES USAGE(id_usage),
    FOREIGN KEY (id_staff) REFERENCES BIBLIOTHECAIRE(id_staff)
);


-- Table de liaison ECRIRE
CREATE TABLE Ecrire (
    id_auteur INT,
    isbn VARCHAR(20),
    PRIMARY KEY (id_auteur, isbn),
    FOREIGN KEY (id_auteur) REFERENCES AUTEUR(id_auteur),
    FOREIGN KEY (isbn) REFERENCES LIVRE(isbn)
);




-- Ajouter un auteur (L'ID se génère tout seul)
INSERT INTO AUTEUR (nom, prenom, nationalite) 
VALUES ('Hugo', 'Victor', 'Française');

-- Ajouter un livre (Regardez bien l'ordre : isbn, titre, annee, id_cat)
INSERT INTO LIVRE (isbn, titre, annee_publi, id_cat)
VALUES ('978-204010567', 'Les Misérables', 1862, 1);

-- Faire le lien dans la table de jonction
INSERT INTO Ecrire (id_auteur, isbn) 
VALUES (1, '978-204010567');

-- Ajouter une catégorie
INSERT INTO CATEGORIE (libelle) VALUES ('Roman Historique');

-- Ajouter un exemplaire physique
INSERT INTO EXEMPLAIRE (etat, date_achat, isbn) 
VALUES ('Bon état', '2023-01-15', '978-204010567');


SELECT LIVRE.titre, AUTEUR.nom 
FROM LIVRE
JOIN Ecrire ON LIVRE.isbn = Ecrire.isbn
JOIN AUTEUR ON Ecrire.id_auteur = AUTEUR.id_auteur
WHERE AUTEUR.nom = 'Hugo';


SELECT USAGE.nom, LIVRE.titre, EMPRUNTE.date_sortie
FROM EMPRUNTE
JOIN USAGE ON EMPRUNTE.id_usage = USAGE.id_usage
JOIN EXEMPLAIRE ON EMPRUNTE.id_exemplaire = EXEMPLAIRE.id_exemplaire
JOIN LIVRE ON EXEMPLAIRE.isbn = LIVRE.isbn
WHERE EMPRUNTE.date_ret_eff IS NULL;


UPDATE EMPRUNTE 
SET date_ret_eff = GETDATE()
WHERE id_emprunt = 1;

UPDATE EXEMPLAIRE 
SET etat = 'Abîmé' 
WHERE id_exemplaire = 5;


SELECT libelle, COUNT(*) as nombre_livres 
FROM LIVRE 
JOIN CATEGORIE ON LIVRE.id_cat = CATEGORIE.id_cat 
GROUP BY libelle;

SELECT TOP 5 * FROM EMPRUNTE 
ORDER BY date_sortie DESC;

SELECT TOP 5 * FROM EMPRUNTE ORDER BY date_sortie DESC



--LES TESTE

INSERT INTO AUTEUR (nom, prenom, nationalite) 
VALUES ('Hugo', 'Victor', 'Française');

INSERT INTO AUTEUR (nom, prenom, nationalite) 
VALUES ('Molière', 'Jean-Baptiste', 'Française');

-- Test de la sélection avec le TOP corrigé
SELECT TOP 5 * FROM AUTEUR ORDER BY nom ASC;

-- Test de la table EMPRUNTE (vérifier si GETDATE() a fonctionné)
SELECT * FROM EMPRUNTE;


UPDATE EMPRUNTE 
SET date_ret_eff = GETDATE() 
WHERE id_emprunt = 1;

-- Vérifiez le résultat
SELECT date_ret_eff FROM EMPRUNTE WHERE id_emprunt = 1;


 
 -- Ajouter un auteur
INSERT INTO AUTEUR (nom, prenom, nationalite) 
VALUES ('honoré', 'de Balzac', 'Française');

-- Ajouter une catégorie
INSERT INTO CATEGORIE (libelle) 
VALUES ('Roman Historique');

-- Ajouter un livre (lié à la catégorie 1)
INSERT INTO LIVRE (isbn, titre, annee_publi, id_cat) 
VALUES ('978-204010568', 'Le Père Goriot', 1835, 1);


-- Ajouter un exemplaire physique
INSERT INTO EXEMPLAIRE (etat, date_achat, isbn) 
VALUES ('Bon état', '2023-01-15', '978-204010568');

