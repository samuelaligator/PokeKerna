import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchWithHeaders(String url) async {
  try {
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

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
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