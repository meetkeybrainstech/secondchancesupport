import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../account_type.dart';
import '../privacy_policy.dart';
import 'Myjobs.dart';
import 'chat_person.dart';
import 'wallet_screen.dart';
/*
import 'Donor_profile.dart';
import 'chat_person.dart';
import 'donor_home.dart';
*/

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawer Example',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawer Example'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Home Screen Content'),
      ),
    );
  }
}

class AppDrawer extends StatefulWidget {

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final drawerWidth = MediaQuery.of(context).size.width * 0.7; // Adjust the width as needed


    return SafeArea(
      child: Drawer(
        width: drawerWidth, // Set the width of the drawer
        child: ListView(
          padding: EdgeInsets.zero, // Remove the default padding
          children: <Widget>[
            StreamBuilder(
              stream: _getUserInfoStream(),
              builder: (context, AsyncSnapshot<UserInfo?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Text('No user data available.');
                } else {
                  UserInfo userInfo = snapshot.data!;
                  return Column(
                    children: [
                      ListTile(
                        title: Text(userInfo.fullName),
                        subtitle: Text(userInfo.email),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              userInfo.imageUrl
                          ),
                        ),

                      )
                    ],
                  );
                }
              },
            ),
            Divider(),
            ListTile(
              title: Text('Home'),
              onTap: () {
               // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CustomInfoWindowExample()));
                // Handle Home screen navigation
                // Navigator.pop(context); // Close the drawer
              },
            ),
            Divider(),

            ListTile(
              title: Text('My Profile'),
              onTap: () {
             //   Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                // Handle My Profile screen navigation
                //  Navigator.pop(context); // Close the drawer
              },
            ),
            Divider(),
            ListTile(
              title: Text('Request Payment'),
              onTap: () {
                //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyDonation()));
                // Handle My Donations screen navigation
                // Navigator.pop(context); // Close the drawer
              },
            ),
            Divider(),
            ListTile(
              title: Text('My Wallet'),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Wallet_page()));
                // Handle My Donations screen navigation
                // Navigator.pop(context); // Close the drawer
              },
            ),
            Divider(),
            ListTile(
              title: Text('My Jobs'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyJobs()));
                // Handle My Jobs screen navigation
                //Navigator.pop(context); // Close the drawer
              },
            ),
            Divider(),
            StreamBuilder<int>(
              stream: getTotalUnreadMessagesCount(), // Use your stream here
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final unreadMessagesCount = snapshot.data!;
                  return ListTile(
                    title: Text('Messages'),
                    trailing: unreadMessagesCount !=0 ? CircleAvatar(
                        backgroundColor: Color(0xFF46BA80),
                        maxRadius: 15,
                        child: Text(unreadMessagesCount.toString(),style: TextStyle(
                            color: Colors.white
                        ),)):Text("0",style: TextStyle(color: Colors.white),),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserListScreen()),
                      );
                      // Handle Messages screen navigation
                      // Navigator.pop(context); // Close the drawer
                    },
                   );
                } else {
                  // Handle loading state or errors
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UserListScreen()));
                    },
                    child: ListTile(
                      title: Text('Messages'),
                    ),
                  );
                }
              },
            ),

            Divider(),
            ListTile(
              title: Text('Advertise'),
              onTap: () {
                // Handle Advertise screen navigation
                Navigator.pop(context); // Close the drawer
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Privacy policy'),
              onTap: () {
                // Sign out the user when the "Sign Out" button is pressed
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivacyPolicyScreen()));

                //Navigator.pop(context); // Close the drawer
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                QuickAlert.show(
                  onCancelBtnTap: () {
                    Navigator.pop(context);
                  },
                  onConfirmBtnTap: (){
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Account_type()));
                  },
                  context: context,
                  type: QuickAlertType.confirm,
                  text: 'Do you want to logout',
                  titleAlignment: TextAlign.center,
                  textAlignment: TextAlign.center,
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  confirmBtnColor: Colors.green,
                  backgroundColor: Colors.white,
                  headerBackgroundColor: Colors.grey,
                  confirmBtnTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  cancelBtnTextStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  barrierColor: Colors.white,
                  titleColor: Colors.black,
                  textColor: Colors.black,
                );
                /* FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Account_type()));
               */ // Handle Logout action
                // Close the drawer
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }



  Stream<int> getTotalUnreadMessagesCount() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Get a list of chat IDs for the user
    return FirebaseFirestore.instance
        .collection('merchants')
        .doc(userId)
        .snapshots()
        .asyncMap((snapshot) async {
          print("hello 33");
      if (!snapshot.exists) {
        print('hello 44');
        return 0;
      }

      final userChats = snapshot.get('usersChats') as List<dynamic>;

      // Create a list of individual chat streams with unread message counts
      final chatStreams = userChats.map((chatId) {
        return FirebaseFirestore.instance
            .collection('chats/${chatId + '_' + userId}/messages')
            .where('isRead', isEqualTo: false)
            .get()
            .then<int>((querySnapshot) => querySnapshot.size);
      });

      // Calculate the total count of unread messages
      final List<int> unreadCounts = await Future.wait(chatStreams);
      final totalUnreadMessagesCount = unreadCounts.reduce((a, b) => a + b);

      return totalUnreadMessagesCount;
    });
  }
  Stream<UserInfo?> _getUserInfoStream() {
    var user = _auth.currentUser!.uid;
    if (user != null) {
      return _firestore
          .collection('merchants') // Change this to your users collection
          .doc(user)
          .snapshots()
          .map((snapshot) {
        print(FirebaseAuth.instance.currentUser!.uid);
        if (snapshot.exists) {
          print("hello");
          return UserInfo(
            fullName: snapshot.get('Name'),
            email: snapshot.get('Email'),
            imageUrl: snapshot.get('image'),
          );
        } else {
          return null;
        }
      });
    } else {
      return Stream.empty();
    }
  }

}
class UserInfo {
  final String fullName;
  final String email;
  final String imageUrl;

  UserInfo({
    required this.fullName,
    required this.email,
    required this.imageUrl,
  });
}
