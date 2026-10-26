import 'package:flutter/material.dart';

import '../palette.dart';

/// "Slide to send": for actions that can't be undone. Dragging the knob to
/// the end confirms; letting go earlier springs it back. Screen readers get a
/// plain button with the same label.
class KitSlideToConfirm extends StatefulWidget {
  const KitSlideToConfirm({super.key, required this.label, required this.onConfirmed, this.enabled = true, this.busy = false});

  final String label;
  final VoidCallback onConfirmed;
  final bool enabled;

  /// Shows a spinner on the knob while the action runs.
  final bool busy;

  @override
  State<KitSlideToConfirm> createState() => _KitSlideToConfirmState();
}

class _KitSlideToConfirmState extends State<KitSlideToConfirm> with SingleTickerProviderStateMixin {
  static const double _height = 64;
  static const double _knob = 52;
  static const double _pad = 6;

  /// How far the knob is, 0 to 1.
  double _progress = 0;
  late final AnimationController _spring = AnimationController(vsync: this, duration: const Duration(milliseconds: 260))
    ..addListener(() => setState(() => _progress = _from * (1 - Curves.easeOutCubic.transform(_spring.value))));
  double _from = 0;

  @override
  void didUpdateWidget(KitSlideToConfirm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.busy && !widget.busy) {
      _reset();
    }
  }

  @override
  void dispose() {
    _spring.dispose();
    super.dispose();
  }

  bool get _active => widget.enabled && !widget.busy;

  void _reset() {
    _from = _progress;
    _spring.forward(from: 0);
  }

  void _end() {
    if (_progress >= 0.92) {
      setState(() => _progress = 1);
      widget.onConfirmed();
    } else {
      _reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    return LayoutBuilder(
      builder: (context, constraints) {
        final travel = constraints.maxWidth - _knob - _pad * 2;
        return Semantics(
          button: true,
          enabled: _active,
          label: widget.label,
          excludeSemantics: true,
          onTap: _active ? widget.onConfirmed : null,
          child: Opacity(
            opacity: widget.enabled ? 1 : 0.5,
            child: Container(
              height: _height,
              decoration: BoxDecoration(
                color: p.tile,
                borderRadius: BorderRadius.circular(_height / 2),
                border: Border.all(color: p.hairline, width: 0.5),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(left: _knob + _pad),
                      child: Center(
                        child: Opacity(
                          opacity: (1 - _progress * 1.6).clamp(0.0, 1.0),
                          child: Text(widget.label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: p.secondary)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: _pad + travel * _progress,
                    child: GestureDetector(
                      key: const Key('kit-slide-knob'),
                      onHorizontalDragUpdate: _active
                          ? (d) => setState(() {
                                _spring.stop();
                                _progress = (_progress + d.delta.dx / travel).clamp(0.0, 1.0);
                              })
                          : null,
                      onHorizontalDragEnd: _active ? (_) => _end() : null,
                      child: Container(
                        width: _knob,
                        height: _knob,
                        decoration: BoxDecoration(color: p.accentText, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: widget.busy
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2.2, color: p.isDark ? Colors.black : Colors.white),
                              )
                            : Icon(Icons.arrow_forward_rounded, color: p.isDark ? Colors.black : Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
