import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_firebase_pro/UI/aut/login_screen.dart';
import 'package:my_first_firebase_pro/UI/firestore/firestore_list_screen.dart';
import 'package:my_first_firebase_pro/UI/firestore/image_upload.dart';
import 'package:my_first_firebase_pro/UI/posts/upload_image.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final aut = FirebaseAuth.instance;
    final user = aut.currentUser;

    if (user != null) {
      Timer(
        Duration(seconds: 3),
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImageUpload()),
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
