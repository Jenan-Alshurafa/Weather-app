import 'package:flutter/material.dart';
import 'glassmorphism_widget.dart';

class NavBarWidget extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onHomeTap;
  final VoidCallback onAddTap;

  const NavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onHomeTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.all(20),
      child: GlassmorphismWidget(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AnimatedNavButton(
                icon: Icons.home,
                isActive: currentIndex == 0,
                onTap: onHomeTap,
              ),
              const SizedBox(width: 50),
              _AnimatedNavButton(
                icon: Icons.add,
                isActive: currentIndex == 1,
                onTap: onAddTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedNavButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _AnimatedNavButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isActive
            ? LinearGradient(
                colors: [
                  Colors.purple.withValues(alpha: 0.9),
                  Colors.blue.withValues(alpha: 0.9),
                ],
              )
            : null,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.purple.withValues(alpha: 0.6),
                  blurRadius: 25,
                  spreadRadius: 6,
                ),
              ]
            : [],
      ),
      child: AnimatedScale(
        scale: isActive ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 250),
        child: IconButton(
          icon: Icon(icon, color: Colors.white, size: 28),
          onPressed: onTap,
        ),
      ),
    );
  }
}
