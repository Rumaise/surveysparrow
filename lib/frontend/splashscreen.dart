import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:surveysparrow/frontend/login_user.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.height,
      child: SplashScreen(
          seconds: 3,
          navigateAfterSeconds: new LogInPage(),
          title: new Text(
            'End-to-End Conversational Experience Management Platform',
            style: TextStyle(
                color: Colors.grey, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          image: new Image.asset(
            'assets/images/logo_sparrow.png',
            height: 500,
          ),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 100.0,
          loaderColor: Colors.red),
    );
  }
}
