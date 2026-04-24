--- Test du Trigger1 equipe_meme_pays ---

-----OK-------
INSERT INTO LesSportifs VALUES (1401,'Neves','Joao','Portugal','masculin','1998-08-08 00:00:00'),
							   (1402,'Ferriera','Vitinha','Portugal','masculin','1999-01-08 00:00:00'),
							   (1403,'Ruiz','Fabian','Spain','masculin','1997-07-08 00:00:00');
-----OK-------
INSERT INTO LesEquipes VALUES (1);
-----OK-------
INSERT INTO Appartenance  VALUES (1401,1),(1402,1);


----- !!! NOK : Pas le meme pays !!! ------
INSERT INTO Appartenance  VALUES (1403,1);
