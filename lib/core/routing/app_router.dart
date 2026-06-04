import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
// feature_cli:router-imports
import '../localization/app_localizations_x.dart';
import 'route_names.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final user = ref.watch(authControllerProvider).value;
  final isAuthenticated = user != null;

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLogin = state.matchedLocation == '/login';
      if (!isAuthenticated && !isLogin) return '/login';
      if (isAuthenticated && isLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/settings',
        name: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      // feature_cli:router-routes
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: Text(context.l10n.notFound)),
      body: Center(
        child: Text(state.error?.message ?? context.l10n.routeNotFound),
      ),
    ),
  );
}
