import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../core/filesystem/file_utils.dart';
import '../../../core/filesystem/name_template.dart';
import '../../../core/notifications/app_notification.dart';
import '../../../core/notifications/notification_controller.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/animations.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/file_type_icon.dart';
import '../../../core/widgets/icon_tile.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../folders/application/folders_controller.dart';
import '../../folders/application/monitoring_controller.dart';
import '../application/rule_builder_seed.dart';
import '../application/rule_editor_controller.dart';
import '../application/rule_preview.dart';
import '../application/rules_controller.dart';
import '../domain/rule.dart';
import '../domain/rule_action.dart';
import '../domain/rule_condition.dart';
import '../domain/rule_enums.dart';
import 'rule_format.dart';

class RuleEditorPanel extends ConsumerStatefulWidget {
  const RuleEditorPanel({super.key, this.ruleId});

  final String? ruleId;

  @override
  ConsumerState<RuleEditorPanel> createState() => _RuleEditorPanelState();
}

class _RuleEditorPanelState extends ConsumerState<RuleEditorPanel> {
  static const _uuid = Uuid();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _destinationController = TextEditingController();
  final _subfolderController = TextEditingController();

  final List<RuleCondition> _conditions = [];
  ActionType _actionType = ActionType.move;
  ConflictPolicy _conflictPolicy = ConflictPolicy.askEveryTime;
  bool _createSubfolder = false;
  String? _scopeFolderPath;
  bool _initialized = false;
  bool _applying = false;

  bool get _isEditing => widget.ruleId != null;

