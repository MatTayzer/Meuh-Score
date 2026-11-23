// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'players_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Players)
final playersProvider = PlayersProvider._();

final class PlayersProvider
    extends $StreamNotifierProvider<Players, List<Player>> {
  PlayersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playersHash();

  @$internal
  @override
  Players create() => Players();
}

String _$playersHash() => r'8a89dc3770cc1e17f3a3a5717213bed59c1c480b';

abstract class _$Players extends $StreamNotifier<List<Player>> {
  Stream<List<Player>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Player>>, List<Player>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Player>>, List<Player>>,
              AsyncValue<List<Player>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
