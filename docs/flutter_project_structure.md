# Structure de projet Flutter — guide de référence

> Guide réutilisable pour démarrer un projet Flutter propre.
> Stack de référence : **Riverpod** (état), **Drift** (base locale), **go_router** (navigation), **FVM** (version de Flutter).
> Les principes restent valables avec d'autres librairies : seul le contenu des dossiers change.

---

## 1. Les 4 principes

1. **Ranger par fonctionnalité, pas par type de fichier.**
   Tout ce qui concerne les joueurs est dans `features/players/`, pas éparpillé entre `screens/`, `models/` et `providers/`.
   → Pour modifier une fonctionnalité, on ouvre un seul dossier. Pour la supprimer, on supprime un seul dossier.

2. **Séparer en couches à l'intérieur de chaque feature.**
   L'écran ne parle pas à la base de données ; il passe par un provider, qui passe par un repository.

3. **Les dépendances vont dans un seul sens.**
   `presentation → application → data → domain`. Jamais l'inverse.

4. **Une seule source de vérité par sujet.**
   Les couleurs dans le thème, les espacements dans `AppSpacing`, les routes dans le router, les chemins d'assets dans `AppAssets`.

---

## 2. L'arborescence complète

```
mon_app/
├── .fvmrc                         # version de Flutter du projet (commité)
├── .vscode/settings.json          # pointe VS Code vers le SDK FVM
├── analysis_options.yaml          # règles de lint
├── pubspec.yaml
├── README.md
│
├── assets/
│   ├── images/
│   ├── icons/
│   ├── sounds/
│   └── fonts/
│
├── lib/
│   ├── main.dart                  # point d'entrée : runApp(), rien d'autre
│   │
│   ├── app/                       # configuration globale de l'application
│   │   ├── app.dart               # MaterialApp.router
│   │   ├── router/
│   │   │   ├── app_router.dart    # GoRouter + toutes les routes
│   │   │   └── app_routes.dart    # constantes des chemins ('/players'…)
│   │   └── theme/
│   │       ├── app_theme.dart     # ThemeData clair / sombre
│   │       ├── app_colors.dart    # couleurs de marque (si besoin hors seed)
│   │       ├── app_spacing.dart   # 4, 8, 16, 24, 32…
│   │       └── app_text_styles.dart
│   │
│   ├── core/                      # technique, partagé, sans logique métier
│   │   ├── constants/
│   │   │   └── app_assets.dart    # chemins des assets
│   │   ├── database/
│   │   │   ├── app_database.dart  # @DriftDatabase + migrations
│   │   │   ├── app_database.g.dart
│   │   │   ├── tables/            # une table par fichier quand ça grossit
│   │   │   │   ├── players_table.dart
│   │   │   │   └── games_table.dart
│   │   │   └── database_provider.dart
│   │   ├── errors/
│   │   │   └── app_exception.dart # erreurs métier typées
│   │   ├── extensions/
│   │   │   ├── context_extensions.dart   # context.colors, context.textTheme…
│   │   │   └── date_extensions.dart
│   │   └── utils/
│   │       └── validators.dart
│   │
│   ├── shared/                    # UI réutilisée par plusieurs features
│   │   └── widgets/
│   │       ├── app_button.dart
│   │       ├── async_value_view.dart     # gère loading / error / data
│   │       └── empty_state.dart
│   │
│   ├── features/
│   │   ├── home/
│   │   │   └── presentation/
│   │   │       └── pages/
│   │   │           └── home_page.dart
│   │   │
│   │   └── players/               # ← modèle de feature complète
│   │       ├── domain/            # QUOI : modèles et règles métier, Dart pur
│   │       │   ├── player.dart
│   │       │   └── player_rules.dart
│   │       ├── data/              # OÙ : accès aux données (BDD, API, fichiers)
│   │       │   └── players_repository.dart
│   │       ├── application/       # QUAND : état et actions (providers Riverpod)
│   │       │   └── players_provider.dart
│   │       └── presentation/      # COMMENT : ce que l'utilisateur voit
│   │           ├── pages/
│   │           │   ├── players_page.dart
│   │           │   └── new_player_page.dart
│   │           └── widgets/
│   │               └── player_tile.dart
│   │
│   └── l10n/                      # traductions (si l'app est multilingue)
│       ├── app_fr.arb
│       └── app_en.arb
│
└── test/                          # même arborescence que lib/
    ├── features/
    │   └── players/
    │       ├── domain/player_rules_test.dart
    │       ├── data/players_repository_test.dart
    │       └── presentation/players_page_test.dart
    └── helpers/
        └── test_database.dart     # base Drift en mémoire pour les tests
```

