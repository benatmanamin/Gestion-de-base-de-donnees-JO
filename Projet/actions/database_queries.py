
# Fonction permettant lister les épreuves d'une discipline donnée

def liste_epreuves(data):
    cursor = data.cursor()
    discipline=input("\nRentrez la discipline : ")
    cursor.execute("SELECT COUNT(*) FROM Discipline WHERE nomDi = ?", [discipline])
    if cursor.fetchone()[0]==0 :
        print("La discipline n'existe pas")
    else :
        print("\nListe des épreuves de " + discipline + " :\n")
        try:
            cursor = data.cursor()
            result = cursor.execute(
                """
                    SELECT DISTINCT nomEp, formeEp
                    FROM LesEpreuves
                    WHERE nomDi = ?
                    ORDER BY nomEp
                """,
                [discipline])
        except Exception as e:
            print("Impossible d'afficher les résultats : " + repr(e))
        else:
            for epreuve in result:
                print(epreuve[0] + " - " + epreuve[1])


# Fonction permettant lister les membres d'une équipe donnée

def membres_equipe(data):
    cursor = data.cursor()
    numEq=input("\nRentrez le numero d'equipe : ")
    cursor.execute("SELECT COUNT(*) FROM LesEquipes WHERE numEq = ?", [numEq])
    if cursor.fetchone()[0]==0 :
        print("Le numéro d'equipe n'existe pas")
    else :  
        print("\nMembres d'equipe numero " + numEq + " :\n")
        try:
            result = cursor.execute(
                """
                    SELECT s.numSp, s.nomSp , s.prenomSp  
                    FROM Appartenance a JOIN LesSportifs s ON a.numSp==s.numSp
                    WHERE numEq = ?
                """,
                [numEq])
        except Exception as e:
            print("Impossible d'afficher les résultats : " + repr(e))
        else:
            for membre in result:
                print(str(membre[0]) + " - " + str(membre[1])+ " - " + str(membre[2]))


# Fonction permettant lister les gagnants d'une épreuve

def gagnants(data):
    cursor = data.cursor()
    numEp=input("\nRentrez le numero d'epreuve : ")
    cursor.execute("SELECT COUNT(*) FROM ResultatInd WHERE numEp = ?", [numEp])
    if cursor.fetchone()[0]==0 :
        cursor.execute("SELECT COUNT(*) FROM ResultatEq WHERE numEp = ?", [numEp])
        if cursor.fetchone()[0]==0 :
            print("Le numéro d'epreuve n'existe pas")
        else : 
            print("\nLes trois premiers de l'epreuve " + numEp + " :\n")
        try:
            result = cursor.execute(
                """
                    SELECT gold, silver, bronze 
                    FROM ResultatEq
                    WHERE numEp = ?
                """,
                [numEp])
        except Exception as e:
            print("Impossible d'afficher les résultats : " + repr(e))
        else:
            for place in result:
                print("1er - "+str(place[0]) + "\n" +"2eme - "+str(place[1])+ " \n"+"3eme - " + str(place[2]))
    else :  
        print("\nLes trois premiers de l'epreuve " + numEp + " :\n")
        try:
            result = cursor.execute(
                """
                    SELECT gold, silver, bronze  
                    FROM ResultatInd
                    WHERE numEp = ?
                """,
                [numEp])
        except Exception as e:
            print("Impossible d'afficher les résultats : " + repr(e))
        else:
            for place in result:
                print("1er - "+str(place[0]) + "\n" +"2eme - "+str(place[1])+ " \n"+"3eme - " + str(place[2]))


# Fonction permettant lister les participants d'une épreuve

def participants(data):
    cursor = data.cursor()
    numEp=input("\nRentrez le numero d'epreuve : ")
    cursor.execute("SELECT COUNT(*) FROM EpIndividuelle WHERE numEp = ?", [numEp])
    if cursor.fetchone()[0]==0 :
        cursor.execute("SELECT COUNT(*) FROM EpEquipe WHERE numEp = ?", [numEp])
        if cursor.fetchone()[0]==0 :
            print("Le numéro d'epreuve n'existe pas")
        else : 
            print("\nLes participants à l'epreuve " + numEp + " :\n")
        try:
            result = cursor.execute(
                """
                    SELECT numEq
                    FROM EpEquipe
                    WHERE numEp = ?
                """,
                [numEp])
        except Exception as e:
            print("Impossible d'afficher les résultats : " + repr(e))
        else:
            for participant in result:
                print("- "+str(participant[0]))
    else :  
        print("\nLes participants à l'epreuve " + numEp + " :\n")
        try:
            result = cursor.execute(
                """
                    SELECT numSp
                    FROM EpIndividuelle
                    WHERE numEp = ?
                """,
                [numEp])
        except Exception as e:
            print("Impossible d'afficher les résultats : " + repr(e))
        else:
            for participant in result:
                print("- "+str(participant[0]))


######### FONCTIONS DES VIEWS ##########

# Fonction permettant d'afficher l'age des sportifs

def ageSportifs(data):
    print("\nLes Ages des Sportifs :\n")
    try:
        cursor = data.cursor()
        result = cursor.execute(
        """
            SELECT numSp, nomSp, prenomSp, ageSp
            FROM LesAgesSportifs
        """)
    except Exception as e:
        print("Impossible d'afficher les résultats : " + repr(e))
    else:
        for age in result:
            print(str(age[0]) + " - " + str(age[1]) + " - " + str(age[2]) + " - " + str(age[3]))


# Fonction permettant d'afficher le nombre d'équipers de chaque équipe

def nbEquipiers(data):
    print("\nLes nombres d'équipers de chaque équipe sont :\n")
    try:
        cursor = data.cursor()
        result = cursor.execute(
        """
            SELECT numEq, nbEquipiersEq
            FROM LesNbsEquipiers
        """)
    except Exception as e:
        print("Impossible d'afficher les résultats : " + repr(e))
    else:
        for age in result:
            print(str(age[0]) + " - " + str(age[1]))


# Fonction permettant d'afficher les ages moyens des equipes gagnants une médaille d'Or

def agemoy(data):
    print("\nLes ages moyens des equipes d'Or :\n")
    try:
        cursor = data.cursor()
        result = cursor.execute(
        """
            SELECT gold, ageMoy
            FROM AgeMoyEqOr
        """)
    except Exception as e:
        print("Impossible d'afficher les résultats : " + repr(e))
    else:
        for age in result:
            print(str(age[0]) + " - " + str(age[1]))


# Fonction permettant d'afficher le classement des pays selon les médailles gagnées

def classement(data):
    print("\nLe classement des pays selon les nombres de médailles :\n")
    try:
        cursor = data.cursor()
        result = cursor.execute(
        """
            SELECT pays, nbOr, nbArgent, nbBronze
            FROM ClassementPays
        """)
    except Exception as e:
        print("Impossible d'afficher les résultats : " + repr(e))
    else:
        i=1
        for age in result:
            print(str(i) + " | "+str(age[0]) + " - " + str(age[1]) + " - " + str(age[2]) + " - " + str(age[3]))
            i=i+1
