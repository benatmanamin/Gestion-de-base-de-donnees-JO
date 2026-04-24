PRAGMA foreign_keys=on;

CREATE TABLE IF NOT EXISTS Discipline
(
  nomDi TEXT PRIMARY KEY 
);


CREATE TABLE IF NOT EXISTS LesSportifs
(
  numSp INTEGER PRIMARY KEY ,
  nomSp TEXT,
  prenomSp TEXT,
  pays TEXT,
  categorieSp TEXT,
  dateNaisSp DATE,
  CONSTRAINT SP_UQ1 UNIQUE( nomSp,prenomSp ),
  CONSTRAINT SP_CK1 CHECK(numSp >= 1000 and numSp <= 1500 ),
  CONSTRAINT SP_CK2 CHECK(categorieSp IN ('feminin','masculin'))
);


CREATE TABLE IF NOT EXISTS LesEpreuves
(
  numEp INTEGER PRIMARY KEY,
  nomEp TEXT,
  formeEp TEXT,
  nomDi TEXT REFERENCES Discipline(nomDi),
  categorieEp TEXT,
  nbSportifsEp INTEGER,
  dateEp DATE,
  CONSTRAINT EP_CK1 CHECK (formeEp IN ('individuelle','par equipe','par couple')),
  CONSTRAINT EP_CK2 CHECK (categorieEp IN ('feminin','masculin','mixte')),
  CONSTRAINT EP_CK3 CHECK (numEp > 0),
  CONSTRAINT EP_CK4 CHECK (nbSportifsEp > 0)
);


CREATE TABLE IF NOT EXISTS LesEquipes
(
  numEq INTEGER PRIMARY KEY,
  CONSTRAINT EQ_CK1 CHECK(numEq >= 1 and numEq <= 100 )
);


CREATE TABLE IF NOT EXISTS Appartenance
(
  numSp INTEGER REFERENCES LesSportifs(numSp),
  numEq INTEGER REFERENCES LesEquipes(numEq),
  CONSTRAINT APP_PK PRIMARY KEY( numSp,numEq )
);


CREATE TABLE IF NOT EXISTS EpIndividuelle
(
  numSp INTEGER REFERENCES LesSportifs(numSp),
  numEp INTEGER REFERENCES LesEpreuves(numEp),
  CONSTRAINT EpInd_PK PRIMARY KEY( numSp,numEp )
);


CREATE TABLE IF NOT EXISTS EpEquipe
(
  numEq INTEGER REFERENCES LesEquipes(numEq),
  numEp INTEGER REFERENCES LesEpreuves(numEp),
  CONSTRAINT EpEq_PK PRIMARY KEY( numEq,numEp )
);


CREATE TABLE IF NOT EXISTS ResultatInd
(
  numEp INTEGER PRIMARY KEY,
  gold INTEGER NOT NULL REFERENCES LesSportifs(numSp),
  silver INTEGER NOT NULL REFERENCES LesSportifs(numSp),
  bronze INTEGER NOT NULL REFERENCES LesSportifs(numSp)
);


CREATE TABLE IF NOT EXISTS ResultatEq
(
  numEp INTEGER PRIMARY KEY,
  gold INTEGER NOT NULL REFERENCES LesEquipes(numEq),
  silver INTEGER NOT NULL REFERENCES LesEquipes(numEq),
  bronze INTEGER NOT NULL REFERENCES LesEquipes(numEq)
);



----VIEWS----


--- LesAgesSportifs qui calcule l'age de chaque sportif ---

CREATE VIEW IF NOT EXISTS  LesAgesSportifs AS
  SELECT numSp, nomSp, prenomSp, pays, categorieSp, dateNaisSp, 
         (strftime('%Y', 'now') - strftime('%Y', dateNaisSp)) -
         (strftime('%m-%d', 'now') < strftime('%m-%d', dateNaisSp)) AS ageSp 
  FROM LesSportifs
;


--- LesNbsEquipiers qui calcule le nombre d'equipiers de chaque equipe ---

CREATE VIEW IF NOT EXISTS  LesNbsEquipiers AS
  SELECT numEq, COUNT(numSp) AS nbEquipiersEq  
  FROM Appartenance
  GROUP BY numEq
;


--- AgeMoyEqOr qui calcule les ages moyens de tous les équipes qui ont gagné une médaille d'or ---

CREATE VIEW IF NOT EXISTS  AgeMoyEqOr AS
  SELECT R.gold, AVG(L.ageSp) AS ageMoy 
  FROM ResultatEq R JOIN Appartenance A ON A.numEq=R.gold
                    JOIN LesAgesSportifs L ON L.numSp = A.numSp
  GROUP BY R.gold
;


--- ClassementPays qui classe les pays selon les médailles gagnées ---

CREATE VIEW IF NOT EXISTS  ClassementPays AS
  WITH liste_pays AS(
    SELECT DISTINCT pays FROM LesSportifs
  ),
  equipe_pays AS(
    SELECT DISTINCT numEq, pays FROM Appartenance JOIN LesSportifs USING (numSp)
  ), 
  medGold AS(
    SELECT S.pays,R.gold
    FROM ResultatInd R JOIN LesSportifs S ON S.numSp=R.gold
    UNION ALL 
    SELECT E.pays,R.gold
    FROM ResultatEq R JOIN equipe_pays E ON E.numEq=R.gold
  ),nbGold AS(
    SELECT L.pays,COUNT(M.gold) AS nbOr
    FROM liste_pays L LEFT JOIN medGold M ON L.pays=M.pays
    GROUP BY L.pays
  ), 
  medSilver AS(
    SELECT S.pays,R.silver
    FROM ResultatInd R JOIN LesSportifs S ON S.numSp=R.silver
    UNION ALL 
    SELECT E.pays,R.silver
    FROM ResultatEq R JOIN equipe_pays E ON E.numEq=R.silver
  ),nbSilver AS(
    SELECT L.pays,COUNT(M.silver) AS nbArgent
    FROM liste_pays L LEFT JOIN medSilver M ON L.pays=M.pays
    GROUP BY L.pays
  ), 
  medBronze AS(
    SELECT S.pays,R.bronze
    FROM ResultatInd R JOIN LesSportifs S ON S.numSp=R.bronze
    UNION ALL 
    SELECT E.pays,R.bronze
    FROM ResultatEq R JOIN equipe_pays E ON E.numEq=R.bronze
  ),nbBronzeTable AS(
    SELECT L.pays,COUNT(M.bronze) AS nbBronze
    FROM liste_pays L LEFT JOIN medBronze M ON L.pays=M.pays
    GROUP BY L.pays
  )

  SELECT pays,nbOr,nbArgent,nbBronze
  FROM nbGold JOIN nbSilver USING(pays)
              JOIN nbBronzeTable USING(pays)
  ORDER BY nbOr DESC,nbArgent DESC,nbBronze DESC
;