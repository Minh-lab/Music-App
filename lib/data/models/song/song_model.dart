import 'package:spotify_me/domain/entities/song/song.dart';

class SongModel {
  final String id;
  final String artist;
  final String title;
  final Duration duration;
  final DateTime releaseDate;
  final String? audioUrl;
  final String? coverUrl;

  SongModel({
    required this.id,
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.title,
    this.audioUrl,
    this.coverUrl,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown Title',
      artist: json['artist']?.toString() ?? 'Unknown Artist',
      coverUrl: json['cover_url']?.toString(),
      audioUrl: json['audio_url']?.toString(),
      duration: json['duration'] != null
          ? Duration(seconds: (json['duration'] as num).toInt())
          : Duration.zero,                        
      releaseDate: json['releaseDate'] != null
          ? DateTime.tryParse(json['releaseDate'].toString()) ?? DateTime.now()
          : DateTime.now(),                   
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.tryParse(id) ?? 0,               
      'title': title,
      'artist': artist,
      'cover_url': coverUrl,
      'audio_url': audioUrl,
      'duration': duration.inSeconds,          
      'releaseDate': releaseDate.toIso8601String(), 
    };
  }
}

extension SongModelToEntity on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      id: id,
      artist: artist,
      duration: duration,
      releaseDate: releaseDate,
      title: title,
      coverUrl: coverUrl,
      audioUrl: audioUrl,
    );
  }
}