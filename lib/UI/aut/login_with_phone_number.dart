import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_firebase_pro/UI/aut/verfiy_code.dart';
import 'package:my_first_firebase_pro/UI/util/toast_utils.dart';
import 'package:my_first_firebase_pro/UI/widgets/round_button.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final aut = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: Text('Login With Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 50),
            TextFormField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Enter Phone Number',
                prefixIcon: const Icon(Icons.phone),
                hintText: '+92 3112233334',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.indigo, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            SizedBox(height: 100),
            RoundButton(
              title: 'Login',
              onTap: () {
                aut.verifyPhoneNumber(
                  phoneNumber: phoneNumberController.text,
                  verificationCompleted: (PhoneAuthCredential credential) {},
                  verificationFailed: (FirebaseAuthException e) {
                    ToastUtils.show(e.message ?? 'Verification failed');
                  },
                  codeSent: (String verificationId, int? resendToken) {
                    ToastUtils.show("Code sent to your number");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VerfiyCodeScreen(verificationId: verificationId),
                      ),
                    );
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {
                    ToastUtils.show("Timeout occurred");
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
