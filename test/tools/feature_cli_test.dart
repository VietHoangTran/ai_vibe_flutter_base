import 'package:flutter_test/flutter_test.dart';

import '../../tools/feature_cli.dart';

void main() {
  group('feature name formatting', () {
    test('normalizes feature names consistently', () {
      expect(snakeCase('User Profile'), 'user_profile');
      expect(snakeCase('user-profile'), 'user_profile');
      expect(snakeCase('userProfile'), 'user_profile');
      expect(pascalCase('user_profile'), 'UserProfile');
      expect(camelCase('user_profile'), 'userProfile');
    });
  });

  group('parseFeatureCliArgs', () {
    test('parses dry run and AI guidance flags', () {
      final result = parseFeatureCliArgs([
        'user-profile',
        '--dry-run',
        '--with-route',
        '--with-localization',
        '--with-story',
      ]);

      final success = result as FeatureCliParseSuccess;
      expect(success.options.featureName, 'user_profile');
      expect(success.options.dryRun, isTrue);
      expect(success.options.withRoute, isTrue);
      expect(success.options.withLocalization, isTrue);
      expect(success.options.withStory, isTrue);
    });

    test('parses force flag', () {
      final result = parseFeatureCliArgs(['profile', '--force']);

      final success = result as FeatureCliParseSuccess;
      expect(success.options.force, isTrue);
    });

    test('rejects multiple feature names', () {
      final result = parseFeatureCliArgs(['profile', 'settings']);

      expect(result, isA<FeatureCliParseFailure>());
    });

    test('rejects names that cannot become Dart identifiers', () {
      final result = parseFeatureCliArgs(['123-profile']);

      expect(result, isA<FeatureCliParseFailure>());
    });

    test('rejects unsupported flags', () {
      final result = parseFeatureCliArgs(['profile', '--unknown']);

      expect(result, isA<FeatureCliParseFailure>());
    });
  });

  group('buildFeatureFiles', () {
    test('includes all Clean Architecture layers', () {
      const options = FeatureCliOptions(featureName: 'profile');
      final files = buildFeatureFiles(options);

      expect(
        files.keys,
        containsAll(<String>[
          'lib/features/profile/data/datasources/profile_remote_data_source.dart',
          'lib/features/profile/data/models/profile_model.dart',
          'lib/features/profile/data/repositories/profile_repository_impl.dart',
          'lib/features/profile/data/repositories/profile_repository_provider.dart',
          'lib/features/profile/domain/entities/profile.dart',
          'lib/features/profile/domain/repositories/profile_repository.dart',
          'lib/features/profile/domain/usecases/get_profile_usecase.dart',
          'lib/features/profile/presentation/controllers/profile_controller.dart',
          'lib/features/profile/presentation/pages/profile_page.dart',
          'lib/features/profile/presentation/widgets/profile_content.dart',
          'test/features/profile/get_profile_usecase_test.dart',
        ]),
      );
    });

    test('keeps generated code on the approved stack', () {
      const options = FeatureCliOptions(featureName: 'profile');
      final generatedCode = buildFeatureFiles(options).values.join('\n');

      expect(generatedCode, isNot(contains('GetX')));
      expect(generatedCode, isNot(contains('GetIt')));
      expect(generatedCode, isNot(contains('Bloc')));
      expect(generatedCode, isNot(contains('Cubit')));
      expect(generatedCode, contains('@riverpod'));
      expect(generatedCode, contains('Dio _dio'));
    });

    test('default page preserves simple title behavior', () {
      const options = FeatureCliOptions(featureName: 'profile');
      final page = buildFeatureFiles(
        options,
      )['lib/features/profile/presentation/pages/profile_page.dart'];

      expect(page, contains("const Text('Profile')"));
      expect(page, isNot(contains('context.l10n.profileTitle')));
    });

    test('localization mode adds guidance without breaking analysis', () {
      const options = FeatureCliOptions(
        featureName: 'profile',
        withLocalization: true,
      );
      final page = buildFeatureFiles(
        options,
      )['lib/features/profile/presentation/pages/profile_page.dart'];

      expect(page, contains('TODO(profile)'));
      expect(page, contains('Text(context.l10n.profileTitle)'));
      expect(page, contains("const Text('Profile')"));
      expect(page, isNot(contains('app_localizations_x.dart')));
    });

    test('datasource fails clearly when response body is missing', () {
      const options = FeatureCliOptions(featureName: 'profile');
      final datasource = buildFeatureFiles(
        options,
      )['lib/features/profile/data/datasources/profile_remote_data_source.dart'];

      expect(datasource, contains('Missing Profile response body'));
      expect(
        datasource,
        isNot(contains('response.data ?? <String, dynamic>{}')),
      );
    });
  });

  group('buildNextSteps', () {
    test('includes route, localization, and story guidance when requested', () {
      const options = FeatureCliOptions(
        featureName: 'profile',
        withRoute: true,
        withLocalization: true,
        withStory: true,
      );
      final output = buildNextSteps(options);

      expect(output, contains('RouteNames.profile'));
      expect(output, contains("'/profile'"));
      expect(output, contains('profileTitle'));
      expect(output, contains('docs/templates/story.md'));
    });
  });

  group('route registration', () {
    const options = FeatureCliOptions(featureName: 'user_profile');

    const routeNamesSource =
        '''
class RouteNames {
  const RouteNames._();

  static const home = 'home';

  $routeNamesAnchor
}
''';

    const routerSource =
        '''
import '../../features/settings/presentation/pages/settings_page.dart';
$routerImportsAnchor
import 'route_names.dart';

GoRouter appRouter(Ref ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/settings',
        name: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      $routerRoutesAnchor
    ],
  );
}
''';

    test('inserts route-name constants at the anchor', () {
      final result = registerRouteName(routeNamesSource, options);

      expect(result, contains("static const userProfile = 'userProfile';"));
      expect(
        result,
        contains("static const userProfilePath = '/user_profile';"),
      );
      expect(result, contains(routeNamesAnchor));
    });

    test('inserts the page import and a GoRoute into the router', () {
      final withRoute = registerRouterRoute(routerSource, options);
      final result = registerRouteImport(withRoute, options);

      expect(result, contains('import '));
      expect(
        result,
        contains('/presentation/pages/user_profile_page.dart'),
      );
      expect(result, contains('path: RouteNames.userProfilePath,'));
      expect(result, contains('name: RouteNames.userProfile,'));
      expect(
        result,
        contains('builder: (context, state) => const UserProfilePage(),'),
      );
      expect(result, contains(routerRoutesAnchor));
    });

    test('is idempotent when the route is already registered', () {
      final once = registerRouteName(routeNamesSource, options);
      final twice = registerRouteName(once, options);

      expect(twice, once);
      expect('userProfile ='.allMatches(twice).length, 1);
    });

    test('returns source unchanged when the anchor is missing', () {
      const withoutAnchor = 'class RouteNames {}\n';

      expect(registerRouteName(withoutAnchor, options), withoutAnchor);
      expect(registerRouterRoute(withoutAnchor, options), withoutAnchor);
      expect(registerRouteImport(withoutAnchor, options), withoutAnchor);
    });
  });
}
