import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homeless/model/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as location;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class AddMemberPage extends StatefulWidget {
  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
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

  LatLng? selectedLocation;
  bool isLoading = false;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController deviceSerialController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedGender = '';
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;
  String? allotDevice = 'No';
  String? genderValidationError;

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

  String memberId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46BA80),
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Add Member',
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
              Center(
                child: GestureDetector(
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _pickedImage != null
                        ? FileImage(_pickedImage!)
                        : null, // Show image if picked, or null if no image selected
                    child: _pickedImage == null
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                        : null, // Show camera icon if no image selected
                  ),
                ),
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
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
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
                      controller: pinController,
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
              Padding(
                padding: const EdgeInsets.only(left: 21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                                  ? Colors.green // Change color when selected
                                  : Colors.grey,
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
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Female",
                            style: TextStyle(
                              color: selectedGender == "Female"
                                  ? Colors.green // Change color when selected
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                    SizedBox(width: 16), // Add spacing between dropdowns
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
                    SizedBox(width: 16), // Add spacing between dropdowns
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
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      width: 16), // Add spacing between Text and Radio buttons
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
                            color: Colors.grey, fontWeight: FontWeight.bold),
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
                            color: Colors.grey, fontWeight: FontWeight.bold),
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
                    SharedPreferences prefs= await SharedPreferences.getInstance();
                    var email = prefs.getString("email");
                    var password = prefs.getString("password");
                    var oid = prefs.getString("uid");
                    String address = await getLocationAddress(selectedLocation!.latitude, selectedLocation!.longitude);
                    int monthNumber = getMonthNumber(selectedMonth.toString());

                    DateTime date = DateTime(int.parse(selectedYear.toString()),
                        monthNumber, int.parse(selectedDay.toString()));

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
                      pinNumber: pinController.text,
                      userName: userNameController
                          .text, // Device Serial from TextEditingController
                      longitude: selectedLocation!.longitude.toString(),
                      latitude: selectedLocation!.latitude.toString(),
                    );
                    UserCredential userCredential = await   FirebaseAuth.instance.createUserWithEmailAndPassword(email: member.email!, password: "123456");
                    final User? firebaseUser = userCredential.user;
                    firebaseUser!.updateProfile(displayName: "HomelessMember");
                    String uid = userCredential.user!.uid;
                    final CollectionReference membersCollection =
                    FirebaseFirestore.instance
                        .collection('HomeLessMembers');
                    await membersCollection.doc(userCredential.user!.uid).set({
                      'fullName': member.fullName,
                      'email': member.email,
                      'phone': member.phone,
                      'gender': member.gender,
                      'dob': member.dob,
                      'allotDevice': member.allotDevice,
                      'deviceSerial': member.deviceSerial,
                      'pinNumber': member.pinNumber,
                      'userName': member.userName,
                      'donationRecived':"",
                      'walletBalance':"",
                      "joinDate":DateTime.now().toString(),
                      "address":address,
                      'profileImageUrl': downloadUrl == ''
                          ? 'https://firebasestorage.googleapis.com/v0/b/homeless-399009.appspot.com/o/profile_images%2Fimages.jpeg?alt=media&token=d4464296-feb1-4baa-83d6-17fefae82e2d&_gl=1*1owceyi*_ga*OTc2NTc3NTkwLjE2OTUwMDk4ODc.*_ga_CW55HF8NVT*MTY5NjgyMzIxMC4zMi4xLjE2OTY4MjU0NzIuNTAuMC4w'
                          : downloadUrl,
                      'longitude': member.longitude,
                      'latitude': member.latitude,
                      'organizationId':oid,
                      'about':"",
                      'isApprove':true
                    });

                    setState(() {
                      isLoading = false;
                    });
                    final snackBar = SnackBar(
                      content: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ), // Add padding to all sides
                        child: Text('Data Inserted Sucessfully'),
                      ),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10.0), // Set the borderRadius
                      ),
                      padding: EdgeInsets.all(16.0), // Set padding
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    await FirebaseAuth.instance.signOut();
                 //   print(FirebaseAuth.instance.currentUser!.uid ??"hello");
                    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.toString(), password: password.toString());
                   // print(FirebaseAuth.instance.currentUser!.uid);
                   // sendWelcomeEmail(member.email!,member.fullName!);
                  }
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
                        : const Text('Add Member',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w600,
                              height: 2,
                            ))),
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


  Future<void> sendWelcomeEmail(String recipientEmail, String fullname) async {
    String username = 'sagar_desai@sparrowsofttech.com';
    String password = 'Sagar@123';

    String text = "Dear $fullname,\n\nWe hope this message finds you well. As part of our ongoing commitment to security and privacy, we have updated your authentication credentials for accessing our services.\n\n Please find your new email and password below:\n\nEmail: $recipientEmail \nPassword: 123456 \n\nWith these credentials, you can securely access and authenticate your account. Please make sure to keep this information confidential and do not share it with anyone.\n\nIf you did not request these changes or have any concerns, please contact our support team immediately at [Support Email] or [Support Phone Number].\n\nThank you for choosing our services, and we look forward to providing you with a secure and seamless experience.\n\nBest regards,\nHomeless Team";

    final smtpServer = SmtpServer(
      "smtp.hostinger.com", // Hostinger SMTP server address (without @gmail.com)
      port: 465, // Port number (may vary, check your Hostinger email settings)
      username: username,
      password: password,
      ssl: true, // Use SSL for secure connection
    );

    final message = Message()
      ..from = Address(username, 'Homeless')
      ..recipients.add(recipientEmail)
      ..subject = 'Your New Authentication Credentials'
      ..text = text; // Use the email content stored in the 'text' variable

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Message not sent.\n${e.toString()}');
    }
  }


  Future<String> getLocationAddress(double latitude,double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String formattedAddress = " ${placemark.administrativeArea} , ${placemark.country}";
        return formattedAddress;
      } else {
        return "Address not Found";
      }
    } catch (e) {

    }
    return "";
  }
}

