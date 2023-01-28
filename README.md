# Projet-ELM

L'objectif de ce projet était d'écrire le programme elm d'une application web permettant à un joueur de deviner un mot dont les définitions sont affichées.

# Description fonctionnelle et technique

Au chargement de la page, le programme choisit au hasard un mot parmi ceux de la liste fournie (words.txt). Puis, il demande et affiche ces définitions à partir d'une requête HTTP adressée à Free Dictionary API. On doit alors deviner et écrire le mot qu'il croit correspondre aux définitions. On peut continuer tant qu'on n'a pas la réponse correcte. Quand on a écrit la réponse correcte, un message le confirme.
Si il y a un problème de connexion, de chargement du fichier ou autre, un bouton "Start" s'affiche, permettant de relancer l'ouverture du fichier et la requète HTTP sans avoir à rafraichir la page.
Si l'utilisateur ne trouve pas le mot à deviner, il a possibilité d'afficher la réponse avec le bouton "Show word".
Pour changer de mot, l'utilisateur peut rafraichir la page ou cliquer sur le bouton "Next word".

# Comment installer et lancer le programme

Si ELM n'est pas déjà installé sur votre machine, vous pouvez l'installer en suivant ce guide : https://guide.elm-lang.org/install/elm.html
Il faut ensuite s'assurer d'avoir lancé la commande 'elm init' dans votre dossier source, pour ainsi obtenir un fichier elm.json et un dossier src. Il faut ensuite télécharger les deux fichiers Main.elm et words.txt et placer le premier dans le dossier src, et le second, soit dans un dossier ELM (situé au même endroit que le dossier src initial), soit dans un autre dossier, mais il faudra alors modifier la ligne 50 du programme pour remplacer le lien par celui de votre fichier. Vous devez trouver son lien sur votre http://localhost:8000 (obtenu en tapant elm reactor).
Il vous suffit ensuite de cliquer directement sur le programme Main.elm depuis http://localhost:8000.
