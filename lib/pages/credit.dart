import 'package:flutter/material.dart';
import 'misc.dart';

class CreditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InfoRow(
                icon: Icons.code_rounded,
                text: "D'après une idée originale de",
                size: 22,
                fontWeight: FontWeight.bold,
                mainAxisAlignment: MainAxisAlignment.center),
            UserProfileRow(
                picture: "assets/images/logo.png",
                username: 'Zamuel',
                mainAxisAlignment: MainAxisAlignment.center),
            SizedBox(height: 32),
            InfoRow(
                icon: Icons.code_rounded,
                text: "Développement",
                size: 22,
                fontWeight: FontWeight.bold,
                mainAxisAlignment: MainAxisAlignment.center),
          ],
        ),
      ),
    );
  }
}
