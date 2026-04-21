import 'package:spotify_me/domain/entities/artists/artists_entity.dart';

abstract class ArtistState {}
 class ArtistGetLoading extends ArtistState {}
 class ArtistGetSuccess extends ArtistState {
  ArtistsEntity artist;
  ArtistGetSuccess({required this.artist});
}
 class ArtistGetFailure extends ArtistState {
  String? errorMessage;
  ArtistGetFailure({this.errorMessage});
}

