
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minhasreceitas/data/firebase/FirebaseAuthentication.dart';
import 'package:minhasreceitas/model/Recipe.dart';

class ApplicationSingleton {
  static ApplicationSingleton _instance;
  factory ApplicationSingleton() {
    _instance ??= ApplicationSingleton._internalConstructor();
    return _instance;
  }
  ApplicationSingleton._internalConstructor();

  static Auth baseAuth;
  static FirebaseUser currentUser;
  static String recipeId;

}