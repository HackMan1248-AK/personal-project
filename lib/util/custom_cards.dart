import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(20);

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: radius,
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 2,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class QuestCard extends StatelessWidget {
  final String title;
  final String category;
  final String? timeRange;
  final int difficulty;
  final int intensity;
  final int progress;
  final int total;
  final Color categoryColor;
  final Color borderColor;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final String? dueStatus;
  final bool completed;
  final VoidCallback? onComplete;

  const QuestCard({
    Key? key,
    required this.title,
    required this.category,
    this.timeRange,
    required this.difficulty,
    required this.intensity,
    required this.progress,
    required this.total,
    required this.categoryColor,
    required this.borderColor,
    required this.completed,
    this.onTap,
    this.onComplete,
    this.onDelete,
    this.dueStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: onComplete,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: completed ? borderColor : Colors.transparent,
                            border: Border.all(color: borderColor, width: 2),
                          ),
                          child: completed
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.black,
                                )
                              : null,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: completed ? Colors.white38 : Colors.white,
                            decoration: completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),

                      if (onDelete != null)
                        GestureDetector(
                          onTap: onDelete,
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.white24,
                            size: 20,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: borderColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: borderColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "⭐ $difficulty",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "⚡ $intensity",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  if (timeRange != null)
                    Text(
                      timeRange!,
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),

                  const SizedBox(height: 14),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: total == 0 ? 0 : progress / total,
                      minHeight: 4,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation(borderColor),
                    ),
                  ),

                  if (dueStatus != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      dueStatus!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: dueStatus!.contains("DUE")
                            ? Colors.redAccent
                            : Colors.white38,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // if (onDelete != null)
            //   Positioned(
            //     top: 16,
            //     right: 16,
            //     child: GestureDetector(
            //       onTap: onDelete,
            //       child: Icon(
            //         Icons.delete_outline,
            //         size: 18,
            //         color: Colors.grey[500],
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}

class AttributeCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const AttributeCard({
    Key? key,
    required this.label,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.2,
            colors: [color.withValues(alpha: 0.25), Colors.transparent],
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            LinearProgressIndicator(
              value: value / 100,
              minHeight: 4,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation(color),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TomeCard extends StatelessWidget {
  final String title;
  final int topicCount;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TomeCard({
    Key? key,
    required this.title,
    required this.topicCount,
    required this.backgroundColor,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                backgroundColor.withValues(alpha: 0.25),
                backgroundColor.withValues(alpha: 0.12),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$topicCount topics',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: Colors.white60,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopicCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? tutorLabel;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TopicCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.tutorLabel,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 30, 26, 65),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                title.substring(0, 1),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          if (tutorLabel != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, size: 14, color: Colors.black),
                  SizedBox(width: 6),
                  Text(
                    tutorLabel!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          if (onDelete != null) ...[
            SizedBox(width: 12),
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.delete_outline,
                size: 18,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
