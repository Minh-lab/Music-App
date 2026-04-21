import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final clientId = '92a6cb79d8c541abafe71e43167e3f1b';
  final clientSecret = '41eee3b3b9a84462aac66f25646f63e5';
  
  // 1. Get Token
  final bytes = utf8.encode('$clientId:$clientSecret');
  final base64Str = base64.encode(bytes);
  
  final tokenResponse = await http.post(
    Uri.parse('https://accounts.spotify.com/api/token'),
    headers: {
      'Authorization': 'Basic $base64Str',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'grant_type': 'client_credentials',
    },
  );
  
  if (tokenResponse.statusCode != 200) {
    print('Failed to get token: \${tokenResponse.body}');
    return;
  }
  
  final token = jsonDecode(tokenResponse.body)['access_token'];
  print('Token: $token\n');
  
  // 2. Call New Releases API
  final newReleasesResponse = await http.get(
    Uri.parse('https://api.spotify.com/v1/browse/new-releases?limit=10'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  
  print('Status code: \${newReleasesResponse.statusCode}');
  print('Response body:');
  print(newReleasesResponse.body);
}
