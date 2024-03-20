import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeless/Screen/Organization/home_screen.dart';
import 'package:homeless/model/Firestore_service.dart';
import 'package:homeless/model/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../login/login_mechant.dart';
import '../merchant/Homepage_merchant.dart';

class Register_merchant extends StatefulWidget {
  @override
  State<Register_merchant> createState() => _Register_merchantState();
}

class _Register_merchantState extends State<Register_merchant> {
  bool isRegistering = false;
  bool isloading = false;
  FirestoreService firestoreService = FirestoreService();
  List<String> imagePaths = [];
  // Use XFile for image paths
  int currentIndex = 0;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image and update the grid

  Future<void> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      // Define a reference to the Firebase Storage bucket where you want to store the image
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('Merchant_Business_Certificates')
          .child('image_${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the image file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Get the download URL of the uploaded image
      String imageUrl = await (await uploadTask).ref.getDownloadURL();
      setState(() {
        selectedImages.add(pickedImage);
        imagePaths.add(imageUrl);
      });
      // Now you can use the imageUrl as needed (e.g., save it to Firebase Firestore or display the image)
      print('Uploaded image URL: $imageUrl');
    } else {
      // Handle the case where no image was picked
    }
  }

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController choosePassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
//Business Details
  TextEditingController businessname = TextEditingController();
  TextEditingController businessCategory = TextEditingController();
  TextEditingController city4Business = TextEditingController();
  TextEditingController state4Business = TextEditingController();
  TextEditingController country4Business = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController areaSector = TextEditingController();
  TextEditingController pincode = TextEditingController();
