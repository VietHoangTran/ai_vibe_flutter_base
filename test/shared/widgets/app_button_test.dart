import 'package:flutter/material.dart';
import 'package:ai_vibe_flutter_base/shared/widgets/app_button.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppButton calls onPressed when tapped', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Continue',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Continue'));

    expect(tapped, isTrue);
  });
}
