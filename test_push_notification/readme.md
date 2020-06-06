## Push notifications

C'est un tutoriel qui va vous permettre de pouvoir lancer les deux scripts python "message_to_all" et "update_runs".

#### Requirements

- Admin Python SDK — Python 3.5+

- Projet Firebase

#### Get started

Si vous n'avez pas encore de projet Firebase, vous devez en créer un dans la [console Firebase](https://console.firebase.google.com/). 

Il faut maintenant installer le sdk de python.

```bash
pip install firebase_admin
```

Ensuite, il faut initialiser le SDK avec les credentials de Firebase.

Pour cela il vous faut faire cela comme suit :

1. Dans la console Firebase, ouvrez **Settings** > [Service Accounts](https://console.firebase.google.com/project/_/settings/serviceaccounts/adminsdk)

2. Cliquez sur **Generate New Private Key**, puis confirmer en cliquant sur **Generate Key**

3. Il vous maintenant enregistrer le ficher dans le même dossier que les deux fichiers python

Pour lancer les deux fichiers, il vous suffit tout simplement de faire :

```bash
python message_to_all.py
python update_runs.py
```




