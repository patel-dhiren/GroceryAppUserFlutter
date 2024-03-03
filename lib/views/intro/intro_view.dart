import 'package:flutter/material.dart';
import 'package:grocery_app_user/constants/constants.dart';
import 'package:grocery_app_user/widget/custom_button.dart';

import '../../gen/assets.gen.dart';

class IntroView extends StatelessWidget {
  const IntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Assets.images.introBg
              .image(fit: BoxFit.cover, width: double.infinity),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.all(24),
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        Assets.images.introBgTran.path,
                      ),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome\nto our store',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Get your groceries in as fast as one hour',
                    style: TextStyle(color: Colors.black38),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    title: 'Get Started',
                    backgroundColor: Colors.green.shade400,
                    foregroundColor: Colors.white,
                    callback: () {
                        Navigator.pushNamed(context, AppConstant.loginView);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
