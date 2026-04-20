import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:spotify_me/data/models/song/song_model.dart';
import 'package:spotify_me/data/source/song/song_service.dart';
import 'package:spotify_me/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SongItunesService extends SongService {
  // Helper tách riêng để tái sử dụng
  Future<void> syncToDatabase(List<SongModel> models) async {
    if (models.isEmpty) return;
    try {
      await sl<SupabaseClient>()
          .from('songs')
          .upsert(
            models.map((e) => e.toJson()).toList(),
            onConflict: 'id',
          );
    } catch (e) {
      print('Lỗi đồng bộ danh sách nhạc: $e');
    }
  }

  @override
  Future<Either<dynamic, dynamic>> getNewsSongs() async {
    try {
      final url = Uri.parse(
        'https://itunes.apple.com/vn/rss/topsongs/limit=40/json',
      );
      final response = await http.get(url);

      if (response.statusCode != 200) {
        return Left('Failed to load top songs. Status: ${response.statusCode}');
      }

      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> entries = data['feed']?['entry'] ?? [];

      final List<SongModel> models = entries.map((item) {
        final String trackId =
            item['id']?['attributes']?['im:id']?.toString() ?? '';

        String artworkUrl = '';
        if (item['im:image'] is List && item['im:image'].isNotEmpty) {
          artworkUrl = item['im:image'].last['label']?.toString() ?? '';
        }

        String previewUrl = '';
        if (item['link'] is List) {
          for (var link in item['link']) {
            if (link['attributes']?['type']?.toString().startsWith('audio') == true) {
              previewUrl = link['attributes']?['href']?.toString() ?? '';
              break;
            }
          }
        }

        return SongModel(
          id: trackId,
          title: item['im:name']?['label']?.toString() ?? 'Unknown Title',
          artist: item['im:artist']?['label']?.toString() ?? 'Unknown Artist',
          coverUrl: artworkUrl,
          audioUrl: previewUrl,
          duration: const Duration(seconds: 30),
          releaseDate: item['im:releaseDate']?['label'] != null
              ? DateTime.tryParse(item['im:releaseDate']['label']) ?? DateTime.now()
              : DateTime.now(),
        );
      }).toList();

      // Sync lên Supabase (có await)
      await syncToDatabase(models);

      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<dynamic, dynamic>> searchSong(String query) async {
    try {
      if (query.trim().isEmpty) return const Right([]);

      final url = Uri.parse(
        'https://itunes.apple.com/search?term=${Uri.encodeComponent(query)}&entity=song&limit=20',
      );
      final response = await http.get(url);

      if (response.statusCode != 200) {
        return Left('Failed to load songs. Status: ${response.statusCode}');
      }

      final List<dynamic> results = json.decode(response.body)['results'] ?? [];

      final List<SongModel> models = results.map((item) => SongModel(
        id: item['trackId']?.toString() ?? '',
        title: item['trackName'] ?? 'Unknown Title',
        artist: item['artistName'] ?? 'Unknown Artist',
        coverUrl: item['artworkUrl100']?.toString() ?? '',
        audioUrl: item['previewUrl']?.toString() ?? '',
        duration: Duration(
          milliseconds: (item['trackTimeMillis'] as num?)?.toInt() ?? 0,
        ),
        releaseDate: item['releaseDate'] != null
            ? DateTime.tryParse(item['releaseDate']) ?? DateTime.now()
            : DateTime.now(),
      )).toList();

      await syncToDatabase(models);

      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }
}