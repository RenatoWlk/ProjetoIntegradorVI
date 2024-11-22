import 'package:flutter/material.dart';

class CustomDrawerButton extends StatelessWidget {
  const CustomDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    Color iconColor = isDarkMode ? Colors.orange[500]! : Colors.black;

    return Builder(
      builder: (context) {
        return FloatingActionButton(
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          backgroundColor: backgroundColor,
          child: Icon(Icons.person_outline, size: 50, color: iconColor),
        );
      },
    );
  }
}
