import 'package:flutter/material.dart';

/// The one accent an app uses: Shine teal for myShine, indigo for drShine.
/// Everything else is white, light grey and near-black ink.
@immutable
class KitAccent {
  const KitAccent({
    required this.name,
    required this.accent,
    required this.accentText,
    required this.accentSoft,
    required this.ground,
    required this.accentDark,
    required this.accentSoftDark,
  });

  final String name;

  /// The brand colour itself: dots, rings, the knob of "slide to send".
  final Color accent;

  /// The accent dark enough for text and icons on white (4.5:1 or better).
  final Color accentText;

  /// A pale wash behind accent icons.
  final Color accentSoft;

  /// The page background in light mode.
  final Color ground;

  /// The accent for text and icons in dark mode.
  final Color accentDark;
  final Color accentSoftDark;

  static const KitAccent myShine = KitAccent(
    name: 'myShine',
    accent: Color(0xFF83C9CB),
    accentText: Color(0xFF12787C),
    accentSoft: Color(0xFFE8F5F5),
    ground: Color(0xFFF5F5F7),
    accentDark: Color(0xFF83C9CB),
    accentSoftDark: Color(0xFF15302F),
  );

  static const KitAccent drShine = KitAccent(
    name: 'drShine',
    accent: Color(0xFF5364A3),
    accentText: Color(0xFF5364A3),
    accentSoft: Color(0xFFE6E9F5),
    ground: Color(0xFFF4F6FA),
    accentDark: Color(0xFFAAB1DA),
    accentSoftDark: Color(0xFF262B40),
  );
}

/// The colours of one app in one mode, read anywhere with `context.kit`.
@immutable
class KitPalette extends ThemeExtension<KitPalette> {
  const KitPalette({
    required this.isDark,
    required this.ground,
    required this.tile,
    required this.inset,
    required this.ink,
    required this.secondary,
    required this.tertiary,
    required this.hairline,
    required this.accent,
    required this.accentText,
    required this.accentSoft,
    required this.halo,
    required this.danger,
  });

  factory KitPalette.of(KitAccent brand, Brightness brightness) {
    if (brightness == Brightness.dark) {
      return KitPalette(
        isDark: true,
        ground: const Color(0xFF000000),
        tile: const Color(0xFF1C1C1E),
        inset: const Color(0xFF2C2C2E),
        ink: const Color(0xFFF5F5F7),
        secondary: const Color(0xFFA1A1A6),
        tertiary: const Color(0xFF8E8E93),
        hairline: const Color(0xFF38383A),
        accent: brand.accent,
        accentText: brand.accentDark,
        accentSoft: brand.accentSoftDark,
        halo: const Color(0xFF1C1C1E),
        danger: const Color(0xFFFF6961),
      );
    }
    return KitPalette(
      isDark: false,
      ground: brand.ground,
      tile: const Color(0xFFFFFFFF),
      inset: brand.ground,
      ink: const Color(0xFF1D1D1F),
      secondary: const Color(0xFF6E6E73),
      tertiary: const Color(0xFF86868B),
      hairline: const Color(0xFFD2D2D7),
      accent: brand.accent,
      accentText: brand.accentText,
      accentSoft: brand.accentSoft,
      halo: const Color(0xFFFFFFFF),
      danger: const Color(0xFFC0392B),
    );
  }

  final bool isDark;

  /// The page.
  final Color ground;

  /// White tiles on the page.
  final Color tile;

  /// Tiles inside a white panel.
  final Color inset;
  final Color ink;
  final Color secondary;
  final Color tertiary;
  final Color hairline;
  final Color accent;
  final Color accentText;
  final Color accentSoft;

  /// The soft light behind the hero.
  final Color halo;
  final Color danger;

  @override
  KitPalette copyWith({Color? ground, Color? tile, Color? ink, Color? accent, Color? accentText, Color? accentSoft}) {
    return KitPalette(
      isDark: isDark,
      ground: ground ?? this.ground,
      tile: tile ?? this.tile,
      inset: inset,
      ink: ink ?? this.ink,
      secondary: secondary,
      tertiary: tertiary,
      hairline: hairline,
      accent: accent ?? this.accent,
      accentText: accentText ?? this.accentText,
      accentSoft: accentSoft ?? this.accentSoft,
      halo: halo,
      danger: danger,
    );
  }

  @override
  KitPalette lerp(KitPalette? other, double t) {
    if (other == null) {
      return this;
    }
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return KitPalette(
      isDark: t < 0.5 ? isDark : other.isDark,
      ground: mix(ground, other.ground),
      tile: mix(tile, other.tile),
      inset: mix(inset, other.inset),
      ink: mix(ink, other.ink),
      secondary: mix(secondary, other.secondary),
      tertiary: mix(tertiary, other.tertiary),
      hairline: mix(hairline, other.hairline),
      accent: mix(accent, other.accent),
      accentText: mix(accentText, other.accentText),
      accentSoft: mix(accentSoft, other.accentSoft),
      halo: mix(halo, other.halo),
      danger: mix(danger, other.danger),
    );
  }
}

extension KitContext on BuildContext {
  /// The kit's colours for the current app and mode.
  KitPalette get kit => Theme.of(this).extension<KitPalette>() ?? KitPalette.of(KitAccent.myShine, Brightness.light);
}

/// Shared sizes: tiles 20, panels 30, pills fully round.
abstract final class KitSize {
  static const double gutter = 20;
  static const double tileRadius = 20;
  static const double panelRadius = 30;
  static const double gap = 10;
  static const double buttonHeight = 54;
  static const double touch = 44;
}
