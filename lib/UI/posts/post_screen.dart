import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_firebase_pro/UI/aut/login_screen.dart';
import 'package:my_first_firebase_pro/UI/posts/addpost_screen.dart';
import 'package:my_first_firebase_pro/UI/util/toast_utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

final aut = FirebaseAuth.instance;

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: Text('WelCome'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                ToastUtils.show('Logged out successfully');

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              });
            },

            icon: const Icon(Icons.logout),
            color: Colors.black,
            focusColor: Colors.red,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddpostScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
