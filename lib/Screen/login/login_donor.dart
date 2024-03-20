import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homeless/Screen/register/Register.dart';
import 'package:homeless/Screen/register/Register_donor.dart';
import 'package:homeless/model/service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Donor/donor_home.dart';
import '../Organization/home_screen.dart';

class Login_screen_donor extends StatefulWidget {
  const Login_screen_donor({Key? key}) : super(key: key);

  @override
  State<Login_screen_donor> createState() => _Login_screen_OrganazitionState();
}

class _Login_screen_OrganazitionState extends State<Login_screen_donor> {
  String error = "";
  bool pass = true;
  bool isloading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final form_key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: form_key,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xFF46BA80),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                  ),
                  Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "Welcome to Donor",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .75,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(100))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .1,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email address';
                                } else if (!RegExp(
                                    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null; // Return null if the input is valid.
                              },
                              controller: email,
                              decoration: InputDecoration(
                                  hintText: "Email address",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)
                                      //borderSide: BorderSide.none
                                      )),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null; // Return null if the input is valid.
                              },
                              controller: password,
                              obscureText: pass,
                              decoration: InputDecoration(
                                  suffixIcon: pass
                                      ? IconButton(
                                          icon: Icon(Icons.visibility),
                                          onPressed: () {
                                            setState(() {
                                              pass = false;
                                            });
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              pass = true;
                                            });
                                          },
                                        ),
                                  hintText: "Password",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)
                                      //borderSide: BorderSide.none
                                      )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              showAlertDialog(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * .15),
                              alignment: Alignment.topRight,
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Color(0xFF46BA80),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if(form_key.currentState!.validate()){
                                setState(() {
                                  isloading = true;
                                });
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                      email: email.text,
                                      password: password.text);
                                  final user = FirebaseAuth.instance.currentUser;

                                  if(user!.displayName == "Donor"){
                                    final DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('donor').doc(user.uid).get();
                                    final isApprove = snapshot.get('isApprove');


                                    Navigator.push(context,MaterialPageRoute(builder: (context)=> CustomInfoWindowExample()));
                                    showalert("Login Successfully", AlertType.success, context);
                                    /*  if(isApprove == true){

                                    var token = await NotificationService().getDeviceToken();
                                    print(token);
                                    FirebaseFirestore.instance.collection("donor").doc(FirebaseAuth.instance.currentUser!.uid).update({
                                      "token":token
                                    }).catchError((e)=>print(e));
                                    Navigator.push(context,MaterialPageRoute(builder: (context)=>const Navbar_screen()));
                                    showalert("Login Successfully", AlertType.success, context);
                                  }
                                  else{
                                    showalert("Your Profile is under verifing", AlertType.warning, context);
                                  }*/
                                  }
                                  else{
                                    showalert("Email is not register in Donor", AlertType.error, context);
                                  }
                                  //print(user!.displayName);
                                  setState(() {
                                    isloading = false;
                                  });
                                } catch (e) {
                                  if (e is FirebaseAuthException) {
                                    print(
                                        'Firebase Authentication Error: ${e.code}');
                                    print('Error Message: ${e.message}');
                                    if(e.code == "INVALID_LOGIN_CREDENTIALS"){
                                      print("hello");
                                    }
                                    switch (e.code) {
                                      case 'INVALID_LOGIN_CREDENTIALS':
                                        showalert("Your Email and Password is invalid", AlertType.error, context);
                                        break;
                                      case 'invalid-email':
                                        showalert("Your Email is invalid", AlertType.error, context);
                                        // Handle invalid email error
                                        break;
                                      case 'user-disabled':
                                        showalert(e.code, AlertType.error, context);
                                        // Handle user disabled error
                                        break;
                                      case 'user-not-found':
                                        showalert("Email is not Register", AlertType.error, context);
                                        // Handle user not found error
                                        break;
                                      case 'wrong-password':
                                        showalert("Password is mismatch", AlertType.error, context);
                                        // Handle wrong password error
                                        break;
                                      case 'too-many-requests':
                                      // Handle too many login attempts error
                                        break;
                                      case 'network-request-failed':
                                      // Handle network request failed error
                                        break;
                                      default:
                                      // Handle other Firebase Authentication errors
                                        break;
                                    }
                                  }
                                }

                              }


                            },
                            child: Container(
                                width: 200,
                                height: 50,
                                decoration: ShapeDecoration(
                                  color: Color(0xFF46BA80),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: isloading == false
                                    ? Text('Sign up your Account',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'SF Pro Text',
                                          fontWeight: FontWeight.w600,
                                          height: 2,
                                        ))
                                    : Center(
                                        child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have Account ? ",
                                style: TextStyle(fontSize: 16),
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Register_donor()));
                                  },
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xFF46BA80)),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  showalert(message,type,BuildContext context){
    return Alert(context: context,title: message,type: type,buttons: [
      DialogButton(
        child: Text(
          "Ok",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {Navigator.pop(context);
        setState(() {
          isloading = false;
        });
        } ,
        width: 120,
      )
    ],).show();
  }

  showAlertDialog(BuildContext context) {
    TextEditingController _emailController = new TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final emailField = TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
              hintText: 'something@example.com',
              // labelText: 'Account Email to Reset',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
        );

        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height / 4,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Reset Password Link",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                emailField,
                MaterialButton(
                  onPressed: () async {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: _emailController.text).then((value) {
                      Navigator.pop(context);
                      Alert(context: context,title: "Reset Password sent Successfully" , type: AlertType.success,buttons: [
                        DialogButton(child: const Text("Ok"), onPressed: (){
                          Alert(context: context).dismiss();
                          Navigator.pop(context);
                        } )
                      ]).show();

                    });
                    //Navigator.of(context).pop();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 12,
                    padding: EdgeInsets.all(15.0),
                    child: Material(
                        color: Color(0xFF46BA80),
                        borderRadius: BorderRadius.circular(25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Reset',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: 'helvetica_neue_light',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
