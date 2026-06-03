import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/async_value_view.dart';
import '../../../../shared/widgets/brand_mark.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../domain/entities/app_user.dart';
import '../controllers/auth_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homeTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.settingsTitle,
            onPressed: () => context.pushNamed(RouteNames.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: AsyncValueView(
        value: auth,
        data: (user) => _HomeContent(user: user),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.user});

  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final actions = _buildActions(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.xxl,
      ),
      children: [
        FadeSlideIn(child: _GreetingCard(user: user)),
        const SizedBox(height: AppSpacing.xl),
        FadeSlideIn(
          delay: AppDurations.stagger,
          child: Text(
            context.l10n.homeQuickActions,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.45,
          children: [
            for (var i = 0; i < actions.length; i++)
              FadeSlideIn(
                delay: AppDurations.stagger * (i + 2),
                child: _QuickActionCard(action: actions[i]),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeSlideIn(
          delay: AppDurations.stagger * (actions.length + 2),
          child: const _TipCard(),
        ),
      ],
    );
  }

  List<_QuickAction> _buildActions(BuildContext context) {
    final l10n = context.l10n;
    return [
      _QuickAction(
        icon: Icons.dashboard_outlined,
        title: l10n.homeActionFeatures,
        description: l10n.homeActionFeaturesDesc,
      ),
      _QuickAction(
        icon: Icons.menu_book_outlined,
        title: l10n.homeActionDocs,
        description: l10n.homeActionDocsDesc,
      ),
      _QuickAction(
        icon: Icons.widgets_outlined,
        title: l10n.homeActionComponents,
        description: l10n.homeActionComponentsDesc,
      ),
      _QuickAction(
        icon: Icons.settings_outlined,
        title: l10n.homeActionSettings,
        description: l10n.homeActionSettingsDesc,
        onTap: (ctx) => ctx.pushNamed(RouteNames.settings),
      ),
    ];
  }
}

class _GreetingCard extends StatelessWidget {
  const _GreetingCard({required this.user});

  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = user?.name ?? 'guest';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: AppRadius.card,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.tertiary],
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const BrandMark(size: 56, icon: Icons.person_outline_rounded),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.homeWelcomeSubtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: colors.onPrimary.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n.homeGreeting(name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (user?.email != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    user!.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: colors.onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.action});

  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Pressable(
      borderRadius: AppRadius.card,
      onTap: action.onTap == null ? null : () => action.onTap!(context),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.card,
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: AppRadius.field,
              ),
              child: Icon(
                action.icon,
                color: colors.onPrimaryContainer,
                size: 22,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  action.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: AppRadius.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: colors.secondary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.homeTipTitle,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n.homeTipBody,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  const _QuickAction({
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final void Function(BuildContext context)? onTap;
}
