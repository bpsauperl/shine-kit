import 'package:flutter/material.dart';

import '../palette.dart';
import '../theme.dart';

/// A white tile on the grey page. Tappable when [onTap] is set.
class KitTile extends StatelessWidget {
  const KitTile({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(16), this.color, this.radius});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? KitSize.tileRadius));
    return Material(
      color: color ?? context.kit.tile,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: Padding(padding: padding, child: child)),
    );
  }
}

/// A number tile: small icon and label, then the number large ("21:40").
class KitStat extends StatelessWidget {
  const KitStat({super.key, required this.icon, required this.label, required this.value, this.unit, this.onTap, this.inset = false});

  final IconData icon;
  final String label;
  final String value;
  final String? unit;
  final VoidCallback? onTap;

  /// Inside a white panel the tile is grey instead of white.
  final bool inset;

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    return Semantics(
      label: '$label: $value${unit != null ? ' $unit' : ''}',
      excludeSemantics: true,
      button: onTap != null,
      child: KitTile(
        onTap: onTap,
        color: inset ? p.inset : p.tile,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                KitIconBadge(icon: icon, size: 26),
                const SizedBox(width: 8),
                Flexible(child: Text(label, style: KitType.label(color: p.secondary), overflow: TextOverflow.ellipsis)),
              ],
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: value, style: KitType.number(color: p.ink)),
                  if (unit != null) TextSpan(text: ' $unit', style: KitType.label(color: p.secondary).copyWith(fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// An accent icon on a pale rounded square.
class KitIconBadge extends StatelessWidget {
  const KitIconBadge({super.key, required this.icon, this.size = 40});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: p.accentSoft, borderRadius: BorderRadius.circular(size * 0.3)),
      alignment: Alignment.center,
      child: Icon(icon, size: size * 0.58, color: p.accentText),
    );
  }
}

enum KitButtonKind { primary, secondary, accent }

/// A full-width pill: black primary, white secondary, or the brand colour.
class KitButton extends StatelessWidget {
  const KitButton({super.key, required this.label, required this.onPressed, this.icon, this.trailingIcon, this.kind = KitButtonKind.primary, this.busy = false, this.height = KitSize.buttonHeight});

  const KitButton.secondary({super.key, required this.label, required this.onPressed, this.icon, this.trailingIcon, this.busy = false, this.height = KitSize.buttonHeight})
      : kind = KitButtonKind.secondary;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final KitButtonKind kind;
  final bool busy;
  final double height;

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    final (Color bg, Color fg, BorderSide side) = switch (kind) {
      KitButtonKind.primary => (p.ink, p.isDark ? Colors.black : Colors.white, BorderSide.none),
      KitButtonKind.secondary => (p.tile, p.ink, BorderSide(color: p.hairline, width: 0.5)),
      KitButtonKind.accent => (p.isDark ? p.accentText : p.accentText, p.isDark ? Colors.black : Colors.white, BorderSide.none),
    };
    final enabled = onPressed != null && !busy;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: TextButton(
        onPressed: enabled ? onPressed : null,
        style: TextButton.styleFrom(
          backgroundColor: enabled ? bg : p.hairline.withValues(alpha: 0.6),
          foregroundColor: fg,
          disabledForegroundColor: p.secondary,
          shape: StadiumBorder(side: side),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.2),
        ),
        child: busy
            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.2, color: fg))
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
                  Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
                  if (trailingIcon != null) ...[const SizedBox(width: 8), Icon(trailingIcon, size: 18)],
                ],
              ),
      ),
    );
  }
}

