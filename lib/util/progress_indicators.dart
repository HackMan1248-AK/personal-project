import 'dart:ui';
import 'package:flutter/material.dart';

class CircleProgressIndicator extends StatelessWidget {
  final int current;
  final int total;
  final double size;
  final Color color;

  const CircleProgressIndicator({
    Key? key,
    required this.current,
    required this.total,
    this.size = 80,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = current / total;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 5,
              ),
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.12),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: CircularProgressPainter(
                progress: progress,
                color: color,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                current.toString(),
                style: TextStyle(
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                '${total.toString()} XP',
                style: TextStyle(fontSize: size * 0.15, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircularProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0.7), color],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * 3.14159 / 180,
      360 * progress * 3.14159 / 180,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class XPProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final String label;

  const XPProgressBar({
    Key? key,
    required this.current,
    required this.total,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = current / total;
    final primary = Theme.of(context).colorScheme.primary;

    return ClipRect(
      clipBehavior: Clip.none,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.0,
                  colors: [
                    const Color(0xFF34C759).withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: RadialGradient(
                  center: Alignment.bottomRight,
                  radius: 1.0,
                  colors: [
                    const Color(0xFF30D158).withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFF34C759).withValues(alpha: 0.08),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    CircleProgressIndicator(
                      current: current,
                      total: total,
                      size: 80,
                      color: primary,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${total - current} XP to next level',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.08,
                              ),
                              valueColor: AlwaysStoppedAnimation(primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
