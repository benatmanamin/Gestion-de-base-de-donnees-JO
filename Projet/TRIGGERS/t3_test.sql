--- Test du Trigger3 categorieInd ---

-----OK-------
INSERT INTO LesSportifs VALUES (1401,'Lea','Emily','Italy','feminin','1999-08-08 00:00:00'),(1402,'Ferriera','Vitinha','Portugal','masculin','1999-01-08 00:00:00');

-----OK-------
INSERT INTO Discipline VALUES ('UFC');
INSERT INTO LesEpreuves  VALUES (1,'Final','individuelle','UFC','masculin',NULL,'2020-11-25 21:00:00');
-----OK-------
INSERT INTO EpIndividuelle  VALUES (1402,1);


----- !!! NOK : Pas la meme catégorie !!! ------
INSERT INTO EpIndividuelle  VALUES (1401,1);