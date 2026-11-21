import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfeed/main.dart';

void main() {
  testWidgets('login screen renders PawFeed entry screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PawFeedApp()));

    expect(find.text('Selamat datang kembali'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Koneksi terenkripsi. Kredensial perangkat tidak pernah ditampilkan.'), findsOneWidget);
  });
}
