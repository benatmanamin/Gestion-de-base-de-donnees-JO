-- TRIGGER  5 : Non respect du nombre de sportifs par équipe fixé par une épreuve par équipe --

DROP TRIGGER IF EXISTS nbSp_limite;

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
