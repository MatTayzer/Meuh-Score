# Meuh Score

Application Android Flutter. Version de Flutter figée avec FVM (voir `.fvmrc`).

## Démarrer

```bash
fvm install
fvm flutter pub get
fvm flutter run
```

Toujours préfixer les commandes par `fvm` (`fvm flutter analyze`, `fvm flutter test`…).

## Structure

```
lib/
├── main.dart          point d'entrée
├── app/               configuration globale (MaterialApp, thème)
├── core/              briques techniques partagées (constantes, services)
├── features/          une fonctionnalité = un dossier
│   └── <feature>/
│       ├── domain/        modèles et logique métier pure
│       ├── data/          accès aux données (base, API)
│       ├── application/   état et logique d'écran
│       └── presentation/  pages/ et widgets/
└── shared/widgets/    composants UI réutilisables
assets/images/         images (noms en snake_case, chemins dans core/constants/app_assets.dart)
test/                  même arborescence que lib/
```

## Build release

Placer la clé dans `keystore/upload-keystore.jks` et créer `keystore/keystore.properties`
(hors Git) :

```
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=../../keystore/upload-keystore.jks
```

```bash
fvm flutter build appbundle --release
```