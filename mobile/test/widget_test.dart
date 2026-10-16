import 'package:flutter_test/flutter_test.dart';
import 'package:stowise_mobile/main.dart';

void main() {
  testWidgets('mostra o título do app', (tester) async {
    await tester.pumpWidget(const StowiseApp());

    expect(find.text('Stowise'), findsOneWidget);
  });
}
