import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homeless/Screen/register/Register.dart';
import 'package:homeless/Screen/register/Register_donor.dart';
import 'package:homeless/Screen/register/Register_merchant.dart';
import 'package:homeless/Screen/Organization/home_screen.dart';
import 'package:homeless/Screen/login/login_donor.dart';
import 'package:homeless/Screen/login/login_mechant.dart';
import 'package:homeless/Screen/login/login_organization.dart';
import 'package:homeless/Screen/splash_screen.dart';

import 'Donor/donor_home.dart';
import 'merchant/Homepage_merchant.dart';

class Account_type extends StatefulWidget {
  const Account_type({Key? key}) : super(key: key);

  @override
  State<Account_type> createState() => _Account_typeState();
}

class _Account_typeState extends State<Account_type> {
  var seleted_index = 0;
  @override
  Widget build(BuildContext context) {
    var height= MediaQuery.of(context).size.height ;
    var width= MediaQuery.of(context).size.width ;
     return WillPopScope(
       onWillPop: ()async{
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>splash_screen()),(Route<dynamic> route) => false);
         return false;
       },
       child: Scaffold(

        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*.05,
              ),
              Row(
                children: [
                  IconButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>splash_screen()));
                  }, icon: Icon(Icons.arrow_back)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .25,
                  ),
                  Text(
                    'Account Type',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1F2D36),
                      fontSize: 18,
                      fontFamily: 'SF Pro Text',
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ],
              ),
              Text(
                'Kindly select account type from below options.',
                style: TextStyle(
                  color: Color(0xFF787878),
                  fontSize: 13,
                  fontFamily: 'SF Pro Text',
                  fontWeight: FontWeight.w400,
                  height: 0.08,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .03,
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    seleted_index = 1;
                    print(seleted_index);
                  });
                },
                child: Container(
                  width: width * .4,
                  height: height * .2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: seleted_index == 1 ? Border.all(color: Color(0xFF46BA80)): Border.all(color: Colors.white),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/organization.png",
                      height: MediaQuery.of(context).size.height * .1,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .03,
                      ),
                      Text(
                        'Organization',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:seleted_index == 1 ? Color(0xFF46BA80) : Colors.black,
                          fontSize: 16,
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w500,
                          height: 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .04,
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    seleted_index = 2;
                  });
                },
                child: Container(
                  width: width * .4,
                  height: height * .2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: seleted_index == 2 ? Border.all(color: Color(0xFF46BA80)): Border.all(color: Colors.white),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/merchant.png",
                        height: MediaQuery.of(context).size.height * .1,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .03,
                      ),
                      Text(
                        'Merchant',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:seleted_index == 2 ? Color(0xFF46BA80) : Colors.black,
                          fontSize: 16,
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w500,
                          height: 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .04,
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    seleted_index = 3;
                  });

                },
                child: Container(
                  width: width * .4,
                  height: height * .2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: seleted_index == 3 ? Border.all(color: Color(0xFF46BA80)): Border.all(color: Colors.white),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/Donor.png",
                        height: MediaQuery.of(context).size.height * .1,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .03,
                      ),
                      Text(
                        'Donor',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:seleted_index == 3 ? Color(0xFF46BA80) : Colors.black,
                          fontSize: 16,
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w500,
                          height: 0.06,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: height * .05,),
              if(height > 700)
              SizedBox(
                height: MediaQuery.of(context).size.height * .07,
              ),
              InkWell(
                onTap: (){
                  if(seleted_index == 0){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select the Account type")));
                  }else if(seleted_index == 1){
                    if(FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.displayName == "Organization"){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Navbar_screen() ));
                    }
                    else{
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Login_screen_Organazition() ));
                    }

                  }else if(seleted_index == 2){
                    if(FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.displayName == "Merchant"){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchDemo() ));
                    }
                    else{
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Login_screen_Merchant() ));
                    }

                  }
                  else if(seleted_index == 3){
                    if(FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.displayName == "Donor"){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomInfoWindowExample() ));
                    }
                    else{
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Login_screen_donor() ));
                    }
                  }

                },
                child: Container(
                    width: 343,
                    height: 50,
                    decoration: ShapeDecoration(
                      color: Color(0xFF46BA80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w600,
                          height: 2,
                        ))),
              ),
            ],
          ),
        ),
    ),
     );
  }
}
