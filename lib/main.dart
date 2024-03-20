/*

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bottom_sheet/bottom_sheet.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Upload Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showImagePickerBottomSheet(context);
          },
          child: Text('Choose Image'),
        ),
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.26,
      maxHeight: 1,
      bottomSheetColor: Colors.white,
      context: context,
      builder: (BuildContext context, ScrollController scrollController, double offset) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Choose an Option",style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.bold
                ),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      final image = await ImagePicker().pickImage(source: ImageSource.camera);
                      if (image != null) {
                        Navigator.pop(context); // Close the bottom sheet
                        // Add your image handling logic here
                      }
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.photo_camera,
                          size: 64,
                          color: Colors.grey,
                        ),
                        Text('Camera'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        Navigator.pop(context); // Close the bottom sheet
                        // Add your image handling logic here
                      }
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.photo_size_select_actual_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        Text('Gallery'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        Navigator.pop(context); // Close the bottom sheet
                        // Add your image handling logic here
                      }
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.add_to_drive_rounded,
                          size: 64,
                          color: Colors.grey,
                        ),
                        Text('Drive'),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Divider(),
              ),
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text("Cancel"))
              // Add Google Drive option and functionality here.
            ],
          ),
        );
      },
    );
  }
}
*/


import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screen/Donor/Donor_profile.dart';
import 'Screen/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Firebase messaging
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProfileProvider()),
    ],
    child: MyApp(),
  ),);
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: splash_screen());
  }
}

