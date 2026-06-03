import 'dart:io';

String _pascalCase(String input) {
  return input
      .split(RegExp(r'[_\-\s]+'))
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase())
      .join();
}

String _camelCase(String input) {
  final pascal = _pascalCase(input);
  if (pascal.isEmpty) return pascal;
  return pascal[0].toLowerCase() + pascal.substring(1);
}

String _snakeCase(String input) {
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

void main(List<String> args) {
  if (args.isEmpty || args.contains('--help') || args.contains('-h')) {
    _printUsage();
    return;
  }

  final dryRun = args.contains('--dry-run');
  final force = args.contains('--force');
  final featureName = _snakeCase(
    args.firstWhere((arg) => !arg.startsWith('-')),
  );

  if (featureName.isEmpty) {
    stderr.writeln('Feature name is invalid.');
    exitCode = 64;
    return;
  }

  final className = _pascalCase(featureName);
  final camelName = _camelCase(featureName);
  final basePath = 'lib/features/$featureName';
  final files = <String, String>{
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
    '$basePath/domain/entities/$featureName.dart': _entity(className),
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
    '$basePath/presentation/pages/${featureName}_page.dart': _page(
      featureName,
      camelName,
      className,
    ),
    '$basePath/presentation/widgets/${featureName}_content.dart': _content(
      featureName,
      className,
    ),
    'test/features/$featureName/get_${featureName}_usecase_test.dart':
        _useCaseTest(featureName, className),
  };

  for (final entry in files.entries) {
    final file = File(entry.key);
    if (dryRun) {
      stdout.writeln('Would create: ${entry.key}');
      continue;
    }

    if (file.existsSync() && !force) {
      stderr.writeln('Skip existing file: ${entry.key}');
      continue;
    }

    file.parent.createSync(recursive: true);
    file.writeAsStringSync(entry.value);
    stdout.writeln('Created: ${entry.key}');
  }

  if (!dryRun) {
    stdout
      ..writeln('\nNext steps:')
      ..writeln('1. flutter pub get')
      ..writeln('2. dart run build_runner build --delete-conflicting-outputs')
      ..writeln('3. dart analyze --fatal-infos --fatal-warnings')
      ..writeln(
        '4. Register a route in lib/core/routing/app_router.dart '
        'if this feature has a page.',
      )
      ..writeln('5. Replace TODOs with real API/domain logic.');
  }
}

void _printUsage() {
  stdout.writeln('''
Create a Riverpod/Clean Architecture feature skeleton.

Usage:
  dart run tools/feature_cli.dart <feature_name> [--dry-run] [--force]

Examples:
  dart run tools/feature_cli.dart profile
  dart run tools/feature_cli.dart user_profile --dry-run

Rules:
  - Use snake_case feature names.
  - Generated files follow data/domain/presentation layers.
  - Controllers/providers/models use codegen (@riverpod, freezed);
    run build_runner after generating.
  - Do not put business logic in pages/widgets; use controllers/usecases.
''');
}

String _entity(String className) =>
    '''
import 'package:equatable/equatable.dart';

class $className extends Equatable {
  const $className({
    required this.id,
    required this.name,
  });

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
    return ${className}Model.fromJson(response.data ?? <String, dynamic>{});
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

String _page(String featureName, String camelName, String className) =>
    '''
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
      appBar: AppBar(title: const Text('$className')),
      body: AsyncValueView(
        value: state,
        data: ${className}Content.new,
      ),
    );
  }
}
''';

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
import 'package:ai_vibe_flutter_base/features/$featureName/domain/entities/$featureName.dart';
import 'package:ai_vibe_flutter_base/features/$featureName/domain/repositories/${featureName}_repository.dart';
import 'package:ai_vibe_flutter_base/features/$featureName/domain/usecases/get_${featureName}_usecase.dart';
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
