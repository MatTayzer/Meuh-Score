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

String _$playersHash() => r'615fed359bd6a742861016d34cdf2f9063bf257e';

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
