// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:dubaothoitiet_ck_ltnc/app.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherApp());
    expect(find.byType(WeatherApp), findsOneWidget);
  });
}