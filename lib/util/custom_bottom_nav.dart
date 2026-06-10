import 'dart:ui';
import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.18),
                width: 0.8,
              ),
            ),
          ),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  label: 'Home',
                  index: 0,
                  currentIndex: currentIndex,
                  onTap: onTap,
                  primary: primary,
                ),
                _NavItem(
                  icon: Icons.format_list_bulleted,
                  label: 'Quests',
                  index: 1,
                  currentIndex: currentIndex,
                  onTap: onTap,
                  primary: primary,
                ),
                _CenterFloatingButton(onTap: () => onTap(2), primary: primary),
                _NavItem(
                  icon: Icons.book_outlined,
                  label: 'Tomes',
                  index: 3,
                  currentIndex: currentIndex,
                  onTap: onTap,
                  primary: primary,
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  label: 'Self',
                  index: 4,
                  currentIndex: currentIndex,
                  onTap: onTap,
                  primary: primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final Function(int) onTap;
  final Color primary;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.55),
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? primary : Colors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterFloatingButton extends StatelessWidget {
  final Function() onTap;
  final Color primary;

  const _CenterFloatingButton({required this.onTap, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
