import 'dart:io';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeless/Screen/login/login_organization.dart';

import 'package:image_picker/image_picker.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

import '../../model/model.dart';
import '../../model/service.dart';
import '../Organization/home_screen.dart';

class StepModel {
  final String title;
  final Widget content;

  StepModel({required this.title, required this.content});
}

class Register_Organization extends StatefulWidget {
  @override
  _Register_OrganizationState createState() => _Register_OrganizationState();
}

class _Register_OrganizationState extends State<Register_Organization> {
  bool isRegistering = false;
  List<String> imagePaths = [];
  List<XFile?> selectedImages = [];
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contact_person = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController choose_password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController appartment = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  bool checkvalue = false;
  bool password1 = true;
  bool password2 = true;
  final formkey = GlobalKey<FormState>();
  int currentStep = 0;
  int currentIndex = 0;
  final ImagePicker _picker = ImagePicker();
  Future<void> pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImages.add(pickedImage);
        currentIndex++;
      });
    }
  }

  List steps = [
    {
      'title': "Organization Details",
    },
    {
      'title': "Address Details",
    },
    {
      'title': "Upload Documents",
    }
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentStep > 0) {
          setState(() {
            currentStep--;
          });

          return false;
        } else {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: Text('Register'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List<Widget>.generate(steps.length, (index) {
                    //  String name = widget.steps[index].title;
                    String text = steps[index]["title"];
                    List<String> words = text.split(" ");
                    return Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${words[0]}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'SF Pro Text',
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${words[1]}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'SF Pro Text',
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .25,
                          height: 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: currentStep >= index
                                  ? Colors.green
                                  : Colors.grey),
                        )
                      ],
                    );
                  }),
                ),
                Container(
                  child: currentStep == 0
                      ? Organization_details(context)
                      : currentStep == 1
                          ? Address_details(context)
                          : currentStep == 2
                              ? upload_document(context)
                              : Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Organization_details(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  'Organization name',
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
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: name,
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter name";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: Color(0x1943BA82),
                      filled: true,
                      hintText: "Organization name",
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
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Text(
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
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: email,
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
                  decoration: InputDecoration(
                      fillColor: Color(0x1943BA82),
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
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  'Contact Person',
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
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Contact person";
                    }
                    return null;
                  },
                  controller: contact_person,
                  decoration: InputDecoration(
                      fillColor: Color(0x1943BA82),
                      filled: true,
                      hintText: "Contact Person",
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
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Text(
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
                padding: EdgeInsets.all(10),
                child: TextFormField(
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
                  controller: phone,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      fillColor: Color(0x1943BA82),
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
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  'Choose Password',
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
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Choose Password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                  controller: choose_password,
                  obscureText: password1,
                  decoration: InputDecoration(
                      fillColor: Color(0x1943BA82),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: password1
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            password1 ? password1 = false : password1 = true;
                          });
                        },
                      ),
                      hintText: "Choose Password",
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
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  'Confirm Password',
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
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Confirm Password";
                    } else if (value != choose_password.text) {
                      return "Both password is not Match";
                    }
                    return null;
                  },
                  obscureText: password2,
                  controller: confirm_password,
                  decoration: InputDecoration(
                      fillColor: Color(0x1943BA82),
                      filled: true,
                      hintText: "Confirm Password",
                      suffixIcon: IconButton(
                        icon: password2
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            password2 ? password2 = false : password2 = true;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none)),
                ),
              )
            ],
          ),
          CheckboxListTile(
            title: Text(
              "I’ve read and agreed to Terms & conditions",
              style: TextStyle(fontSize: 14),
            ),
            value: checkvalue,
            onChanged: (newValue) {
              setState(() {
                if (checkvalue == true) {
                  checkvalue = false;
                } else {
                  checkvalue = true;
                }
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
          InkWell(
            onTap: () {
              if (formkey.currentState!.validate()) {
                if (checkvalue == false) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please check the Terms and Condition")));
                } else {
                  print(name.text);
                  setState(() {
                    currentStep = currentStep + 1;
                  });
                }
              }

              //   print(DefaultTabController.of(context).index);
              //Navigator.push(context, MaterialPageRoute(builder: (context)=> Home_screen() ));
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
    );
  }

  upload_document(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Upload Registration Certificate',
                    style: TextStyle(
                      color: Color(0xFF787878),
                      fontSize: 17,
                      fontFamily: 'SF Pro Text',
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: selectedImages.length +
                        1, // Add one for the "Add" button
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          3, // You can adjust the number of columns as needed
                      childAspectRatio:
                          1.0, // Set the aspect ratio to 1.0 for square items
                      mainAxisSpacing: 16.0, // Adjust the spacing as needed
                      crossAxisSpacing: 16.0, // Adjust the spacing as needed
                      // Set itemExtent to specify fixed height and width
                      // You can adjust these values as needed
                      // For example, if you want each item to be 100x100 pixels, set itemExtent: 100.0,
                      // itemExtent: 100.0,
                    ),
                    itemBuilder: (context, index) {
                      if (index < selectedImages.length) {
                        // Display selected image
                        String imagePath =
                            selectedImages[index]!.path; // Get the image path
                        imagePaths
                            .add(imagePath); // Add the image path to the list
                        return GestureDetector(
                          onLongPress: () {
                            setState(() {
                              selectedImages.removeAt(index);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(File(imagePath))),
                              border: Border.all(
                                color: Colors
                                    .grey, // Set the border color as desired
                                width: 1.0, // Set the border width as desired
                              ),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set border radius as desired
                            ),
                          ),
                        );
                      } else {
                        // Display "Add" button
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors
                                  .grey, // Set the border color as desired
                              width: 1.0, // Set the border width as desired
                            ),
                            borderRadius: BorderRadius.circular(
                                10.0), // Set border radius as desired
                          ),
                          child: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                _showImagePickerBottomSheet(context);
                              }
                              // Call pickImage() when the button is pressed
                              ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * .75,
            left: 10,
          ),
          child: InkWell(
            onTap: () async {
              if (selectedImages.isEmpty) {
                Alert(
                  context: context,
                  type: AlertType.warning,
                  title: "Please Upload Registration Certificate",
                ).show();
              } else {
                setState(() {
                  isRegistering = true; // Show the circular progress indicator
                });

                try {
                  List<String> downloadUrls =
                      await uploadImages(selectedImages);
                  print(downloadUrls);
                  UserApp user = UserApp(
                    organizationName: name.text,
                    email: email.text,
                    password: confirm_password.text,
                    contactPerson: contact_person.text,
                    phone: phone.text,
                    fullName: fullname.text,
                    address: address.text,
                    apartmentName: appartment.text,
                    city: city.text,
                    state: state.text,
                    country: country.text,
                    image: downloadUrls,
                  );

                  await AuthService().registerUser(context, user);

                  setState(() {
                    isRegistering =
                        false; // Hide the circular progress indicator
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login_screen_Organazition(),
                      ),
                    );
                  });

                  Alert(
                    context: context,
                    title: "Account Register Successfully",
                    type: AlertType.success,
                    buttons: [
                      DialogButton(
                        child: Text(
                          "ok",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          // Navigate to Login_screen_Organazition
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login_screen_Organazition(),
                            ),
                          );
                        },
                        color: Color.fromRGBO(0, 179, 134, 1.0),
                        radius: BorderRadius.circular(0.0),
                      ),
                    ],
                  ).show();
                } catch (error) {
                  setState(() {
                    isRegistering =
                        false; // Hide the circular progress indicator
                  });
                  if (error is FirebaseAuthException) {
                    if (error.code == 'email-already-in-use') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Email is already in use'),
                        ),
                      );
                    } else {
                      // Handle other Firebase Authentication errors as needed
                      print("Firebase Authentication Error: ${error.code}");
                      print(error.message);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('An error occurred: ${error.toString()}'),
                        ),
                      );
                    }
                  } else {
                    // Handle non-Firebase errors
                    print("Error: $error");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('An error occurred: ${error.toString()}'),
                      ),
                    );
                  }
                }
              }
            },
            child: Container(
              width: 343,
              height: 50,
              decoration: ShapeDecoration(
                color: Color(0xFF46BA80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isRegistering
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ) // Show the circular progress indicator
                  : Text(
                      'Register',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.w600,
                        height: 2,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Address_details(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  'Address',
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
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Address";
                    }
                    return null;
                  },
                  controller: address,
                  decoration: InputDecoration(
                      fillColor: Color(0x1943BA82),
                      filled: true,
                      hintText: "Street Address",
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
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  'Area/Sector',
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
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: appartment,
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Appartment";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: Color(0x1943BA82),
                      filled: true,
                      hintText: "Area/Sector",
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
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  'Pincode',
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
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: city,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Pincode";
                    } else if (value.length < 6) {
                      return "Pincode must be at least 6 characters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: Color(0x1943BA82),
                      filled: true,
                      hintText: "Pincode",
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
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  'State/Province',
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
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: state,
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter State/Province";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: Color(0x1943BA82),
                      filled: true,

                      //suffixIcon: Icon(Icons.visibility),
                      hintText: "State/Province",
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
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  'Country',
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
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: TextFormField(
                  controller: country,
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Country";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: Color(0x1943BA82),
                      filled: true,
                      hintText: "Country",
                      //suffixIcon: Icon(Icons.visibility),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none)),
                ),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .02,
          ),
          InkWell(
            onTap: () {
              if (formkey.currentState!.validate()) {
                setState(() {
                  currentStep++;
                });
                /*  UserApp user = UserApp(
                    organizationName : name.text,
                    email: email.text,
                    password: confirm_password.text,
                    contactPerson: contact_person.text,
                    phone: phone.text,
                    fullName: fullname.text,
                    address: address.text,
                    apartmentName: appartment.text,
                    city: city.text,
                    state: state.text,
                    country: country.text
                );
                AuthService().registerUser(user).then((value) => Alert(context: context,title:"Account Register Successfully",type: AlertType.success,buttons: [
                  DialogButton(
                    child: Text(
                      "ok",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () =>  Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Navbar_screen())),
                    color: Color.fromRGBO(0, 179, 134, 1.0),
                    radius: BorderRadius.circular(0.0),
                  ),
                ],).show());*/
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
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.26,
      maxHeight: 1,
      bottomSheetColor: Colors.white,
      context: context,
      builder: (BuildContext context, ScrollController scrollController,
          double offset) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Choose an Option",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      final XFile? pickedImage =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (pickedImage != null) {
                        setState(() {
                          selectedImages.add(pickedImage);
                          currentIndex++;
                        });
                        Navigator.pop(context);
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
                      final XFile? pickedImage =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (pickedImage != null) {
                        setState(() {
                          selectedImages.add(pickedImage);
                          currentIndex++;
                        });
                        Navigator.pop(context);
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
                      final image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
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
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"))
              // Add Google Drive option and functionality here.
            ],
          ),
        );
      },
    );
  }

  Future<List<String>> uploadImages(List<XFile?> selectedImages) async {
    final List<String> downloadUrls = [];

    for (final imageFile in selectedImages) {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('Orgranization/${DateTime.now()}.png');
      final UploadTask uploadTask = storageRef.putFile(File(imageFile!.path));

      await uploadTask.whenComplete(() async {
        final String downloadUrl = await storageRef.getDownloadURL();
        downloadUrls.add(downloadUrl);
      });
    }

    return downloadUrls;
  }
}
