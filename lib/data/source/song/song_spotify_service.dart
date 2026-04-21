// import 'package:dartz/dartz.dart';
// import 'package:spotify_me/data/source/song/song_service.dart';

// import 'package:spotify/spotify.dart';
// import 'package:spotify_me/domain/entities/song/song.dart'; 

// class SongSpotifyService extends SongService {
//   final String clientId = '92a6cb79d8c541abafe71e43167e3f1b';
//   final String clientSecret = '41eee3b3b9a84462aac66f25646f63e5';

//   @override
//   Future<Either<dynamic, dynamic>> getNewsSongs() {
//     // TODO: implement getNewsSongs
//     throw UnimplementedError();
//   }
  
//   @override
//   Future<Either<dynamic, dynamic>> searchSong(String query) async {
//     try {
//       final credentials = SpotifyApiCredentials(clientId, clientSecret);
//       final spotify = SpotifyApi(credentials);

//       // Gọi API search với type là Track
//       final searchResult = await spotify.search.get(query, types: [SearchType.track]).first();
      
//       List<SongEntity> songs = [];

//       for (var page in searchResult) {
//         if (page.items != null) {
//           for (var item in page.items!) {
//             if (item is Track) {
//               songs.add(
//                 SongEntity(
//                   id: item.id ?? '',
//                   title: item.name ?? '',
//                   artist: item.artists?.isNotEmpty == true ? item.artists!.first.name! : 'Unknown',
//                   coverUrl: item.album?.images?.isNotEmpty == true ? item.album!.images!.first.url! : '',
//                   audioUrl: item.previewUrl ?? '',
//                   // duration: item.durationMs ?? 0,
//                   // Tạm thời lấy thời gian hiện tại nếu Track không có releaseDate, 
//                   // có thể lấy từ item.album?.releaseDate nếu cần
//                   releaseDate: DateTime.now(), 
//                 )
//               );
//             }
//           }
//         }
//       }

//       return Right(songs);
//     } catch (e) {
//       return Left(e.toString());
//     }
//   }
// }