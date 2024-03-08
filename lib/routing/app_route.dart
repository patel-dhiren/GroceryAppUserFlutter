import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:grocery_app_user/model/category.dart';
import 'package:grocery_app_user/model/item.dart';
import 'package:grocery_app_user/model/order_data.dart';
import 'package:grocery_app_user/model/user_data.dart';
import 'package:grocery_app_user/views/address/address_view.dart';
import 'package:grocery_app_user/views/checkout/checkout_view.dart';
import 'package:grocery_app_user/views/dashboard/dashboard_view.dart';
import 'package:grocery_app_user/views/dashboard/search/search_view.dart';
import 'package:grocery_app_user/views/intro/intro_view.dart';
import 'package:grocery_app_user/views/item_detail/item_detail_view.dart';
import 'package:grocery_app_user/views/itemlist/itemlist_view.dart';
import 'package:grocery_app_user/views/my_cart/my_cart_view.dart';
import 'package:grocery_app_user/views/orderlist/orderlist_view.dart';
import 'package:grocery_app_user/views/profile_update/profile_update_view.dart';
import 'package:grocery_app_user/views/sign_in/sign_in_view.dart';
import 'package:grocery_app_user/views/user_detail/user_detail_view.dart';
import 'package:grocery_app_user/views/verification/verification_view.dart';
import '../constants/constants.dart';
import '../views/address_list/address_list_view.dart';
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

      case AppConstant.itemView:

        Item item = settings.arguments as Item;

        return MaterialPageRoute(
          builder: (context) => ItemDetailView(item: item,),
        );

      case AppConstant.profileUpdateView:

        UserData user = settings.arguments as UserData;

        return MaterialPageRoute(
          builder: (context) => ProfileUpdateView(user),
        );

      case AppConstant.checkoutView:

        return MaterialPageRoute(
          builder: (context) => CheckOutView(),
        );

      case AppConstant.addressListView:

        OrderData data = settings.arguments as OrderData;

        return MaterialPageRoute(
          builder: (context) => ListAddressesPage(data: data),
        );

      case AppConstant.addressView:

        return MaterialPageRoute(
          builder: (context) => AddAddressPage(),
        );

      case AppConstant.myCartView:

        return MaterialPageRoute(
          builder: (context) => MyCartView(),
        );

      case AppConstant.orderListView:

        return MaterialPageRoute(
          builder: (context) => OrderListView(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );
    }
  }
}
