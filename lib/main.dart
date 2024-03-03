import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_user/routing/app_route.dart';
import 'package:grocery_app_user/themes/app_theme.dart';

import 'constants/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyCbhPeDncItRtCDqlHbz07sJv-OUAxlGa0',
        appId: '1:570297416659:android:21c62f32dc17faaddd8d26',
        messagingSenderId: '570297416659',
        projectId: 'grocerystoreapp-fa367',
        storageBucket: 'grocerystoreapp-fa367.appspot.com'
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme(context),
      debugShowCheckedModeBanner: false,
      initialRoute: AppConstant.splashView,
      onGenerateRoute: AppRoute.generateRoute,
    );
  }
}
