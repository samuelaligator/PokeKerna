import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokekerna/pages/booster.dart';
import 'package:pokekerna/pages/credit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'login.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../main.dart';
import 'admin.dart';
import 'misc.dart';
import '../requests.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _controller = TextEditingController();
  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

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

  Future<void> _handleApiRequest(String input) async {
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
        .get(Uri.parse('https://code.pokekerna.xyz/v1/code?code=${input}'), headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse.containsKey('type') && jsonResponse['type'] == 'card') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BoosterPage(responseBody: jsonResponse['card'])),
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
              builder: (context) => AdminPage()),
        );
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Secret codes are for masters.')),
        );
      }
    
  }

  void _handleInput(String input) {
    if (input == 'clickey') {
      _copyApiKeyToClipboard();
    } else if (input == "notif") {
      showNotification("🐛 Test des Notifications", "Alors ? Ça semble marcher non ?");
    } else if (input == "admn") {
      _handleAdminGrant();
    } else if (input == "tmr") {
      _NoTimer();
    } else if (input == "credits"){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CreditPage()
        ), // Navigate to LoginPage
      );
    } else {
      _handleApiRequest(input);
    }
  }

  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username'); // Fetch the saved username
  }

  Future<void> _NoTimer() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('next_booster');
    prefs.remove('cached_response_https://code.pokekerna.xyz/v1/draw');// Fetch the saved username
  }

  // Function to log out by clearing the SharedPreferences
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await fetchWithHeaders("https://code.pokekerna.xyz/v1/logout");
    await prefs.remove('username'); // Remove username
    await prefs.remove('api_key'); // Use 'api_key' instead of 'apiKey'

    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Navigate to LoginPage
    );
  }

  void openEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  void openBrowser(String url) async {
    print(url);
    final Uri uri = Uri.parse(url);
    print(uri);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0),),

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
                      InfoRow(icon: Icons.developer_mode_rounded, text: '${appName} v${version} - patch ${buildNumber}', size: 20),
                      InfoRow(icon: Icons.folder_zip_rounded, text: packageName, size: 16, color: Colors.grey),
                      InfoRow(icon: Icons.cloud_circle_rounded, text: 'Implémentation Prismarine', size: 16, color: Colors.lightBlue.shade200),

                      /* ACTIVE CETTE OPTION ET DEGAGE LA MIENNE QUAND TU BUILD ZAM
                      _buildInfoRow(Icons.lightbulb_circle_rounded, 'Implémentation Lightfrog', 16, Colors.red.shade400),
                      */

                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              child: FloatingActionButton.extended(
                                onPressed: () => openBrowser("https://pokekerna.xyz"),
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
                                onPressed: () => openEmail("contact@pokekerna.xyz"),
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