> **Règle d'or :** ne crée pas un dossier vide « au cas où ». Une feature simple peut n'avoir que `presentation/pages/`. On ajoute `domain/`, `data/`… le jour où on en a besoin.

---

## 3. Le rôle de chaque dossier

| Dossier | Contient | Ne contient jamais |
|---|---|---|
| `app/` | Ce qui configure l'application entière : router, thème, `MaterialApp` | Du code propre à une feature |
| `core/` | Technique partagée : base de données, extensions, constantes, erreurs | Des widgets, de la logique métier |
| `shared/` | Widgets utilisés par **au moins deux** features | Un widget utilisé par une seule feature (il va dans sa feature) |
| `features/x/domain/` | Modèles, enums, règles métier — **Dart pur** | `import 'package:flutter/...'`, Drift, Riverpod |
| `features/x/data/` | Repositories : lisent et écrivent les données | Des widgets, du `BuildContext` |
| `features/x/application/` | Providers / Notifiers : état de l'écran et actions | Des widgets, des requêtes SQL directes (idéalement) |
| `features/x/presentation/` | Pages et widgets | Des requêtes à la base, de la logique métier |

### Qui a le droit d'importer qui ?

```
presentation  ──►  application  ──►  data  ──►  domain
      │                                           ▲
      └───────────────────────────────────────────┘
               (une page peut lire un modèle)
```

- `domain` n'importe **rien** du projet (à part d'autres fichiers `domain`).
- Une feature peut importer le `domain` d'une autre feature (ex. `game` utilise `Player`).
- Une feature n'importe **jamais** la `presentation` d'une autre feature. Si deux features partagent un widget, il monte dans `shared/widgets/`.

---

## 4. Exemple complet d'une feature

### `domain/player.dart` — le modèle
```dart
class Player {
  const Player({required this.id, required this.name});

  final int id;
  final String name;
}
```

### `domain/player_rules.dart` — la règle métier, testable sans Flutter
```dart
abstract final class PlayerRules {
  static const maxNameLength = 60;

  static String? validateName(String raw) {
    final name = raw.trim();
    if (name.isEmpty) return 'Le nom est obligatoire';
    if (name.length > maxNameLength) return 'Nom trop long';
    return null; // null = valide
  }
}
```

### `data/players_repository.dart` — le seul endroit qui parle à la base
```dart
import 'package:drift/drift.dart';
import 'package:mon_app/core/database/app_database.dart';
import 'package:mon_app/core/database/database_provider.dart';
import 'package:mon_app/features/players/domain/player.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'players_repository.g.dart';

class PlayersRepository {
  PlayersRepository(this._db);

  final AppDatabase _db;

  Stream<List<Player>> watchAll() =>
      (_db.select(_db.players)..orderBy([(p) => OrderingTerm.asc(p.name)]))
          .watch();

  Future<bool> nameExists(String name, {int? exceptId}) async {
    final query = _db.select(_db.players)
      ..where((p) => p.name.lower().equals(name.toLowerCase()));
    if (exceptId != null) query.where((p) => p.id.equals(exceptId).not());
    return await query.getSingleOrNull() != null;
  }

  Future<void> insert(String name) =>
      _db.into(_db.players).insert(PlayersCompanion.insert(name: name));
}

@Riverpod(keepAlive: true)
PlayersRepository playersRepository(Ref ref) =>
    PlayersRepository(ref.watch(databaseProvider));
```

### `application/players_provider.dart` — l'état et les actions
```dart
import 'package:mon_app/features/players/data/players_repository.dart';
import 'package:mon_app/features/players/domain/player.dart';
import 'package:mon_app/features/players/domain/player_rules.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'players_provider.g.dart';

@riverpod
class Players extends _$Players {
  PlayersRepository get _repo => ref.read(playersRepositoryProvider);

  @override
  Stream<List<Player>> build() =>
      ref.watch(playersRepositoryProvider).watchAll();

  /// Renvoie un message d'erreur, ou null si tout s'est bien passé.
  Future<String?> add(String raw) async {
    final error = PlayerRules.validateName(raw);
    if (error != null) return error;

    final name = raw.trim();
    if (await _repo.nameExists(name)) return 'Ce nom existe déjà';

    await _repo.insert(name);
    return null;
  }
}
```

### `presentation/pages/new_player_page.dart` — l'écran
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mon_app/app/theme/app_spacing.dart';
import 'package:mon_app/features/players/application/players_provider.dart';

class NewPlayerPage extends ConsumerStatefulWidget {
  const NewPlayerPage({super.key});

  @override
  ConsumerState<NewPlayerPage> createState() => _NewPlayerPageState();
}

