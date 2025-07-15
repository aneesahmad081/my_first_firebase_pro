import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_first_firebase_pro/UI/util/toast_utils.dart';
import 'package:my_first_firebase_pro/UI/widgets/round_button.dart';

class AddpostScreen extends StatefulWidget {
  const AddpostScreen({super.key});

  @override
  State<AddpostScreen> createState() => _AddpostScreenState();
}

class _AddpostScreenState extends State<AddpostScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('post');

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30),
            TextField(
              controller: postController,
              decoration: InputDecoration(
                hintText: 'What is on your mind?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.all(12),
              ),
              maxLines: 5,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              style: TextStyle(fontSize: 16),
              cursorColor: Colors.indigo,
            ),
            SizedBox(height: 20),
            RoundButton(
              title: 'Add',
              loading: loading,
              onTap: () async {
                final title = postController.text.trim();
                if (title.isEmpty) {
                  ToastUtils.show('Post content cannot be empty');
                  return;
                }

                setState(() => loading = true);

                String id = DateTime.now().millisecondsSinceEpoch.toString();

                await FirebaseDatabase.instance
                    .ref('post')
                    .child(id)
                    .set({'id': id, 'title': title})
                    .then((value) {
                      ToastUtils.show('Post added successfully');
                      Navigator.pop(context);
                    })
                    .catchError((error) {
                      ToastUtils.show('Failed to add post: $error');
                    });

                setState(() => loading = false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
