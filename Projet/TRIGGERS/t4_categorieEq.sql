-- TRIGGER  4 : Non respect de la catégorie d'une épreuve par équipe --

DROP TRIGGER IF EXISTS categorieEq;

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
