import 'dart:convert';
import 'package:http/http.dart' as http;

class AgoraTokenService {
  // You need to set up a token server that generates Agora tokens
  // For testing, you can use Agora's temporary token generator:
  // https://console.agora.io/projects/{your-project-id}/token

  static const String tokenServerUrl = "YOUR_TOKEN_SERVER_URL";

  /// Generate token from your backend server
  static Future<String?> getToken({
    required String channelName,
    required int uid,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$tokenServerUrl/generateToken'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'channelName': channelName,
          'uid': uid,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        print('Failed to get token: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  /// For testing: Generate a temporary token manually
  /// Go to: https://console.agora.io → Your Project → Generate Token
  /// Then paste it here
  static String getTestToken(String channelName) {
    // Replace with your generated token from Agora Console
    // Token expires after 24 hours
    const String temporaryToken = "PASTE_YOUR_TOKEN_HERE";

    // Return empty string if using without certificate
    return temporaryToken == "PASTE_YOUR_TOKEN_HERE" ? "" : temporaryToken;
  }
}
