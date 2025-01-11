import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'login.dart';

class SettingsPage extends StatelessWidget {
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
            return Column(
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
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Voici ton espace compte :)',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),

                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // Adds space between the buttons
                      children: [
                        FloatingActionButton.extended(
                          onPressed: () => _NoTimer(),
                          label: Text('Kill da timer'),
                          icon: Icon(Icons.bug_report),
                          backgroundColor: Colors.orange,
                        ),
                        SizedBox(
                            width:
                            16), // Adds a little gap between the two buttons
                        FloatingActionButton.extended(
                          onPressed: () => _logout(context),
                          label: Text('Déconnexion'),
                          icon: Icon(Icons.logout),
                          backgroundColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                )
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
