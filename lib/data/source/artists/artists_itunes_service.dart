import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:spotify_me/data/models/artists/artists_model.dart';
import 'package:spotify_me/data/models/song/song_model.dart';
import 'package:spotify_me/data/source/artists/artists_service.dart';
import 'package:spotify_me/data/source/song/song_itunes_service.dart';
import 'package:spotify_me/data/source/song/song_service.dart';
import 'package:spotify_me/service_locator.dart'; // Thêm import này

class ArtistsItunesService extends ArtistsService {
  @override
  Future<Either<dynamic, dynamic>> getArtists() async {
    try {
      final url = Uri.parse(
        'https://itunes.apple.com/vn/rss/topsongs/limit=40/json',
      );
      final response = await http.get(url);

      if (response.statusCode != 200) {
        return Left('Failed to load artists. Status: ${response.statusCode}');
      }

      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> entries = data['feed']?['entry'] ?? [];

      final Set<String> seenNames = {};
      final List<ArtistsModel> models = [];

      for (final item in entries) {
        final String artistName =
            item['im:artist']?['label']?.toString() ?? 'Unknown Artist';

        if (seenNames.contains(artistName)) continue;
        seenNames.add(artistName);

        String artistId = '';
        final String? href = item['im:artist']?['attributes']?['href']
            ?.toString();
        if (href != null && href.isNotEmpty) {
          final uri = Uri.tryParse(href);
          if (uri != null && uri.pathSegments.isNotEmpty) {
            String rawId = uri.pathSegments.last;
            // Strip 'id' prefix if present (e.g., 'id1234567' -> '1234567')
            if (rawId.startsWith('id')) {
              rawId = rawId.substring(2);
            }
            artistId = rawId;
          }
        }

        String coverUrl = '';
        if (item['im:image'] is List && item['im:image'].isNotEmpty) {
          coverUrl = item['im:image'].last['label']?.toString() ?? '';
          // Upscale cover image to 600x600 for better quality
          coverUrl = coverUrl.replaceAll(RegExp(r'\d+x\d+'), '600x600');
        }

        // Tạo Model ca sĩ nhưng KHÔNG gọi _fetchSongsByArtistId ở đây
        models.add(
          ArtistsModel(
            id: artistId,
            name: artistName,
            track: 0,
            coverUrl: coverUrl,
            listSong: [], // 
          ),
        );
      }

      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<dynamic, dynamic>> getArtistsById(String id) async {
    try {
      // 1. Gọi API lấy thông tin và bài hát của 1 ca sĩ cụ thể
      final url = Uri.parse(
        'https://itunes.apple.com/lookup?id=$id&entity=song&limit=20',
      );
      final response = await http.get(url);

      if (response.statusCode != 200) {
        return Left('Failed to load artist. Status: ${response.statusCode}');
      }

      final List<dynamic> results = json.decode(response.body)['results'] ?? [];

      if (results.isEmpty) {
        return const Left('Artist not found');
      }

      // 2. Tách dữ liệu
      final artistJson = results.first;
      final trackResults = results.skip(1).toList();

      // 3. Xử lý danh sách bài hát
      final List<SongModel> songs = trackResults
          .map(
            (item) => SongModel(
              id: item['trackId']?.toString() ?? '',
              title: item['trackName'] ?? 'Unknown Title',
              artist: item['artistName'] ?? 'Unknown Artist',
              coverUrl: (item['artworkUrl100']?.toString() ?? '').replaceAll(
                '100x100',
                '600x600',
              ),
              audioUrl: item['previewUrl']?.toString() ?? '',
              duration: Duration(
                milliseconds: (item['trackTimeMillis'] as num?)?.toInt() ?? 0,
              ),
              releaseDate: item['releaseDate'] != null
                  ? DateTime.tryParse(item['releaseDate']) ?? DateTime.now()
                  : DateTime.now(),
            ),
          )
          .toList();

      // 4. Đồng bộ lên Supabase thông qua Service Locator
      await sl<SongService>().syncToDatabase(songs);

      // 5. Trả về model hoàn chỉnh
      final model = ArtistsModel(
        id: artistJson['artistId']?.toString() ?? id,
        name: artistJson['artistName'] ?? 'Unknown Artist',
        coverUrl: songs.isNotEmpty ? (songs.first.coverUrl ?? '') : '',
        track: songs.length,
        listSong: songs,
      );

      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
