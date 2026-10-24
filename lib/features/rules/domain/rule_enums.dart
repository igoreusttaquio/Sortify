/// Attributes a file can be tested against.
enum ConditionType {
  extension('extension'),
  size('size'),
  name('name'),

  /// Age of the file based on its last modification time, in days.
  modified('modified');

  const ConditionType(this.dbValue);

  final String dbValue;

  static ConditionType fromDb(String value) => ConditionType.values.firstWhere(
    (e) => e.dbValue == value,
    orElse: () => ConditionType.extension,
  );
}

/// How a [ConditionType] is compared to its value.
enum ConditionOperator {
  isEqual('is'),
  isNot('isNot'),
  contains('contains'),
  doesNotContain('doesNotContain'),
  greaterThan('greaterThan'),
  lessThan('lessThan'),
  equalTo('equalTo'),
  startsWith('startsWith'),
  endsWith('endsWith'),
  olderThan('olderThan'),
  newerThan('newerThan');

  const ConditionOperator(this.dbValue);

  final String dbValue;

  static ConditionOperator fromDb(String value) =>
      ConditionOperator.values.firstWhere(
        (e) => e.dbValue == value,
        orElse: () => ConditionOperator.isEqual,
      );
}

/// The operation a rule performs on a matched file.
enum ActionType {
  move('move'),
  copy('copy'),
  rename('rename'),
  delete('delete');

  const ActionType(this.dbValue);

  final String dbValue;

  static ActionType fromDb(String value) => ActionType.values.firstWhere(
    (e) => e.dbValue == value,
    orElse: () => ActionType.move,
  );

  /// Whether the action sends the file to a destination folder.
  bool get isPathAction => this == ActionType.move || this == ActionType.copy;
}

/// What to do when a file already exists at the destination.
enum ConflictPolicy {
  askEveryTime('askEveryTime'),
  keepBoth('keepBoth'),
  replace('replace'),
  skip('skip');

  const ConflictPolicy(this.dbValue);

  final String dbValue;

  static ConflictPolicy fromDb(String value) =>
      ConflictPolicy.values.firstWhere(
        (e) => e.dbValue == value,
        orElse: () => ConflictPolicy.askEveryTime,
      );
}
