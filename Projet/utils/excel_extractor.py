import sqlite3, pandas
from sqlite3 import IntegrityError


# Fonction permettant de lire le fichier Excel des JO et d'insérer les données dans la base
def read_excel_file_V0(data:sqlite3.Connection, file):


    # Lecture de l'onglet LesEpreuves du fichier excel, en interprétant toutes les noms Discipline
    df_epreuves = pandas.read_excel(file, sheet_name='LesEpreuves', dtype=str)
    df_epreuves = df_epreuves.where(pandas.notnull(df_epreuves), 'null')

    cursor = data.cursor()
    for ix, row in df_epreuves.iterrows():
        try:
            query = "insert or ignore into Discipline values ('{}')".format(row['nomDi'])

            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            print(query)
            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")


    # Lecture de l'onglet du fichier excel LesSportifs, en interprétant toutes les colonnes comme des strings
    # pour construire uniformement la requête
    df_sportifs = pandas.read_excel(file, sheet_name='LesSportifs', dtype=str)
    df_sportifs = df_sportifs.where(pandas.notnull(df_sportifs), 'null')

    cursor = data.cursor()
    for ix, row in df_sportifs.iterrows():
        try:
            query = "insert into LesSportifs values ({},'{}','{}','{}','{}','{}')".format(
                row['numSp'], row['nomSp'], row['prenomSp'], row['pays'], row['categorieSp'], row['dateNaisSp'])
            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            print(query)
            cursor.execute(query)
        except IntegrityError as err:
            print(err)

    # Lecture de l'onglet LesEpreuves du fichier excel, en interprétant toutes les colonnes comme des string
    # pour construire uniformement la requête
    df_epreuves = pandas.read_excel(file, sheet_name='LesEpreuves', dtype=str)
    df_epreuves = df_epreuves.where(pandas.notnull(df_epreuves), 'null')

    cursor = data.cursor()
    for ix, row in df_epreuves.iterrows():
        try:
            query = "insert into LesEpreuves values ({},'{}','{}','{}','{}',{},".format(
                row['numEp'], row['nomEp'], row['formeEp'], row['nomDi'], row['categorieEp'], row['nbSportifsEp'])

            if row['dateEp'] != 'null':
                query = query + "'{}')".format(row['dateEp'])
            else:
                query = query + "null)"
            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            print(query)
            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")


    
    # Lecture de l'onglet LesSportifs du fichier excel, en interprétant toutes la relation LesEquipes
    df_sportifs = pandas.read_excel(file, sheet_name='LesSportifs', dtype=str)
    df_sportifs = df_sportifs.where(pandas.notnull(df_sportifs), 'null')

    cursor = data.cursor()
    for ix, row in df_sportifs.iterrows():
        if row['numEq'] == 'null':
            continue
        try:
            query = "insert or ignore into LesEquipes values ({})".format(row['numEq'])

            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            print(query)
            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")


    # Lecture de l'onglet LesSportifs du fichier excel, en interprétant toutes la relation Appartenance
    df_sportifs = pandas.read_excel(file, sheet_name='LesSportifs', dtype=str)
    df_sportifs = df_sportifs.where(pandas.notnull(df_sportifs), 'null')

    cursor = data.cursor()
    for ix, row in df_sportifs.iterrows():
        if row['numEq'] == 'null':
            continue
        try:
            query = "insert or ignore into Appartenance values ({},{})".format(row['numSp'],row['numEq'])

            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            print(query)
            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")


    # Lecture de l'onglet LesInscription du fichier excel, en interprétant la relation EpEquipe
    df_inscription = pandas.read_excel(file, sheet_name='LesInscriptions', dtype=str)
    df_inscription = df_inscription.where(pandas.notnull(df_inscription), 'null')

    cursor = data.cursor()
    for ix, row in df_inscription.iterrows():
        if int(row['numIn']) > 100:
            continue
        try:
            query = "insert or ignore into EpEquipe values ({},{})".format(row['numIn'],row['numEp'])

            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            print(query)
            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")



    # Lecture de l'onglet LesInscription du fichier excel, en interprétant la relation EpIndividuelle
    df_inscription = pandas.read_excel(file, sheet_name='LesInscriptions', dtype=str)
    df_inscription = df_inscription.where(pandas.notnull(df_inscription), 'null')

    cursor = data.cursor()
    for ix, row in df_inscription.iterrows():
        if int(row['numIn']) < 1000:
            continue
        try:
            query = "insert or ignore into EpIndividuelle values ({},{})".format(row['numIn'],row['numEp'])

            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            print(query)
            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")



    # Lecture de l'onglet LesResultats du fichier excel, en interprétant la relation ResultatInd
    df_resultats = pandas.read_excel(file, sheet_name='LesResultats', dtype=str)
    df_resultats = df_resultats.where(pandas.notnull(df_resultats), 'null')

    cursor = data.cursor()
    for ix, row in df_resultats.iterrows():
        if int(row['gold']) < 1000:
            continue
        try:
            query = "insert or ignore into ResultatInd values ({},{},{},{})".format(row['numEp'],row['gold'],row['silver'],row['bronze'])

            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            print(query)
            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")


    # Lecture de l'onglet Resultats du fichier excel, en interprétant la relation ResultatEq
    df_resultats = pandas.read_excel(file, sheet_name='LesResultats', dtype=str)
    df_resultats = df_resultats.where(pandas.notnull(df_resultats), 'null')

    cursor = data.cursor()
    for ix, row in df_resultats.iterrows():
        if int(row['gold']) > 100:
            continue
        try:
            query = "insert or ignore into ResultatEq values ({},{},{},{})".format(row['numEp'],row['gold'],row['silver'],row['bronze'])

            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            print(query)
            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")