class _NewPlayerPageState extends ConsumerState<NewPlayerPage> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose(); // toujours libérer les controllers
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    final error =
        await ref.read(playersProvider.notifier).add(_controller.text);
    if (!mounted) return; // l'écran a pu être fermé pendant l'attente
    setState(() => _saving = false);

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau joueur')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            TextField(controller: _controller, autofocus: true),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: _saving ? null : _submit, // évite le double clic
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}
```

> **Petit projet ?** Tu peux sauter la couche `data/` et faire les requêtes Drift directement dans le provider. Ajoute un repository quand le provider devient long, quand plusieurs providers font les mêmes requêtes, ou quand tu veux tester sans vraie base.

---

## 5. Le socle `app/`

### `main.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mon_app/app/app.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}
```

### `app/app.dart`
```dart
import 'package:flutter/material.dart';
import 'package:mon_app/app/router/app_router.dart';
import 'package:mon_app/app/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mon App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
```

### `app/router/app_routes.dart` — les chemins à un seul endroit
```dart
abstract final class AppRoutes {
  static const home = '/';
  static const players = '/players';
  static const newPlayer = '/players/new';
  static String game(int id) => '/game/$id';
}
```
Dans les pages : `context.push(AppRoutes.newPlayer)` — jamais de chaîne écrite à la main, et **toujours des chemins absolus** (commençant par `/`).

### `app/router/app_router.dart`
```dart
import 'package:go_router/go_router.dart';
import 'package:mon_app/app/router/app_routes.dart';
import 'package:mon_app/features/home/presentation/pages/home_page.dart';
import 'package:mon_app/features/players/presentation/pages/new_player_page.dart';
import 'package:mon_app/features/players/presentation/pages/players_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.players,
      builder: (context, state) => const PlayersPage(),
      routes: [
        GoRoute(
          path: 'new', // sous-route → /players/new
          builder: (context, state) => const NewPlayerPage(),
        ),
      ],
    ),
  ],
);
```

### `go` ou `push` ?
| | Effet | Quand l'utiliser |
|---|---|---|
| `context.go(route)` | Remplace la pile par le chemin | Changer de section (accueil → partie lancée) |
| `context.push(route)` | Ajoute une page par-dessus | Ouvrir un détail ou un formulaire |
| `context.pop()` | Revient à la page précédente | Fermer ce qu'on a ouvert avec `push` |

---

## 6. Conventions de nommage

| Élément | Convention | Exemple |
|---|---|---|
| Fichiers et dossiers | `snake_case` | `new_player_page.dart` |
| Classes, enums | `PascalCase` | `NewPlayerPage`, `GameType` |
| Variables, fonctions | `camelCase` | `selectedIds`, `startGame()` |
| Privé au fichier | préfixe `_` | `_controller`, `_submit()` |
| Écran complet | suffixe `Page` | `PlayersPage` |
| Morceau d'écran | nom descriptif | `PlayerTile`, `ScoreTable` |
| Provider | ce qu'il fournit | `players`, `gameScore` → `playersProvider` |
| Repository | `XxxRepository` | `PlayersRepository` |
| Test | `<fichier>_test.dart` | `player_rules_test.dart` |

**Un fichier = une classe publique principale**, et le fichier porte son nom (`PlayersPage` → `players_page.dart`).

---

## 7. Imports

- **Toujours `package:`**, jamais de relatif (`../../../`). Ça reste lisible et ne casse pas quand on déplace un fichier.
- Ordre (géré par le lint `directives_ordering`) : `dart:` → `package:` externes → `package:mon_app/` → `part`.
- Pour forcer la règle, dans `analysis_options.yaml` :
  ```yaml
  linter:
    rules:
      - always_use_package_imports
  ```

---

## 8. Code généré

Drift, Riverpod, Freezed… génèrent des fichiers `*.g.dart` / `*.freezed.dart`.

- Ils sont **à côté** du fichier source (`part 'xxx.g.dart';`).
- On ne les modifie **jamais** à la main.
- Régénérer après chaque modification d'une table ou d'un `@riverpod` :
  ```bash
  fvm dart run build_runner build --delete-conflicting-outputs
  ```
- En mode « surveillance » pendant qu'on code :
  ```bash
  fvm dart run build_runner watch --delete-conflicting-outputs
  ```
- Les commiter ou non : les deux se font. Les commiter évite de devoir lancer `build_runner` après chaque `git clone`.

---

## 9. Tests

`test/` reproduit exactement l'arborescence de `lib/`. Par ordre de priorité :

1. **`domain/`** — logique pure, rapide, aucun mock. C'est là que les bugs coûtent le plus cher.
   ```dart
   import 'package:flutter_test/flutter_test.dart';
   import 'package:mon_app/features/players/domain/player_rules.dart';

   void main() {
     group('PlayerRules.validateName', () {
       test('refuse un nom vide', () {
         expect(PlayerRules.validateName('   '), isNotNull);
       });
       test('accepte un nom normal', () {
         expect(PlayerRules.validateName('Paul'), isNull);
       });
     });
   }
   ```
2. **`data/`** — avec une base Drift en mémoire (`NativeDatabase.memory()`).
3. **`presentation/`** — tests de widgets sur les écrans importants, en remplaçant les providers avec `ProviderScope(overrides: [...])`.

Lancer : `fvm flutter test`

---

## 10. Configuration du projet

### `.fvmrc`
```json
{ "flutter": "3.x.y" }
```

### `.vscode/settings.json`
```json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk",
  "editor.formatOnSave": true,
  "search.exclude": { "**/.fvm": true },
  "files.watcherExclude": { "**/.fvm": true }
}
```

### `analysis_options.yaml`
```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - build/**
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  errors:
    avoid_print: error

linter:
  rules:
    - always_declare_return_types
    - always_use_package_imports
    - avoid_redundant_argument_values
    - cancel_subscriptions
    - directives_ordering
    - discarded_futures
    - prefer_const_constructors
    - prefer_final_locals
    - prefer_single_quotes
    - unawaited_futures
    - use_build_context_synchronously
    - use_super_parameters
```
> `require_trailing_commas` est volontairement absent : depuis Dart 3.7, le formateur gère lui-même les virgules finales et les deux se contredisent.

### `.gitignore` (à ajouter au fichier généré par Flutter)
```gitignore
# FVM : seul .fvmrc est commité
.fvm/
```

### `pubspec.yaml` — assets
```yaml
flutter:
  uses-material-design: true
  assets:            # un dossier n'inclut pas ses sous-dossiers
    - assets/images/
    - assets/icons/
    - assets/sounds/
```

---

## 11. Checklist « nouveau projet »

```bash
fvm use 3.x.y --force
fvm flutter create --org com.tonnom --platforms android,ios mon_app
cd mon_app
fvm flutter pub add flutter_riverpod riverpod_annotation go_router drift drift_flutter
fvm flutter pub add dev:build_runner dev:riverpod_generator dev:drift_dev
git init
```

- [ ] `.fvmrc` + `.vscode/settings.json` + `.fvm/` dans `.gitignore`
- [ ] `analysis_options.yaml` (section 10)
- [ ] Supprimer le compteur de démo et `test/widget_test.dart`
- [ ] Créer `app/app.dart`, `app/router/`, `app/theme/` et alléger `main.dart`
- [ ] Créer `core/` seulement pour ce dont tu as besoin tout de suite
- [ ] Première feature : `features/home/presentation/pages/home_page.dart`
- [ ] `fvm flutter analyze` → *No issues found*
- [ ] Premier commit

## 12. Checklist « nouvelle feature »

1. Créer `features/<nom>/`.
2. **domain** : le modèle et les règles (+ leur test).
3. **data** : la table Drift dans `core/database/tables/`, puis le repository.
4. **application** : le provider.
5. **presentation** : la page, puis ses widgets.
6. Ajouter la route dans `app_routes.dart` et `app_router.dart`.
7. `build_runner build` → `flutter analyze` → `flutter test` → commit.

---

## 13. Les erreurs classiques à éviter

| ❌ À éviter | ✅ À faire |
|---|---|
| `MaterialApp(home: ...)` avec go_router | `MaterialApp.router(routerConfig: ...)` |
| `context.go('players')` (relatif) | `context.go(AppRoutes.players)` (absolu) |
| `TextEditingController` sans `dispose()` | Toujours `dispose()` dans `State.dispose` |
| `await ...; context.go(...)` | `await ...; if (!mounted) return; context.go(...)` |
| `else {}` silencieux en cas d'échec | Un `SnackBar` ou un message d'erreur |
| Bouton actif pendant une sauvegarde | Booléen `_saving` qui désactive le bouton |
| `Colors.red`, `EdgeInsets.all(13)` dans un widget | `Theme.of(context).colorScheme`, `AppSpacing` |
| `SizedBox(height: 400)` autour d'une liste | `Expanded` |
| Requête SQL dans un widget | Repository → provider → widget |
| `catch (_) {}` qui avale tout | Attraper l'exception précise, ou vérifier avant |
| `ConsumerStatefulWidget` sans état ni `ref` | `StatelessWidget` |
| Imports `../../../` | Imports `package:` |
