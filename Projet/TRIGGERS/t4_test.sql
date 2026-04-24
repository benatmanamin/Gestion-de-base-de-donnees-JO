--- Test du Trigger4 categorieEq ---

-----OK-------
INSERT INTO LesSportifs VALUES (1401,'Neves','Joao','Portugal','masculin','1998-08-08 00:00:00'),
							   (1402,'Ferriera','Vitinha','Portugal','masculin','1999-01-08 00:00:00'),
							   (1403,'Ruiz','Fabian','Portugal','masculin','1997-07-08 00:00:00');

-----OK-------
INSERT INTO Discipline VALUES ('Natation');
INSERT INTO LesEpreuves  VALUES (1,'500m','par equipe','Natation','feminin',NULL,'2020-11-25 21:00:00');
INSERT INTO LesEpreuves  VALUES (2,'500m','par equipe','Natation','masculin',NULL,'2020-11-25 21:00:00');
-----OK-------
INSERT INTO LesEquipes VALUES (1);
-----OK-------
INSERT INTO Appartenance  VALUES (1401,1),(1402,1),(1403,1);
-----OK-------
INSERT INTO EpEquipe VALUES (1,2);


----- !!! NOK : Pas la meme catégorie !!! ------
INSERT INTO EpEquipe   VALUES (1,1);