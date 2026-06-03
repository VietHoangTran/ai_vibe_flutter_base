import 'package:ai_vibe_flutter_base/shared/widgets/pressable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Pressable invokes onTap when tapped', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Pressable(
              onTap: () => taps++,
              child: const SizedBox(
                width: 100,
                height: 100,
                child: Text('tap'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('tap'));
    await tester.pumpAndSettle();

    expect(taps, 1);
  });
}
