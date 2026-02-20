import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class GoldShineText extends StatefulWidget {
  const GoldShineText(this.text, {super.key, this.size = 52});

  final String text;
  final double size;

  @override
  State<GoldShineText> createState() => _GoldShineTextState();
}

class _GoldShineTextState extends State<GoldShineText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  late final Animation<double> _x = Tween<double>(
    begin: -1.2,
    end: 1.2,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  TextStyle _base({Paint? fg, Color? color, List<Shadow>? shadows}) =>
      TextStyle(
        fontSize: widget.size,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5,
        foreground: fg,
        color: color,
        shadows: shadows,
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // bordo esterno
        Text(
          widget.text,
          style: _base(
            fg: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 7
              ..color = const Color(0xFF6A4B00),
          ),
        ),

        // bordo interno
        Text(
          widget.text,
          style: _base(
            fg: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3.2
              ..color = const Color(0xFFE7C44A),
          ),
        ),

        // riempimento oro
        Text(
          widget.text,
          style: _base(
            fg: Paint()
              ..shader = ui.Gradient.linear(
                const Offset(0, 0),
                Offset(0, widget.size * 1.5),
                const [
                  Color(0xFFFFFDE7),
                  Color(0xFFFFF3A6),
                  Color(0xFFFFD54F),
                  Color(0xFFF4B400),
                  Color(0xFFC98A00),
                ],
                const [0.00, 0.18, 0.45, 0.72, 1.00],
              ),
            shadows: const [
              Shadow(color: Color(0xAAFFF59D), blurRadius: 12),
              Shadow(
                color: Color(0x55000000),
                offset: Offset(0, 2),
                blurRadius: 3,
              ),
            ],
          ),
        ),

        // shine animato che scorre
        AnimatedBuilder(
          animation: _x,
          builder: (_, __) {
            return ShaderMask(
              blendMode: BlendMode.srcIn, // <- chiave: niente bianco statico
              shaderCallback: (rect) {
                final dx = rect.width * _x.value;
                return ui.Gradient.linear(
                  Offset(dx - rect.width * 0.18, 0),
                  Offset(dx + rect.width * 0.18, 0),
                  const [
                    Color(0x00FFFFFF),
                    Color(0xF5FFFFFF),
                    Color(0x00FFFFFF),
                  ],
                  const [0.0, 0.5, 1.0],
                );
              },
              child: Text(widget.text, style: _base(color: Colors.white)),
            );
          },
        ),
      ],
    );
  }
}
