import 'dart:io';

const _packageName = 'ai_vibe_flutter_base';

const routeNamesPath = 'lib/core/routing/route_names.dart';
const appRouterPath = 'lib/core/routing/app_router.dart';

const routeNamesAnchor = '// feature_cli:route-names';
const routerImportsAnchor = '// feature_cli:router-imports';
const routerRoutesAnchor = '// feature_cli:router-routes';

class FeatureCliOptions {
  const FeatureCliOptions({
    required this.featureName,
    this.dryRun = false,
    this.force = false,
    this.withRoute = false,
    this.withLocalization = false,
    this.withStory = false,
  });

  final String featureName;
  final bool dryRun;
  final bool force;
  final bool withRoute;
  final bool withLocalization;
  final bool withStory;

  String get className => pascalCase(featureName);
  String get camelName => camelCase(featureName);
  String get titleKey => '${camelName}Title';
}

sealed class FeatureCliParseResult {
  const FeatureCliParseResult();
}

class FeatureCliParseSuccess extends FeatureCliParseResult {
  const FeatureCliParseSuccess(this.options);

  final FeatureCliOptions options;
}

class FeatureCliParseHelp extends FeatureCliParseResult {
  const FeatureCliParseHelp();
}

class FeatureCliParseFailure extends FeatureCliParseResult {
  const FeatureCliParseFailure(this.message);

  final String message;
}

String pascalCase(String input) {
  return input
      .split(RegExp(r'[_\-\s]+'))
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase())
      .join();
}

String camelCase(String input) {
  final pascal = pascalCase(input);
  if (pascal.isEmpty) return pascal;
  return pascal[0].toLowerCase() + pascal.substring(1);
}

