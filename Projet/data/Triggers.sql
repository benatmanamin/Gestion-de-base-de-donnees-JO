-- TRIGGER  1 : Verifie que Les sportifs d'une meme equipe sont du meme pays --

DROP TRIGGER IF EXISTS equipe_meme_pays;
/
CREATE TRIGGER equipe_meme_pays
BEFORE INSERT ON Appartenance
WHEN EXISTS (
    SELECT 1
    FROM Appartenance A
    JOIN LesSportifs S ON A.numSp = S.numSp
    WHERE A.numEq = NEW.numEq
      AND S.pays <> (SELECT pays FROM LesSportifs WHERE numSp = NEW.numSp)
)
BEGIN
    SELECT RAISE(ABORT, 'Tous les sportifs d''une équipe doivent être du même pays');
END;

-- TRIGGER  2 : Une equipe contient au moins deux sportifs --

/
DROP TRIGGER IF EXISTS minimum_equipe;
/
CREATE TRIGGER minimum_equipe
BEFORE DELETE ON Appartenance
WHEN (
    SELECT COUNT(*)
    FROM Appartenance 
    WHERE numEq = OLD.numEq
) = 2
BEGIN
    SELECT RAISE(ABORT, 'Minimum 2 sportifs par équipe');
END;

-- TRIGGER  3 : Non respect de la catégorie d'une épreuve individuelle --

/
DROP TRIGGER IF EXISTS categorieInd;
/
CREATE TRIGGER categorieInd
BEFORE INSERT ON EpIndividuelle
BEGIN
    SELECT RAISE(ABORT, 'Categorie non respectée aux épreuves individuelles')
    WHERE
    (SELECT categorieEp FROM LesEpreuves WHERE numEp = NEW.numEp) <> 'mixte'
    AND
    (SELECT categorieEp FROM LesEpreuves WHERE numEp = NEW.numEp) <>
    (SELECT categorieSp FROM LesSportifs WHERE numSp = NEW.numSp);
END;

-- TRIGGER  4 : Non respect de la catégorie d'une épreuve par équipe --

/
DROP TRIGGER IF EXISTS categorieEq;
/
CREATE TRIGGER categorieEq
BEFORE INSERT ON EpEquipe
BEGIN
    SELECT RAISE(ABORT, 'Categorie non respectée aux épreuves d''équipe')
    WHERE
    (SELECT categorieEp FROM LesEpreuves WHERE numEp = NEW.numEp) <> 'mixte'
    AND
    EXISTS (SELECT 1 FROM Appartenance A JOIN LesSportifs S ON A.numSp = S.numSp
                     WHERE A.numEq = NEW.numEq
                     AND S.categorieSp <> (SELECT categorieEp FROM LesEpreuves WHERE numEp = NEW.numEp));
END;

-- TRIGGER  5 : Non respect du nombre de sportifs par équipe fixé par une épreuve par équipe --

/
DROP TRIGGER IF EXISTS nbSp_limite;
/
CREATE TRIGGER nbSp_limite
BEFORE INSERT ON EpEquipe
BEGIN
    SELECT RAISE(ABORT, 'Le nombre de sportifs par équipe ne respecte pas le nombre fixé par l''epreuve')
    WHERE
    (SELECT nbSportifsEp FROM LesEpreuves WHERE numEp = NEW.numEp) IS NOT NULL
    AND
    (SELECT COUNT(*) FROM Appartenance WHERE numEq = NEW.numEq)
    <> (SELECT nbSportifsEp FROM LesEpreuves WHERE numEp = NEW.numEp);
                            
END;
