import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/application/settings_controller.dart';
import '../../l10n/generated/app_localizations.dart';
import '../theme/app_tokens.dart';

class AppLanguage {
  const AppLanguage(this.code, this.countryCode);

  final String code;

  /// Country whose flag represents the language in the UI.
  final String countryCode;

  String label(AppLocalizations l10n) => switch (code) {
    'pt' => l10n.languagePortuguese,
    'es' => l10n.languageSpanish,
    _ => l10n.languageEnglish,
  };
}

const supportedLanguages = <AppLanguage>[
  AppLanguage('en', 'US'),
  AppLanguage('pt', 'BR'),
  AppLanguage('es', 'ES'),
];

CountryFlag languageFlag(String code, {double width = 22, double height = 16}) {
  final language = supportedLanguages.firstWhere(
    (l) => l.code == code,
    orElse: () => supportedLanguages.first,
  );
  return CountryFlag.fromCountryCode(
    language.countryCode,
    theme: ImageTheme(
      width: width,
      height: height,
      shape: const RoundedRectangle(3),
    ),
  );
}

/// Language switcher for the top bar, showing the flag of each language.
class LanguageSelectorButton extends ConsumerWidget {
  const LanguageSelectorButton({super.key, this.showLabel = true});

  final bool showLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider);
    final theme = Theme.of(context);
    final current = supportedLanguages.firstWhere(
      (l) => l.code == settings.languageCode,
      orElse: () => supportedLanguages.first,
    );

    return PopupMenuButton<String>(
      tooltip: l10n.sectionLanguage,
      position: PopupMenuPosition.under,
      onSelected: (code) =>
          ref.read(settingsControllerProvider.notifier).setLanguage(code),
      itemBuilder: (context) => [
        for (final language in supportedLanguages)
          PopupMenuItem<String>(
            value: language.code,
            child: Row(
              children: [
                languageFlag(language.code),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    language.label(l10n),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (language.code == settings.languageCode)
                  Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
              ],
            ),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            languageFlag(settings.languageCode),
            if (showLabel) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(
                current.label(l10n),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              Icon(
                Icons.expand_more_rounded,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