String snakeCase(String input) {
  final normalized = input.replaceAll(RegExp('[^A-Za-z0-9]+'), '_');
  return normalized
      .replaceAllMapped(
        RegExp('([a-z0-9])([A-Z])'),
        (match) => '${match[1]}_${match[2]}',
      )
      .toLowerCase()
      .replaceAll(RegExp('_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
}

FeatureCliParseResult parseFeatureCliArgs(List<String> args) {
  if (args.isEmpty || args.contains('--help') || args.contains('-h')) {
    return const FeatureCliParseHelp();
  }

  final featureArgs = args.where((arg) => !arg.startsWith('-')).toList();
  if (featureArgs.isEmpty) {
    return const FeatureCliParseFailure('Feature name is required.');
  }

  if (featureArgs.length > 1) {
    return FeatureCliParseFailure(
      'Expected exactly one feature name, got: ${featureArgs.join(', ')}',
    );
  }

  final featureArg = featureArgs.first;

  final unsupportedFlags = args
      .where((arg) => arg.startsWith('-'))
      .where(
        (arg) => !{
          '--dry-run',
          '--force',
          '--with-route',
          '--with-localization',
          '--with-story',
        }.contains(arg),
      )
      .toList();

  if (unsupportedFlags.isNotEmpty) {
    return FeatureCliParseFailure(
      'Unsupported option(s): ${unsupportedFlags.join(', ')}',
    );
  }

  final featureName = snakeCase(featureArg);
  if (featureName.isEmpty ||
      !RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(featureName)) {
    return const FeatureCliParseFailure(
      'Feature name must start with a letter and contain only letters, numbers, or underscores.',
    );
  }

  return FeatureCliParseSuccess(
    FeatureCliOptions(
      featureName: featureName,
      dryRun: args.contains('--dry-run'),
      force: args.contains('--force'),
      withRoute: args.contains('--with-route'),
      withLocalization: args.contains('--with-localization'),
      withStory: args.contains('--with-story'),
    ),
  );
}

Map<String, String> buildFeatureFiles(FeatureCliOptions options) {
  final featureName = options.featureName;
  final className = options.className;
  final camelName = options.camelName;
  final basePath = 'lib/features/$featureName';

  return <String, String>{
    '$basePath/data/datasources/${featureName}_remote_data_source.dart':
        _remoteDataSource(featureName, className),
    '$basePath/data/models/${featureName}_model.dart': _model(
      featureName,
      className,
    ),
    '$basePath/data/repositories/${featureName}_repository_impl.dart':
        _repositoryImpl(featureName, className),
    '$basePath/data/repositories/${featureName}_repository_provider.dart':
        _repositoryProvider(featureName, camelName, className),
    '$basePath/domain/entities/$featureName.dart': _entity(
      featureName,
      className,
    ),
    '$basePath/domain/repositories/${featureName}_repository.dart': _repository(
      featureName,
      className,
    ),
    '$basePath/domain/usecases/get_${featureName}_usecase.dart': _useCase(
      featureName,
      className,
    ),
    '$basePath/presentation/controllers/${featureName}_controller.dart':
        _controller(featureName, camelName, className),
    '$basePath/presentation/pages/${featureName}_page.dart': _page(options),
    '$basePath/presentation/widgets/${featureName}_content.dart': _content(
      featureName,
      className,
    ),
    'test/features/$featureName/get_${featureName}_usecase_test.dart':
        _useCaseTest(featureName, className),
  };
}

String buildNextSteps(FeatureCliOptions options) {
  final featureName = options.featureName;
  final className = options.className;
  final camelName = options.camelName;
  final buffer = StringBuffer()
    ..writeln('\nNext steps:')
    ..writeln('1. flutter pub get')
    ..writeln('2. dart run build_runner build --delete-conflicting-outputs')
    ..writeln('3. Replace TODO($featureName) items with real domain/API logic.')
    ..writeln('4. Add tests required by docs/ai/VALIDATION_MATRIX.md.')
    ..writeln('5. Run scripts/quality_check.sh');

  if (options.withRoute) {
    buffer
      ..writeln('\nRoute (auto-registered with --with-route):')
      ..writeln("  RouteNames.$camelName -> '/$featureName'")
      ..writeln('  Edited route_names.dart and app_router.dart at the')
      ..writeln('  feature_cli anchors. Navigate with')
      ..writeln('  context.pushNamed(RouteNames.$camelName).')
      ..writeln('  Run build_runner so app_router.g.dart picks up the route.');
  } else {
    buffer.writeln(
      '\nRoute guidance: pass --with-route to auto-register the route in '
      'route_names.dart and app_router.dart.',
    );
  }

  if (options.withLocalization) {
    buffer
      ..writeln('\nLocalization keys to add before analyze:')
      ..writeln('- assets/l10n/app_en.arb: "${options.titleKey}": "$className"')
      ..writeln(
        '- assets/l10n/app_vi.arb: "${options.titleKey}": "TODO: $className"',
      )
      ..writeln(
        '- assets/l10n/app_ja.arb: "${options.titleKey}": "TODO: $className"',
      )
      ..writeln('- Run flutter gen-l10n after updating ARB files.');
  } else {
    buffer.writeln(
      '\nLocalization guidance: pass --with-localization for compile-safe l10n TODOs and ARB key suggestions.',
    );
  }

  if (options.withStory) {
    buffer
      ..writeln('\nStory guidance:')
      ..writeln(
        '- Copy docs/templates/story.md to docs/stories/<story-name>.md.',
      )
      ..writeln(
        '- Capture scope, affected layers, validation proof, and open decisions.',
      );
  }

  return buffer.toString();
}

/// Inserts the route-name constants at [routeNamesAnchor].
///
/// Returns [source] unchanged when the constants already exist or the anchor
/// is missing, so re-running the generator is safe and never corrupts a file
/// whose anchor a human removed.
String registerRouteName(String source, FeatureCliOptions options) {
  final camel = options.camelName;
  if (source.contains('static const $camel =')) return source;
  if (!source.contains(routeNamesAnchor)) return source;

  final insertion =
      "  static const $camel = '$camel';\n"
      "  static const ${camel}Path = '/${options.featureName}';\n";
  return source.replaceFirst(
    '  $routeNamesAnchor',
    '$insertion  $routeNamesAnchor',
  );
}

/// Inserts the feature page import at [routerImportsAnchor].
String registerRouteImport(String source, FeatureCliOptions options) {
  final import =
      "import '../../features/${options.featureName}"
      "/presentation/pages/${options.featureName}_page.dart';";
  if (source.contains(import)) return source;
  if (!source.contains(routerImportsAnchor)) return source;

  return source.replaceFirst(
    routerImportsAnchor,
    '$import\n$routerImportsAnchor',
  );
}

/// Inserts a `GoRoute` for the feature at [routerRoutesAnchor].
String registerRouterRoute(String source, FeatureCliOptions options) {
  final camel = options.camelName;
  if (source.contains('name: RouteNames.$camel,')) return source;
  if (!source.contains(routerRoutesAnchor)) return source;

  final route =
      '      GoRoute(\n'
      '        path: RouteNames.${camel}Path,\n'
      '        name: RouteNames.$camel,\n'
      '        builder: (context, state) => const ${options.className}Page(),\n'
      '      ),\n';
  return source.replaceFirst(
    '      $routerRoutesAnchor',
    '$route      $routerRoutesAnchor',
  );
}

void main(List<String> args) {
  final parseResult = parseFeatureCliArgs(args);

  switch (parseResult) {
    case FeatureCliParseHelp():
      _printUsage();
      return;
    case FeatureCliParseFailure(:final message):
      stderr.writeln(message);
      _printUsage();
      exitCode = 64;
      return;
    case FeatureCliParseSuccess(:final options):
      _runGenerator(options);
  }
}

void _runGenerator(FeatureCliOptions options) {
  final files = buildFeatureFiles(options);

  for (final entry in files.entries) {
    final file = File(entry.key);
    if (options.dryRun) {
      stdout.writeln('Would create: ${entry.key}');
      continue;
    }

    if (file.existsSync() && !options.force) {
      stderr.writeln('Skip existing file: ${entry.key}');
      continue;
    }

    file.parent.createSync(recursive: true);
    file.writeAsStringSync(entry.value);
    stdout.writeln('Created: ${entry.key}');
  }

  if (options.withRoute) {
    _registerRoute(options);
  }

  stdout.write(buildNextSteps(options));
}

void _registerRoute(FeatureCliOptions options) {
  if (options.dryRun) {
    stdout.writeln(
      'Would register RouteNames.${options.camelName} in $routeNamesPath '
      'and $appRouterPath.',
    );
    return;
  }

  _applyRouteEdit(
    path: routeNamesPath,
    label: 'route name',
    transform: (source) => registerRouteName(source, options),
  );
  _applyRouteEdit(
    path: appRouterPath,
    label: 'router route',
    transform: (source) =>
        registerRouteImport(registerRouterRoute(source, options), options),
  );
}

void _applyRouteEdit({
  required String path,
  required String label,
  required String Function(String source) transform,
}) {
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('Skip $label: $path not found.');
    return;
  }

  final original = file.readAsStringSync();
  final updated = transform(original);
  if (updated == original) {
    stderr.writeln(
      'Skip $label: anchor missing or route already registered in $path.',
    );
    return;
  }

  file.writeAsStringSync(updated);
  stdout.writeln('Updated $path ($label).');
}

void _printUsage() {
  stdout.writeln('''
Create a Riverpod/Clean Architecture feature skeleton.

Usage:
  dart run tools/feature_cli.dart <feature_name> [--dry-run] [--force] [--with-route] [--with-localization] [--with-story]

Examples:
  dart run tools/feature_cli.dart profile
  dart run tools/feature_cli.dart user_profile --dry-run
  dart run tools/feature_cli.dart profile --with-route --with-localization

Rules:
  - Use snake_case feature names.
  - Generated files follow data/domain/presentation layers.
  - Controllers/providers/models use codegen (@riverpod, freezed);
    run build_runner after generating.
  - Do not put business logic in pages/widgets; use controllers/usecases.
  - With --with-route the generator edits route_names.dart and app_router.dart
    at the feature_cli anchors (re-running is idempotent). ARB, localization
    usage, and story files are not auto-edited.
''');
}

String _entity(String featureName, String className) =>
    '''
import 'package:equatable/equatable.dart';

class $className extends Equatable {
  const $className({
    required this.id,
    required this.name,
  });

  // TODO($featureName): Replace placeholder fields with real domain data.
  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
''';

String _model(String featureName, String className) =>
    '''
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/$featureName.dart';

part '${featureName}_model.freezed.dart';
part '${featureName}_model.g.dart';

@freezed
abstract class ${className}Model with _\$${className}Model {
  const factory ${className}Model({
    required String id,
    required String name,
  }) = _${className}Model;

  const ${className}Model._();

  factory ${className}Model.fromJson(Map<String, dynamic> json) =>
      _\$${className}ModelFromJson(json);

  // TODO($featureName): Map transport fields to the real domain entity.
  $className toEntity() => $className(id: id, name: name);
}
''';

String _repository(String featureName, String className) =>
    '''
import '../entities/$featureName.dart';

abstract interface class ${className}Repository {
  Future<$className> get$className();
}
''';

String _remoteDataSource(String featureName, String className) =>
    '''
import 'package:dio/dio.dart';

import '../models/${featureName}_model.dart';

class ${className}RemoteDataSource {
  const ${className}RemoteDataSource(this._dio);

  final Dio _dio;

  Future<${className}Model> fetch() async {
    // TODO($featureName): Replace endpoint with the real API path.
    final response = await _dio.get<Map<String, dynamic>>('/$featureName');
    final data = response.data;
    if (data == null) {
      throw const FormatException('Missing $className response body');
    }

    return ${className}Model.fromJson(data);
  }
}
''';

String _repositoryImpl(String featureName, String className) =>
    '''
import '../../domain/entities/$featureName.dart';
import '../../domain/repositories/${featureName}_repository.dart';
import '../datasources/${featureName}_remote_data_source.dart';

class ${className}RepositoryImpl implements ${className}Repository {
  const ${className}RepositoryImpl(this._remoteDataSource);

  final ${className}RemoteDataSource _remoteDataSource;

  @override
  Future<$className> get$className() async {
    final model = await _remoteDataSource.fetch();
    return model.toEntity();
  }
}
''';

String _repositoryProvider(
  String featureName,
  String camelName,
  String className,
) =>
    '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_provider.dart';
import '../../domain/repositories/${featureName}_repository.dart';
import '../datasources/${featureName}_remote_data_source.dart';
import '${featureName}_repository_impl.dart';

part '${featureName}_repository_provider.g.dart';

@riverpod
${className}Repository ${camelName}Repository(Ref ref) {
  return ${className}RepositoryImpl(
    ${className}RemoteDataSource(ref.watch(dioProvider)),
  );
}
''';

String _useCase(String featureName, String className) =>
    '''
import '../entities/$featureName.dart';
import '../repositories/${featureName}_repository.dart';

class Get${className}UseCase {
  const Get${className}UseCase(this._repository);

  final ${className}Repository _repository;

  Future<$className> call() => _repository.get$className();
}
''';

String _controller(String featureName, String camelName, String className) =>
    '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/${featureName}_repository_provider.dart';
import '../../domain/entities/$featureName.dart';
import '../../domain/usecases/get_${featureName}_usecase.dart';

part '${featureName}_controller.g.dart';

@riverpod
class ${className}Controller extends _\$${className}Controller {
  @override
  Future<$className> build() {
    final useCase = Get${className}UseCase(ref.watch(${camelName}RepositoryProvider));
    return useCase();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final useCase = Get${className}UseCase(ref.read(${camelName}RepositoryProvider));
      return useCase();
    });
  }
}
''';

String _page(FeatureCliOptions options) {
  final featureName = options.featureName;
  final camelName = options.camelName;
  final className = options.className;
  final localizationTodo = options.withLocalization
      ? '      // TODO($featureName): After adding ${options.titleKey} to all ARB files, replace with Text(context.l10n.${options.titleKey}).\n'
      : '';

  return '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/async_value_view.dart';
import '../controllers/${featureName}_controller.dart';
import '../widgets/${featureName}_content.dart';

class ${className}Page extends ConsumerWidget {
  const ${className}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(${camelName}ControllerProvider);

    return Scaffold(
$localizationTodo      appBar: AppBar(title: const Text('$className')),
      body: AsyncValueView(
        value: state,
        data: ${className}Content.new,
        onRetry: ref.read(${camelName}ControllerProvider.notifier).refresh,
      ),
    );
  }
}
''';
}

String _content(String featureName, String className) =>
    '''
import 'package:flutter/material.dart';

import '../../domain/entities/$featureName.dart';

class ${className}Content extends StatelessWidget {
  const ${className}Content(this.data, {super.key});

  final $className data;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(data.name));
  }
}
''';

String _useCaseTest(String featureName, String className) =>
    '''
import 'package:$_packageName/features/$featureName/domain/entities/$featureName.dart';
import 'package:$_packageName/features/$featureName/domain/repositories/${featureName}_repository.dart';
import 'package:$_packageName/features/$featureName/domain/usecases/get_${featureName}_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class Mock${className}Repository extends Mock implements ${className}Repository {}

void main() {
  test('Get${className}UseCase returns the entity from the repository', () async {
    final repository = Mock${className}Repository();
    const entity = $className(id: '1', name: 'Demo');

    when(repository.get$className).thenAnswer((_) async => entity);

    final useCase = Get${className}UseCase(repository);
    final result = await useCase();

    expect(result, entity);
    verify(repository.get$className).called(1);
  });
}
''';
