import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homeless/Screen/login/login_mechant.dart';
import 'package:homeless/Screen/login/login_organization.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserRecord(BuildContext context, UserApp user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'organizationName': user.organizationName,
        'email': user.email,
        'contactPerson': user.contactPerson,
        'phone': user.phone,
        'password': user.password,
        'address': user.address,
        'area': user.apartmentName,
        'pincode': user.city,
        'state': user.state,
        'country': user.country,
        'images': user.image,
        'isApprove':false,
        'profileImage':"https://firebasestorage.googleapis.com/v0/b/homeless-399009.appspot.com/o/profile_images%2Fimages.jpeg?alt=media&token=d4464296-feb1-4baa-83d6-17fefae82e2d"
      });
      Alert(
        context: context,
        title: "Register Successfully",
        type: AlertType.success,
        buttons: [
          DialogButton(
            child: Text("Ok"),
            onPressed: () {
              Alert(context: context).dismiss();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login_screen_Organazition(),
                ),
              );
            },
          ),
        ],
      ).show();
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        Alert(
            context: context,
            title: "Email Already Registered",
            type: AlertType.warning,
            buttons: [
              DialogButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Alert(context: context).dismiss();
                  })
            ]).show();
      }
    }
  }

  Future<void> createdonorRecord(donorUser user) async {
    try {
      await _firestore.collection('donor').doc(user.uid).set({
        'email': user.email,
        'phone': user.phone,
        'password': user.password,
        'fullName': user.fullName,
        'gender': user.gender,
        'image':
            "https://firebasestorage.googleapis.com/v0/b/homeless-399009.appspot.com/o/profile_images%2Fimages.jpeg?alt=media&token=d4464296-feb1-4baa-83d6-17fefae82e2d",
        'year': "",
        'location': "",
        'isApprove':false
      });
    } catch (e) {
      print('Error creating user record: $e');
    }
  }

  Future<UserApp?> getUserData(String uid) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return UserApp(
          uid: uid,
          organizationName: data['organizationName'],
          email: data['email'],
          contactPerson: data['contactPerson'],
          phone: data['phone'],
          password: data['password'],
          fullName: data['fullName'],
          address: data['address'],
          apartmentName: data['apartmentName'],
          city: data['city'],
          state: data['state'],
          country: data['country'],
        );
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<void> addMerchantData(BuildContext context, Merchant merchant) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final UserCredential authResult =
          await _auth.createUserWithEmailAndPassword(
        email: merchant.Email!,
        password: merchant.ChoosePassword!,
      );

      // final User? firebaseUser = authResult.user;
      final User? firebaseUser = authResult.user;
      firebaseUser!.updateProfile(displayName: "Merchant");

      await _firestore.collection('merchants').doc(firebaseUser.uid).set({
        'Name': merchant.Name,
        'Email': merchant.Email,
        'Phone': merchant.Phone,
        'ChoosePassword': merchant.ChoosePassword,
        'ConfirmPassword': merchant.ConfirmPassword,
        'BusinessName': merchant.BusinessName,
        'BusinessCategory': merchant.BusinessCategory,
        'StreetAddress': merchant.StreetAddress,
        'AreaSector': merchant.AreaSector,
        'Pincode': merchant.Pincode,
        'State': merchant.State,
        'Country': merchant.Country,
        'AccountNumber': merchant.AccountNumber,
        'BankName': merchant.BankName,
        'CityBank': merchant.CityBank,
        'StateBank': merchant.StateBank,
        'BranchLocation': merchant.BranchLocation,
        'document_images':merchant.images,
        'image':"https://firebasestorage.googleapis.com/v0/b/homeless-399009.appspot.com/o/profile_images%2Fimages.jpeg?alt=media&token=d4464296-feb1-4baa-83d6-17fefae82e2d",
        'isApprove':false
      });

      Alert(
        context: context,
        title: "Register Successfully",
        type: AlertType.success,
        buttons: [
          DialogButton(
            child: Text("Ok"),
            onPressed: () {
              Alert(context: context).dismiss();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login_screen_Merchant(),
                ),
              );
            },
          ),
        ],
      ).show();
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        Alert(
            context: context,
            title: "Email Already Registered",
            type: AlertType.warning,
            buttons: [
              DialogButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Alert(context: context).dismiss();
                  })
            ]).show();
      }
    }
  }
}
