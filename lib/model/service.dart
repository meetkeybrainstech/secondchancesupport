

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Firestore_service.dart';
import 'model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirestoreService _firestoreService = FirestoreService();

  Future<UserApp?> registerUser(BuildContext context, UserApp user) async {
    try {
      // Register the user with Firebase Authentication first (you can use email/password or Google sign-in)
      final UserCredential authResult =
          await _auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
      print(user.image);
      final User? firebaseUser = authResult.user;
      firebaseUser!.updateProfile(displayName: "Organization");
      // If Firebase Authentication succeeds, store user data in Firestore
      if (firebaseUser != null) {
        user = user.copyWith(
            uid: firebaseUser.uid); // Set the UID in the UserApp object
        await _firestoreService.createUserRecord(context, user);
        return user;
      }
      return null;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          // Fetch additional user data from Google account
          final String? displayName = user.displayName;
          final String? email = user.email;

          // Create a UserApp object
          final UserApp userData = UserApp(
            uid: user.uid,
            email: email,
            fullName: displayName,
            // Add other fields as needed
          );

          // Store the user data in Firestore
          await _firestoreService.createUserRecord(context, userData);

          return userData;
        }
      }
      return null;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? firebaseUser = authResult.user;
      firebaseUser!.updateProfile(displayName: "Organization");
      if (firebaseUser != null) {
        final user = await _firestoreService.getUserData(firebaseUser.uid);
        return "";
      }
      return "";
    } catch (error) {
      print(error.toString());
      return "Email and Password is invalid";
    }
  }
  // ... Other authentication methods and sign-in options

  Future<UserApp?> getUserData(String uid) async {
    return _firestoreService.getUserData(uid);
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<String> registerDonor(donorUser user) async {
    try {
      // Register the user with Firebase Authentication first (you can use email/password or Google sign-in)
      final UserCredential authResult =
          await _auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
      final User? firebaseUser = authResult.user;

      // If Firebase Authentication succeeds, store user data in Firestore
      if (firebaseUser != null) {
        firebaseUser.updateProfile(displayName: "Donor");
        user = user.copyWith(
            uid: firebaseUser.uid); // Set the UID in the UserApp object
        await _firestoreService.createdonorRecord(user);
        return "Account Register Successfully";
        //return user;
      }
      return "";
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          // The email address is already in use by another account
          return 'Email is already registered.';
        } else {
          // Handle other FirebaseAuthException errors
          return 'Firebase Authentication Error: ${e.code}';
        }
      } else {
        // Handle other exceptions
        print('Error: $e');
      }
    }
    return "";
  }
}
