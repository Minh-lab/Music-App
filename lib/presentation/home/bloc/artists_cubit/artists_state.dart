import 'package:spotify_me/domain/entities/artists/artists_entity.dart';

abstract class ArtistsState {}

class ArtistsLoading extends ArtistsState {}

class ArtistsLoaded extends ArtistsState {
  List<ArtistsEntity> listArtists;
  ArtistsLoaded({required this.listArtists});
}

class ArtistsLoadFailure extends ArtistsState {
  String? errorMessage;
  ArtistsLoadFailure({this.errorMessage});
}
