import 'package:freezed_annotation/freezed_annotation.dart';

part 'watched_folder.freezed.dart';

/// A folder Sortify monitors for new files.
@freezed
abstract class WatchedFolder with _$WatchedFolder {
  const WatchedFolder._();

  const factory WatchedFolder({
    required String id,
    required String path,
    @Default(true) bool enabled,
    required DateTime createdAt,
  }) = _WatchedFolder;

  /// The folder's display name, e.g. `Downloads`.
  String get name {
    final normalized = path.replaceAll('\\', '/');
    final trimmed = normalized.endsWith('/')
        ? normalized.substring(0, normalized.length - 1)
        : normalized;
    final index = trimmed.lastIndexOf('/');
    return index == -1 ? trimmed : trimmed.substring(index + 1);
  }
}
