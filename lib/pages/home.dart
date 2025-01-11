import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'booster.dart';
import '../requests.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              // Centrer le Container
              child: Image.asset(
                'assets/images/booster.png', // Chemin de l'image
              ),
            ),
          ),
          SizedBox(height: 20),
          BoosterButton(),
          SizedBox(height: 20),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class BoosterButton extends StatefulWidget {
  @override
  _BoosterButtonState createState() => _BoosterButtonState();
}

class _BoosterButtonState extends State<BoosterButton> {
  int _secondsRemaining = 0; // Timer initial à 10 secondes
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeAsyncData();
    startTimer();
  }

  Future<void> _initializeAsyncData() async {
    final prefs = await SharedPreferences.getInstance();
    final next = prefs.getInt('next_booster');
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    if (timestamp > next!) {
      setState(() {
        _secondsRemaining = 0; // Save the username
      });
    } else {
      setState(() {
        _secondsRemaining = next - timestamp; // Save the username
      });
    }
  }

  // Fonction pour démarrer le timer
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          // Envoyer la notification quand le timer atteint 0
        }
      });
    });
  }

  String _formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColor = Theme.of(context).colorScheme.primaryContainer;
    return FloatingActionButton.extended(
      onPressed: () async {
        // Si le timer n'est pas écoulé, afficher un message d'erreur
        if (_secondsRemaining > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Attendez que le timer soit à zéro !"),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          openBooster();
        }
      },
      label: Text(
        _secondsRemaining > 0
            ? 'Attendez ${_formatTime(_secondsRemaining)}'
            : 'Ouvrir le booster',
      ),
      icon: Icon(
        _secondsRemaining > 0 ? Icons.lock : Icons.open_in_new,
      ),
      backgroundColor: _secondsRemaining > 0 ? Colors.grey : defaultColor,
    );
  }

  Future<void> openBooster() async {
    try {
      final response = await fetchWithHeaders("https://code.pokekerna.xyz/v1/draw");
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('next_booster', timestamp + 10800);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BoosterPage(responseBody: response),
          ));
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.orange[300],
        ),
      );
    }
  }
}