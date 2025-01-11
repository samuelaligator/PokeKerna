import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchWithHeaders(String url) async {
  try {
    print('Fetching shared preferences...');
    // Access shared preferences
    final prefs = await SharedPreferences.getInstance();

    // Retrieve user_id and key
    final userId = prefs.getInt('user_id');
    final key = prefs.getString('api_key');

    print('Retrieved user_id: ${userId}, key: ${key}');

    if (userId == null || key == null) {
      throw Exception('Missing user_id or key in shared preferences');
    }

    // Set headers
    final headers = {
      'User-Id': userId.toString(),
      'Key': key,
    };

    print('Headers set: ${headers}');

    // Execute GET request
    print('Sending GET request to ${url}...');
    final response = await http.get(Uri.parse(url), headers: headers);

    // Handle response
    print('Response received with status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      print("test" + response.contentLength.toString());
      final List<dynamic> responseData = jsonDecode(response.body);
      print('Response body: ${responseData}');
      return responseData;
    } else if (response.statusCode == 418) {
      throw Exception('🔥 Boosters Désactivées.');
    } else if (response.statusCode == 429) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      throw Exception('⌛ ${responseData['error']}');
    } else if (response.statusCode == 500) {
      throw Exception('💣 Super erreur du serveur. Réessayez plus tard !');
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    // Handle errors
    print('Error occurred: ${e}');
    final errorMessage = e.toString().replaceFirst('Exception: ', '');
    throw Exception(errorMessage);
  }
}