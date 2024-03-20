import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: PhoneNumberLoginScreen()));
}


class PhoneNumberLoginScreen extends StatefulWidget {
  @override
  _PhoneNumberLoginScreenState createState() => _PhoneNumberLoginScreenState();
}

class _PhoneNumberLoginScreenState extends State<PhoneNumberLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String phoneNumber = '';
  String smsCode = '';
  String verificationId = '';

  Future<void> verifyPhoneNumber() async {
    try {
      // Ensure the phone number is in E.164 format, including the country code.
      phoneNumber = '+91' + phoneNumber; // Replace '+1' with the appropriate country code.

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Handle auto-verification or instant verification (not using OTP).
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Error: ${e.message}');
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          // Save the verification ID to be used for signing in later.
          this.verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto retrieval timeout.
        },
      );

      // You can show an OTP input field here after sending the OTP.
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> signInWithPhoneNumber() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);
      // User is signed in.
    } catch (e) {
      print('Error: $e');
      // Handle sign-in error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Number Login'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (value) {
                phoneNumber = value;
              },
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            ElevatedButton(
              onPressed: verifyPhoneNumber,
              child: Text('Send OTP'),
            ),
            TextField(
              onChanged: (value) {
                smsCode = value;
              },
              decoration: InputDecoration(labelText: 'OTP'),
            ),
            ElevatedButton(
              onPressed: signInWithPhoneNumber,
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
