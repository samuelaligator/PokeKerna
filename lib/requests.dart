import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

Future<dynamic> fetchWithHeaders(String url) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_response_${url}') ?? "null";
    final lastFetch = prefs.getInt('last_fetch_time_${url}') ?? 0;
    bool isOffline = !(await hasNetworkConnection());
    
    if (isOffline || (cachedData != "null" && DateTime.now().millisecondsSinceEpoch - lastFetch < 300000)) {
      print("Use cached data");
      return jsonDecode(cachedData); // Use cached data
    }

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
      final dynamic responseData = jsonDecode(response.body);
      await prefs.setString('cached_response_${url}', response.body);
      await prefs.setInt('last_fetch_time_${url}', DateTime.now().millisecondsSinceEpoch);
      return responseData;
    } else if (response.statusCode == 418) {
      throw Exception('🔥 Boosters Désactivées.');
    } else if (response.statusCode == 499) {
      final dynamic responseData = jsonDecode(response.body);
      final int timestamp = responseData["timestamp"];
      await prefs.setInt('next_booster', timestamp);
      throw Exception('🔥 Timer non syncronisé...');
    } else if (response.statusCode == 429) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      await prefs.setString('cached_response', response.body);
      await prefs.setInt('last_fetch_time', DateTime.now().millisecondsSinceEpoch);
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

Future<bool> hasNetworkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
