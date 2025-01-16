import 'package:flutter/material.dart';
import '../navigation.dart';
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 64),
              Image.asset("assets/images/logo.png"),
              SizedBox(height: 64),
              InfoRow(
                  icon: Icons.lightbulb_rounded,
                  text: "D'après une idée originale de",
                  size: 22,
                  fontWeight: FontWeight.bold,
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/zam.png",
                  username: 'Zamuel',
                  mainAxisAlignment: MainAxisAlignment.center),
              SizedBox(height: 48),
              InfoRow(
                  icon: Icons.code_rounded,
                  text: "Développement",
                  size: 22,
                  fontWeight: FontWeight.bold,
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/zam.png",
                  username: 'Zamuel',
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/funa.png",
                  username: 'Guilhem',
                  mainAxisAlignment: MainAxisAlignment.center),
              SizedBox(height: 48),
              InfoRow(
                  icon: Icons.palette_rounded,
                  text: "Direction Artisitique",
                  size: 22,
                  fontWeight: FontWeight.bold,
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/elo.png",
                  username: 'Élodie',
                  mainAxisAlignment: MainAxisAlignment.center),
              SizedBox(height: 48),
              InfoRow(
                  icon: Icons.draw,
                  text: "Images & Dessins",
                  size: 22,
                  fontWeight: FontWeight.bold,
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/zam.png",
                  username: 'Élodie',
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/zam.png",
                  username: 'Thomas',
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  username: '???',
                  mainAxisAlignment: MainAxisAlignment.center),
              SizedBox(height: 48),
              InfoRow(
                  icon: Icons.border_color_rounded,
                  text: "Rédaction",
                  size: 22,
                  fontWeight: FontWeight.bold,
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/zam.png",
                  username: 'Noah',
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/zam.png",
                  username: 'Léo',
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/zam.png",
                  username: 'Timtonix',
                  mainAxisAlignment: MainAxisAlignment.center),
              SizedBox(height: 48),
              InfoRow(
                  icon: Icons.webhook_rounded,
                  text: "Site Web",
                  size: 22,
                  fontWeight: FontWeight.bold,
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/funa.png",
                  username: 'Zamuel',
                  mainAxisAlignment: MainAxisAlignment.center),
              SizedBox(height: 48),
              InfoRow(
                  icon: Icons.electric_bolt_rounded,
                  text: "Infrastructure",
                  size: 22,
                  fontWeight: FontWeight.bold,
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/funa.png",
                  username: 'Zamuel',
                  mainAxisAlignment: MainAxisAlignment.center),
              SizedBox(height: 48),
              InfoRow(
                  icon: Icons.stars_rounded,
                  text: "Armonisation",
                  size: 22,
                  fontWeight: FontWeight.bold,
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/zam.png",
                  username: 'Zamuel',
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/zam.png",
                  username: 'Zamuel',
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/zam.png",
                  username: 'Zamuel',
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/zam.png",
                  username: 'Zamuel',
                  mainAxisAlignment: MainAxisAlignment.center),
              UserProfileRow(
                  picture: "assets/profile/zam.png",
                  username: 'Zamuel',
                  mainAxisAlignment: MainAxisAlignment.center),
              SizedBox(height: 48),
              InfoRow(
                  icon: Icons.computer,
                  text: "Hébergé Par",
                  size: 22,
                  fontWeight: FontWeight.bold,
                  mainAxisAlignment: MainAxisAlignment.center),
              SizedBox(height: 8),
              Image.asset(
                "assets/images/vaatigames.png",
                    height: 48,
              ),
              SizedBox(height: 48,),
              FloatingActionButton.extended(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavigationBarPage(),
                    )),
                label: Text("Retour à l'accueil"),
                icon: Icon(Icons.home),
                backgroundColor: Colors.amber[200],
              ),
              SizedBox(height: 12),
              Text("Psst! Pourquoi pas essayer le code VAATIGAMES ?",
              style: TextStyle(
                  color: Colors.grey.shade600
              )),
              SizedBox(height: 128),
            ],
          ),
        ),
      ),
    );
  }
}
