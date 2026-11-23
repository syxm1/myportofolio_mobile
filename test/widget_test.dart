import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/widgets/portfolio_date_field.dart';

void main() {
  final formRoutes = <(String, String)>[
    ('Tambah Proyek', 'Add Project Form'),
    ('Tambah Edukasi', 'Tambah Edukasi'),
    ('Tambah Pengalaman', 'Tambah Pengalaman'),
    ('Tambah Sertifikasi', 'Tambah Sertifikasi'),
  ];

  for (final (cardLabel, pageTitle) in formRoutes) {
    testWidgets('$cardLabel opens from its card and returns Home', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      final card = find.text(cardLabel);
      await tester.ensureVisible(card);
      await tester.tap(card);
      await tester.pumpAndSettle();

      expect(find.text(pageTitle), findsOneWidget);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      expect(
        find.text('Selamat datang di MyPortfolio Mobile!'),
        findsOneWidget,
      );
    });
  }

  for (final (drawerLabel, pageTitle) in <(String, String)>[
    ('Add Project', 'Add Project Form'),
    ('Add Education', 'Tambah Edukasi'),
    ('Add Experience', 'Tambah Pengalaman'),
    ('Add Certification', 'Tambah Sertifikasi'),
  ]) {
    testWidgets('$drawerLabel opens from the drawer', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text(drawerLabel));
      await tester.pumpAndSettle();

      expect(find.text(pageTitle), findsOneWidget);
    });
  }

  testWidgets('last action card and save button are reachable on a phone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Tambah Sertifikasi'));
    await tester.tap(find.text('Tambah Sertifikasi'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Simpan'));
    expect(find.text('Simpan'), findsOneWidget);
  });

  testWidgets('certification validates inputs and shows a summary', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Tambah Sertifikasi'));
    await tester.tap(find.text('Tambah Sertifikasi'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Nama sertifikasi wajib diisi'), findsOneWidget);
    expect(find.text('Tanggal terbit wajib diisi'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Flutter Developer');
    await tester.enterText(fields.at(1), 'Dart Institute');
    await tester.enterText(fields.at(2), 'CERT-123');
    await tester.enterText(fields.at(3), 'invalid-url');
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(
      find.text('Masukkan URL http atau https yang valid'),
      findsOneWidget,
    );

    await tester.enterText(fields.at(3), 'https://example.com/cert');
    await tester.ensureVisible(find.byType(PortfolioDateField));
    await tester.tap(find.byType(PortfolioDateField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Ringkasan Sertifikasi'), findsOneWidget);
    expect(find.text('Sertifikasi: Flutter Developer'), findsOneWidget);
    expect(
      find.text('URL Kredensial: https://example.com/cert'),
      findsOneWidget,
    );
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    expect(find.text('Tambah Sertifikasi'), findsOneWidget);
  });
}