/// A round 44 pt button: back, close, more, notifications. Needs a [label]
/// for screen readers.
class KitRoundButton extends StatelessWidget {
  const KitRoundButton({super.key, required this.icon, required this.label, required this.onPressed, this.dot = false, this.size = KitSize.touch});

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  /// A small accent dot, for something new.
  final bool dot;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: p.tile,
        shape: CircleBorder(side: BorderSide(color: p.hairline, width: 0.5)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, size: size * 0.45, color: p.ink),
                if (dot)
                  Positioned(
                    top: size * 0.22,
                    right: size * 0.24,
                    child: Container(width: 8, height: 8, decoration: BoxDecoration(color: p.accentText, shape: BoxShape.circle)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Eyebrow, big title with an optional grey second line, then quiet body text.
class KitHeadline extends StatelessWidget {
  const KitHeadline({super.key, this.eyebrow, required this.title, this.muted, this.body, this.size = 46});

  final String? eyebrow;
  final String title;

  /// Shown after the title in grey: "Your smile," + "revealed."
  final String? muted;
  final String? body;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[Text(eyebrow!, style: KitType.eyebrow(color: p.accentText)), const SizedBox(height: 10)],
        Semantics(
          header: true,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: title),
                if (muted != null) TextSpan(text: '\n$muted', style: TextStyle(color: p.tertiary.withValues(alpha: 0.85))),
              ],
            ),
            style: KitType.display(size, color: p.ink),
          ),
        ),
        if (body != null) ...[const SizedBox(height: 14), Text(body!, style: KitType.body(color: p.secondary))],
      ],
    );
  }
}

/// An inset group of rows on one white tile, separated by hairlines.
class KitListGroup extends StatelessWidget {
  const KitListGroup({super.key, required this.children, this.title});

  final List<Widget> children;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(padding: const EdgeInsets.fromLTRB(4, 0, 4, 8), child: Text(title!, style: KitType.eyebrow(color: p.secondary))),
        KitTile(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1) Divider(height: 0.5, thickness: 0.5, indent: 52, color: p.hairline.withValues(alpha: 0.6)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// One row: icon, title and detail, a state on the right, and a chevron.
class KitListRow extends StatelessWidget {
  const KitListRow({super.key, required this.title, this.icon, this.detail, this.state, this.highlight = false, this.onTap, this.leading});

  final String title;
  final IconData? icon;
  final Widget? leading;
  final String? detail;
  final String? state;

  /// Accent colour for the icon and state: the step that needs you.
  final bool highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    final tone = highlight ? p.accentText : p.secondary;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 58),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 14)] else if (icon != null) ...[
                SizedBox(width: 22, child: Icon(icon, size: 21, color: highlight ? p.accentText : p.tertiary)),
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.2, color: p.ink)),
                    if (detail != null) ...[const SizedBox(height: 2), Text(detail!, style: TextStyle(fontSize: 13, color: p.secondary))],
                  ],
                ),
              ),
              if (state != null) ...[const SizedBox(width: 8), Text(state!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tone))],
              if (onTap != null) ...[const SizedBox(width: 6), Icon(Icons.chevron_right_rounded, size: 20, color: p.tertiary.withValues(alpha: 0.7))],
            ],
          ),
        ),
      ),
    );
  }
}

/// A white panel that rises over the hero with rounded top corners.
class KitPanel extends StatelessWidget {
  const KitPanel({super.key, required this.child, this.padding = const EdgeInsets.fromLTRB(16, 10, 16, 0)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    return Container(
      decoration: BoxDecoration(
        color: p.tile,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(KitSize.panelRadius)),
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 5,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(color: p.hairline.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(3)),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

/// The two-part wordmark: "my" or "dr" in the accent, "Shine" in ink.
class KitWordmark extends StatelessWidget {
  const KitWordmark({super.key, required this.prefix, this.word = 'Shine', this.size = 20});

  final String prefix;
  final String word;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    return Semantics(
      label: '$prefix$word',
      excludeSemantics: true,
      child: Text.rich(
        TextSpan(children: [
          TextSpan(text: prefix, style: TextStyle(color: p.accentText)),
          TextSpan(text: word, style: TextStyle(color: p.ink)),
        ]),
        style: TextStyle(fontSize: size, fontWeight: FontWeight.w700, letterSpacing: size * -0.03),
      ),
    );
  }
}
