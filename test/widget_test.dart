import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/screens/login_screen.dart'; // Projenizin ana dosyasını buraya dahil edin.

void main() {
  testWidgets('Login screen renders correctly', (WidgetTester tester) async {
    // LoginScreen widget'ını oluştur.
    await tester.pumpWidget(MaterialApp(
      home: LoginScreen(),  // key parametresi olmadan widget oluşturuluyor
    ));

    // 'Giriş Yap' yazısının varlığını test et.
    expect(find.text('Giriş Yap'), findsOneWidget);
  });
}
