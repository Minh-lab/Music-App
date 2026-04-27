import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrls {
  static String get supabaseCoversStorage => '${dotenv.env['SUPABASE_URL']}/storage/v1/object/public/covers';
  static String get supabaseSongsStorage => '${dotenv.env['SUPABASE_URL']}/storage/v1/object/public/songs';
}