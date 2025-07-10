import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
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
  String fullPhone = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login With Number'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            IntlPhoneField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              initialCountryCode: 'PK',
              keyboardType: TextInputType.phone,
              onChanged: (phone) {
                fullPhone = phone.completeNumber;
              },
            ),
            const SizedBox(height: 40),
            RoundButton(
              title: 'Send Code',
              loading: loading,
              onTap: () {
                if (fullPhone.isEmpty) {
                  ToastUtils.show("Please enter a valid number.");
                  return;
                }
                setState(() => loading = true);

                _auth.verifyPhoneNumber(
                  phoneNumber: fullPhone,
                  timeout: const Duration(seconds: 60),
                  verificationCompleted: (PhoneAuthCredential cred) {
                    // auto‑retrieval (Android only)
                    setState(() => loading = false);
                  },
                  verificationFailed: (FirebaseAuthException e) {
                    setState(() => loading = false);
                    ToastUtils.show(e.message ?? 'Verification failed');
                  },
                  codeSent: (String verificationId, int? resendToken) {
                    setState(() => loading = false);
                    ToastUtils.show("Code sent to $fullPhone");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VerfiyCodeScreen(verificationId: verificationId),
                      ),
                    );
                  },
                  codeAutoRetrievalTimeout: (String vid) {
                    setState(() => loading = false);
                    ToastUtils.show("Auto‑retrieve timeout");
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
