/// A single entry of a rule preview: a file that would be affected and where
/// it would go. Purely presentational data.
class RulePreviewEntry {
  const RulePreviewEntry({
    required this.sourcePath,
    required this.sourceFolder,
    required this.destination,
  });

  final String sourcePath;
  final String sourceFolder;
  final String destination;
}
