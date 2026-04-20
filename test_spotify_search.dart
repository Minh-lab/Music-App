import 'package:spotify/spotify.dart';

void main() async {
  final clientId = '92a6cb79d8c541abafe71e43167e3f1b';
  final clientSecret = '41eee3b3b9a84462aac66f25646f63e5';
  final credentials = SpotifyApiCredentials(clientId, clientSecret);
  final spotify = SpotifyApi(credentials);

  try {
    final search = await spotify.search.get('metallica', types: [SearchType.track]).first();
    print("Got it!");
    for (var page in search) {
      print(page.items?.length);
    }
  } catch (e) {
    print(e);
  }
}
