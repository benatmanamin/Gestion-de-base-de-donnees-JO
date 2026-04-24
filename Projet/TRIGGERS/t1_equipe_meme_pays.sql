-- TRIGGER  1 : Verifie que Les sportifs d'une meme equipe sont du meme pays --

DROP TRIGGER IF EXISTS equipe_meme_pays;

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

