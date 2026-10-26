import 'package:flutter/material.dart';

import 'palette.dart';

/// Type: Inter for text, Inter Display for the big headlines and numbers.
/// Both ship inside the kit (SIL Open Font License, fonts/Inter-LICENSE.txt).
abstract final class KitType {
  static const String text = 'packages/shine_kit/Inter';
  static const String displayFamily = 'packages/shine_kit/InterDisplay';

  /// Hero numbers and headlines: "Aligner 04/08", "€100".
  static TextStyle display(double size, {Color? color}) => TextStyle(
        fontFamily: displayFamily,
        fontSize: size,
        fontWeight: FontWeight.w800,
        letterSpacing: size * -0.04,
        height: 0.98,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Page titles.
  static TextStyle title({Color? color}) =>
      TextStyle(fontFamily: displayFamily, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -1.1, height: 1.05, color: color);

  /// Numbers inside tiles.
  static TextStyle number({double size = 26, Color? color}) => TextStyle(
        fontFamily: displayFamily,
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: size * -0.04,
        height: 1.1,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// The small coloured line above a headline.
  static TextStyle eyebrow({Color? color}) => TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color);

  static TextStyle body({Color? color}) => TextStyle(fontSize: 15, height: 1.45, color: color);

  static TextStyle label({Color? color}) => TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color);
}

/// The whole app theme for one brand: light grey page, white tiles, pill
/// buttons (black primary, white secondary), the accent only in small places.
ThemeData kitTheme(KitAccent brand, Brightness brightness) {
  final p = KitPalette.of(brand, brightness);
  final scheme = ColorScheme.fromSeed(seedColor: brand.accent, brightness: brightness).copyWith(
    primary: p.accentText,
    onPrimary: p.isDark ? const Color(0xFF000000) : Colors.white,
    primaryContainer: p.accentSoft,
    onPrimaryContainer: p.accentText,
    secondary: p.accent,
    surface: p.tile,
    onSurface: p.ink,
    onSurfaceVariant: p.secondary,
    outline: p.hairline,
    outlineVariant: p.hairline,
    error: p.danger,
  );

  final base = ThemeData(useMaterial3: true, brightness: brightness, colorScheme: scheme, fontFamily: KitType.text, extensions: [p]);
  final text = base.textTheme.apply(bodyColor: p.ink, displayColor: p.ink);
  const pill = StadiumBorder();
  final field = OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: p.hairline, width: 0.5));

  return base.copyWith(
    scaffoldBackgroundColor: p.ground,
    splashFactory: InkSparkle.splashFactory,
    textTheme: text.copyWith(
      displaySmall: text.displaySmall?.copyWith(fontFamily: KitType.displayFamily, fontWeight: FontWeight.w800, letterSpacing: -1.4, height: 1),
      headlineMedium: text.headlineMedium?.copyWith(fontFamily: KitType.displayFamily, fontWeight: FontWeight.w800, letterSpacing: -1.1, height: 1.05),
      headlineSmall: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.8),
      titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5),
      titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600, letterSpacing: -0.2),
      bodyMedium: text.bodyMedium?.copyWith(height: 1.4),
      bodySmall: text.bodySmall?.copyWith(color: p.secondary, height: 1.35),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: p.ground,
      foregroundColor: p.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(color: p.ink, fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: -0.2),
    ),
    cardTheme: CardThemeData(
      color: p.tile,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KitSize.tileRadius)),
    ),
    dividerTheme: DividerThemeData(color: p.hairline, thickness: 0.5, space: 0.5),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: p.ink,
        foregroundColor: p.isDark ? const Color(0xFF000000) : Colors.white,
        disabledBackgroundColor: p.hairline,
        disabledForegroundColor: p.secondary,
        minimumSize: const Size.fromHeight(KitSize.buttonHeight),
        shape: pill,
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.2),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: p.ink,
        backgroundColor: p.tile,
        minimumSize: const Size.fromHeight(KitSize.buttonHeight),
        side: BorderSide(color: p.hairline, width: 0.5),
        shape: pill,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.2),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: p.accentText,
        minimumSize: const Size(KitSize.touch, KitSize.touch),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.tile,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: field,
      enabledBorder: field,
      focusedBorder: field.copyWith(borderSide: BorderSide(color: p.accentText, width: 1.5)),
      labelStyle: TextStyle(color: p.secondary),
      hintStyle: TextStyle(color: p.tertiary),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: p.tile,
      selectedColor: p.ink,
      secondarySelectedColor: p.ink,
      side: BorderSide(color: p.hairline, width: 0.5),
      labelStyle: TextStyle(color: p.ink, fontWeight: FontWeight.w500),
      secondaryLabelStyle: TextStyle(color: p.isDark ? const Color(0xFF000000) : Colors.white, fontWeight: FontWeight.w600),
      shape: pill,
      showCheckmark: false,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        shape: const WidgetStatePropertyAll(pill),
        side: WidgetStatePropertyAll(BorderSide(color: p.hairline, width: 0.5)),
        backgroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? p.ink : p.tile),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? (p.isDark ? const Color(0xFF000000) : Colors.white) : p.ink,
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: p.isDark ? p.inset : p.ink,
      contentTextStyle: TextStyle(color: p.isDark ? p.ink : Colors.white),
      shape: const StadiumBorder(),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: p.accentText, linearTrackColor: p.accentSoft),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: p.tile,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: p.hairline,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(KitSize.panelRadius))),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: p.tile,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KitSize.panelRadius)),
      titleTextStyle: TextStyle(fontFamily: KitType.displayFamily, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.8, color: p.ink),
      contentTextStyle: TextStyle(fontFamily: KitType.text, fontSize: 15, height: 1.45, color: p.secondary),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: p.tile,
      indicatorColor: p.accentSoft,
      elevation: 0,
    ),
  );
}
