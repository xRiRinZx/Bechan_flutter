import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function() onSelected;

  CustomChip({required this.label, required this.isSelected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(width: 5),
            if (isSelected)
              Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
