import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_operation.freezed.dart';

/// Outcome of an operation.
enum OperationStatus {
  moved('moved'),
  skipped('skipped'),
  failed('failed');

  const OperationStatus(this.dbValue);

  final String dbValue;

  static OperationStatus fromDb(String value) =>
      OperationStatus.values.firstWhere(
        (e) => e.dbValue == value,
        orElse: () => OperationStatus.skipped,
      );
}

/// Type of operation, mirrors the rule action types.
enum OperationKind {
  move('move'),
  copy('copy'),
  rename('rename'),
  delete('delete');

  const OperationKind(this.dbValue);

  final String dbValue;

  static OperationKind fromDb(String value) => OperationKind.values.firstWhere(
    (e) => e.dbValue == value,
    orElse: () => OperationKind.move,
  );
}

/// An immutable record of a single file operation, used by the activity log
/// and, in the future, by the undo system.
@freezed
abstract class FileOperation with _$FileOperation {
  const FileOperation._();

  const factory FileOperation({
    required String id,
    String? ruleId,
    String? ruleName,
    required String fileName,
    required String source,
    String? destination,
    required OperationKind operation,
    required OperationStatus status,
    String? error,
    required DateTime createdAt,
  }) = _FileOperation;

  bool get succeeded => status == OperationStatus.moved;
}
