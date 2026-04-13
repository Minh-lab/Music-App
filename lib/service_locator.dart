import 'package:get_it/get_it.dart';
import 'package:spotify_me/data/repositories/auth/auth_repository_impl.dart';
import 'package:spotify_me/data/repositories/song/song_repository_impl.dart';
import 'package:spotify_me/data/source/auth/auth_service.dart';
import 'package:spotify_me/data/source/auth/auth_supabase_service.dart';
import 'package:spotify_me/data/source/song/song_service.dart';
import 'package:spotify_me/data/source/song/song_supabase_service.dart';
import 'package:spotify_me/domain/repositories/auth/auth.dart';
import 'package:spotify_me/domain/repositories/song/song_repository.dart';
import 'package:spotify_me/domain/usecases/auth/signin.dart';
import 'package:spotify_me/domain/usecases/auth/signup.dart';
import 'package:spotify_me/domain/usecases/song/get_news_songs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;
Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthService>(AuthSupabaseServiceImpl());
  sl.registerSingleton<SongService>(SongSupabaseService());
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<SongRepository>(SongRepositoryImpl());
  sl.registerSingleton<SignupUsecase>(SignupUsecase());
  sl.registerSingleton<SigninUsecase>(SigninUsecase());
  sl.registerSingleton<GetNewsSongsUsecase>(GetNewsSongsUsecase());
  sl.registerSingleton<SupabaseClient>(Supabase.instance.client) ;
}

