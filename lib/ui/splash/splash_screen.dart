
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minhasreceitas/ext/Constants.dart';
import 'package:minhasreceitas/utils/ApplicationSingleton.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    _callPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Image.asset("assets/images/bk_splash.png"),
    );
  }

  _callPage()async{
    var user = await ApplicationSingleton.baseAuth.getCurrentUser();
    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(Duration(seconds: 3)).then((_) {
      if (user != null) {
        ApplicationSingleton.currentUser = user;
        Navigator.of(context).pushReplacementNamed(Constants.RECIPE_PAGE);
      } else {
        Navigator.of(context).pushReplacementNamed(Constants.LOGIN_PAGE);
      }
    });
  }
}
