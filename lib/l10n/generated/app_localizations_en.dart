// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Sortify';

  @override
  String get appTagline => 'Automatic file organization';

  @override
  String get navWorkspace => 'WORKSPACE';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navRules => 'Rules';

  @override
  String get navActivity => 'Activity';

  @override
  String get navLocations => 'LOCATIONS';

  @override
  String get navFolders => 'Folders';

  @override
  String get navSettings => 'Settings';

  @override
  String get collapseMenu => 'Collapse menu';

  @override
  String get expandMenu => 'Expand menu';

  @override
  String get search => 'Search';

  @override
  String get help => 'Help';

  @override
  String get settings => 'Settings';

  @override
  String get statusMonitoring => 'Monitoring';

  @override
  String get statusPaused => 'Paused';

  @override
  String statusMonitoringSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count folders are being watched',
      one: '1 folder is being watched',
      zero: 'No folders are being watched',
    );
    return '$_temp0';
  }

  @override
  String activeRulesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active rules',
      one: '1 active rule',
      zero: 'No active rules',
    );
    return '$_temp0';
  }

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardSubtitle => 'Everything Sortify is doing, at a glance';

  @override
  String get statFilesToday => 'Files organized today';

  @override
  String get statActiveRules => 'Active rules';

  @override
  String get statFoldersMonitored => 'Folders monitored';

  @override
  String get statFilesPending => 'Files pending';

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get viewAll => 'View all';

  @override
  String get rulesTitle => 'Rules';

  @override
  String get rulesSubtitle => 'Decide what happens to every file';

  @override
  String get newRule => 'New rule';

  @override
  String get editRule => 'Edit rule';

  @override
  String get duplicateRule => 'Duplicate rule';

  @override
  String get deleteRule => 'Delete rule';

  @override
  String get runRuleNow => 'Run now';

  @override
  String get viewRuleActivity => 'View activity';

  @override
  String get enableRule => 'Enable';

  @override
  String get disableRule => 'Disable';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String ruleProcessed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files processed',
      one: '1 file processed',
      zero: 'Never used',
    );
    return '$_temp0';
  }

  @override
  String ruleLastRun(String when) {
    return 'Last run $when';
  }

  @override
  String get ruleNeverRun => 'Never run';

  @override
  String get ruleDeleted => 'Rule deleted';

  @override
  String get ruleSaved => 'Rule saved';

  @override
  String get undo => 'Undo';

  @override
  String get noRulesTitle => 'No rules yet';

  @override
  String get noRulesBody =>
      'Rules tell Sortify where to move your files. Create your first one to get started.';

  @override
  String get noRulesAction => 'Create your first rule';

  @override
  String get ruleName => 'Rule name';

  @override
  String get ruleNameHint => 'Organize PDFs';

  @override
  String get ruleScope => 'Applies to';

  @override
  String get allFolders => 'All folders';

  @override
  String get ruleDescription => 'Description (optional)';

  @override
  String get ruleDescriptionHint =>
      'Move all PDF documents to a dedicated folder';

  @override
  String get whenLabel => 'WHEN';

  @override
  String get andLabel => 'AND';

  @override
  String get thenLabel => 'THEN';

  @override
  String get addCondition => 'Add condition';

  @override
  String get conditionExtension => 'File extension';

  @override
  String get conditionSize => 'File size';

  @override
  String get conditionName => 'File name';

  @override
  String get operatorIs => 'is';

  @override
  String get operatorIsNot => 'is not';

  @override
  String get operatorContains => 'contains';

  @override
  String get operatorDoesNotContain => 'does not contain';

  @override
  String get operatorGreaterThan => 'greater than';

  @override
  String get operatorLessThan => 'less than';

  @override
  String get operatorEqualTo => 'equal to';

  @override
  String get actionMove => 'Move to';

  @override
  String get actionCopy => 'Copy to';

  @override
  String get actionRename => 'Rename';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionComingSoon => 'Coming soon';

  @override
  String get destinationFolder => 'Destination folder';

  @override
  String get newFileName => 'New name';

  @override
  String get chooseFolder => 'Choose folder';

  @override
  String get previewTitle => 'Preview';

  @override
  String previewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files match this rule',
      one: '1 file matches this rule',
      zero: 'No files match this rule',
    );
    return '$_temp0';
  }

  @override
  String get previewScanning => 'Scanning folders for matches...';

  @override
  String get previewNoMatchesHint =>
      'Try broadening the conditions so more files can match.';

  @override
  String get applyRule => 'Apply rule';

  @override
  String get saveRule => 'Save rule';

  @override
  String get backToRules => 'Back to rules';

  @override
  String get activityTitle => 'Activity';

  @override
  String get activitySubtitle => 'A complete history of what Sortify did';

  @override
  String get filterAll => 'All';

  @override
  String get filterMoved => 'Moved';

  @override
  String get filterSkipped => 'Skipped';

  @override
  String get filterFailed => 'Failed';

  @override
  String get statusMoved => 'Moved';

  @override
  String get statusSkipped => 'Skipped';

  @override
  String get statusFailed => 'Failed';

  @override
  String get noActivityTitle => 'Nothing here yet';

  @override
  String get noActivityBody =>
      'Operations will appear here as soon as Sortify starts organizing your files.';

  @override
  String get noActivityFilteredTitle => 'No matching operations';

  @override
  String get noActivityFilteredBody =>
      'No activity matches the selected filter.';

  @override
  String get noMatchingRule => 'No matching rule';

  @override
  String get operationDetails => 'Operation details';

  @override
  String get detailTimestamp => 'Timestamp';

  @override
  String get detailSource => 'Source';

  @override
  String get detailDestination => 'Destination';

  @override
  String get detailRule => 'Rule';

  @override
  String get detailOperation => 'Operation';

  @override
  String get detailStatus => 'Status';

  @override
  String get detailError => 'Error';

  @override
  String get technicalDetails => 'Technical details';

  @override
  String get detailOperationId => 'Operation ID';

  @override
  String get detailRuleId => 'Rule ID';

  @override
  String get clearHistory => 'Clear history';

  @override
  String get clearHistoryConfirm =>
      'Clear all activity history? This cannot be undone.';

  @override
  String get foldersTitle => 'Watched folders';

  @override
  String get foldersSubtitle => 'Folders Sortify keeps an eye on';

  @override
  String get addFolder => 'Add folder';

  @override
  String get folderMonitoring => 'Monitoring';

  @override
  String get folderPaused => 'Paused';

  @override
  String get openFolder => 'Open folder';

  @override
  String get revealInExplorer => 'Reveal in file manager';

  @override
  String get removeFolder => 'Remove folder';

  @override
  String get removeFolderConfirmTitle => 'Remove watched folder?';

  @override
  String removeFolderConfirmBody(String path) {
    return 'Sortify will stop monitoring $path. Files already organized are not affected.';
  }

  @override
  String get addFolderPreviewTitle => 'Start watching this folder?';

  @override
  String addFolderPreviewBody(String path) {
    return 'Sortify will watch $path and apply your enabled rules to new files.';
  }

  @override
  String get folderPickerTitle => 'Choose a folder to watch';

  @override
  String get folderAlreadyWatched => 'This folder is already being watched';

  @override
  String get folderAdded => 'Folder added';

  @override
  String get folderRemoved => 'Folder removed';

  @override
  String get noFoldersTitle => 'No folders are being watched';

  @override
  String get noFoldersBody =>
      'Add a folder to start automatically organizing your files.';

  @override
  String get noFoldersAction => 'Add a folder';

  @override
  String get fileExistsTitle => 'File already exists';

  @override
  String fileExistsBody(String fileName) {
    return '$fileName already exists in the destination folder.';
  }

  @override
  String get keepBoth => 'Keep both';

  @override
  String get replace => 'Replace';

  @override
  String get skip => 'Skip';

  @override
  String get unmatchedTitle => 'Unmatched files';

  @override
  String get unmatchedSubtitle => 'Files that don\'t match any rule';

  @override
  String unmatchedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files don\'t match any rule',
      one: '1 file doesn\'t match any rule',
      zero: 'No unmatched files',
    );
    return '$_temp0';
  }

  @override
  String get createRuleFromFile => 'Create rule from file';

  @override
  String get deleteFile => 'Delete file';

  @override
  String get deleteFileConfirmTitle => 'Delete this file?';

  @override
  String deleteFileConfirmPermanent(String fileName) {
    return '$fileName will be permanently deleted. This cannot be undone.';
  }

  @override
  String deleteFileConfirmTrash(String fileName) {
    return '$fileName will be moved to the trash.';
  }

  @override
  String get fileDeleted => 'File deleted';

  @override
  String get deleteToTrash => 'Move deleted files to trash';

  @override
  String get deleteToTrashDesc =>
      'When off, deleting a file removes it permanently';

  @override
  String get filterByType => 'Filter by type';

  @override
  String get allTypes => 'All types';

  @override
  String get tableFile => 'File';

  @override
  String get tableType => 'Type';

  @override
  String get tableFolder => 'Folder';

  @override
  String createRuleForType(String type) {
    return 'Create rule for $type';
  }

  @override
  String ignoreType(String type) {
    return 'Ignore $type';
  }

  @override
  String get paginationPrev => 'Previous';

  @override
  String get paginationNext => 'Next';

  @override
  String paginationSummary(int start, int end, int total) {
    return '$start–$end of $total';
  }

  @override
  String trayMonitoring(int count) {
    return 'Monitoring $count folders';
  }

  @override
  String get trayOpen => 'Open Sortify';

  @override
  String get trayPause => 'Pause monitoring';

  @override
  String get trayResume => 'Resume monitoring';

  @override
  String get trayRunAll => 'Run all rules';

  @override
  String get traySettings => 'Settings';

  @override
  String get trayQuit => 'Quit';

  @override
  String get trayTooltip => 'Sortify - file organizer';

  @override
  String notificationsMoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Moved $count files',
      one: 'Moved 1 file',
    );
    return '$_temp0';
  }

  @override
  String get paletteSearchHint => 'Search commands, rules and files...';

  @override
  String get paletteCommands => 'Commands';

  @override
  String get paletteRules => 'Rules';

  @override
  String get paletteFiles => 'Unmatched files';

  @override
  String get paletteNoResults => 'No results found';

  @override
  String get paletteCreateRule => 'Create new rule';

  @override
  String get paletteAddFolder => 'Add folder';

  @override
  String get paletteRunAll => 'Run all rules';

  @override
  String get palettePause => 'Pause monitoring';

  @override
  String get paletteResume => 'Resume monitoring';

  @override
  String get paletteOpenSettings => 'Open settings';

  @override
  String get paletteGoDashboard => 'Go to dashboard';

  @override
  String get paletteGoActivity => 'Go to activity';

  @override
  String get paletteGoRules => 'Go to rules';

  @override
  String get paletteGoFolders => 'Go to folders';

  @override
  String get paletteRunRule => 'Run rule';

  @override
  String get paletteToggleTheme => 'Toggle theme';

  @override
  String get paletteClose => 'Close';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Tune how Sortify behaves';

  @override
  String get sectionGeneral => 'General';

  @override
  String get sectionMonitoring => 'Monitoring';

  @override
  String get sectionConflicts => 'Conflicts';

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get startWithSystem => 'Start with system';

  @override
  String get startWithSystemDesc => 'Launch Sortify when you sign in';

  @override
  String get startMinimized => 'Start minimized';

  @override
  String get startMinimizedDesc => 'Open in the system tray without a window';

  @override
  String get confirmFileOperations => 'Confirm file operations';

  @override
  String get confirmFileOperationsDesc => 'Ask before moving or deleting files';

  @override
  String get scanInterval => 'Scan interval';

  @override
  String get scanIntervalDesc => 'How often watched folders are re-scanned';

  @override
  String secondsShort(int count) {
    return '${count}s';
  }

  @override
  String get watchSubfolders => 'Watch subfolders';

  @override
  String get watchSubfoldersDesc => 'Include nested folders in monitoring';

  @override
  String get ignoreHidden => 'Ignore hidden files';

  @override
  String get ignoreHiddenDesc => 'Skip dotfiles and hidden system files';

  @override
  String get ignoredExtensions => 'Ignored extensions';

  @override
  String get ignoredExtensionsDesc =>
      'Files with these extensions are never tracked or organized';

  @override
  String get extensionHint => 'tmp, log';

  @override
  String get addExtension => 'Add';

  @override
  String get conflictAskEveryTime => 'Ask every time';

  @override
  String get conflictAskEveryTimeDesc =>
      'Show a dialog when a destination file exists';

  @override
  String get conflictKeepBoth => 'Keep both';

  @override
  String get conflictKeepBothDesc =>
      'Rename the incoming file to avoid overwriting';

  @override
  String get conflictReplace => 'Replace';

  @override
  String get conflictReplaceDesc => 'Overwrite the existing file';

  @override
  String get conflictSkip => 'Skip';

  @override
  String get conflictSkipDesc => 'Leave the file where it is';

  @override
  String get appearanceDark => 'Dark';

  @override
  String get appearanceLight => 'Light';

  @override
  String get appearanceSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageSpanish => 'Español';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonRun => 'Run';

  @override
  String get commonPause => 'Pause';

  @override
  String get commonResume => 'Resume';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonSuccess => 'Success';

  @override
  String get commonWarning => 'Warning';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonComingSoon => 'Coming soon';

  @override
  String commonFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files',
      one: '1 file',
    );
    return '$_temp0';
  }

  @override
  String get shortcutCommandPalette => 'Command palette';

  @override
  String get shortcutSearch => 'Search';

  @override
  String get helpTitle => 'Quick guide';

  @override
  String get helpBody =>
      'Add a folder, create a rule, and Sortify will organize new files automatically.';

  @override
  String get filesUnit => 'MB';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';
}
