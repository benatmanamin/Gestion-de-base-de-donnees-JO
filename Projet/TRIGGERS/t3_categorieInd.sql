-- TRIGGER  3 : Non respect de la catégorie d'une épreuve individuelle --

DROP TRIGGER IF EXISTS categorieInd;

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