  bool get _isPathAction => _actionType.isPathAction;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _destinationController.dispose();
    _subfolderController.dispose();
    super.dispose();
  }

  void _initialize(List<Rule> rules) {
    if (_initialized) return;
    _initialized = true;

    if (_isEditing) {
      final rule = rules.where((r) => r.id == widget.ruleId).firstOrNull;
      if (rule != null) {
        _nameController.text = rule.name;
        _descriptionController.text = rule.description ?? '';
        _destinationController.text = rule.destination ?? '';
        _conditions
          ..clear()
          ..addAll(rule.conditions);
        _actionType = rule.primaryAction?.type ?? ActionType.move;
        _subfolderController.text = rule.primaryAction?.subfolder ?? '';
        _createSubfolder = _subfolderController.text.trim().isNotEmpty;
        _conflictPolicy = rule.conflictPolicy;
        _scopeFolderPath = rule.scopeFolderPath;
        return;
      }
    }

    // Read the seed without mutating the provider: this runs during build,
    // and modifying a provider inside build is not allowed. The seed is cleared
    // in a post-frame callback once the widget tree is settled.
    final seed = ref.read(ruleBuilderSeedProvider);
    if (seed != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ref.read(ruleBuilderSeedProvider.notifier).consume();
      });
      if (seed.extension != null && seed.extension!.isNotEmpty) {
        _conditions.add(
          RuleCondition(
            id: _uuid.v4(),
            type: ConditionType.extension,
            operator: ConditionOperator.isEqual,
            value: '.${seed.extension}',
          ),
        );
      }
    }
    if (_conditions.isEmpty) {
      _conditions.add(
        RuleCondition(
          id: _uuid.v4(),
          type: ConditionType.extension,
          operator: ConditionOperator.isEqual,
          value: '',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final rulesAsync = ref.watch(rulesControllerProvider);

    return rulesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('$error')),
      data: (rules) {
        _initialize(rules);
        return _buildForm(context);
      },
    );
  }

  Widget _buildForm(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final border = context.semanticColors.subtleBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(theme, l10n),
        Divider(height: 1, color: border),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context)
                .copyWith(scrollbars: true),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedEntrance(child: _buildBasics(theme, l10n)),
                  const SizedBox(height: AppSpacing.md),
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 60),
                    child: _buildWhenSection(theme, l10n),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 120),
                    child: _buildThenSection(theme, l10n),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
        Divider(height: 1, color: border),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: _buildActions(theme, l10n),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          IconTile(
            icon: _isEditing ? Icons.edit_outlined : Icons.add_rounded,
            color: theme.colorScheme.primary,
            size: 38,
            iconSize: 19,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditing ? l10n.editRule : l10n.newRule,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  l10n.rulesSubtitle,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.commonClose,
            onPressed: _close,
            icon: const Icon(Icons.close_rounded, size: 20),
          ),
        ],
      ),
    );
  }

  void _close() {
    ref.read(ruleEditorProvider.notifier).close();
  }

  Widget _buildBasics(ThemeData theme, AppLocalizations l10n) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FieldLabel(l10n.ruleName),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: l10n.ruleNameHint),
          ),
          const SizedBox(height: AppSpacing.md),
          _FieldLabel(l10n.ruleDescription),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(hintText: l10n.ruleDescriptionHint),
          ),
          const SizedBox(height: AppSpacing.md),
          _FieldLabel(l10n.ruleScope),
          const SizedBox(height: AppSpacing.xs),
          _buildScopeDropdown(),
        ],
      ),
    );
  }

  Widget _buildScopeDropdown() {
    final l10n = AppLocalizations.of(context);
    final folders = ref.watch(foldersControllerProvider).value ?? const [];
    final items = <DropdownMenuItem<String?>>[
      DropdownMenuItem(
        value: null,
        child: Text(l10n.allFolders, overflow: TextOverflow.ellipsis),
      ),
      for (final folder in folders)
        DropdownMenuItem(
          value: folder.path,
          child: Text(folder.name, overflow: TextOverflow.ellipsis),
        ),
    ];

    // Keep a scope pointing to a removed folder visible instead of crashing.
    final dangling = _scopeFolderPath;
    if (dangling != null && !folders.any((f) => p.equals(f.path, dangling))) {
      items.add(
        DropdownMenuItem(
          value: dangling,
          child: Text(p.basename(dangling), overflow: TextOverflow.ellipsis),
        ),
      );
    }

    return DropdownButtonFormField<String?>(
      initialValue: _scopeFolderPath,
      isDense: true,
      mouseCursor: SystemMouseCursors.click,
      isExpanded: true,
      decoration: const InputDecoration(),
      items: items,
      onChanged: (value) => setState(() => _scopeFolderPath = value),
    );
  }

  Widget _buildWhenSection(ThemeData theme, AppLocalizations l10n) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionBadge(label: l10n.whenLabel),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < _conditions.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  children: [
                    Text(
                      l10n.andLabel,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            AnimatedEntrance(
              key: ValueKey(_conditions[i].id),
              slide: 0.12,
              duration: AppMotion.fast,
              child: _ConditionRow(
                condition: _conditions[i],
                canRemove: _conditions.length > 1,
                onChanged: (updated) => setState(() {
                  _conditions[i] = updated;
                }),
                onRemove: () => setState(() {
                  _conditions.removeAt(i);
                }),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() {
                _conditions.add(
                  RuleCondition(
                    id: _uuid.v4(),
                    type: ConditionType.extension,
                    operator: ConditionOperator.isEqual,
                    value: '',
                  ),
                );
              }),
              icon: const Icon(Icons.add_rounded, size: 17),
              label: Text(l10n.addCondition),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThenSection(ThemeData theme, AppLocalizations l10n) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionBadge(label: l10n.thenLabel),
          const SizedBox(height: AppSpacing.sm),
          ChoicePills<ActionType>(
            value: _actionType,
            onChanged: (value) => setState(() => _actionType = value),
            options: [
              for (final type in ActionType.values)
                ChoiceOption(
                  value: type,
                  label: _actionLabel(type, l10n),
                  icon: RuleFormat.actionIcon(type),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AnimatedSize(
            duration: AppMotion.fast,
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: switch (_actionType) {
              ActionType.move ||
              ActionType.copy => _buildPathActionFields(theme, l10n),
              ActionType.rename => _buildRenameFields(theme, l10n),
              ActionType.delete => _HelpText(
                icon: Icons.info_outline_rounded,
                text: l10n.deleteHelp,
              ),
            },
          ),
        ],
      ),
    );
  }

  String _actionLabel(ActionType type, AppLocalizations l10n) => switch (type) {
    ActionType.move => l10n.actionMove,
    ActionType.copy => l10n.actionCopy,
    ActionType.rename => l10n.actionRename,
    ActionType.delete => l10n.actionDelete,
  };

  Widget _buildPathActionFields(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldLabel(l10n.destinationFolder),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: _destinationController,
          decoration: InputDecoration(
            hintText: l10n.destinationFolder,
            prefixIcon: const Icon(Icons.folder_outlined, size: 18),
            suffixIcon: IconButton(
              tooltip: l10n.chooseFolder,
              onPressed: _pickDestination,
              icon: const Icon(Icons.folder_open_rounded, size: 18),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _ToggleRow(
          icon: Icons.create_new_folder_outlined,
          title: l10n.createSubfolder,
          subtitle: l10n.createSubfolderHelp,
          value: _createSubfolder,
          onChanged: (value) => setState(() => _createSubfolder = value),
        ),
        if (_createSubfolder) ...[
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: _subfolderController,
            decoration: InputDecoration(
              hintText: '${l10n.subfolderName} · {year}/{ext}',
              prefixIcon: const Icon(
                Icons.subdirectory_arrow_right_rounded,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _TokenBar(
            onInsert: (token) => _insertToken(_subfolderController, token),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        _buildExample(theme, l10n),
        const SizedBox(height: AppSpacing.md),
        _FieldLabel(l10n.onConflict),
        const SizedBox(height: AppSpacing.xs),
        ChoicePills<ConflictPolicy>(
          dense: true,
          value: _conflictPolicy,
          onChanged: (value) => setState(() => _conflictPolicy = value),
          options: [
            ChoiceOption(
              value: ConflictPolicy.askEveryTime,
              label: l10n.conflictAskEveryTime,
            ),
            ChoiceOption(value: ConflictPolicy.keepBoth, label: l10n.keepBoth),
            ChoiceOption(value: ConflictPolicy.replace, label: l10n.replace),
            ChoiceOption(value: ConflictPolicy.skip, label: l10n.skip),
          ],
        ),
      ],
    );
  }

  Widget _buildRenameFields(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldLabel(l10n.newFileName),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: _destinationController,
          decoration: const InputDecoration(
            hintText: '{date}_{name}',
            prefixIcon: Icon(Icons.drive_file_rename_outline, size: 18),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        _TokenBar(
          onInsert: (token) => _insertToken(_destinationController, token),
        ),
        const SizedBox(height: AppSpacing.xs),
        _HelpText(icon: Icons.info_outline_rounded, text: l10n.renameHelp),
        const SizedBox(height: AppSpacing.sm),
        _buildExample(theme, l10n),
      ],
    );
  }

  /// Live preview of where a sample file would end up with the current form.
  Widget _buildExample(ThemeData theme, AppLocalizations l10n) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        _destinationController,
        _subfolderController,
      ]),
      builder: (context, _) {
        final example = _examplePath();
        if (example == null) return const SizedBox.shrink();
        final semantic = context.semanticColors;
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: semantic.subtleBorder),
          ),
          child: Row(
            children: [
              Icon(
                Icons.visibility_outlined,
                size: 15,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${l10n.exampleResult}:',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Tooltip(
                  message: example,
                  child: Text(
                    example,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontFamily: 'Consolas',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Renders the current form against a sample file named after the first
  /// extension condition, e.g. `report.pdf`.
  String? _examplePath() {
    final value = _destinationController.text.trim();
    if (value.isEmpty) return null;

    var extension = '.pdf';
    for (final condition in _conditions) {
      if (condition.type != ConditionType.extension ||
          condition.operator != ConditionOperator.isEqual) {
        continue;
      }
      final first = condition.value.split(',').first.trim();
      if (first.isNotEmpty) {
        extension = first.startsWith('.') ? first : '.$first';
        break;
      }
    }

    final folders = ref.read(foldersControllerProvider).value ?? const [];
    final watched =
        _scopeFolderPath ?? (folders.isEmpty ? null : folders.first.path);
    final samplePath = p.join(watched ?? '', 'report$extension');
    final now = DateTime.now();

    if (_actionType == ActionType.rename) {
      var name = NameTemplate.sanitizeSegment(
        NameTemplate.render(
          value,
          filePath: samplePath,
          modified: now,
        ).replaceAll(RegExp(r'[\\/]'), '_'),
      );
      if (name.isEmpty) return null;
      if (p.extension(name).isEmpty) name = '$name$extension';
      return name;
    }

    var folder = watched == null
        ? p.normalize(value)
        : FileUtils.resolveDestination(
            watchedFolder: watched,
            destination: value,
          );
    if (_createSubfolder) {
      final subfolder = NameTemplate.renderFolder(
        _subfolderController.text,
        filePath: samplePath,
        modified: now,
      );
      if (subfolder.isNotEmpty) folder = p.join(folder, subfolder);
    }
    return p.join(folder, p.basename(samplePath));
  }

  void _insertToken(TextEditingController controller, String token) {
    final text = controller.text;
    final selection = controller.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final inserted = '{$token}';
    controller.value = TextEditingValue(
      text: text.replaceRange(start, end, inserted),
      selection: TextSelection.collapsed(offset: start + inserted.length),
    );
  }

  Widget _buildActions(ThemeData theme, AppLocalizations l10n) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        TextButton(onPressed: _close, child: Text(l10n.commonCancel)),
        OutlinedButton.icon(
          onPressed: _applying ? null : _applyRule,
          icon: _applying
              ? const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.play_arrow_rounded, size: 18),
          label: Text(l10n.applyRule),
        ),
        FilledButton.icon(
          onPressed: _saveRule,
          icon: const Icon(Icons.check_rounded, size: 18),
          label: Text(l10n.saveRule),
        ),
      ],
    );
  }

  Future<void> _pickDestination() async {
    final l10n = AppLocalizations.of(context);
    final path = await FilePicker.getDirectoryPath(
      dialogTitle: l10n.chooseFolder,
    );
    if (path != null) {
      setState(() => _destinationController.text = path);
    }
  }

  Rule _buildRule() {
    final now = DateTime.now();
    final existing = ref
        .read(rulesControllerProvider)
        .value
        ?.where((r) => r.id == widget.ruleId)
        .firstOrNull;

    final destination = _destinationController.text.trim();
    final subfolder = _isPathAction && _createSubfolder
        ? _subfolderController.text.trim()
        : '';
    return Rule(
      id: widget.ruleId ?? _uuid.v4(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      enabled: existing?.enabled ?? true,
      conditions: [
        for (var i = 0; i < _conditions.length; i++)
          _conditions[i].copyWith(ordinal: i),
      ],
      actions: [
        RuleAction(
          id: existing?.primaryAction?.id ?? _uuid.v4(),
          type: _actionType,
          value: _actionType == ActionType.delete ? '' : destination,
          subfolder: subfolder,
        ),
      ],
      conflictPolicy: _conflictPolicy,
      scopeFolderPath: _scopeFolderPath,
      processedCount: existing?.processedCount ?? 0,
      lastRunAt: existing?.lastRunAt,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
  }

  bool _validate(AppLocalizations l10n, Rule rule) {
    if (rule.name.isEmpty) {
      _notify(l10n.ruleName, type: AppNotificationType.error);
      return false;
    }
    if (rule.conditions.isEmpty) {
      _notify(l10n.addCondition, type: AppNotificationType.error);
      return false;
    }
    if (!rule.isActionReady) {
      _notify(
        _actionType == ActionType.rename
            ? l10n.newFileName
            : l10n.destinationFolder,
        type: AppNotificationType.error,
      );
      return false;
    }
    if (_isPathAction &&
        _createSubfolder &&
        _subfolderController.text.trim().isEmpty) {
      _notify(l10n.subfolderName, type: AppNotificationType.error);
      return false;
    }
    return true;
  }

  void _notify(
    String message, {
    AppNotificationType type = AppNotificationType.info,
  }) {
    ref.read(notificationProvider.notifier).show(message, type: type);
  }

  Future<void> _saveRule() async {
    final l10n = AppLocalizations.of(context);
    final rule = _buildRule();
    if (!_validate(l10n, rule)) return;

    await ref.read(rulesControllerProvider.notifier).save(rule);
    if (!mounted) return;
    _notify(l10n.ruleSaved, type: AppNotificationType.success);
    _close();
  }

  Future<void> _applyRule() async {
    final l10n = AppLocalizations.of(context);
    final rule = _buildRule();
    if (!_validate(l10n, rule)) return;

    setState(() => _applying = true);
    try {
      final entries = await ref
          .read(monitoringControllerProvider.notifier)
          .previewRule(rule);
      if (!mounted) return;
      final confirmed = await _showPreviewDialog(context, entries, l10n);
      if (!confirmed || !mounted) return;

      await ref.read(rulesControllerProvider.notifier).save(rule);
      final moved = await ref
          .read(monitoringControllerProvider.notifier)
          .applyRule(rule);
      if (!mounted) return;
      _notify(l10n.commonFiles(moved), type: AppNotificationType.success);
      _close();
    } finally {
      if (mounted) setState(() => _applying = false);
    }
  }
}

Future<bool> _showPreviewDialog(
  BuildContext context,
  List<RulePreviewEntry> entries,
  AppLocalizations l10n,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      final semantic = context.semanticColors;
      return AlertDialog(
        title: Text(l10n.previewTitle),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.previewMatches(entries.length),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (entries.isEmpty)
                Text(
                  l10n.previewNoMatchesHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: entries.take(50).length,
                    separatorBuilder: (_, _) =>
                        Divider(height: 1, color: semantic.subtleBorder),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            FileTypeIcon(
                              path: entry.sourcePath,
                              size: 30,
                              iconSize: 15,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.sourcePath
                                        .split(RegExp(r'[\\/]'))
                                        .last,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    entry.destination.isEmpty
                                        ? l10n.actionDelete
                                        : '→ ${entry.destination}',
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: entry.destination.isEmpty
                                          ? theme.colorScheme.error
                                          : theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel, overflow: TextOverflow.ellipsis),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.applyRule, overflow: TextOverflow.ellipsis),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

class _ConditionRow extends StatelessWidget {
  const _ConditionRow({
    required this.condition,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
  });

  final RuleCondition condition;
  final bool canRemove;
  final ValueChanged<RuleCondition> onChanged;
  final VoidCallback onRemove;

  static List<ConditionOperator> _operatorsFor(ConditionType type) {
    return switch (type) {
      ConditionType.extension => [
        ConditionOperator.isEqual,
        ConditionOperator.isNot,
      ],
      ConditionType.size => [
        ConditionOperator.greaterThan,
        ConditionOperator.lessThan,
        ConditionOperator.equalTo,
      ],
      ConditionType.name => [
        ConditionOperator.contains,
        ConditionOperator.doesNotContain,
        ConditionOperator.startsWith,
        ConditionOperator.endsWith,
        ConditionOperator.isEqual,
        ConditionOperator.isNot,
      ],
      ConditionType.modified => [
        ConditionOperator.olderThan,
        ConditionOperator.newerThan,
      ],
    };
  }

  String _valueHint(ConditionType type) {
    return switch (type) {
      ConditionType.extension => '.pdf, .jpg',
      ConditionType.size => '10 MB',
      ConditionType.name => 'invoice',
      ConditionType.modified => '30',
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final typeField = DropdownButtonFormField<ConditionType>(
      initialValue: condition.type,
      isDense: true,
      mouseCursor: SystemMouseCursors.click,
      isExpanded: true,
      decoration: const InputDecoration(),
      items: [
        for (final type in ConditionType.values)
          DropdownMenuItem(
            value: type,
            child: Text(
              RuleFormat.conditionTypeLabel(type, l10n),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
      ],
      onChanged: (type) {
        if (type == null) return;
        onChanged(
          condition.copyWith(type: type, operator: _operatorsFor(type).first),
        );
      },
    );

    final operatorField = DropdownButtonFormField<ConditionOperator>(
      initialValue: condition.operator,
      isDense: true,
      mouseCursor: SystemMouseCursors.click,
      isExpanded: true,
      decoration: const InputDecoration(),
      items: [
        for (final operator in _operatorsFor(condition.type))
          DropdownMenuItem(
            value: operator,
            child: Text(
              RuleFormat.operatorLabel(operator, l10n),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
      ],
      onChanged: (operator) {
        if (operator != null) {
          onChanged(condition.copyWith(operator: operator));
        }
      },
    );

    final valueField = TextFormField(
      initialValue: condition.value,
      onChanged: (value) => onChanged(condition.copyWith(value: value)),
      decoration: InputDecoration(
        hintText: _valueHint(condition.type),
        suffixText: condition.type == ConditionType.modified
            ? l10n.daysUnit
            : null,
      ),
    );

    final removeButton = IconButton(
      onPressed: canRemove ? onRemove : null,
      tooltip: l10n.commonDelete,
      icon: const Icon(Icons.close_rounded, size: 18),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 640) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: typeField),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(child: operatorField),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: valueField),
                  removeButton,
                ],
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 170, child: typeField),
            const SizedBox(width: AppSpacing.xs),
            SizedBox(width: 130, child: operatorField),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: valueField),
            removeButton,
          ],
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.labelLarge?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _SectionBadge extends StatelessWidget {
  const _SectionBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: 3,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// A compact switch row with an icon, a title and a short explanation.
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = value
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.labelLarge),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

/// Clickable `{token}` chips that insert a name template token.
class _TokenBar extends StatelessWidget {
  const _TokenBar({required this.onInsert});

  final ValueChanged<String> onInsert;

  static String _description(String token, AppLocalizations l10n) =>
      switch (token) {
        'name' => l10n.tokenName,
        'ext' => l10n.tokenExt,
        'year' => l10n.tokenYear,
        'month' => l10n.tokenMonth,
        'day' => l10n.tokenDay,
        'date' => l10n.tokenDate,
        _ => token,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '${l10n.templateTokens}:',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        for (final token in NameTemplate.tokens)
          Tooltip(
            message: _description(token, l10n),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              onTap: () => onInsert(token),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: semantic.subtleBorder),
                ),
                child: Text(
                  '{$token}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontFamily: 'Consolas',
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HelpText extends StatelessWidget {
  const _HelpText({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(
            icon,
            size: 15,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
