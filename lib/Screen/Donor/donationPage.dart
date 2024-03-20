import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homeless/Screen/Donor/success.dart';

class DonationPage extends StatefulWidget {
  String? id;
  DonationPage({Key? key,this.id}) : super(key: key);

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {

  Map<String,dynamic> userData ={};
  bool? isloading = true;
  Map<String,dynamic> HomelessuserData ={};
  TextEditingController a = TextEditingController();
  Future<void> fetchDataForCurrentUser() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final String uid = user.uid;

      try {
        final DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('donor').doc(uid).get();

        if (documentSnapshot.exists) {
          // Data for the current user exists
          setState(() {
            userData = documentSnapshot.data()
            as Map<String, dynamic>;

          });

          // Process and use the user data as needed
          print('User Data: $userData');
        } else {
          // Data for the current user does not exist
          print('User data not found.');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      // User is not signed in
      print('User not signed in.');
    }
  }
  Future<void> fetchDataForHomelessUser(String id) async {
    final User? user = FirebaseAuth.instance.currentUser;


      try {
        final DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('HomeLessMembers').doc(id).get();

        if (documentSnapshot.exists) {
          // Data for the current user exists
          setState(() {
            HomelessuserData = documentSnapshot.data()
            as Map<String, dynamic>;

          });

          // Process and use the user data as needed
          print('User Data: $HomelessuserData');
        } else {
          // Data for the current user does not exist
          print('User data not found.');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
      finally {
        // Set loading state to false when data is fetched
        setState(() {
          isloading = false;
        });
      }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDataForCurrentUser();
    fetchDataForHomelessUser(widget.id.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donation",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),

      body:
      isloading == true ? Center(child: CircularProgressIndicator()):
      Stack(
        children: [
          Opacity(
            opacity: 0.5, // Adjust opacity (0.5 for 50% opacity)
            child: Image.asset(
              'assets/download.jpeg', // Replace with your image URL
              fit: BoxFit.cover, // Adjust the fit as needed
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Container(

        child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10), // Add top spacing
                      child: Container(
                        padding: EdgeInsets.all(8), // Padding for the border width
                        decoration: BoxDecoration(
                          color: Color.fromARGB(
                              255, 207, 203, 203), // Background color of the circle
                          borderRadius: BorderRadius.circular(
                              55), // Half of the sum of radius and border width
                          border: Border.all(
                            color: Colors.transparent, // Border color
                            // width: 5, // Border width
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 40, // Adjust the radius as needed
                          backgroundColor:
                          Colors.transparent, // Transparent background color
                          backgroundImage:NetworkImage(userData["image"]),
                          // You can set a background image or initials here if needed
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      'YOU ARE PAYING',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      color: Colors.blueGrey,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: ListTile(
                        leading:Text(
                          'Amount',
                          style: TextStyle(color: Colors.white,height: 1.5,
                          fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),

                        ),
                        title: TextField(
                          controller: a,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.center, // Align text to the center
                        ),
                        trailing: Text(
                          'US Dollars',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    CircleAvatar(
                      radius: 4,
                      backgroundColor: Colors.blueGrey,
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.blueGrey,
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.blueGrey,
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    CircleAvatar(
                      radius: 7,
                      backgroundColor: Colors.blueGrey,
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.blueGrey,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 140, width: 140,
                      padding: EdgeInsets.all(9), // Padding for the border width
                      decoration: BoxDecoration(
                        color: Color.fromARGB(
                            255, 207, 203, 203), // Background color of the circle
                        borderRadius: BorderRadius.circular(
                            85), // Half of the sum of radius and border width
                        border: Border.all(
                          color: Colors.transparent, // Border color
                          // width: 5, // Border width
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 40, // Adjust the radius as needed
                        backgroundColor:
                        Colors.transparent, // Transparent background color
                        backgroundImage: NetworkImage(HomelessuserData["profileImageUrl"]),
                        // You can set a background image or initials here if needed
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                     HomelessuserData["fullName"],
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    Container(
                      width: 300, // Set the width as needed
                      child: FloatingActionButton.extended(
                        // shape: CircleBorder(),
                        label: Text('DONATE'),
                        onPressed: () {
                          // Handle the donation button press
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>MyCustomLayout(),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}