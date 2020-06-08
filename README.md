# Runeo Drive Flutter

Application mobile de suivi des courses des chauffeurs du Paleo Festival.

## Getting Started

1. [Installation de Flutter](https://flutter.dev/docs/get-started/install)

2. Clonez le repo

```bash
git clone https://github.com/CPNV-ES/Runeo-Drive-Flutter.git
cd Runeo-Drive-Flutter
```

3. Faire une copie du .env.example renommée en .env

```bash
cp .env.example .env
```

4. Ajoutez l'url du backend Runeo-Desk-2020 au .env

```
API_URL=<backend url>
```

5. Lancez l'application mobile

```bash
flutter run
```

## Installation de Firebase Messaging Cloud

La [documentation](./docs/Firebase_Messaging_Cloud_Installation(Android&IOS).md) se trouve dans le dossier docs.

  ### Testez les push notifications
  
  Dans le dossier test_push_notification se trouve 2 fichiers pythons qui permettent d'envoyer des push notifications.
  
  Pour la configuration, il faut se référer au [readme](./test_push_notification/readne.md).
  
  Pour le message à tous les chauffeurs, il faut lancer
  
  ```bash
python message_to_all.py
```

Et pour mettre à jours les runs, il suffit simplement de lancer

 ```bash
python update_runs.py
```

## Configuration du scan de QR codes

La [documentation](./docs/Barcode_scan_configuration(Android&IOS).md) se trouve dans le dossier docs.
