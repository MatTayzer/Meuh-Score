// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_score_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GameScore)
final gameScoreProvider = GameScoreFamily._();

final class GameScoreProvider
    extends $StreamNotifierProvider<GameScore, List<Score>> {
  GameScoreProvider._({
    required GameScoreFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'gameScoreProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameScoreHash();

  @override
  String toString() {
    return r'gameScoreProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GameScore create() => GameScore();

  @override
  bool operator ==(Object other) {
    return other is GameScoreProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameScoreHash() => r'3a01137e6ce30f8761ee680ef97e3b1548199cac';

final class GameScoreFamily extends $Family
    with
        $ClassFamilyOverride<
          GameScore,
          AsyncValue<List<Score>>,
          List<Score>,
          Stream<List<Score>>,
          int
        > {
  GameScoreFamily._()
    : super(
        retry: null,
        name: r'gameScoreProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GameScoreProvider call(int gameId) =>
      GameScoreProvider._(argument: gameId, from: this);

  @override
  String toString() => r'gameScoreProvider';
}

abstract class _$GameScore extends $StreamNotifier<List<Score>> {
  late final _$args = ref.$arg as int;
  int get gameId => _$args;

  Stream<List<Score>> build(int gameId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Score>>, List<Score>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Score>>, List<Score>>,
              AsyncValue<List<Score>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
