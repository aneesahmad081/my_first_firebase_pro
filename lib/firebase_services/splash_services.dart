import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_firebase_pro/UI/aut/login_screen.dart';
import 'package:my_first_firebase_pro/UI/posts/post_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final aut = FirebaseAuth.instance;
    final user = aut.currentUser;

    if (user != null) {
      Timer(
        Duration(seconds: 3),
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostScreen()),
        ),
      );
    } else {
      Timer(
        Duration(seconds: 3),
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ),
      );
    }
  }
}
