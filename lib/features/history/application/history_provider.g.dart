// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Parties terminées, la plus récente en premier.

@ProviderFor(gameHistory)
final gameHistoryProvider = GameHistoryProvider._();

/// Parties terminées, la plus récente en premier.

final class GameHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GameSummary>>,
          List<GameSummary>,
          Stream<List<GameSummary>>
        >
    with
        $FutureModifier<List<GameSummary>>,
        $StreamProvider<List<GameSummary>> {
  /// Parties terminées, la plus récente en premier.
  GameHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameHistoryHash();

  @$internal
  @override
  $StreamProviderElement<List<GameSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<GameSummary>> create(Ref ref) {
    return gameHistory(ref);
  }
}

String _$gameHistoryHash() => r'76b432f5e23df0ef350248dd371574c94512f983';