// Bank Details
  TextEditingController accountNumber = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController city4Bank = TextEditingController();
  TextEditingController state4Bank = TextEditingController();
  TextEditingController branchLocation = TextEditingController();

  List<XFile?> selectedImages = [];

  bool checkvalue = false;
  bool password1 = true;
  bool password2 = true;
  final formkey = GlobalKey<FormState>();
  int currentStep = 0;
  List steps = [
    {
      'title': "Your Details",
    },
    {
      'title': "Business Details",
    },
    {
      'title': "Bank Details",
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
          title: const Text('Register'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List<Widget>.generate(steps.length, (index) {
                    //  String name = widget.steps[index].title;
                    String text = steps[index]["title"];
                    List<String> words = text.split(" ");
                    return Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${words[0]}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'SF Pro Text',
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${words[1]}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: currentStep == 0
                      ? Merchant_details(context)
                      : currentStep == 1
                          ? Merchant_Address_details(context)
                          : currentStep == 2
                              ? Merchant_Bank_details(context)
                              : Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Merchant_details(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
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
                  controller: name,
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
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Choose Password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                  controller: choosePassword,
                  obscureText: password1,
                  decoration: InputDecoration(
                      fillColor: const Color(0x1943BA82),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: password1
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
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
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: const Text(
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
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Confirm Password";
                    } else if (value != choosePassword.text) {
                      return "Both password is not Match";
                    }
                    return null;
                  },
                  obscureText: password2,
                  controller: confirmPassword,
                  decoration: InputDecoration(
                      fillColor: const Color(0x1943BA82),
                      filled: true,
                      hintText: "Confirm Password",
                      suffixIcon: IconButton(
                        icon: password2
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
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
            title: const Text(
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please check the Terms and Condition")));
                } else {
                  print(name.text);
                  setState(() {
                    currentStep = currentStep + 1;
                  });
                }
              }

              //   print(DefaultTabController.of(context).index);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => Merchant_Address_details(context)));
            },
            child: Container(
                width: 343,
                height: 50,
                decoration: ShapeDecoration(
                  color: const Color(0xFF46BA80),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Continue',
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
    );
  }

  Merchant_Address_details(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: const Text(
                  'Business name',
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
                  controller: businessname,
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Business name";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: const Color(0x1943BA82),
                      filled: true,
                      hintText: "Business name",
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
                  'Business Category',
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
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Business Category";
                    }
                    return null;
                  },
                  controller: businessCategory,
                  decoration: InputDecoration(
                      fillColor: const Color(0x1943BA82),
                      filled: true,
                      hintText: "Business Category",
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
                  'Street Address',
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
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Street Address";
                    }
                    return null;
                  },
                  controller: address,
                  decoration: InputDecoration(
                      fillColor: const Color(0x1943BA82),
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
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: const Text(
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
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: areaSector,
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Area/Sector";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: const Color(0x1943BA82),
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
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: const Text(
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
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: pincode,
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Pincode";
                    } else if (value.length < 6) {
                      return "Pincode must be at least 6 characters";
                    }
                    return null;
                  },
                  inputFormatters: [LengthLimitingTextInputFormatter(6)],
                  decoration: InputDecoration(
                      fillColor: const Color(0x1943BA82),
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
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: const Text(
                  'State',
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
                  controller: state4Business,
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter State";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: const Color(0x1943BA82),
                      filled: true,

                      //suffixIcon: Icon(Icons.visibility),
                      hintText: "State",
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
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: TextFormField(
                  controller: country4Business,
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Country";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: const Color(0x1943BA82),
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
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upload Registraction Certificate',
                  style: TextStyle(
                    color: Color(0xFF787878),
                    fontSize: 13,
                    fontFamily: 'SF Pro Text',
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: selectedImages.length +
                        1, // Add one for the "Add" button
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                        return InkWell(
                          onLongPress: () {
                            setState(() {
                              selectedImages.removeAt(index);
                              imagePaths.removeAt(index);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors
                                    .grey, // Set the border color as desired
                                width: 1.0, // Set the border width as desired
                              ),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set border radius as desired
                            ),
                            child: Image.file(
                              File(
                                  imagePath), // Use the imagePath to display the image
                              fit: BoxFit.fill,
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
                            icon: const Icon(Icons.add),
                            onPressed:
                                pickImage, // Call pickImage() when the button is pressed
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .02,
          ),
          InkWell(
            onTap: () {
              if (formkey.currentState!.validate()) {
                // Insert data into Firebase

                if (selectedImages.isEmpty) {
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    title: "Please Upload Registration Certificate",
                  ).show();
                } else {
                  setState(() {
                    currentStep = currentStep + 1;
                  });
                }
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
                child: const Text('Continue',
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
    );
  }

  Merchant_Bank_details(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: const Text(
                  'Account Number',
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
                  controller: accountNumber,
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Account Number";
                    } else if (value.length < 12) {
                      return "Account Number must be at least 12 characters";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(12)],
                  decoration: InputDecoration(
                      fillColor: const Color(0x1943BA82),
                      filled: true,
                      hintText: "Account Number",
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
                  'Bank Name',
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
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Bank Name";
                    }
                    return null;
                  },
                  controller: bankName,
                  decoration: InputDecoration(
                      fillColor: const Color(0x1943BA82),
                      filled: true,
                      hintText: "Bank Name",
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
                  'City',
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
                  controller: city4Bank,
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter City";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: const Color(0x1943BA82),
                      filled: true,
                      hintText: "City",
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
                  'State',
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
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter State";
                    }
                    return null;
                  },
                  controller: state4Bank,
                  decoration: InputDecoration(
                      fillColor: const Color(0x1943BA82),
                      filled: true,
                      hintText: "State",
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
                  'Branch Location',
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
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: TextFormField(
                  controller: branchLocation,
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Please enter Branch Location";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: const Color(0x1943BA82),
                      filled: true,
                      hintText: "Branch Location",
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
            onTap: () async {
              if (formkey.currentState!.validate()) {
                setState(() {
                  isRegistering = true;
                });
                Merchant merchant = Merchant(
                  Name: name.text,
                  Email: email.text,
                  Phone: phone.text,
                  ChoosePassword: choosePassword.text,
                  ConfirmPassword: confirmPassword.text,
                  //business
                  BusinessName: businessname.text,
                  BusinessCategory: businessCategory.text,
                  StreetAddress: address.text,
                  AreaSector: areaSector.text,
                  Pincode: int.parse(pincode.text),
                  State: state4Business.text,
                  Country: country4Business.text,
                  images: imagePaths,
                  //bank
                  AccountNumber: accountNumber.text,
                  BankName: bankName.text,
                  CityBank: city4Bank.text,
                  StateBank: state4Bank.text,
                  BranchLocation: branchLocation.text,
                );

                try {
                  await firestoreService
                      .addMerchantData(context, merchant)
                      .then((value) {
                    setState(() {
                      isRegistering =
                          false; // Hide the circular progress indicator
                    });
                  });
                } on FirebaseAuthException catch (e) {
                  if (e.code == "email-already-in-use") {
                    // print('Hello!!');
                  }
                }
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
                child: isloading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                    : Text('Register',
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
}
