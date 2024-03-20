import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DonorSProfile extends StatefulWidget {
  @override
  State<DonorSProfile> createState() => _DonorSProfileState();
}

class _DonorSProfileState extends State<DonorSProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic>? _userData;

  Future<void> _getUserData() async {
    _user = _auth.currentUser;

    if (_user != null) {
      final DocumentSnapshot userData = await _firestore
          .collection('users') // Replace with your collection name
          .doc(_user!.uid) // Use the user's UID as the document ID
          .get();

      setState(() {
        _userData = userData.data() as Map<String, dynamic>?;
        email.text = _userData!["email"];
        phone.text = _userData!["phone"];
        business_name.text = _userData!["organizationName"];
        address.text = _userData!["address"];
        area.text = _userData!["area"];
        pincode.text = _userData!["pincode"];
        state.text = _userData!["state"];
        country.text = _userData!["country"];
        _profileImageUrl = _userData!["profileImage"];
      });
    }
  }
  TextEditingController email  = TextEditingController();
  TextEditingController phone  = TextEditingController();
  TextEditingController business_name  = TextEditingController();
  TextEditingController address  = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController pincode  = TextEditingController();
  TextEditingController state  = TextEditingController();
  TextEditingController country  = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? _profileImageUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserData();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: Color.fromRGBO(231, 231, 231, 1)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1F2D36),
                      fontSize: 18,
                      fontFamily: 'SF Pro Text',
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: ShapeDecoration(
                          image:   _profileImageUrl != null
                              ? DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(_profileImageUrl!),
                          )
                              : DecorationImage(image: AssetImage("assets/organization_logo.png")),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: Color(0xFF43BA82),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          _pickAndUploadImage();
                        },
                        child: Container(
                          width: 22,
                          height: 22,
                          margin: const EdgeInsets.only(left: 40, top: 90),
                          decoration: const ShapeDecoration(
                            //color: Color(0xFF43BA82),
                            shape: OvalBorder(
                              side: BorderSide(width: 1, color: Colors.white),
                            ),
                          ),
                          child: Image.asset("assets/edit_image.png"),
                        ),
                      )
                    ],
                  ),
                  Container(
                   margin: const EdgeInsets.symmetric(horizontal: 20.0),
                   child: Card(

                       child:Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Container(
                            // padding:EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text("Email",style: TextStyle(fontSize: 17,color: Color(0xFF43BA82),fontWeight: FontWeight.bold),),
                                 SizedBox(
                                   width: MediaQuery.of(context).size.width * .6,
                                   height: 30,
                                   child: TextField(
                                     textAlign: TextAlign.right,
                                       controller: email,
                                     decoration: InputDecoration(
                                       hintText: "Email",
                                       border: InputBorder.none
                                     ),
                                   ),
                                 )
                                 //Text("abc@gmail.com",style: TextStyle(fontSize: 17),)
                               ],
                             ),
                           ),
                           Divider(thickness: 2,),
                           Container(
                           //  padding:EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text("Phone",style: TextStyle(fontSize: 17,color: Color(0xFF43BA82),fontWeight: FontWeight.bold),),
                                 SizedBox(
                                   width: MediaQuery.of(context).size.width * .4,
                                   height: 30,
                                   child: TextField(
                                     inputFormatters: [
                                       LengthLimitingTextInputFormatter(10),
                                     ],
                                     keyboardType: TextInputType.number,
                                     textAlign: TextAlign.right,
                                     controller: phone,
                                     decoration: InputDecoration(
                                         hintText: "phone",
                                         border: InputBorder.none
                                     ),
                                   ),
                                 )
                               ],
                             ),
                           ),
                         ],
                     ),
                       )
                   ),
                 ),
                  const SizedBox(
                    height: 30,
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(

                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                               height:40,
                                // padding:EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Organization Name",style: TextStyle(fontSize: 15,color: Color(0xFF43BA82),fontWeight: FontWeight.bold),),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .4,
                                      height: 30,
                                      child: TextField(
                                        controller: business_name,
                                        textAlign: TextAlign.right,
                                        //controller: ,
                                        decoration: InputDecoration(
                                            hintText: "Email",
                                            border: InputBorder.none

                                        ),
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(thickness: 2,),
                              Container(
                                height:40,
                                //  padding:EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Address",style: TextStyle(fontSize: 17,color: Color(0xFF43BA82),fontWeight: FontWeight.bold),),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .4,
                                      height: 30,
                                      child: TextField(
                                        controller: address,
                                        textAlign: TextAlign.right,
                                        //controller: ,
                                        decoration: InputDecoration(
                                            hintText: "Email",
                                            border: InputBorder.none
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(thickness: 2,),
                              Container(
                                height:40,
                                //  padding:EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Area/Sector",style: TextStyle(fontSize: 17,color: Color(0xFF43BA82),fontWeight: FontWeight.bold),),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .4,
                                      height: 30,
                                      child: TextField(
                                        controller: area,
                                        textAlign: TextAlign.right,
                                        //controller: ,
                                        decoration: InputDecoration(
                                            hintText: "Email",
                                            border: InputBorder.none
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(thickness: 2,),
                              Container(
                                height:40,
                                //  padding:EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Pincode",style: TextStyle(fontSize: 17,color: Color(0xFF43BA82),fontWeight: FontWeight.bold),),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .4,
                                      height: 30,
                                      child: TextField(
                                        controller: pincode,
                                        textAlign: TextAlign.right,
                                        //controller: ,
                                        decoration: InputDecoration(
                                            hintText: "Email",
                                            border: InputBorder.none
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(thickness: 2,),
                              Container(
                                height:40,
                                //  padding:EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("State/Province",style: TextStyle(fontSize: 17,color: Color(0xFF43BA82),fontWeight: FontWeight.bold),),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .4,
                                      height: 30,
                                      child: TextField(
                                        controller: state,
                                        textAlign: TextAlign.right,
                                        //controller: ,
                                        decoration: InputDecoration(
                                            hintText: "Email",
                                            border: InputBorder.none
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(thickness: 2,),
                              Container(
                                height:40,
                                //  padding:EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Country",style: TextStyle(fontSize: 17,color: Color(0xFF43BA82),fontWeight: FontWeight.bold),),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .4,
                                      height: 30,
                                      child: TextField(
                                        controller: country,
                                        textAlign: TextAlign.right,
                                        //controller: ,
                                        decoration: InputDecoration(
                                            hintText: "Email",
                                            border: InputBorder.none
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () async {
                      final userDocRef = _firestore.collection('users').doc(_user!.uid);
                      await userDocRef.update({
                      "address":address.text,
                        "apartmentName":area.text,
                        "country":country.text,
                        "email":email.text,
                        "organizationName":business_name.text,
                        "state":state.text,
                        "pincode":pincode.text,
                        "phone":phone.text
                      }).then((value) => Alert(
                        context: context,
                        title: "Profile Updated Successfully",
                        type: AlertType.success,
                        buttons: [
                          DialogButton(child: Text("Ok"), onPressed: (){
                            Alert(
                              context: context,

                            ).dismiss();
                          })
                        ]
                      ).show());
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * .85,
                        height: MediaQuery.of(context).size.height > 660 ? MediaQuery.of(context).size.height*.06:  MediaQuery.of(context).size.height*.06,
                        decoration: BoxDecoration(
                          color: Color(0xFF43BA82),
                          //   borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text("Save",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),)
                    ),
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );

  }
  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
     final File imageFile = File(pickedFile.path);
      String? imageUrl = await _uploadProfilePicture(imageFile);

      if (imageUrl != null) {
        await _updateProfileImage(imageUrl);
      }
    }
  }
  Future<String?> _uploadProfilePicture(File imageFile) async {
    try {
      final storageRef = _storage.ref().child('profile_images').child('${_user!.uid}.jpg');
      await storageRef.putFile(imageFile);
      final downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading profile picture: $e");
      return null;
    }
  }
  Future<void> _updateProfileImage(String imageUrl) async {
    try {
      final userDocRef = _firestore.collection('users').doc(_user!.uid);
      await userDocRef.update({'profileImage': imageUrl});
      setState(() {
        _profileImageUrl = imageUrl;
      });
    } catch (e) {
      print("Error updating profile image URL: $e");
    }
  }

}
