import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Sortify'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Automatic file organization'**
  String get appTagline;

  /// No description provided for @navWorkspace.
  ///
  /// In en, this message translates to:
  /// **'WORKSPACE'**
  String get navWorkspace;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navRules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get navRules;

  /// No description provided for @navActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// No description provided for @navLocations.
  ///
  /// In en, this message translates to:
  /// **'LOCATIONS'**
  String get navLocations;

  /// No description provided for @navFolders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get navFolders;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @collapseMenu.
  ///
  /// In en, this message translates to:
  /// **'Collapse menu'**
  String get collapseMenu;

  /// No description provided for @expandMenu.
  ///
  /// In en, this message translates to:
  /// **'Expand menu'**
  String get expandMenu;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @statusMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get statusMonitoring;

  /// No description provided for @statusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get statusPaused;

  /// No description provided for @statusMonitoringSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No folders are being watched} =1{1 folder is being watched} other{{count} folders are being watched}}'**
  String statusMonitoringSubtitle(int count);

  /// No description provided for @activeRulesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No active rules} =1{1 active rule} other{{count} active rules}}'**
  String activeRulesCount(int count);

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything Sortify is doing, at a glance'**
  String get dashboardSubtitle;

  /// No description provided for @statFilesToday.
  ///
  /// In en, this message translates to:
  /// **'Files organized today'**
  String get statFilesToday;

  /// No description provided for @statActiveRules.
  ///
  /// In en, this message translates to:
  /// **'Active rules'**
  String get statActiveRules;

  /// No description provided for @statFoldersMonitored.
  ///
  /// In en, this message translates to:
  /// **'Folders monitored'**
  String get statFoldersMonitored;

  /// No description provided for @statFilesPending.
  ///
  /// In en, this message translates to:
  /// **'Files pending'**
  String get statFilesPending;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @rulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rulesTitle;

  /// No description provided for @rulesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Decide what happens to every file'**
  String get rulesSubtitle;

  /// No description provided for @newRule.
  ///
  /// In en, this message translates to:
  /// **'New rule'**
  String get newRule;

  /// No description provided for @editRule.
  ///
  /// In en, this message translates to:
  /// **'Edit rule'**
  String get editRule;

  /// No description provided for @duplicateRule.
  ///
  /// In en, this message translates to:
  /// **'Duplicate rule'**
  String get duplicateRule;

  /// No description provided for @deleteRule.
  ///
  /// In en, this message translates to:
  /// **'Delete rule'**
  String get deleteRule;

  /// No description provided for @runRuleNow.
  ///
  /// In en, this message translates to:
  /// **'Run now'**
  String get runRuleNow;

  /// No description provided for @viewRuleActivity.
  ///
  /// In en, this message translates to:
  /// **'View activity'**
  String get viewRuleActivity;

  /// No description provided for @enableRule.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enableRule;

  /// No description provided for @disableRule.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disableRule;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @ruleProcessed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Never used} =1{1 file processed} other{{count} files processed}}'**
  String ruleProcessed(int count);

  /// No description provided for @ruleLastRun.
  ///
  /// In en, this message translates to:
  /// **'Last run {when}'**
  String ruleLastRun(String when);

  /// No description provided for @ruleNeverRun.
  ///
  /// In en, this message translates to:
  /// **'Never run'**
  String get ruleNeverRun;

  /// No description provided for @ruleDeleted.
  ///
  /// In en, this message translates to:
  /// **'Rule deleted'**
  String get ruleDeleted;

  /// No description provided for @ruleSaved.
  ///
  /// In en, this message translates to:
  /// **'Rule saved'**
  String get ruleSaved;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @noRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'No rules yet'**
  String get noRulesTitle;

  /// No description provided for @noRulesBody.
  ///
  /// In en, this message translates to:
  /// **'Rules tell Sortify where to move your files. Create your first one to get started.'**
  String get noRulesBody;

  /// No description provided for @noRulesAction.
  ///
  /// In en, this message translates to:
  /// **'Create your first rule'**
  String get noRulesAction;

  /// No description provided for @ruleName.
  ///
  /// In en, this message translates to:
  /// **'Rule name'**
  String get ruleName;

  /// No description provided for @ruleNameHint.
  ///
  /// In en, this message translates to:
  /// **'Organize PDFs'**
  String get ruleNameHint;

  /// No description provided for @ruleScope.
  ///
  /// In en, this message translates to:
  /// **'Applies to'**
  String get ruleScope;

  /// No description provided for @allFolders.
  ///
  /// In en, this message translates to:
  /// **'All folders'**
  String get allFolders;

  /// No description provided for @ruleDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get ruleDescription;

  /// No description provided for @ruleDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Move all PDF documents to a dedicated folder'**
  String get ruleDescriptionHint;

  /// No description provided for @whenLabel.
  ///
  /// In en, this message translates to:
  /// **'WHEN'**
  String get whenLabel;

  /// No description provided for @andLabel.
  ///
  /// In en, this message translates to:
  /// **'AND'**
  String get andLabel;

  /// No description provided for @thenLabel.
  ///
  /// In en, this message translates to:
  /// **'THEN'**
  String get thenLabel;

  /// No description provided for @addCondition.
  ///
  /// In en, this message translates to:
  /// **'Add condition'**
  String get addCondition;

  /// No description provided for @conditionExtension.
  ///
  /// In en, this message translates to:
  /// **'File extension'**
  String get conditionExtension;

  /// No description provided for @conditionSize.
  ///
  /// In en, this message translates to:
  /// **'File size'**
  String get conditionSize;

  /// No description provided for @conditionName.
  ///
  /// In en, this message translates to:
  /// **'File name'**
  String get conditionName;

  /// No description provided for @operatorIs.
  ///
  /// In en, this message translates to:
  /// **'is'**
  String get operatorIs;

  /// No description provided for @operatorIsNot.
  ///
  /// In en, this message translates to:
  /// **'is not'**
  String get operatorIsNot;

  /// No description provided for @operatorContains.
  ///
  /// In en, this message translates to:
  /// **'contains'**
  String get operatorContains;

  /// No description provided for @operatorDoesNotContain.
  ///
  /// In en, this message translates to:
  /// **'does not contain'**
  String get operatorDoesNotContain;

  /// No description provided for @operatorGreaterThan.
  ///
  /// In en, this message translates to:
  /// **'greater than'**
  String get operatorGreaterThan;

  /// No description provided for @operatorLessThan.
  ///
  /// In en, this message translates to:
  /// **'less than'**
  String get operatorLessThan;

  /// No description provided for @operatorEqualTo.
  ///
  /// In en, this message translates to:
  /// **'equal to'**
  String get operatorEqualTo;

  /// No description provided for @actionMove.
  ///
  /// In en, this message translates to:
  /// **'Move to'**
  String get actionMove;

  /// No description provided for @actionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy to'**
  String get actionCopy;

  /// No description provided for @actionRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get actionRename;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get actionComingSoon;

  /// No description provided for @destinationFolder.
  ///
  /// In en, this message translates to:
  /// **'Destination folder'**
  String get destinationFolder;

  /// No description provided for @newFileName.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get newFileName;

  /// No description provided for @chooseFolder.
  ///
  /// In en, this message translates to:
  /// **'Choose folder'**
  String get chooseFolder;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewTitle;

  /// No description provided for @previewMatches.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No files match this rule} =1{1 file matches this rule} other{{count} files match this rule}}'**
  String previewMatches(int count);

  /// No description provided for @previewScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning folders for matches...'**
  String get previewScanning;

  /// No description provided for @previewNoMatchesHint.
  ///
  /// In en, this message translates to:
  /// **'Try broadening the conditions so more files can match.'**
  String get previewNoMatchesHint;

  /// No description provided for @applyRule.
  ///
  /// In en, this message translates to:
  /// **'Apply rule'**
  String get applyRule;

  /// No description provided for @saveRule.
  ///
  /// In en, this message translates to:
  /// **'Save rule'**
  String get saveRule;

  /// No description provided for @backToRules.
  ///
  /// In en, this message translates to:
  /// **'Back to rules'**
  String get backToRules;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityTitle;

  /// No description provided for @activitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'A complete history of what Sortify did'**
  String get activitySubtitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterMoved.
  ///
  /// In en, this message translates to:
  /// **'Moved'**
  String get filterMoved;

  /// No description provided for @filterSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get filterSkipped;

  /// No description provided for @filterFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get filterFailed;

  /// No description provided for @statusMoved.
  ///
  /// In en, this message translates to:
  /// **'Moved'**
  String get statusMoved;

  /// No description provided for @statusSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get statusSkipped;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// No description provided for @noActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get noActivityTitle;

  /// No description provided for @noActivityBody.
  ///
  /// In en, this message translates to:
  /// **'Operations will appear here as soon as Sortify starts organizing your files.'**
  String get noActivityBody;

  /// No description provided for @noActivityFilteredTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching operations'**
  String get noActivityFilteredTitle;

  /// No description provided for @noActivityFilteredBody.
  ///
  /// In en, this message translates to:
  /// **'No activity matches the selected filter.'**
  String get noActivityFilteredBody;

  /// No description provided for @noMatchingRule.
  ///
  /// In en, this message translates to:
  /// **'No matching rule'**
  String get noMatchingRule;

  /// No description provided for @operationDetails.
  ///
  /// In en, this message translates to:
  /// **'Operation details'**
  String get operationDetails;

  /// No description provided for @detailTimestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get detailTimestamp;

  /// No description provided for @detailSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get detailSource;

  /// No description provided for @detailDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get detailDestination;

  /// No description provided for @detailRule.
  ///
  /// In en, this message translates to:
  /// **'Rule'**
  String get detailRule;

  /// No description provided for @detailOperation.
  ///
  /// In en, this message translates to:
  /// **'Operation'**
  String get detailOperation;

  /// No description provided for @detailStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get detailStatus;

  /// No description provided for @detailError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get detailError;

  /// No description provided for @technicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Technical details'**
  String get technicalDetails;

  /// No description provided for @detailOperationId.
  ///
  /// In en, this message translates to:
  /// **'Operation ID'**
  String get detailOperationId;

  /// No description provided for @detailRuleId.
  ///
  /// In en, this message translates to:
  /// **'Rule ID'**
  String get detailRuleId;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear all activity history? This cannot be undone.'**
  String get clearHistoryConfirm;

  /// No description provided for @foldersTitle.
  ///
  /// In en, this message translates to:
  /// **'Watched folders'**
  String get foldersTitle;

  /// No description provided for @foldersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Folders Sortify keeps an eye on'**
  String get foldersSubtitle;

  /// No description provided for @addFolder.
  ///
  /// In en, this message translates to:
  /// **'Add folder'**
  String get addFolder;

  /// No description provided for @folderMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get folderMonitoring;

  /// No description provided for @folderPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get folderPaused;

  /// No description provided for @openFolder.
  ///
  /// In en, this message translates to:
  /// **'Open folder'**
  String get openFolder;

  /// No description provided for @revealInExplorer.
  ///
  /// In en, this message translates to:
  /// **'Reveal in file manager'**
  String get revealInExplorer;

  /// No description provided for @removeFolder.
  ///
  /// In en, this message translates to:
  /// **'Remove folder'**
  String get removeFolder;

  /// No description provided for @removeFolderConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove watched folder?'**
  String get removeFolderConfirmTitle;

  /// No description provided for @removeFolderConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Sortify will stop monitoring {path}. Files already organized are not affected.'**
  String removeFolderConfirmBody(String path);

  /// No description provided for @addFolderPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Start watching this folder?'**
  String get addFolderPreviewTitle;

  /// No description provided for @addFolderPreviewBody.
  ///
  /// In en, this message translates to:
  /// **'Sortify will watch {path} and apply your enabled rules to new files.'**
  String addFolderPreviewBody(String path);

  /// No description provided for @folderPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a folder to watch'**
  String get folderPickerTitle;

  /// No description provided for @folderAlreadyWatched.
  ///
  /// In en, this message translates to:
  /// **'This folder is already being watched'**
  String get folderAlreadyWatched;

  /// No description provided for @folderAdded.
  ///
  /// In en, this message translates to:
  /// **'Folder added'**
  String get folderAdded;

  /// No description provided for @folderRemoved.
  ///
  /// In en, this message translates to:
  /// **'Folder removed'**
  String get folderRemoved;

  /// No description provided for @noFoldersTitle.
  ///
  /// In en, this message translates to:
  /// **'No folders are being watched'**
  String get noFoldersTitle;

  /// No description provided for @noFoldersBody.
  ///
  /// In en, this message translates to:
  /// **'Add a folder to start automatically organizing your files.'**
  String get noFoldersBody;

  /// No description provided for @noFoldersAction.
  ///
  /// In en, this message translates to:
  /// **'Add a folder'**
  String get noFoldersAction;

  /// No description provided for @fileExistsTitle.
  ///
  /// In en, this message translates to:
  /// **'File already exists'**
  String get fileExistsTitle;

  /// No description provided for @fileExistsBody.
  ///
  /// In en, this message translates to:
  /// **'{fileName} already exists in the destination folder.'**
  String fileExistsBody(String fileName);

  /// No description provided for @keepBoth.
  ///
  /// In en, this message translates to:
  /// **'Keep both'**
  String get keepBoth;

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @unmatchedTitle.
  ///
  /// In en, this message translates to:
  /// **'Unmatched files'**
  String get unmatchedTitle;

  /// No description provided for @unmatchedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Files that don\'t match any rule'**
  String get unmatchedSubtitle;

  /// No description provided for @unmatchedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No unmatched files} =1{1 file doesn\'t match any rule} other{{count} files don\'t match any rule}}'**
  String unmatchedCount(int count);

  /// No description provided for @createRuleFromFile.
  ///
  /// In en, this message translates to:
  /// **'Create rule from file'**
  String get createRuleFromFile;

  /// No description provided for @deleteFile.
  ///
  /// In en, this message translates to:
  /// **'Delete file'**
  String get deleteFile;

  /// No description provided for @deleteFileConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this file?'**
  String get deleteFileConfirmTitle;

  /// No description provided for @deleteFileConfirmPermanent.
  ///
  /// In en, this message translates to:
  /// **'{fileName} will be permanently deleted. This cannot be undone.'**
  String deleteFileConfirmPermanent(String fileName);

  /// No description provided for @deleteFileConfirmTrash.
  ///
  /// In en, this message translates to:
  /// **'{fileName} will be moved to the trash.'**
  String deleteFileConfirmTrash(String fileName);

  /// No description provided for @fileDeleted.
  ///
  /// In en, this message translates to:
  /// **'File deleted'**
  String get fileDeleted;

  /// No description provided for @deleteToTrash.
  ///
  /// In en, this message translates to:
  /// **'Move deleted files to trash'**
  String get deleteToTrash;

  /// No description provided for @deleteToTrashDesc.
  ///
  /// In en, this message translates to:
  /// **'When off, deleting a file removes it permanently'**
  String get deleteToTrashDesc;

  /// No description provided for @filterByType.
  ///
  /// In en, this message translates to:
  /// **'Filter by type'**
  String get filterByType;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get allTypes;

  /// No description provided for @tableFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get tableFile;

  /// No description provided for @tableType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get tableType;

  /// No description provided for @tableFolder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get tableFolder;

  /// No description provided for @createRuleForType.
  ///
  /// In en, this message translates to:
  /// **'Create rule for {type}'**
  String createRuleForType(String type);

  /// No description provided for @ignoreType.
  ///
  /// In en, this message translates to:
  /// **'Ignore {type}'**
  String ignoreType(String type);

  /// No description provided for @paginationPrev.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get paginationPrev;

  /// No description provided for @paginationNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get paginationNext;

  /// No description provided for @paginationSummary.
  ///
  /// In en, this message translates to:
  /// **'{start}–{end} of {total}'**
  String paginationSummary(int start, int end, int total);

  /// No description provided for @trayMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring {count} folders'**
  String trayMonitoring(int count);

  /// No description provided for @trayOpen.
  ///
  /// In en, this message translates to:
  /// **'Open Sortify'**
  String get trayOpen;

  /// No description provided for @trayPause.
  ///
  /// In en, this message translates to:
  /// **'Pause monitoring'**
  String get trayPause;

  /// No description provided for @trayResume.
  ///
  /// In en, this message translates to:
  /// **'Resume monitoring'**
  String get trayResume;

  /// No description provided for @trayRunAll.
  ///
  /// In en, this message translates to:
  /// **'Run all rules'**
  String get trayRunAll;

  /// No description provided for @traySettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get traySettings;

  /// No description provided for @trayQuit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get trayQuit;

  /// No description provided for @trayTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sortify - file organizer'**
  String get trayTooltip;

  /// No description provided for @notificationsMoved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Moved 1 file} other{Moved {count} files}}'**
  String notificationsMoved(int count);

  /// No description provided for @paletteSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search commands, rules and files...'**
  String get paletteSearchHint;

  /// No description provided for @paletteCommands.
  ///
  /// In en, this message translates to:
  /// **'Commands'**
  String get paletteCommands;

  /// No description provided for @paletteRules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get paletteRules;

  /// No description provided for @paletteFiles.
  ///
  /// In en, this message translates to:
  /// **'Unmatched files'**
  String get paletteFiles;

  /// No description provided for @paletteNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get paletteNoResults;

  /// No description provided for @paletteCreateRule.
  ///
  /// In en, this message translates to:
  /// **'Create new rule'**
  String get paletteCreateRule;

  /// No description provided for @paletteAddFolder.
  ///
  /// In en, this message translates to:
  /// **'Add folder'**
  String get paletteAddFolder;

  /// No description provided for @paletteRunAll.
  ///
  /// In en, this message translates to:
  /// **'Run all rules'**
  String get paletteRunAll;

  /// No description provided for @palettePause.
  ///
  /// In en, this message translates to:
  /// **'Pause monitoring'**
  String get palettePause;

  /// No description provided for @paletteResume.
  ///
  /// In en, this message translates to:
  /// **'Resume monitoring'**
  String get paletteResume;

  /// No description provided for @paletteOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get paletteOpenSettings;

  /// No description provided for @paletteGoDashboard.
  ///
  /// In en, this message translates to:
  /// **'Go to dashboard'**
  String get paletteGoDashboard;

  /// No description provided for @paletteGoActivity.
  ///
  /// In en, this message translates to:
  /// **'Go to activity'**
  String get paletteGoActivity;

  /// No description provided for @paletteGoRules.
  ///
  /// In en, this message translates to:
  /// **'Go to rules'**
  String get paletteGoRules;

  /// No description provided for @paletteGoFolders.
  ///
  /// In en, this message translates to:
  /// **'Go to folders'**
  String get paletteGoFolders;

  /// No description provided for @paletteRunRule.
  ///
  /// In en, this message translates to:
  /// **'Run rule'**
  String get paletteRunRule;

  /// No description provided for @paletteToggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle theme'**
  String get paletteToggleTheme;

  /// No description provided for @paletteClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get paletteClose;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tune how Sortify behaves'**
  String get settingsSubtitle;

  /// No description provided for @sectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get sectionGeneral;

  /// No description provided for @sectionMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get sectionMonitoring;

  /// No description provided for @sectionConflicts.
  ///
  /// In en, this message translates to:
  /// **'Conflicts'**
  String get sectionConflicts;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get sectionAppearance;

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get sectionLanguage;

  /// No description provided for @startWithSystem.
  ///
  /// In en, this message translates to:
  /// **'Start with system'**
  String get startWithSystem;

  /// No description provided for @startWithSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Launch Sortify when you sign in'**
  String get startWithSystemDesc;

  /// No description provided for @startMinimized.
  ///
  /// In en, this message translates to:
  /// **'Start minimized'**
  String get startMinimized;

  /// No description provided for @startMinimizedDesc.
  ///
  /// In en, this message translates to:
  /// **'Open in the system tray without a window'**
  String get startMinimizedDesc;

  /// No description provided for @confirmFileOperations.
  ///
  /// In en, this message translates to:
  /// **'Confirm file operations'**
  String get confirmFileOperations;

  /// No description provided for @confirmFileOperationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Ask before moving or deleting files'**
  String get confirmFileOperationsDesc;

  /// No description provided for @scanInterval.
  ///
  /// In en, this message translates to:
  /// **'Scan interval'**
  String get scanInterval;

  /// No description provided for @scanIntervalDesc.
  ///
  /// In en, this message translates to:
  /// **'How often watched folders are re-scanned'**
  String get scanIntervalDesc;

  /// No description provided for @secondsShort.
  ///
  /// In en, this message translates to:
  /// **'{count}s'**
  String secondsShort(int count);

  /// No description provided for @watchSubfolders.
  ///
  /// In en, this message translates to:
  /// **'Watch subfolders'**
  String get watchSubfolders;

  /// No description provided for @watchSubfoldersDesc.
  ///
  /// In en, this message translates to:
  /// **'Include nested folders in monitoring'**
  String get watchSubfoldersDesc;

  /// No description provided for @ignoreHidden.
  ///
  /// In en, this message translates to:
  /// **'Ignore hidden files'**
  String get ignoreHidden;

  /// No description provided for @ignoreHiddenDesc.
  ///
  /// In en, this message translates to:
  /// **'Skip dotfiles and hidden system files'**
  String get ignoreHiddenDesc;

  /// No description provided for @ignoredExtensions.
  ///
  /// In en, this message translates to:
  /// **'Ignored extensions'**
  String get ignoredExtensions;

  /// No description provided for @ignoredExtensionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Files with these extensions are never tracked or organized'**
  String get ignoredExtensionsDesc;

  /// No description provided for @extensionHint.
  ///
  /// In en, this message translates to:
  /// **'tmp, log'**
  String get extensionHint;

  /// No description provided for @addExtension.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addExtension;

  /// No description provided for @conflictAskEveryTime.
  ///
  /// In en, this message translates to:
  /// **'Ask every time'**
  String get conflictAskEveryTime;

  /// No description provided for @conflictAskEveryTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Show a dialog when a destination file exists'**
  String get conflictAskEveryTimeDesc;

  /// No description provided for @conflictKeepBoth.
  ///
  /// In en, this message translates to:
  /// **'Keep both'**
  String get conflictKeepBoth;

  /// No description provided for @conflictKeepBothDesc.
  ///
  /// In en, this message translates to:
  /// **'Rename the incoming file to avoid overwriting'**
  String get conflictKeepBothDesc;

  /// No description provided for @conflictReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get conflictReplace;

  /// No description provided for @conflictReplaceDesc.
  ///
  /// In en, this message translates to:
  /// **'Overwrite the existing file'**
  String get conflictReplaceDesc;

  /// No description provided for @conflictSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get conflictSkip;

  /// No description provided for @conflictSkipDesc.
  ///
  /// In en, this message translates to:
  /// **'Leave the file where it is'**
  String get conflictSkipDesc;

  /// No description provided for @appearanceDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appearanceDark;

  /// No description provided for @appearanceLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appearanceLight;

  /// No description provided for @appearanceSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get appearanceSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get commonApply;

  /// No description provided for @commonRun.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get commonRun;

  /// No description provided for @commonPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get commonPause;

  /// No description provided for @commonResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get commonResume;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonError;

  /// No description provided for @commonSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get commonSuccess;

  /// No description provided for @commonWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get commonWarning;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get commonComingSoon;

  /// No description provided for @commonFiles.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file} other{{count} files}}'**
  String commonFiles(int count);

  /// No description provided for @shortcutCommandPalette.
  ///
  /// In en, this message translates to:
  /// **'Command palette'**
  String get shortcutCommandPalette;

  /// No description provided for @shortcutSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get shortcutSearch;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick guide'**
  String get helpTitle;

  /// No description provided for @helpBody.
  ///
  /// In en, this message translates to:
  /// **'Add a folder, create a rule, and Sortify will organize new files automatically.'**
  String get helpBody;

  /// No description provided for @filesUnit.
  ///
  /// In en, this message translates to:
  /// **'MB'**
  String get filesUnit;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
