import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_first_firebase_pro/UI/util/toast_utils.dart';
import 'package:my_first_firebase_pro/UI/widgets/round_button.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final postController = TextEditingController();
  bool loading = false;
  final firestore = FirebaseFirestore.instance;

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
        title: const Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: postController,
              decoration: InputDecoration(
                hintText: 'What is on your mind?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.all(12),
              ),
              maxLines: 5,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              style: const TextStyle(fontSize: 16),
              cursorColor: Colors.indigo,
            ),
            const SizedBox(height: 20),
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

                try {
                  String id = DateTime.now().microsecondsSinceEpoch.toString();
                  await firestore.collection('users').doc(id).set({
                    'title': title,
                    'id': id,
                    'createdAt': FieldValue.serverTimestamp(),
                  });

                  ToastUtils.show('Post added successfully');
                  if (mounted) Navigator.pop(context);
                } catch (error) {
                  ToastUtils.show('Failed to add post: $error');
                } finally {
                  if (mounted) setState(() => loading = false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
