import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokekerna/pages/booster.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';
import 'home.dart';
import '../main.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _controller = TextEditingController();

  // Method to copy api_key from SharedPreferences to clipboard
  Future<void> _copyApiKeyToClipboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('api_key');
    if (apiKey != null) {
      Clipboard.setData(ClipboardData(text: apiKey));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('API Key copied to clipboard')),
      );
    }
  }

  // Method to handle API request and response
  Future<void> _handleApiRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final key = prefs.getString('api_key');

    if (userId == null || key == null) {
      throw Exception('Missing user_id or key in shared preferences');
    }

    final headers = {
      'User-Id': userId.toString(),
      'Key': key,
    };

    final response = await http
        .get(Uri.parse('https://code.pokekerna.xyz/v1/code'), headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('type') && jsonResponse['type'] == 'card') {
        List<dynamic> listResponse = jsonDecode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BoosterPage(responseBody: listResponse)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No card type in response')),
        );
      }
    } else {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(jsonResponse['message'])),
      );
    }
  }

  Future<void> _handleAdminGrant() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final key = prefs.getString('api_key');

    if (userId == null || key == null) {
      throw Exception('Missing user_id or key in shared preferences');
    }

    final headers = {
      'User-Id': userId.toString(),
      'Key': key,
    };

    final response = await http
        .get(Uri.parse('https://code.pokekerna.xyz/admin'), headers: headers);

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
              builder: (context) => HomePage()),
        );
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Secret codes are for masters.')),
        );
      }
    
  }

  // Method to handle input validation and action
  void _handleInput(String input) {
    if (input == 'clickey') {
      _copyApiKeyToClipboard();
    } else if (input == "notif") {
      showNotification("Scheduled Task", "It's time for your task!");
    } else if (input == "admn") {
      _handleAdminGrant();
    } else if (input == "tmr") {
      _NoTimer();
    } else {
      _handleApiRequest();
    }
  }

  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username'); // Fetch the saved username
  }

  Future<void> _NoTimer() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('next_booster'); // Fetch the saved username
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
            return
              SingleChildScrollView(
            child:
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '👋 Salut ${snapshot.data} !',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                //Clipboard.setData(ClipboardData(text: apiKey));
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Voici ton espace compte :)',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🔑 Codes",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Entrez un code secret...',
                          border: OutlineInputBorder(),
                          //filled: true,
                          //fillColor: Colors.grey[200],
                        ),
                        onSubmitted: _handleInput,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "ℹ️ Informations",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      // Other UI elements can be above if needed
                      Text(
                        'App Version: 1.0.0', // Replace with your version info
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        'Build: DEBUG BETA 1', // Replace with build info (Beta, Debug, etc.)
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        'App ID: fr.zamuel.pokekerna', // Replace with your app's ID or other info
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              child: FloatingActionButton.extended(
                                onPressed: () => Clipboard.setData(ClipboardData(text: "https://pokekerna.xyz")),
                                label: Text('Site Web'),
                                icon: Icon(Icons.webhook_rounded),
                                backgroundColor: Colors.amber[200],
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              child: FloatingActionButton.extended(
                                onPressed: () => Clipboard.setData(ClipboardData(text: "contact@pokekerna.xyz")),
                                label: Text('Contact'),
                                icon: Icon(Icons.mail),
                                backgroundColor: Colors.amber[200],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      Container(
                        width: double
                            .infinity, // Makes the button take all available horizontal space
                        child: FloatingActionButton.extended(
                          onPressed: () => _logout(context),
                          label: Text('Déconnexion'),
                          icon: Icon(Icons.logout),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              ),
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
