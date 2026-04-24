-- TRIGGER  2 : Une equipe contient au moins deux sportifs --

DROP TRIGGER IF EXISTS minimum_equipe;

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

