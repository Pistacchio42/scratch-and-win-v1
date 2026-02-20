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
    duration: const Duration(milliseconds: 3400), // piu lento
  )..repeat();

  // Passaggio piu morbido e meno rapido, poi pausa
  late final Animation<double> _x = Tween<double>(begin: -0.9, end: 1.9).animate(
    CurvedAnimation(
      parent: _c,
      curve: const Interval(0.0, 0.36, curve: Curves.easeInOut),
    ),
  );

  late final Animation<double> _topSweep =
  Tween<double>(begin: -1.0, end: 2.0).animate(_c);

  late final Animation<double> _topPulse = Tween<double>(
    begin: 0.35,
    end: 0.95,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  TextStyle _base({Paint? fg, Color? color, List<Shadow>? shadows}) => TextStyle(
    fontSize: widget.size,
    fontWeight: FontWeight.w900,
    letterSpacing: 0.35,
    foreground: fg,
    color: color,
    shadows: shadows,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          widget.text,
          style: _base(
            fg: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 7
              ..color = const Color(0xFF6A4300),
          ),
        ),
        Text(
          widget.text,
          style: _base(
            fg: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3.4
              ..color = const Color(0xFFE4A91C),
          ),
        ),
        Text(
          widget.text,
          style: _base(
            fg: Paint()
              ..shader = ui.Gradient.linear(
                const Offset(0, 0),
                Offset(0, widget.size * 1.5),
                const [
                  Color(0xFFFFF7CF),
                  Color(0xFFFFE76A),
                  Color(0xFFFFD13D),
                  Color(0xFFE4A91C),
                  Color(0xFFE18A00),
                ],
                const [0.00, 0.20, 0.48, 0.76, 1.00],
              ),
          ),
        ),
        AnimatedBuilder(
          animation: _c,
          builder: (_, __) {
            return ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (rect) {
                final x = rect.width * _topSweep.value;
                final a = _topPulse.value;
                return ui.Gradient.linear(
                  Offset(x - rect.width * 0.20, 0),
                  Offset(x + rect.width * 0.20, 0),
                  [
                    const Color(0x00FF9800),
                    Color.lerp(
                      const Color(0x00FF9800),
                      const Color(0xFFFFA726),
                      a,
                    )!,
                    const Color(0x00FF9800),
                  ],
                  const [0.0, 0.5, 1.0],
                );
              },
              child: Text(widget.text, style: _base(color: Colors.white)),
            );
          },
        ),
        // banda diagonale piu larga e meno rapida
        AnimatedBuilder(
          animation: _x,
          builder: (_, __) {
            return ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (rect) {
                final dx = rect.width * _x.value;
                return ui.Gradient.linear(
                  Offset(dx - rect.width * 0.18, -rect.height * 0.22), // piu larga
                  Offset(dx + rect.width * 0.18, rect.height * 1.18),  // piu larga
                  const [
                    Color(0x00FFFFFF),
                    Color(0x00FFFFFF),
                    Color(0xFFFFFFFF),
                    Color(0xFFFFFFFF),
                    Color(0x00FFFFFF),
                    Color(0x00FFFFFF),
                  ],
                  const [0.0, 0.36, 0.44, 0.56, 0.64, 1.0], // fascia centrale ampia
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