class CustomDropdown extends StatefulWidget {
  final String label;
  final List<String> options;
  final String? selectedValue;
  final void Function(String?) onChanged;

  CustomDropdown({
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _showDropdownMenu,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Color(0x1943BA82),
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.selectedValue ?? '${widget.label}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDropdownMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: ListView.builder(
            itemCount: widget.options.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(widget.options[index]),
                onTap: () {
                  widget.onChanged(widget.options[index]);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  location.Location _location = location.Location();
  LatLng? _currentLocation;
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    _getLocation();
    //selectedLocation = _currentLocation;
  }

  void _getLocation() async {
    try {
      var currentLocation = await _location.getLocation();
      setState(() {
        _currentLocation = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
        selectedLocation = _currentLocation;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF46BA80),
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Current Location On Map',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _currentLocation != null
          ? GoogleMap(
              initialCameraPosition: CameraPosition(
                target: selectedLocation ?? _currentLocation!,
                zoom: 15.0,
              ),
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              onTap: _onMapLongPress,
              markers: {
                Marker(
                  markerId: MarkerId('current_location'),
                  position: _currentLocation!,
                  infoWindow: InfoWindow(title: 'Current Location'),
                ),
                Marker(
                    markerId: MarkerId('selected_location'),
                    position: selectedLocation!,
                    infoWindow: InfoWindow(title: 'Selected Location'))
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF46BA80),
        onPressed: () async {
          if (selectedLocation != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("logitude", selectedLocation!.longitude.toString());
            prefs.setString("latitude", selectedLocation!.latitude.toString());
            Navigator.of(context).pop(selectedLocation);
          }

          ///
        },
        child: Icon(Icons.check),
      ),
    );
  }

  void _onMapLongPress(LatLng location) {
    setState(() {
      selectedLocation = location;
    });
  }
}
