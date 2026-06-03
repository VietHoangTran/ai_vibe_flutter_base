import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/brand_mark.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/app_settings.dart';
import '../controllers/settings_controller.dart';
import 'settings_section.dart';

class SettingsContent extends ConsumerWidget {
  const SettingsContent(this.data, {super.key});

  final AppSettings data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final controller = ref.read(settingsControllerProvider.notifier);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.md,
        AppSpacing.page,
        AppSpacing.xxl,
      ),
      children: [
        FadeSlideIn(
          child: _AccountHeader(name: user?.name, email: user?.email),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeSlideIn(
          delay: AppDurations.stagger,
          child: SettingsSection(
            title: context.l10n.settingsAppearance,
            child: _ThemeModeSelector(
              value: data.themeMode,
              onChanged: controller.updateThemeMode,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeSlideIn(
          delay: AppDurations.stagger * 2,
          child: SettingsSection(
            title: context.l10n.settingsLanguage,
            child: _LanguageSelector(
              value: data.locale,
              onChanged: controller.updateLocale,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeSlideIn(
          delay: AppDurations.stagger * 3,
          child: SettingsSection(
            title: context.l10n.settingsAbout,
            child: ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: Text(context.l10n.settingsVersion),
              trailing: Text(
                AppConfig.appVersion,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        FadeSlideIn(
          delay: AppDurations.stagger * 4,
          child: _SignOutButton(
            onSignOut: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
        ),
      ],
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({this.name, this.email});

  final String? name;
  final String? email;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        const BrandMark(size: 60, icon: Icons.person_outline_rounded),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name ?? 'guest',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (email != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  email!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector({required this.value, required this.onChanged});

  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SegmentedButton<ThemeMode>(
        segments: [
          ButtonSegment(
            value: ThemeMode.system,
            icon: const Icon(Icons.brightness_auto_outlined),
            label: Text(l10n.themeSystem),
          ),
          ButtonSegment(
            value: ThemeMode.light,
            icon: const Icon(Icons.light_mode_outlined),
            label: Text(l10n.themeLight),
          ),
          ButtonSegment(
            value: ThemeMode.dark,
            icon: const Icon(Icons.dark_mode_outlined),
            label: Text(l10n.themeDark),
          ),
        ],
        selected: {value},
        showSelectedIcon: false,
        onSelectionChanged: (selection) => onChanged(selection.first),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({required this.value, required this.onChanged});

  final Locale? value;
  final ValueChanged<Locale?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = <(Locale?, String)>[
      (null, l10n.languageSystem),
      (const Locale('en'), l10n.languageEnglish),
      (const Locale('vi'), l10n.languageVietnamese),
      (const Locale('ja'), l10n.languageJapanese),
    ];

    return RadioGroup<String?>(
      groupValue: value?.languageCode,
      onChanged: (selected) => onChanged(
        options.firstWhere((o) => o.$1?.languageCode == selected).$1,
      ),
      child: Column(
        children: [
          for (final (locale, label) in options)
            RadioListTile<String?>(
              value: locale?.languageCode,
              title: Text(label),
            ),
        ],
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.onSignOut});

  final VoidCallback onSignOut;

  Future<void> _confirm(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.signOutConfirmTitle),
        content: Text(l10n.signOutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );

    if (confirmed ?? false) onSignOut();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return FilledButton.tonalIcon(
      onPressed: () => _confirm(context),
      style: FilledButton.styleFrom(
        backgroundColor: colors.errorContainer,
        foregroundColor: colors.onErrorContainer,
      ),
      icon: const Icon(Icons.logout_rounded),
      label: Text(context.l10n.signOut),
    );
  }
}
