import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_first_firebase_pro/UI/aut/login_screen.dart';
import 'package:my_first_firebase_pro/UI/posts/addpost_screen.dart';
import 'package:my_first_firebase_pro/UI/util/toast_utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

final auth = FirebaseAuth.instance;
final ref = FirebaseDatabase.instance.ref('post');

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Light background
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: const Text('📋 Posts'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                ToastUtils.show('Logged out successfully');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              });
            },
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
      ),

      // ------------ Decorated Body ------------
      body: StreamBuilder(
        stream: ref.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No data available'));
          }

          Map<dynamic, dynamic> map =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<dynamic> list = map.values.toList();

          return ListView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final title = list[index]['title'] ?? 'No Title';
              final id = list[index]['id'] ?? 'No ID';

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Text(
                      title.isNotEmpty ? title[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text("Post ID: $id"),
                ),
              );
            },
          );
        },
      ),

      /*
      // -------- FirebaseAnimatedList (optional alternative) --------
      body: FirebaseAnimatedList(
        query: ref,
        defaultChild: const Center(child: CircularProgressIndicator()),
        itemBuilder: (context, snapshot, animation, index) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text(snapshot.child('title').value.toString()),
              subtitle: Text("Post ID: ${snapshot.child('id').value.toString()}"),
              leading: CircleAvatar(
                backgroundColor: Colors.indigo,
                child: Text(
                  snapshot
                          .child('title')
                          .value
                          .toString()
                          .substring(0, 1)
                          .toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
      */
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddpostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
