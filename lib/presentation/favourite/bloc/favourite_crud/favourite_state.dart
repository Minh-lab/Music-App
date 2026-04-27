import 'package:spotify_me/domain/entities/song/song.dart';

abstract class FavouriteState {
}

class FavouriteInitial extends FavouriteState {}

class FavouriteLoading extends FavouriteState {}

class FavouriteLoaded extends FavouriteState {
  final List<SongEntity>? list;

  FavouriteLoaded({required this.list});
}

class FavouriteFailure extends FavouriteState {}

class FavouriteAddSuccess extends FavouriteState {}
class FavouriteRemoveSuccess extends FavouriteState {}

class FavouriteAddFailure extends FavouriteState {
  String? errorMessage;
  FavouriteAddFailure({this.errorMessage});
}
class FavouriteRemoveFailure extends FavouriteState {
  String? errorMessage;
  FavouriteRemoveFailure({this.errorMessage});
}






