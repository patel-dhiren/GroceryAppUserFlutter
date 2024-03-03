import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../gen/assets.gen.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      var auth = FirebaseAuth.instance.currentUser;

      if(auth==null){
        Navigator.of(context).pushReplacementNamed(AppConstant.introView);
      }else{
        Navigator.of(context).pushReplacementNamed(AppConstant.dashboardView);
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade400,
      body: Center(
        child: Assets.images.appLogo.image(),
      ),
    );
  }
}
