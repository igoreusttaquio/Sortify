import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/system/auto_start_service.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/animations.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/language_selector.dart';
import '../../../core/widgets/page_body.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../rules/domain/rule_enums.dart';
import '../application/settings_controller.dart';
import '../domain/app_settings.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider);
    final notifier = ref.read(settingsControllerProvider.notifier);

    return PageBody(
      child: AnimatedEntrance(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(
              title: l10n.settingsTitle,
              subtitle: l10n.settingsSubtitle,
            ),
            const SizedBox(height: AppSpacing.lg),
            _Section(
              title: l10n.sectionGeneral,
              icon: Icons.tune_rounded,
              children: [
                _SwitchSetting(
                  title: l10n.startWithSystem,
                  subtitle: l10n.startWithSystemDesc,
                  value: settings.startWithSystem,
                  onChanged: (value) async {
                    await notifier.update(
                      (s) => s.copyWith(startWithSystem: value),
                    );
                    await const AutoStartService().setEnabled(value);
                  },
                ),
                _SwitchSetting(
                  title: l10n.startMinimized,
                  subtitle: l10n.startMinimizedDesc,
                  value: settings.startMinimized,
                  onChanged: (value) =>
                      notifier.update((s) => s.copyWith(startMinimized: value)),
                ),
                _SwitchSetting(
                  title: l10n.confirmFileOperations,
                  subtitle: l10n.confirmFileOperationsDesc,
                  value: settings.confirmFileOperations,
                  onChanged: (value) => notifier.update(
                    (s) => s.copyWith(confirmFileOperations: value),
                  ),
                ),
                _SwitchSetting(
                  title: l10n.deleteToTrash,
                  subtitle: l10n.deleteToTrashDesc,
                  value: settings.deleteBehavior == DeleteBehavior.trash,
                  onChanged: (value) => notifier.update(
                    (s) => s.copyWith(
                      deleteBehavior: value
                          ? DeleteBehavior.trash
                          : DeleteBehavior.permanent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _Section(
              title: l10n.sectionMonitoring,
              icon: Icons.visibility_outlined,
              children: [
                _SliderSetting(
                  title: l10n.scanInterval,
                  subtitle: l10n.scanIntervalDesc,
                  value: settings.scanIntervalSeconds,
                  min: 2,
                  max: 30,
                  label: l10n.secondsShort(settings.scanIntervalSeconds),
                  onChanged: (value) => notifier.update(
                    (s) => s.copyWith(scanIntervalSeconds: value),
                  ),
                ),
                _SwitchSetting(
                  title: l10n.watchSubfolders,
                  subtitle: l10n.watchSubfoldersDesc,
                  value: settings.watchSubfolders,
                  onChanged: (value) => notifier.update(
                    (s) => s.copyWith(watchSubfolders: value),
                  ),
                ),
                _SwitchSetting(
                  title: l10n.ignoreHidden,
                  subtitle: l10n.ignoreHiddenDesc,
                  value: settings.ignoreHiddenFiles,
                  onChanged: (value) => notifier.update(
                    (s) => s.copyWith(ignoreHiddenFiles: value),
                  ),
                ),
                _ExtensionListSetting(
                  title: l10n.ignoredExtensions,
                  subtitle: l10n.ignoredExtensionsDesc,
                  extensions: settings.ignoredExtensions,
                  hint: l10n.extensionHint,
                  addLabel: l10n.addExtension,
                  onChanged: (list) => notifier.update(
                    (s) => s.copyWith(ignoredExtensions: list),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _Section(
              title: l10n.sectionConflicts,
              icon: Icons.merge_type_rounded,
              children: [
                ChoicePills<ConflictPolicy>(
                  value: settings.defaultConflictPolicy,
                  onChanged: (value) => notifier.update(
                    (s) => s.copyWith(defaultConflictPolicy: value),
                  ),
                  options: [
                    ChoiceOption(
                      value: ConflictPolicy.askEveryTime,
                      label: l10n.conflictAskEveryTime,
                    ),
                    ChoiceOption(
                      value: ConflictPolicy.keepBoth,
                      label: l10n.conflictKeepBoth,
                    ),
                    ChoiceOption(
                      value: ConflictPolicy.replace,
                      label: l10n.conflictReplace,
                    ),
                    ChoiceOption(
                      value: ConflictPolicy.skip,
                      label: l10n.conflictSkip,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _Section(
              title: l10n.sectionAppearance,
              icon: Icons.palette_outlined,
              children: [
                ChoicePills<AppThemePreference>(
                  value: settings.theme,
                  onChanged: (value) =>
                      notifier.update((s) => s.copyWith(theme: value)),
                  options: [
                    ChoiceOption(
                      value: AppThemePreference.dark,
                      label: l10n.appearanceDark,
                      icon: Icons.dark_mode_outlined,
                    ),
                    ChoiceOption(
                      value: AppThemePreference.light,
                      label: l10n.appearanceLight,
                      icon: Icons.light_mode_outlined,
                    ),
                    ChoiceOption(
                      value: AppThemePreference.system,
                      label: l10n.appearanceSystem,
                      icon: Icons.contrast_rounded,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _Section(
              title: l10n.sectionLanguage,
              icon: Icons.language_rounded,
              children: [
                Row(
                  children: [
                    for (final language in supportedLanguages) ...[
                      _LanguageCard(
                        language: language,
                        selected: settings.languageCode == language.code,
                        onTap: () => notifier.setLanguage(language.code),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;

    return SurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 17, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(title, style: theme.textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Divider(height: AppSpacing.md * 2, color: semantic.subtleBorder),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _SwitchSetting extends StatelessWidget {
  const _SwitchSetting({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.bodyLarge),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _SliderSetting extends StatelessWidget {
  const _SliderSetting({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    required this.label,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final int value;
  final int min;
  final int max;
  final String label;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyLarge),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(label, style: theme.textTheme.labelLarge),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          label: label,
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final l10n = AppLocalizations.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primary.withValues(alpha: 0.12)
                : theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary.withValues(alpha: 0.5)
                  : semantic.subtleBorder,
            ),
          ),
          child: Row(
            children: [
              languageFlag(language.code, width: 26, height: 19),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  language.label(l10n),
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  size: 17,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExtensionListSetting extends StatefulWidget {
  const _ExtensionListSetting({
    required this.title,
    required this.subtitle,
    required this.extensions,
    required this.hint,
    required this.addLabel,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final List<String> extensions;
  final String hint;
  final String addLabel;
  final ValueChanged<List<String>> onChanged;

  @override
  State<_ExtensionListSetting> createState() => _ExtensionListSettingState();
}

class _ExtensionListSettingState extends State<_ExtensionListSetting> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _normalize(String value) =>
      value.trim().toLowerCase().replaceAll('.', '').trim();

  void _add() {
    final parts = _controller.text
        .split(',')
        .map(_normalize)
        .where((e) => e.isNotEmpty && !e.contains(' '))
        .toList();
    if (parts.isEmpty) {
      _controller.clear();
      return;
    }
    final next = {...widget.extensions, ...parts}.toList()..sort();
    widget.onChanged(next);
    _controller.clear();
  }

  void _remove(String extension) {
    widget.onChanged(widget.extensions.where((e) => e != extension).toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: theme.textTheme.bodyLarge),
        Text(
          widget.subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _controller,
          onSubmitted: (_) => _add(),
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: IconButton(
              tooltip: widget.addLabel,
              onPressed: _add,
              icon: const Icon(Icons.add_rounded, size: 18),
            ),
          ),
        ),
        if (widget.extensions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Material(
            type: MaterialType.transparency,
            child: Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final extension in widget.extensions)
                  InputChip(
                    label: Text('.$extension'),
                    onDeleted: () => _remove(extension),
                    deleteIcon: const Icon(Icons.close_rounded, size: 15),
                    side: BorderSide(color: semantic.subtleBorder),
                    backgroundColor: theme.colorScheme.surfaceContainerHigh,
                    labelStyle: theme.textTheme.labelMedium,
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
