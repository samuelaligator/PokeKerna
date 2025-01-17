import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'booster.dart';
import '../requests.dart';
import '../main.dart';

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
  int _secondsRemaining = 0;
  Timer? _timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAsyncData();
    startTimer();
  }

  Future<void> _initializeAsyncData() async {
    final prefs = await SharedPreferences.getInstance();
    final next = prefs.getInt('next_booster') ?? 0;

    final int timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round();;
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
    if (hasNetworkConnection == false) {
      return FloatingActionButton.extended(
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Attendez que le timer soit à zéro !"),
              backgroundColor: Colors.red,
            ),
          );
        },
        label: Text('Ouvrir le booster'),
        icon: Icon(Icons.signal_wifi_connected_no_internet_4_rounded),
        backgroundColor: Colors.grey,
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: _isLoading
            ? null
            : () async {
          if (_secondsRemaining > 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Attendez que le timer soit à zéro !"),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            await openBooster();
          }
        },
        label: Text(
          _secondsRemaining > 0
              ? 'Attendez ${_formatTime(_secondsRemaining)}'
              : _isLoading
              ? 'Chargement...'
              : 'Ouvrir le booster',
        ),
        icon: Icon(
          _isLoading
              ? Icons.refresh_rounded
              : _secondsRemaining > 0
              ? Icons.lock
              : Icons.open_in_new,
        ),
        backgroundColor: _isLoading
            ? Colors.grey
            : _secondsRemaining > 0
            ? Colors.grey
            : defaultColor,
      );
    }
  }

  Future<void> openBooster() async {
    try {
      setState(() {
        _isLoading = true; // Set loading state to true
      });
      final response = await fetchWithHeaders("https://code.pokekerna.xyz/v1/draw");
      final int timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('next_booster', timestamp + 10800);
      await prefs.remove('cached_response_https://code.pokekerna.xyz/v1/selfcards');
      await scheduleNotification();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BoosterPage(responseBody: response),
        ),
      );
    } catch (e) {
      _initializeAsyncData();
      startTimer();
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.orange[300],
        ),
      );
    } finally {
      _initializeAsyncData();
      startTimer();
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }
  }
}
