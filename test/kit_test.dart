import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shine_kit/shine_kit.dart';

Widget host(Widget child, {KitAccent brand = KitAccent.myShine, Brightness brightness = Brightness.light}) => MaterialApp(
      theme: kitTheme(brand, brightness),
      home: Scaffold(body: Center(child: Padding(padding: const EdgeInsets.all(20), child: child))),
    );

void main() {
  group('theme', () {
    test('each app gets its own accent on the same calm base', () {
      final my = kitTheme(KitAccent.myShine, Brightness.light).extension<KitPalette>()!;
      final dr = kitTheme(KitAccent.drShine, Brightness.light).extension<KitPalette>()!;

      expect(my.accentText, const Color(0xFF12787C));
      expect(dr.accentText, const Color(0xFF5364A3));
      expect(my.tile, dr.tile);
      expect(my.ink, dr.ink);
    });

    test('dark mode swaps the base and keeps the accent readable', () {
      final dark = kitTheme(KitAccent.drShine, Brightness.dark);
      final p = dark.extension<KitPalette>()!;

      expect(p.isDark, isTrue);
      expect(dark.scaffoldBackgroundColor, const Color(0xFF000000));
      expect(p.accentText, const Color(0xFFAAB1DA));
    });
  });

  group('slide to confirm', () {
    Future<List<int>> pumpSlider(WidgetTester tester, {bool enabled = true}) async {
      final calls = <int>[];
      await tester.pumpWidget(host(SizedBox(width: 340, child: KitSlideToConfirm(label: 'Slide to send', enabled: enabled, onConfirmed: () => calls.add(1)))));
      return calls;
    }

    testWidgets('sliding all the way confirms once', (tester) async {
      final calls = await pumpSlider(tester);

      await tester.drag(find.byKey(const Key('kit-slide-knob')), const Offset(400, 0));
      await tester.pumpAndSettle();

      expect(calls, [1]);
    });

    testWidgets('letting go halfway springs back without confirming', (tester) async {
      final calls = await pumpSlider(tester);
      final start = tester.getTopLeft(find.byKey(const Key('kit-slide-knob')));

      await tester.drag(find.byKey(const Key('kit-slide-knob')), const Offset(120, 0));
      await tester.pumpAndSettle();

      expect(calls, isEmpty);
      expect(tester.getTopLeft(find.byKey(const Key('kit-slide-knob'))), start);
    });

    testWidgets('a disabled slider does nothing', (tester) async {
      final calls = await pumpSlider(tester, enabled: false);

      await tester.drag(find.byKey(const Key('kit-slide-knob')), const Offset(400, 0));
      await tester.pumpAndSettle();

      expect(calls, isEmpty);
    });

    testWidgets('screen readers get a plain button with the same label', (tester) async {
      final handle = tester.ensureSemantics();
      final calls = await pumpSlider(tester);

      expect(find.bySemanticsLabel('Slide to send'), findsOneWidget);
      tester.semantics.tap(find.semantics.byLabel('Slide to send'));
      expect(calls, [1]);
      handle.dispose();
    });
  });

  testWidgets('the tab bar names only the chosen tab and reports taps', (tester) async {
    var chosen = 0;
    await tester.pumpWidget(host(StatefulBuilder(
      builder: (context, setState) => KitTabBar(
        index: chosen,
        onSelect: (i) => setState(() => chosen = i),
        tabs: const [
          KitTab(icon: Icons.today_rounded, label: 'Today'),
          KitTab(icon: Icons.calendar_month_rounded, label: 'Schedule'),
          KitTab(icon: Icons.chat_bubble_outline_rounded, label: 'Messages', dot: true),
        ],
      ),
    )));

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Schedule'), findsNothing);

    await tester.tap(find.byIcon(Icons.calendar_month_rounded));
    await tester.pumpAndSettle();

    expect(chosen, 1);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Today'), findsNothing);
  });

  testWidgets('a number tile reads as one sentence', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(host(const KitStat(icon: Icons.timer_outlined, label: 'Worn yesterday', value: '21:40', unit: 'h')));

    expect(find.bySemanticsLabel('Worn yesterday: 21:40 h'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('a busy button cannot be pressed twice', (tester) async {
    var presses = 0;
    await tester.pumpWidget(host(KitButton(label: 'Connect', busy: true, onPressed: () => presses++)));

    await tester.tap(find.byType(KitButton));
    expect(presses, 0);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  test('the arch is symmetric, small teeth in front and bigger ones at the back', () {
    final teeth = ArchPainter.teeth();

    expect(teeth, hasLength(ArchPainter.teethCount));
    expect(teeth.first.center.dx + teeth.last.center.dx, closeTo(320, 0.01));
    expect(teeth.first.rx, greaterThan(teeth[teeth.length ~/ 2].rx));
  });

  testWidgets('the hero paints in both apps and both modes', (tester) async {
    for (final brand in [KitAccent.myShine, KitAccent.drShine]) {
      for (final mode in Brightness.values) {
        await tester.pumpWidget(host(const KitArchHero(), brand: brand, brightness: mode));
        expect(find.bySemanticsLabel('A clear Shine aligner'), findsOneWidget);
      }
    }
  });
}
