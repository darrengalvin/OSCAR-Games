import 'package:flutter_test/flutter_test.dart';
import 'package:oscar_games/main.dart';

void main() {
  testWidgets('App launches and shows home screen', (tester) async {
    await tester.pumpWidget(const OscarGamesApp());
    expect(find.text('OSCAR'), findsOneWidget);
    expect(find.text('GAME CENTER'), findsOneWidget);
  });
}
