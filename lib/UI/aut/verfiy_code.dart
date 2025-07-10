import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_firebase_pro/UI/posts/post_screen.dart';
import 'package:my_first_firebase_pro/UI/util/toast_utils.dart';
import 'package:my_first_firebase_pro/UI/widgets/round_button.dart';

class VerfiyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerfiyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerfiyCodeScreen> createState() => _VerfiyCodeState();
}

class _VerfiyCodeState extends State<VerfiyCodeScreen> {
  bool loading = false;
  final codeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Code'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            TextFormField(
              controller: codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'Enter 6‑digit code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                counterText: '',
              ),
            ),
            const SizedBox(height: 40),
            RoundButton(
              title: 'Verify',
              loading: loading,
              onTap: () async {
                final smsCode = codeController.text.trim();
                if (smsCode.length != 6) {
                  ToastUtils.show("Enter a 6‑digit code");
                  return;
                }
                setState(() => loading = true);

                try {
                  final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: smsCode,
                  );
                  await _auth.signInWithCredential(credential);
                  ToastUtils.show("Phone verified!");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostScreen()),
                  );
                } on FirebaseAuthException catch (e) {
                  ToastUtils.show(e.message ?? 'Invalid code');
                } finally {
                  setState(() => loading = false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
