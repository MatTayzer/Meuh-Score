import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meuh_score/features/game/domain/rules/six_qui_prend_rules.dart';
import 'package:meuh_score/features/game/domain/rules/skyjo_rules.dart';
import 'package:meuh_score/features/game/presentation/widgets/result_display.dart';
import 'package:meuh_score/features/players/domain/player.dart';

void main() {
  const alice = Player(id: 1, name: 'Alice');
  const bob = Player(id: 2, name: 'Bob');
  const salome = Player(id: 3, name: 'Salomé');
  const philippe = Player(id: 4, name: 'Philippe');
  const rules = SkyjoRules();

  test('le plus petit total gagne, le plus grand perd', () {
    final result = GameResult.from(
      [alice, bob, philippe],
      {1: 40, 2: 105, 4: 70},
      rules,
    );

    expect(result.winnerMessage, 'Alice a gagné !');
    expect(result.loserMessage, 'Bob a perdu !');
    expect(result.isDraw, isFalse);
  });

  test('utilise les surnoms pour le gagnant comme pour le perdant', () {
    final win = GameResult.from([philippe, bob], {4: 10, 2: 100}, rules);
    final lose = GameResult.from([philippe, bob], {4: 100, 2: 10}, rules);

    expect(win.winnerMessage, 'Le roi de la patience a gagné !');
    expect(lose.loserMessage, 'Le roi de la patience a perdu !');
  });

  test('Salomé et Mémé gardent leur nom quand elles perdent', () {
    const meme = Player(id: 5, name: 'Mémé');
    final salomeLoses = GameResult.from([salome, bob], {3: 100, 2: 10}, rules);
    final memeLoses = GameResult.from([meme, bob], {5: 100, 2: 10}, rules);

    expect(salomeLoses.loserMessage, 'Salomé a perdu !');
    expect(memeLoses.loserMessage, 'Mémé a perdu !');
  });

  test('un joueur sans score compte pour 0 point', () {
    final result = GameResult.from([alice, bob], {2: 100}, rules);

    expect(result.winnerMessage, 'Alice a gagné !');
  });

  test('le 6 qui prend et le Skyjo mettent le perdant en avant', () {
    expect(const SixQuiPrendRules().highlightLoser, isTrue);
    expect(rules.highlightLoser, isTrue);
  });

  testWidgets('le message mis en avant passe en premier et en grand', (
    tester,
  ) async {
    final result = GameResult.from([alice, bob], {1: 10, 2: 100}, rules);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResultDisplay(result: result, highlightLoser: true),
        ),
      ),
    );

    final theme = Theme.of(tester.element(find.byType(ResultDisplay)));
    final loser = tester.widget<Text>(find.text('Bob a perdu !'));
    final winner = tester.widget<Text>(find.text('Alice a gagné !'));
    expect(loser.style, theme.textTheme.headlineSmall);
    expect(winner.style, theme.textTheme.titleMedium);
    expect(
      tester.getTopLeft(find.text('Bob a perdu !')).dy,
      lessThan(tester.getTopLeft(find.text('Alice a gagné !')).dy),
    );
  });

  test('gère les égalités', () {
    final tied = GameResult.from(
      [alice, bob, philippe],
      {1: 10, 2: 10, 4: 100},
      rules,
    );
    final draw = GameResult.from([alice, bob], {1: 100, 2: 100}, rules);

    expect(tied.winnerMessage, 'Alice et Bob ont gagné !');
    expect(draw.isDraw, isTrue);
  });
}
