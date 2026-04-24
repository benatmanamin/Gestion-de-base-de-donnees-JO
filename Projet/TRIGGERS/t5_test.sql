--- Test du Trigger5 nbSp_limite ---

-----OK-------
INSERT INTO LesSportifs VALUES (1401,'Neves','Joao','Portugal','masculin','1998-08-08 00:00:00'),
							   (1402,'Ferriera','Vitinha','Portugal','masculin','1999-01-08 00:00:00'),
							   (1403,'Ruiz','Fabian','Portugal','masculin','1997-07-08 00:00:00');

-----OK-------
INSERT INTO Discipline VALUES ('Football');
INSERT INTO LesEpreuves  VALUES (1,'WC Final','par equipe','Football','masculin',11,'2022-12-18 21:00:00');
INSERT INTO LesEpreuves  VALUES (2,'3 vs 3','par equipe','Football','masculin',3,'2022-12-10 21:00:00');

-----OK-------
INSERT INTO LesEquipes VALUES (1);
-----OK-------
INSERT INTO Appartenance  VALUES (1401,1),(1402,1),(1403,1);
-----OK-------
INSERT INTO EpEquipe VALUES (1,2);


----- !!! NOK : L'équipe respecte pas le nombre fixé par l'épreuve !!! ------
INSERT INTO EpEquipe VALUES (1,1);
