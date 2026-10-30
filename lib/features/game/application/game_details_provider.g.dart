// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(game)
final gameProvider = GameFamily._();

final class GameProvider
    extends $FunctionalProvider<AsyncValue<Game>, Game, Stream<Game>>
    with $FutureModifier<Game>, $StreamProvider<Game> {
  GameProvider._({required GameFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'gameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameHash();

  @override
  String toString() {
    return r'gameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Game> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Game> create(Ref ref) {
    final argument = this.argument as int;
    return game(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameHash() => r'7daec813f1f8e041aa5069c1d0d6295b8bdd3f39';

final class GameFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Game>, int> {
  GameFamily._()
    : super(
        retry: null,
        name: r'gameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GameProvider call(int gameId) => GameProvider._(argument: gameId, from: this);

  @override
  String toString() => r'gameProvider';
}

@ProviderFor(gamePlayers)
final gamePlayersProvider = GamePlayersFamily._();

final class GamePlayersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Player>>,
          List<Player>,
          Stream<List<Player>>
        >
    with $FutureModifier<List<Player>>, $StreamProvider<List<Player>> {
  GamePlayersProvider._({
    required GamePlayersFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'gamePlayersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gamePlayersHash();

  @override
  String toString() {
    return r'gamePlayersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Player>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Player>> create(Ref ref) {
    final argument = this.argument as int;
    return gamePlayers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GamePlayersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gamePlayersHash() => r'159827d962d98b9139e847cf4419e9dc71face2d';

final class GamePlayersFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Player>>, int> {
  GamePlayersFamily._()
    : super(
        retry: null,
        name: r'gamePlayersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GamePlayersProvider call(int gameId) =>
      GamePlayersProvider._(argument: gameId, from: this);

  @override
  String toString() => r'gamePlayersProvider';
}
