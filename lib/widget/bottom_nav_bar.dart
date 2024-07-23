import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_rounded, 'Home', 0),
          _buildNavItem(Icons.bar_chart_rounded, 'Dashboard', 1),
          Visibility(
            visible: false, // Hide the icon
            child: IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: null, // Disables the button
            ),
          ),
          _buildNavItem(FontAwesomeIcons.tags, 'Tags', 2),
          _buildNavItem(Icons.menu_rounded, 'Menu', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: currentIndex == index ? Colors.blue : Colors.black,
        size: 28,
      ),
      onPressed: () => onTap(index),
    );
  }
}
