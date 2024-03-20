import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class add_job_post_screen extends StatefulWidget {
  const add_job_post_screen({Key? key}) : super(key: key);

  @override
  State<add_job_post_screen> createState() => _add_job_post_screenState();
}

class _add_job_post_screenState extends State<add_job_post_screen> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  String formatDate(DateTime date) {
    final day = date.day;
    final month = date.month;
    final year = date.year;

    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final formattedDate = '$day${daySuffix(day)} ${monthNames[month - 1]} $year';

    return formattedDate;
  }

  String daySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  void _submitJobPost() async {
    User? currentUser = await getCurrentUser();

    if (currentUser == null) {
      // Handle the case where the user is not signed in.
      return;
    }

    String jobTitle = _titleController.text;
    String jobLocation = _locationController.text;
    String jobDescription = _descriptionController.text;
    String currentUid = currentUser.uid;
    String currentDate = formatDate(DateTime.now());

    // Create a map to represent the job post data
    Map<String, dynamic> jobPostData = {
      'jobTitle': jobTitle,
      'jobLocation': jobLocation,
      'jobDescription': jobDescription,
      'uid': currentUid,
      'date': currentDate,
    };

    try {
      // Add a new document with an automatically generated ID
      await _firestore.collection('DonorjobPosts').add(jobPostData);
      sendFcmNotification("f1zZP3tmSHunlrwALVg9Om:APA91bGfQGNTXhEqsMCDWiVnGzsQXgKl8SuBMohAcu_42R-__Dv2IuZjcljhs-C0lkIjjvy9sfHFnYdIIyPENHRREtqYhapKtAqnCdHFSVd6olxAbTc9ancwTn-7sw7dnzZzpXaLe3Wn");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Job post added successfully!'),
        ),
      );
    } catch (e) {
      print('Error adding job post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding job post. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        elevation: 0,
        centerTitle: true,
        title: Text("Add New Job"),
        backgroundColor: Colors.grey[50],
        foregroundColor: Colors.black,

      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 10,left: 20),
                child: Text(
                  'Title',
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
                  controller: _titleController,
                  decoration: InputDecoration(
                      fillColor: Color(0x1943BA82),
                      filled: true,
                      hintText: "Job Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none
                      )
                  ),
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 10,left: 20),
                child: Text(
                  'Location',
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
                  controller: _locationController,
                  decoration: InputDecoration(
                      fillColor: Color(0x1943BA82),
                      filled: true,
                      hintText: "Job Location",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none
                      )
                  ),
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 10,left: 20),
                child: Text(
                  'Description',
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
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      fillColor: Color(0x1943BA82),
                      filled: true,
                      hintText: "Job Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none
                      )
                  ),
                  minLines: 1,
                  maxLines: 7,
                ),
              )
            ],
          ),

        ],
      ),
      floatingActionButton: InkWell(
        onTap: (){
          _submitJobPost();
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
            child: Text('Save',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'SF Pro Text',
                  fontWeight: FontWeight.w600,
                  height: 2,
                ))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


  Future<void> sendFcmNotification(String userToken) async {
    final String serverKey = 'AAAACAdA52M:APA91bHxhXgYNLw5lf9o8J4hN7lvUPfgqXZzkuvqcO6d0DJxL7cV9FBvDvpn7esZ9XFca6FxnPiLZ3yhKS-T0VatpPjLA5UPljZkq7E4VE7A_gVFTWq0gXMN4bmoETAW7reJXev9dgQV';
    const String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

    final Map<String, dynamic> message = {
      'to': userToken,
      'data': {
        'title': 'New Job Post',
        'body': 'Donor add new Job post',
      },
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final http.Response response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: headers,
      body: jsonEncode(message),
    );
    print(response.body);
    if (response.statusCode == 200) {
     // print(response)
      print('FCM message sent successfully');
    } else {
      print('Failed to send FCM message. Error: ${response.body}');
    }
  }

}
