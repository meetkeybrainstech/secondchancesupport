import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'donor_drawer.dart';


class User {
  final String email;
  final String fullname;
  late final String image;
  final String gender;
  final String location;
  final String year;
  final String phone;

  User({
    required this.email,
    required this.fullname,
    required this.image,
    required this.gender,
    required this.location,
    required this.year,
    required this.phone,
  });
}

class UserProfileProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? _user;

  User? get user => _user;

  Future<void> fetchUserProfile() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userData =
      await _firestore.collection('donor').doc(currentUser.uid).get();
      _user = User(
        email: currentUser.email ?? '',
        fullname: userData['fullName'] ?? '',
        image: userData['image'] ?? '',
        gender: userData['gender'] ?? '',
        location: userData['location'] ?? '',
        year: userData['year'] ?? '',
        phone: userData['phone'] ?? '',
      );
      notifyListeners();
    }
  }

  Future<void> updateProfile(User updatedUser) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('donor').doc(currentUser.uid).update({
        'fullName': updatedUser.fullname,
        'image': updatedUser.image,
        'gender': updatedUser.gender,
        'location': updatedUser.location,
        'year': updatedUser.year,
        'phone': updatedUser.phone,
      });
      _user = updatedUser;
      notifyListeners();
    }
  }

  Future<String?> uploadImageToStorage(String filePath) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final storageRef = _storage.ref().child('profile_images').child(currentUser.uid + '.jpg');
      final uploadTask = storageRef.putFile(File(filePath));
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    }
    return null;
  }
}


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserProfileProvider>().fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfileProvider>().user;
    
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Color.fromRGBO(237, 237, 237, 1),
      appBar: AppBar(

        centerTitle: true,
        title: Text('Homeless',style: TextStyle(
            color: Colors.black
        ),),
        elevation: 0,
        actions: [
          RawMaterialButton(
            onPressed: () {
              _scaffoldkey.currentState!.openEndDrawer();
            },
            child: Icon(
              Icons.dehaze,
              size: 20.0,
              color: Colors.black,
            ),
            shape: CircleBorder(
              side: BorderSide(color: Colors.black, width: 2.0),
            ),
            //fillColor: Colors.transparent, // Set the background color to transparent
            constraints: BoxConstraints.tight(Size(40.0, 40.0)), // Set the button size
            padding: EdgeInsets.all(8.0), // Adjust the padding as needed
            elevation: 2.0, // Add elevation if desired
            highlightElevation: 4.0, // Add elevation when pressed if desired
            // Set the border color and width
          )

        ],
        backgroundColor: Colors.white,
      ),
      endDrawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: ShapeDecoration(
                          image: userProfile!.image== "null" ?  DecorationImage(
                            image:
                            AssetImage("assets/noImage.png"),
                            fit: BoxFit.cover,
                          ) : DecorationImage(image: NetworkImage(userProfile!.image),fit: BoxFit.cover),
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
                        onTap: ()async{
                          final updatedUser = User(
                            email: userProfile.email,
                            fullname: _fullnameController.text,
                            image: userProfile.image, // Keep the current image URL
                            gender: _genderController.text,
                            location: _locationController.text,
                            year: _yearController.text,
                            phone: _phoneController.text,
                          );

                          final imageFilePath = await ImagePicker().pickImage(source: ImageSource.gallery); // Implement this function

                          if (imageFilePath != null) {
                            final newImageURL = await context
                                .read<UserProfileProvider>()
                                .uploadImageToStorage(imageFilePath.path);

                            if (newImageURL != null) {
                              updatedUser.image = newImageURL;
                            }
                          }

                          // Update user data in Firestore with the new image URL.
                          await context.read<UserProfileProvider>().updateProfile(updatedUser);
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

                  const SizedBox(
                    height: 30,
                  ),
                  Card(

                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEDF9F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Icon(Icons.person,color: Color(0xFF43BA82),),
                            ),
                            title: TextFormField(
                              // initialValue: snapshot.data!.fullName,
                              controller: _fullnameController..text =   userProfile.fullname,
                              decoration: InputDecoration(
                                hintText: "Enter FullName",
                                border: InputBorder.none,
                              ),
                            ),
                            trailing:InkWell(
                              onTap:(){
                                /* print(name.text);
                        FirebaseFirestore.instance.collection("donor").doc(snapshot.data!.uid).update(
                            {
                              "fullName":name.text
                            }).then((value){

                          Alert(
                              context: context,type: AlertType.success,title: "FullName Updated Successfully",
                              buttons: [
                                DialogButton(child: Text("Ok"), onPressed: (){
                                  Alert(context: context).dismiss();
                                })
                              ]
                          ).show();

                        } );*/
                              },
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Image.asset("assets/arrow.png")
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: const Divider(height: 2,thickness: 2,)),
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEDF9F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Icon(Icons.phone,color: Color(0xFF43BA82),),
                            ),
                            title:  TextFormField(
                              controller: _phoneController..text = userProfile.phone,
                              decoration: InputDecoration(
                                hintText: "1234567890",
                                border: InputBorder.none,
                              ),
                            ),
                            trailing:InkWell(
                              onTap:(){
                                //print(name.text);
                                /* FirebaseFirestore.instance.collection("donor").doc(snapshot.data!.uid).update(
                            {
                              "phone":phone.text
                            }).then((value){

                          Alert(
                              context: context,type: AlertType.success,title: "Phone Updated Successfully",
                              buttons: [
                                DialogButton(child: Text("Ok"), onPressed: (){
                                  Alert(context: context).dismiss();
                                  setState(() {

                                  });
                                })
                              ]
                          ).show();

                        } );*/
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Image.asset("assets/arrow.png"),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: const Divider(height: 2,thickness: 2,)),
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEDF9F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Icon(Icons.mail,color: Color(0xFF43BA82),),
                            ),
                            title: TextFormField(
                              controller: _emailController..text = userProfile.email,
                              decoration: InputDecoration(
                                hintText: "Enter Email",
                                border: InputBorder.none,
                              ),
                            ),
                            trailing:InkWell(
                              /*onTap:(){
                        print(name.text);
                        FirebaseFirestore.instance.collection("donor").doc(snapshot.data!.uid).update(
                            {
                              "email":email.text
                            }).then((value){

                          Alert(
                              context: context,type: AlertType.success,title: "Phone Updated Successfully",
                              buttons: [
                                DialogButton(child: Text("Ok"), onPressed: (){
                                  Alert(context: context).dismiss();
                                })
                              ]
                          ).show();
                          setState(() {

                          });
                        } );*/

                              child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Image.asset("assets/arrow.png")
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: const Divider(height: 2,thickness: 2,)),
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEDF9F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Image.asset("assets/year.png"),
                            ),
                            title:TextFormField(

                              controller: _yearController..text = userProfile.year,
                              decoration: InputDecoration(
                                hintText: "Enter Year",
                                border: InputBorder.none,
                              ),
                            ),
                            trailing:InkWell(
                              onTap:(){
                                /* print(name.text);
                        FirebaseFirestore.instance.collection("donor").doc(snapshot.data!.uid).update(
                            {
                              "year":year.text
                            }).then((value){

                          Alert(
                              context: context,type: AlertType.success,title: "Year Updated Successfully",
                              buttons: [
                                DialogButton(child: Text("Ok"), onPressed: (){
                                  Alert(context: context).dismiss();
                                })
                              ]
                          ).show();
                          setState(() {

                          });
                        } );*/
                              },
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Image.asset("assets/arrow.png")
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: const Divider(height: 2,thickness: 2,)),
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEDF9F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Image.asset("assets/location.png"),
                            ),
                            title: TextFormField(
                              controller: _locationController..text = userProfile.location,
                              decoration: InputDecoration(
                                hintText: "Enter Location",
                                border: InputBorder.none,
                              ),
                            ),
                            trailing:InkWell(
                              onTap:(){
                                /* print(name.text);
                        FirebaseFirestore.instance.collection("donor").doc(snapshot.data!.uid).update(
                            {
                              "location":location.text
                            }).then((value){

                          Alert(
                              context: context,type: AlertType.success,title: "lcoation Updated Successfully",
                              buttons: [
                                DialogButton(child: Text("Ok"), onPressed: (){
                                  Alert(context: context).dismiss();
                                })
                              ]
                          ).show();
                          setState(() {

                          });
                        } );*/
                              },
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Image.asset("assets/arrow.png")

                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: const Divider(height: 2,thickness: 2,)),
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEDF9F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Image.asset("assets/gender.png"),
                            ),
                            title: TextFormField(
                              controller: _genderController..text = userProfile.gender,

                              decoration: InputDecoration(
                                hintText: "Enter Gender",
                                border: InputBorder.none,
                              ),
                            ),
                            trailing:InkWell(
                              onTap:(){
                                /*  print(name.text);
                        FirebaseFirestore.instance.collection("donor").doc(snapshot.data!.uid).update(
                            {
                              "gender":gender.text
                            }).then((value){

                          Alert(
                              context: context,type: AlertType.success,title: "Gender Updated Successfully",
                              buttons: [
                                DialogButton(child: Text("Ok"), onPressed: (){
                                  Alert(context: context).dismiss();
                                })
                              ]
                          ).show();
                          setState(() {

                          });
                        } );*/
                              },
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Image.asset("assets/arrow.png")
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );


    }
}
