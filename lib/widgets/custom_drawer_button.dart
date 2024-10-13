import 'package:flutter/material.dart';

class CustomDrawerButton extends StatelessWidget {
  const CustomDrawerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return FloatingActionButton(
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.person_outline, size: 50),
        );
      },
    );
  }
}
