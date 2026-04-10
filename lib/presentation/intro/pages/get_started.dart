import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_me/common/widgets/button/basic_app_button.dart';
import 'package:spotify_me/core/configs/assets/app_images.dart';
import 'package:spotify_me/core/configs/assets/app_vectors.dart';
import 'package:spotify_me/presentation/choose_mode/pages/choose_mode.dart';

class GetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(AppImages.introBG),
              ),
            ),
          ),

          // Container(color: Colors.black.withValues(alpha: 0.15)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(AppVectors.logo),
                ),
                Spacer(),
                Text(
                  'Enjoy Listening To Music',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDADADA),
                  ),
                ),
                SizedBox(height: 21),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sagittis enim purus sed phasellus. Cursus ornare id scelerisque aliquam.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Color(0xFF797979)),
                ),
                SizedBox(height: 20),
                BasicAppButton(
                  title: 'Get Started',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ChooseModePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
