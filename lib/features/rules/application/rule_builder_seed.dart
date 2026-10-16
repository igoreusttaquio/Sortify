import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/filesystem/file_utils.dart';

/// Optional pre-filled values for the rule builder, e.g. when the user chooses
/// "Create rule from file" on an unmatched file.
class RuleBuilderSeed {
  const RuleBuilderSeed({
    this.extension,
    this.nameContains,
    this.sourceFileName,
  });

  final String? extension;
  final String? nameContains;
  final String? sourceFileName;
}

class RuleBuilderSeedController extends Notifier<RuleBuilderSeed?> {
  @override
  RuleBuilderSeed? build() => null;

  void seedFromFile(String path) {
    state = RuleBuilderSeed(
      extension: FileUtils.extensionLabel(path),
      sourceFileName: FileUtils.fileNameOf(path),
    );
  }

  /// Seeds a rule from a bare extension (e.g. when creating a global rule for
  /// every file of a given type).
  void seedFromExtension(String extension) {
    final normalized = extension.startsWith('.')
        ? extension.substring(1)
        : extension;
    state = RuleBuilderSeed(extension: normalized.toLowerCase());
  }

  /// Returns the seed once and clears it so it is not reused.
  RuleBuilderSeed? consume() {
    final seed = state;
    state = null;
    return seed;
  }
}

final ruleBuilderSeedProvider =
    NotifierProvider<RuleBuilderSeedController, RuleBuilderSeed?>(
      RuleBuilderSeedController.new,
    );
