import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations_x.dart';
import '../../../../shared/widgets/async_value_view.dart';
import '../controllers/settings_controller.dart';
import '../widgets/settings_content.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: AsyncValueView(
        value: state,
        data: SettingsContent.new,
      ),
    );
  }
}
