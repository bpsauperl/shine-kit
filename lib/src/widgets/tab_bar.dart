import 'package:flutter/material.dart';

import '../palette.dart';

/// One destination in [KitTabBar].
@immutable
class KitTab {
  const KitTab({required this.icon, required this.label, this.dot = false});

  final IconData icon;
  final String label;

  /// Something new here (unread messages).
  final bool dot;
}

/// The floating pill tab bar. The chosen tab shows its name on a black
/// capsule; the others are icons only.
class KitTabBar extends StatelessWidget {
  const KitTabBar({super.key, required this.tabs, required this.index, required this.onSelect});

  final List<KitTab> tabs;
  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    final onInk = p.isDark ? Colors.black : Colors.white;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Container(
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: p.tile.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(31),
          border: Border.all(color: p.hairline, width: 0.5),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: p.isDark ? 0.4 : 0.06), blurRadius: 24, offset: const Offset(0, 8))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < tabs.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Semantics(
                  button: true,
                  selected: i == index,
                  label: tabs[i].dot ? '${tabs[i].label}, new' : tabs[i].label,
                  excludeSemantics: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onSelect(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      height: 46,
                      padding: EdgeInsets.symmetric(horizontal: i == index ? 16 : 12),
                      decoration: BoxDecoration(color: i == index ? p.ink : Colors.transparent, borderRadius: BorderRadius.circular(23)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(tabs[i].icon, size: 21, color: i == index ? onInk : p.secondary),
                              if (tabs[i].dot && i != index)
                                Positioned(
                                  top: -2,
                                  right: -3,
                                  child: Container(width: 8, height: 8, decoration: BoxDecoration(color: p.accentText, shape: BoxShape.circle)),
                                ),
                            ],
                          ),
                          if (i == index) ...[
                            const SizedBox(width: 6),
                            Text(tabs[i].label, style: TextStyle(color: onInk, fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
