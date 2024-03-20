
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homeless/Screen/Organization/AddMember.dart';
import 'package:homeless/model/model.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class EditMemberPage extends StatefulWidget {
  String?
      memberId; // You may need to pass the member ID to identify the member you want to edit.

  EditMemberPage({
    required this.memberId,
  });

  @override
  _EditMemberPageState createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  int getMonthNumber(String monthName) {
    // Define a map to map month names to their numeric values
    final months = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };

    // Convert the month name to a numeric value
    return months[monthName] ?? 1; // Default to January if not found
  }

  File? _pickedImage;
  String downloadUrl = '';

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    } else {
      // The user canceled the image picking.
    }
    if (_pickedImage != null) {
      Reference storageReference = FirebaseStorage.instance.ref().child(
            'profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
          );

      UploadTask uploadTask = storageReference.putFile(_pickedImage!);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });

      if (taskSnapshot.state == TaskState.success) {
        downloadUrl = await storageReference.getDownloadURL();
        // Do something with the download URL (e.g., save it in Firestore or display it)
      }
    }
  }

  void _navigateToMapScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapScreen(),
      ),
    );

    if (result != null && result is LatLng) {
      setState(() {
        selectedLocation = result;
      });
    }
  }

  bool isLoading = true;

  String? genderValidationError;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController deviceSerialController = TextEditingController();
  TextEditingController pinNumberController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  // Add controllers for other fields

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedGender = '';
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;
  String? allotDevice = 'Yes';
  String? profileI = '';
  LatLng? selectedLocation;
  String? latitude = '';
  String? longitude = '';
  String getMonthName(int monthNumber) {
    // Define a map to map numeric month values to their names
    final months = {
      1: 'January',
      2: 'February',
      3: 'March',
      4: 'April',
      5: 'May',
      6: 'June',
      7: 'July',
      8: 'August',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December',
    };

    // Convert the numeric month value to a month name
    return months[monthNumber] ?? 'January'; // Default to January if not found
  }

  List<String> days = List.generate(31, (index) => (index + 1).toString());
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<String> years =
      List.generate(100, (index) => (DateTime.now().year - index).toString());

  @override
  void initState() {
    super.initState();

    // Fetch member data from Firestore based on the memberId
    FirebaseFirestore.instance
        .collection('HomeLessMembers')
        .doc(widget.memberId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // Retrieve data from Firestore
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        print('${widget.memberId}');

        // Update the state and controllers with retrieved data
        setState(() async {
          isLoading = false;
          fullNameController.text = data['fullName'] ?? '';
          emailController.text = data['email'] ?? '';
          phoneController.text = data['phone'] ?? '';
          deviceSerialController.text = data['deviceSerial'] ?? '';
          selectedGender = data['gender'] ?? '';
          selectedDay =
              DateTime.parse(data['dob'].toString()).day.toString() ?? '';
          selectedMonth =
              getMonthName(DateTime.parse(data['dob'].toString()).month)
                      .toString() ??
                  '';
          selectedYear =
              DateTime.parse(data['dob'].toString()).year.toString() ?? '';
          allotDevice = data['allotDevice'] ?? 'Yes';
          pinNumberController.text = data['pinNumber'] ?? '';
          userNameController.text = data['userName'] ?? '';
          profileI = data['profileImageUrl'] ?? '';
          selectedLocation = LatLng(double.parse(data['latitude'].toString()),
              double.parse(data['longitude'].toString()));
        });
      } else {
        // Handle the case where the document does not exist
        print('Document does not exist');
      }
    }).catchError((error) {
      // Handle errors
      print('Error fetching data: $error');
      setState(() {
        isLoading = false; // Set isLoading to false in case of an error
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(selectedLocation);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xFF46BA80),
        iconTheme: IconThemeData(color:Colors.white),
        title: const Text(
          'Edit Member',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              if (isLoading)
                Container(
                  height: 600,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Container(child: CircularProgressIndicator())),
                    ],
                  ),
                ) // Show progress indicator when isLoading is true
              else
                Container(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.amber[50],
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage("${profileI.toString()}"),
                              radius: 50,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                _pickImage(ImageSource.gallery);
                              },
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.amber,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(top: 10, left: 20),
                            child: const Text(
                              'Full name',
                              style: TextStyle(
                                color: Color(0xFF787878),
                                fontSize: 13,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: fullNameController,
                              validator: (value) {
                                if (value!.isEmpty || value == "") {
                                  return "Please enter name";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  fillColor: const Color(0x1943BA82),
                                  filled: true,
                                  hintText: "Full Name",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none)),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(top: 10, left: 20),
                            child: const Text(
                              'Email Address',
                              style: TextStyle(
                                color: Color(0xFF787878),
                                fontSize: 13,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value!.isEmpty || value == "") {
                                  return "Please Enter Email Address";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  fillColor: const Color(0x1943BA82),
                                  filled: true,
                                  hintText: "Email Address",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none)),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(top: 10, left: 20),
                            child: const Text(
                              'Phone',
                              style: TextStyle(
                                color: Color(0xFF787878),
                                fontSize: 13,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: phoneController,
                              validator: (value) {
                                if (value!.isEmpty || value == "") {
                                  return "Please enter Phone";
                                } else if (value.length < 10) {
                                  return "Please enter valid Phone";
                                }
                                return null;
                              },
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              // controller: phone,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  fillColor: const Color(0x1943BA82),
                                  filled: true,
                                  hintText: "Phone",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none)),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(top: 10, left: 20),
                            child: const Text(
                              'Username',
                              style: TextStyle(
                                color: Color(0xFF787878),
                                fontSize: 13,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: TextFormField(
                              controller: userNameController,
                              validator: (value) {
                                if (value!.isEmpty || value == "") {
                                  return "Please enter Username";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  fillColor: const Color(0x1943BA82),
                                  filled: true,
                                  hintText: "Username",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none)),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(top: 10, left: 20),
                            child: const Text(
                              'Choose The 6-digit PIN',
                              style: TextStyle(
                                color: Color(0xFF787878),
                                fontSize: 13,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: pinNumberController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                              ],
                              validator: (value) {
                                if (value!.isEmpty || value == "") {
                                  return "Please enter The 6-digit PIN";
                                } else if (value.length < 6) {
                                  return "Please enter valid PIN";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  fillColor: const Color(0x1943BA82),
                                  filled: true,
                                  hintText: "Choose The 6-digit PIN",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none)),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedGender = "Male";
                                genderValidationError =
                                    null; // Clear validation message
                              });
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/male.png',
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Male",
                                  style: TextStyle(
                                    color: selectedGender == "Male"
                                        ? Colors
                                            .green // Change color when selected
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20), // Add spacing between images
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedGender = "Female";
                                genderValidationError =
                                    null; // Clear validation message
                              });
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/female.png',
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Female",
                                  style: TextStyle(
                                    color: selectedGender == "Female"
                                        ? Colors
                                            .green // Change color when selected
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (genderValidationError != null)
                        Text(
                          genderValidationError!,
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 18),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Date OF Birth',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF787878),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomDropdown(
                                label: 'Day',
                                options: days,
                                selectedValue: selectedDay,
                                onChanged: (value) {
                                  setState(() {
                                    selectedDay = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                                width: 16), // Add spacing between dropdowns
                            Expanded(
                              flex: 1,
                              child: CustomDropdown(
                                label: 'Month',
                                options: months,
                                selectedValue: selectedMonth,
                                onChanged: (value) {
                                  setState(() {
                                    selectedMonth = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                                width: 16), // Add spacing between dropdowns
                            Expanded(
                              flex: 1,
                              child: CustomDropdown(
                                label: 'Year',
                                options: years,
                                selectedValue: selectedYear,
                                onChanged: (value) {
                                  setState(() {
                                    selectedYear = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Allot Device?",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                              width:
                                  16), // Add spacing between Text and Radio buttons
                          Row(
                            children: [
                              Radio(
                                value: 'Yes',
                                groupValue: allotDevice,
                                onChanged: (value) {
                                  setState(() {
                                    allotDevice = value as String?;
                                  });
                                },
                              ),
                              Text(
                                'Yes',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 'No',
                                groupValue: allotDevice,
                                onChanged: (value) {
                                  setState(() {
                                    allotDevice = value as String?;
                                  });
                                },
                              ),
                              Text(
                                'No',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (allotDevice == 'Yes')
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(top: 10, left: 20),
                              child: const Text(
                                'Device Serial',
                                style: TextStyle(
                                  color: Color(0xFF787878),
                                  fontSize: 13,
                                  fontFamily: 'SF Pro Text',
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: deviceSerialController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                validator: (value) {
                                  if (value!.isEmpty || value == "") {
                                    return "Please enter Device Serial";
                                  } else if (value.length < 6) {
                                    return "Please enter valid PIN";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    fillColor: const Color(0x1943BA82),
                                    filled: true,
                                    hintText: "Device Serial",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none)),
                              ),
                            )
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 21.0),
                        child: Row(
                          children: [
                            Icon(Icons.location_on),
                            TextButton(
                                onPressed: () {
                                  _navigateToMapScreen();
                                },
                                child: Text(
                                  'Pick HomeLess People Location',
                                  style: TextStyle(
                                    color: const Color(0xFF46BA80),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      if (selectedLocation != null)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Latitue : ",
                                ),
                                Text("${selectedLocation!.latitude}")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Longitude : "),
                                Text("${selectedLocation!.longitude}")
                              ],
                            )
                          ],
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            int monthNumber =
                                getMonthNumber(selectedMonth.toString());

                            DateTime date = DateTime(
                                int.parse(selectedYear.toString()),
                                monthNumber,
                                int.parse(selectedDay.toString()));

                            // Upload the picked image to Firebase Storage

                            Member member = Member(
                              fullName: fullNameController
                                  .text, // Full Name from TextEditingController
                              email: emailController
                                  .text, // Email from TextEditingController
                              phone: phoneController
                                  .text, // Phone from TextEditingController
                              gender: selectedGender,
                              dob: date.toString(),
                              allotDevice: allotDevice,
                              deviceSerial: deviceSerialController.text,
                              pinNumber: pinNumberController.text,
                              userName: userNameController
                                  .text, // Device Serial from TextEditingController
                              longitude: selectedLocation!.longitude.toString(),
                              latitude: selectedLocation!.latitude.toString(),
                            );

                            final CollectionReference membersCollection =
                                FirebaseFirestore.instance
                                    .collection('HomeLessMembers');

                            await membersCollection
                                .doc(widget.memberId)
                                .update({
                              'fullName': member.fullName,
                              'email': member.email,
                              'phone': member.phone,
                              'gender': member.gender,
                              'dob': member.dob,
                              'allotDevice': member.allotDevice,
                              'deviceSerial': member.deviceSerial,
                              'pinNumber': member.pinNumber,
                              'userName': member.userName,
                              'profileImageUrl': downloadUrl == ''
                                  ? 'https://firebasestorage.googleapis.com/v0/b/homeless-399009.appspot.com/o/profile_images%2Fimages.jpeg?alt=media&token=d4464296-feb1-4baa-83d6-17fefae82e2d&_gl=1*1owceyi*_ga*OTc2NTc3NTkwLjE2OTUwMDk4ODc.*_ga_CW55HF8NVT*MTY5NjgyMzIxMC4zMi4xLjE2OTY4MjU0NzIuNTAuMC4w'
                                  : downloadUrl,
                              'longitude': member.longitude,
                              'latitude': member.latitude,
                            });
                            setState(() {
                              isLoading = false;
                            });
                            final snackBar = SnackBar(
                              content: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ), // Add padding to all sides
                                child: Text('Data Saved Sucessfully'),
                              ),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Set the borderRadius
                              ),
                              padding: EdgeInsets.all(16.0), // Set padding
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          ;
                        },
                        child: Container(
                            width: 343,
                            height: 50,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF46BA80),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: isLoading
                                ? Center(
                                    child:
                                        CircularProgressIndicator()) // Show progress indicator when isLoading is true
                                : const Text('Save',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w600,
                                      height: 2,
                                    ))),
                      ),
                      TextButton(
                          onPressed: () async {
                            final CollectionReference membersCollection =
                                FirebaseFirestore.instance
                                    .collection('HomeLessMembers');

                            await membersCollection
                                .doc(widget.memberId)
                                .delete()
                                .then((value) => Navigator.pop(context));
                          },
                          child: Text(
                            "Delete Member",
                            style: TextStyle(color: Colors.red),
                          )),
                    ],
                  ),
                ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
