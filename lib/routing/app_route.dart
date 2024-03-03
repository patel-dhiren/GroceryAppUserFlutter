import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:grocery_app_user/model/category.dart';
import 'package:grocery_app_user/views/dashboard/dashboard_view.dart';
import 'package:grocery_app_user/views/dashboard/search/search_view.dart';
import 'package:grocery_app_user/views/intro/intro_view.dart';
import 'package:grocery_app_user/views/itemlist/itemlist_view.dart';
import 'package:grocery_app_user/views/sign_in/sign_in_view.dart';
import 'package:grocery_app_user/views/user_detail/user_detail_view.dart';
import 'package:grocery_app_user/views/verification/verification_view.dart';
import '../constants/constants.dart';
import '../views/splash/splash_view.dart';


class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstant.splashView:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );

      case AppConstant.introView:
        return MaterialPageRoute(
          builder: (context) => IntroView(),
        );

      case AppConstant.loginView:
        return MaterialPageRoute(
          builder: (context) => SignInView(),
        );

      case AppConstant.verificationView:

        String mobileNumber = settings.arguments as String;

        return MaterialPageRoute(
          builder: (context) => VerificationView(mobileNumber: mobileNumber,),
        );

      case AppConstant.userDetailView:

        UserCredential user = settings.arguments as UserCredential;

        return MaterialPageRoute(
          builder: (context) => UserDetailView(credential: user,),
        );

      case AppConstant.itemListView:

        Category category = settings.arguments as Category;

        return MaterialPageRoute(
          builder: (context) => ItemListView(category: category,),
        );

      case AppConstant.dashboardView:

        return MaterialPageRoute(
          builder: (context) => DashboardView(),
        );

      case AppConstant.searchView:

        return MaterialPageRoute(
          builder: (context) => SearchView(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );
    }
  }
}
