// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'games_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Games)
final gamesProvider = GamesProvider._();

final class GamesProvider extends $StreamNotifierProvider<Games, List<Game>> {
  GamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gamesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gamesHash();

  @$internal
  @override
  Games create() => Games();
}

String _$gamesHash() => r'ff15fcadb1ce7cfce30c3f5b88e35814b3d69e7b';

abstract class _$Games extends $StreamNotifier<List<Game>> {
  Stream<List<Game>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Game>>, List<Game>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Game>>, List<Game>>,
              AsyncValue<List<Game>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// La partie la plus récente, si aucune : null

@ProviderFor(lastGame)
final lastGameProvider = LastGameProvider._();

/// La partie la plus récente, si aucune : null

final class LastGameProvider
    extends $FunctionalProvider<AsyncValue<Game?>, Game?, Stream<Game?>>
    with $FutureModifier<Game?>, $StreamProvider<Game?> {
  /// La partie la plus récente, si aucune : null
  LastGameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastGameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastGameHash();

  @$internal
  @override
  $StreamProviderElement<Game?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Game?> create(Ref ref) {
    return lastGame(ref);
  }
}

String _$lastGameHash() => r'629114ade6423985cfef20f418c634de1c22ffc7';
