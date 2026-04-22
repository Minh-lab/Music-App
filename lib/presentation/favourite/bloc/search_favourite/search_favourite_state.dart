import 'package:spotify_me/domain/entities/song/song.dart';

abstract class SearchFavouriteState  {}
class SearchFavouriteLoading extends SearchFavouriteState{}
class SearchFavouriteInitial extends SearchFavouriteState{}
class SearchFavouriteSuccess extends SearchFavouriteState{
  List<SongEntity>? listSongs;
  SearchFavouriteSuccess({this.listSongs}) ;
}
class SearchFavouriteFailure extends SearchFavouriteState{
  String? errorMessage;
  SearchFavouriteFailure({this.errorMessage});
}