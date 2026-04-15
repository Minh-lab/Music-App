import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify_me/core/configs/theme/app_theme.dart';
import 'package:spotify_me/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:spotify_me/presentation/splash/pages/splash.dart';
import 'package:spotify_me/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  late String storagePath;
  if (kIsWeb) {
    storagePath = ''; // Not used for web
  } else {
    try {
      storagePath = (await getTemporaryDirectory()).path;
    } catch (e) {
      // Bắt mọi lỗi (bao gồm cả ArgumentError: libdartjni.so)
      // Dùng đường dẫn internal mặc định của Android làm fallback
      storagePath = '/data/user/0/com.example.spotify_me/cache';
    }
  }

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(storagePath),
  );

  await Supabase.initialize(
    url:
        'https://remuryqmfmlqmmpqzbhc.supabase.co', // TODO: Create and replace this with your project URL from Supabase dashboard
    anonKey: 'sb_publishable_EwpcmPHBjtv080WsxQDyKw_n3S4lfK2',
  );

  await initializeDependencies();
  

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ThemeCubit())],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp(
          title: 'Flutter Demo',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          debugShowCheckedModeBanner: false,
          home: SplashPage(),
        ),
      ),
    );
  }
}
