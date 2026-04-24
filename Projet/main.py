import sqlite3
from actions import database_functions
from actions import database_queries

# Connexion à la base de données
data = sqlite3.connect("data/jo.db")

# Fonction permettant de quitter le programme
def quitter():
    print("Au revoir !")
    exit(0)

# Menu des views
def menu_views():
    print("\n===== VIEWS =====")
    print("1 - Les ages des Sportifs")
    print("2 - Les Nombres Equipiers")
    print("3 - Les ages moyens des equipes gagnants une médaille d'Or")
    print("4 - Classement des pays")
    print("5 - Revenir au Menu Principal")


# Fonction des views
def views():
     # Appel du menu des views
    while True:
        menu_views()
        try:
            choix = int(input("Votre choix : ").strip())
        except Exception: 
            print("choix invalide")   # Ce n'est pas un entier
            continue    #Revenir au menu des views
        if choix==5 :
            break    # Revenir au menu principal
        if choix>0 and choix<5:
            action = actions.get(str(choix+8)) 
            action()
        else:
            print("Choix invalide.")


# Association des actions aux fonctions
actions = {
    "1": lambda: database_functions.database_create(data),
    "2": lambda: database_functions.database_insert(data),
    "3": lambda: database_functions.database_delete(data),
    "4": lambda: database_queries.liste_epreuves(data),
    "5": lambda: database_queries.membres_equipe(data),
    "6": lambda: database_queries.gagnants(data),
    "7": lambda: database_queries.participants(data),
    "8": views,
    "9": lambda: database_queries.ageSportifs(data),   
    "10": lambda: database_queries.nbEquipiers(data),     
    "11": lambda: database_queries.agemoy(data),     
    "12": lambda: database_queries.classement(data),     
    "q": quitter
}

# Fonctions d'affichage du menu
def menu():
    print("\n=== Menu principal ===")
    print("1 - Créer la base de données")
    print("2 - Insérer les données du fichier Excel")
    print("3 - Supprimer la base de données")
    print("4 - Liste des épreuves d'une discipline")
    print("5 - Membres d'une équipe")
    print("6 - Gagnants d'une épreuve")
    print("7 - Participants à une épreuve")
    print("8 - Views (Ages, Classement ...)")
    print("q - Quitter")

# Fonction principale
def main():
     # Appel du menu en boucle et gestion du choix
    while True:
        menu()
        choix = input("Votre choix : ").strip()
        action = actions.get(choix)
        if action:
            action()
        else:
            print("Choix invalide.")

# Appel de la fonction principale
main()