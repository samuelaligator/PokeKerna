import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../password_hasher.dart';
import 'dart:convert';
import 'dart:async';
import '../navigation.dart';
import 'package:url_launcher/url_launcher.dart';

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
    String hashedPassword = await hashPassword(password: password, salt: username);

    try {
      final response = await http.post(
        Uri.parse('https://code.pokekerna.xyz/v1/login'),
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

  void openRegisterBrowser() async {
    final Uri uri = Uri.parse("https://code.pokekerna.xyz/compte");
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      setState(() {
        _errorMessage = '${e}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'), automaticallyImplyLeading: false),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
    children: [
      FloatingActionButton.extended(
        onPressed: _login,
        label: Text("Connexion"),
        icon: Icon(Icons.login),
        backgroundColor: Colors.amber[200],
      ),
      SizedBox(width: 12),
      FloatingActionButton.extended(
        onPressed: openRegisterBrowser,
        label: Text("Inscription"),
        icon: Icon(Icons.supervised_user_circle_sharp),
        backgroundColor: Colors.indigo,
      ),

    ],
    ),
          ],
        ),
      ),
    );
  }
}