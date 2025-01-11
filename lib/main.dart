import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'password_hasher.dart';
import 'booster.dart';
import 'dart:convert';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    runApp(PokeKerna());
  });
}

class PokeKerna extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PokeKerna',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
      ),
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == true) {
          return NavigationBarPage();
        } else {
          return LoginPage();
        }
      },
    );
  }

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('api_key');
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    String salt = "PokeFraiseZamFun";
    String hashedPassword = await hashPassword(password: password, salt: salt);

    try {
      final response = await http.post(
        Uri.parse('https://api.democraft.fr/v1/login'),
        body: json.encode({'username': username, 'password': hashedPassword}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', username);
          await prefs.setInt('user_id', data['user_id']);
          await prefs.setString('api_key', data['key']);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavigationBarPage()),
          );
        } else {
          setState(() {
            _errorMessage = 'Login failed: ${data['message']}';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Server error. Please try again later.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationBarPage extends StatefulWidget {
  @override
  _NavigationBarPageState createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _currentIndex = 0;

  // Liste des pages avec plusieurs widgets
  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
      ),
      body: _pages[_currentIndex], // Affiche la page correspondant à l'onglet
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index; // Met à jour l'onglet sélectionné
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_album_outlined),
            selectedIcon: Icon(Icons.photo_album),
            label: 'Collection',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle),
            label: 'Compte',
          ),
        ],
      ),
    );
  }
}

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
  int _secondsRemaining = 5; // Timer initial à 10 secondes
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
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
            ? 'Attendez $_secondsRemaining s'
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
      final response =
          await fetchWithHeaders("https://api.democraft.fr/v1/draw");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BoosterPage(responseBody: response),
        ),
      );
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

// Page Recherche avec plusieurs widgets
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
    );
  }
}

Future<void> saveTimestamp() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    // Sauvegarder le timestamp dans SharedPreferences
    await prefs.setInt('saved_timestamp', timestamp);

    print('Timestamp enregistré avec succès : $timestamp');
  } catch (e) {
    print('Erreur lors de l’enregistrement du timestamp : $e');
  }
}

void openBooster() {
  final int timestamp = DateTime.now().millisecondsSinceEpoch;
  savePreference("last_booster_timestamp", timestamp);
  print("$timestamp");
}

Future<void> savePreference(String key, dynamic value) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    // Map associant les types aux fonctions de sauvegarde
    final Map<Type, Function> saveMethods = {
      int: (key, value) => prefs.setInt(key, value as int),
      String: (key, value) => prefs.setString(key, value as String),
      bool: (key, value) => prefs.setBool(key, value as bool),
      double: (key, value) => prefs.setDouble(key, value as double),
      List<String>: (key, value) =>
          prefs.setStringList(key, value as List<String>),
    };

    // Vérifie si le type est supporté et appelle la méthode correspondante
    final saveMethod = saveMethods[value.runtimeType];
    if (saveMethod != null) {
      await saveMethod(key, value);
      print('Préférence sauvegardée : $key = $value');
    } else {
      throw ArgumentError("Type de donnée non supporté : ${value.runtimeType}");
    }
  } catch (e) {
    print('Erreur lors de la sauvegarde de la préférence $key : $e');
  }
}

class SettingsPage extends StatelessWidget {
  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username'); // Fetch the saved username
  }

  // Function to log out by clearing the SharedPreferences
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username'); // Remove username
    await prefs.remove('api_key'); // Use 'api_key' instead of 'apiKey'

    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Navigate to LoginPage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<String?>(
        future: _getUsername(), // Fetch username asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while fetching data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data != null) {
            // Display the username when available
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${snapshot.data}!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 20),
                Text(
                  'This is your account page.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _logout(context), // Call logout function
                  child: Text('Log Out'),
                  style: ElevatedButton.styleFrom(
                      // primary: Colors.red,
                      ),
                ),
              ],
            );
          } else {
            // Handle the case where no username is found
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This is your account page.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ]);
          }
        },
      ),
    );
  }
}

class BoosterPage extends StatelessWidget {
  final List<dynamic> responseBody;

  const BoosterPage({Key? key, required this.responseBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Response')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Response Data:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                responseBody.isNotEmpty
                    ? jsonEncode(responseBody)
                    : 'No data available.',
                style: TextStyle(fontSize: 16),
              ),
              FloatingActionButton.extended(
                label: Text("Retour à l'Accueil"),
                icon: Icon(Icons.stars),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavigationBarPage(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
