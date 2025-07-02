import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_first_firebase_pro/UI/aut/login_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    Timer.periodic(Duration(seconds: 3), (timer) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }
}
