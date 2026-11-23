import 'package:go_router/go_router.dart';
import 'package:meuh_score/app/router/page_transitions.dart';
import 'package:meuh_score/features/game/domain/game_type.dart';
import 'package:meuh_score/features/game/presentation/pages/game_page.dart';
import 'package:meuh_score/features/game/presentation/pages/game_players_page.dart';
import 'package:meuh_score/features/game/presentation/pages/new_game_page.dart';
import 'package:meuh_score/features/history/presentation/pages/history_page.dart';
import 'package:meuh_score/features/home/presentation/pages/home_page.dart';
import 'package:meuh_score/features/players/presentation/pages/new_player_page.dart';
import 'package:meuh_score/features/players/presentation/pages/players_page.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'players',
          pageBuilder: (context, state) =>
              slideFadePage(state, const PlayersPage()),
          routes: [
            GoRoute(
              path: 'new',
              pageBuilder: (context, state) =>
                  slideFadePage(state, const NewPlayerPage()),
            ),
          ],
        ),
        GoRoute(
          path: 'newGame',
          pageBuilder: (context, state) =>
              slideFadePage(state, const NewGamePage()),
          routes: [
            GoRoute(
              path: ':type',
              pageBuilder: (context, state) {
                final type = GameType.values.byName(
                  state.pathParameters['type']!,
                );
                return slideFadePage(state, GamePlayersPage(type: type));
              },
            ),
          ],
        ),
        GoRoute(
          path: 'game/:gameId',
          pageBuilder: (context, state) {
            final gameId = int.parse(state.pathParameters['gameId']!);
            return slideFadePage(state, GamePage(gameId: gameId));
          },
        ),
        GoRoute(
          path: 'history',
          pageBuilder: (context, state) =>
              slideFadePage(state, const HistoryPage()),
        ),
      ],
    ),
  ],
);
