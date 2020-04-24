
import 'package:flutter/material.dart';
import 'package:minhasreceitas/data/firebase/FirebaseAuthentication.dart';
import 'package:minhasreceitas/ui/login/login_page.dart';
import 'package:minhasreceitas/ui/notifications/notifications_page.dart';
import 'package:minhasreceitas/ui/recipe/recipe_page.dart';
import 'package:minhasreceitas/ui/recipeDetail/recipe_detail.dart';
import 'package:minhasreceitas/ui/recipeRegister/recipe_register.dart';
import 'package:minhasreceitas/ui/splash/splash_screen.dart';
import 'package:minhasreceitas/utils/ApplicationSingleton.dart';

import 'ext/Constants.dart';
import 'ext/MyColor.dart';


void main() => runApp(MyApp());

final routes = {
  Constants.SPLAS_SCREEN_PAGE: (BuildContext context) => new SplashScreen(),
  Constants.LOGIN_PAGE: (BuildContext context) => new Login(),
  Constants.RECIPE_PAGE: (BuildContext context) => new RecipePage(),
  Constants.RECIPE_REGISTER: (BuildContext context) => new RecipeRegister(),
  Constants.RECIPE_DETAIL: (BuildContext context) => new RecipeDetail(),
  Constants.NOTIFICATIONS_PAGE: (BuildContext context) => new NotificationsPage()
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ApplicationSingleton.baseAuth = new Auth();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MyColor.primaryColorMaterial,
      ),
      routes: routes,
    );
  }
}