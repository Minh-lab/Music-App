import 'package:spotify_me/data/source/song/song_itunes_service.dart';

void main() async {
  print('Testing iTunes Service...');
  final service = SongItunesService();
  final result = await service.getNewsSongs();
  
  result.fold(
    (l) => print("Lỗi: $l"),
    (r) {
      print("Thành công! Đã lấy được ${r.length} bài hát:");
      for (var song in r) {
        print(" - ${song.title} by ${song.artist} | Preview: ${song.audioUrl}");
      }
    }
  );    
}