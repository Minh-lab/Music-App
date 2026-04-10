import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_me/core/configs/assets/app_vectors.dart';
import 'package:spotify_me/presentation/intro/pages/get_started.dart';

class SplashPage extends StatefulWidget {
  SplashPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: SvgPicture.asset(AppVectors.logo)));
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => GetStartedPage()),
    );
  }
}
