import 'package:dartz/dartz.dart';

abstract class SongService {
  Future<Either> getNewsSongs();
}