--- Test du Trigger2 minimum_equipe ---

-----OK-------
INSERT INTO LesSportifs VALUES (1401,'Neves','Joao','Portugal','masculin','1998-08-08 00:00:00'),
							   (1402,'Ferriera','Vitinha','Portugal','masculin','1999-01-08 00:00:00'),
							   (1403,'Fernandez','Rafa','Portugal','masculin','1997-07-08 00:00:00');
-----OK-------
INSERT INTO LesEquipes VALUES (1);
-----OK-------
INSERT INTO Appartenance  VALUES (1401,1),(1402,1),(1403,1);
-----OK-------
DELETE FROM Appartenance WHERE numSp=1403;


----- !!! NOK : Pas moins de deux par équipe !!! ------
DELETE FROM Appartenance WHERE numSp=1402;
