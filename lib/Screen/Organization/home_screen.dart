import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:homeless/Screen/Add_job_post_Screen.dart';
import 'package:homeless/Screen/Organization/AddMember.dart';
import 'package:homeless/Screen/account_type.dart';
import 'package:homeless/Screen/Organization/profile_Screen.dart';
import 'package:homeless/Screen/wallet_screen.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../model/service.dart';
import '../privacy_policy.dart';
import 'Homelesspeople.dart';
import 'Myjobs.dart';
import 'chat_person.dart';
import 'demo.dart';

class Navbar_screen extends StatefulWidget {
  const Navbar_screen({Key? key}) : super(key: key);

  @override
  State<Navbar_screen> createState() => _Navbar_screenState();
}

class _Navbar_screenState extends State<Navbar_screen> {
  late List<Widget> navbar_list = [
    homeview(),
    walletview(),
    notificationview(),
    profileview()
  ];
  int select_index = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        QuickAlert.show(
          onCancelBtnTap: () {
            Navigator.pop(context);
          },
          onConfirmBtnTap: (){
            SystemNavigator.pop();
          },
          context: context,
          type: QuickAlertType.confirm,
          text: 'Do you want to Exit?',
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
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 65,
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 15.0, // soften the shadow
              spreadRadius: 5.0, //extend the shadow
              offset: Offset(
                5.0, // Move to right 5  horizontally
                5.0, // Move to bottom 5 Vertically
              ),
            )
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    select_index = 0;
                  });
                },
                child: Column(
                  children: [
                    if (select_index == 0) ...[
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        height: 30,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF43BA82),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 3,
                            color: Colors.green,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        "Home",
                        style: TextStyle(color: Color(0xFF43BA82)),
                      )
                    ],
                    if (select_index != 0) ...[
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        height: 30,
                        width: 60,
                        child: const Center(
                          child: Icon(
                            Icons.home,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const Text(
                        "Home",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    select_index = 1;
                  });
                },
                child: Column(
                  children: [
                    if (select_index == 1) ...[
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        height: 30,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF43BA82),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 3,
                            color: Colors.green,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.wallet,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        "Wallet",
                        style: TextStyle(color: Color(0xFF43BA82)),
                      )
                    ],
                    if (select_index != 1) ...[
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        height: 30,
                        width: 60,
                        child: const Center(
                          child: Icon(
                            Icons.wallet,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const Text(
                        "wallet",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    select_index = 2;
                  });
                },
                child: Column(
                  children: [
                    if (select_index == 2) ...[
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        height: 30,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF43BA82),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 3,
                            color: Colors.green,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.briefcase_fill,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        "JobPost",
                        style: TextStyle(color: Color(0xFF43BA82)),
                      )
                    ],
                    if (select_index != 2) ...[
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        height: 30,
                        width: 60,
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.briefcase_fill,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const Text(
                        "JobPost",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    select_index = 3;
                  });
                },
                child: Column(
                  children: [
                    if (select_index == 3) ...[
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        height: 30,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF43BA82),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 3,
                            color: Colors.green,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "Profile",
                        style: TextStyle(color: Color(0xFF43BA82)),
                      )
                    ],
                    if (select_index != 3) ...[
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        height: 30,
                        width: 60,
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        body: navbar_list[select_index],
      ),
    );
  }

  homeview() {
    return const Home_screen();
  }

  walletview() {
    return const Wallet_page();
  }

  notificationview() {
    return MyJobs();
  }

  profileview() {
    return DonorSProfile();
  }
}

class Home_screen extends StatefulWidget {
  const Home_screen({Key? key}) : super(key: key);

  @override
  State<Home_screen> createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen> {
  String query = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // fetchFirestoreData();
    //filteredDetails = details;
  }

  late List<Map<String, dynamic>> filteredDetails = [];
  late List<Map<String, dynamic>> details = [];
  bool isLoading = true;
  Future<void> fetchFirestoreData() async {
    // Replace 'your_collection_name' with the actual name of your Firestore collection.
    final collection = FirebaseFirestore.instance.collection('HomeLessMembers');
    try {
      final querySnapshot = await collection.get();
      final data = querySnapshot.docs.map((doc) => doc.data()).toList();

      setState(() {
        // details = List<Map<String, dynamic>>.from(data);
        // filteredDetails = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });

      final String targetOrganizationId = FirebaseAuth.instance.currentUser!
          .uid; // Replace with the organization ID of the logged-in user
      final filteredData = data.where((item) {
        final String organizationId = item[
            'organizationId']; // Replace 'organizationId' with the actual field name
        return organizationId == targetOrganizationId;
      }).toList();
      print(filteredData);
      setState(() {
        details = filteredData;
        filteredDetails = filteredData;
      });
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterbyName(String query) {
    setState(() {
    });
  }

  int calculateAge(DateTime dob) {
    DateTime now = DateTime.now();
    int age = now.year - dob.year;

    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }

    return age;
  }

  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        QuickAlert.show(
          onCancelBtnTap: () {
            Navigator.pop(context);
          },
          onConfirmBtnTap: (){
            SystemNavigator.pop();
          },
          context: context,
          type: QuickAlertType.confirm,
          text: 'Do you want to Exit?',
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
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Homeless",
            style: TextStyle(color: Colors.white),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * .8,
                      // padding: EdgeInsets.all(8),
                      child: TextFormField(
                        controller: search,
                        onChanged: (value){
                          setState(() {
                            query = value;
                          });
                        },
                        decoration: InputDecoration(
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            label: Text("Search"),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            prefixIcon: const Icon(Icons.search),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      )),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Image.asset(
                      "assets/filter.png",
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: const Color(0xFF43BA82),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF46BA80),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddMemberPage()));
          },
        ),
        drawer: SizedBox(
          width: 200,
          child: Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.message),
                    title: Text('Messages'),
                    onTap: () {
                      // Sign out the user when the "Sign Out" button is pressed
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserListScreen()));

                      //Navigator.pop(context); // Close the drawer
                    },
                  ),
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
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Sign Out'),
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
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
            //  print(filteredDetails.length);
              fetchFirestoreData();
            //  print(filteredDetails.length);
            });
          },
          child:  RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          //fetchFirestoreData();
                        });
                      },
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('HomeLessMembers')
                            .where('organizationId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          final members = snapshot.data!.docs;

                          // Initialize the filter list with all members
                          List<DocumentSnapshot> filterList = members;

                          if (query.isNotEmpty) {
                            filterList = members.where((member) {
                              final name = member['fullName'].toString().toLowerCase();
                              return name.contains(query.toLowerCase());
                            }).toList();
                          }
                          if(filterList.isEmpty){
                            return Center(
                              child: Text("No Homeless Members"),
                            );
                          }
                          return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: (MediaQuery.of(context).size.width > 600) ? 5 : 2, // Adjust the crossAxisCount based on screen width
                            ),
                            itemCount: filterList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final member = filterList[index];
                              var year = calculateAge(DateTime.parse(filterList[index]["dob"]));
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: ClipRRect(
                                          child: Image.network(filterList[index]['profileImageUrl']),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        '${filterList[index]['fullName']}',
                                        style: const TextStyle(
                                          color: Color(0xFF1F2D36),
                                          fontSize: 16,
                                          fontFamily: 'SF Pro Text',
                                          fontWeight: FontWeight.w600,
                                          height: 0.07,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MapScreen_detail(
                                                user_index: index,
                                              ),
                                            ),
                                          ).then((value) => setState(() {}));
                                          setState(() {});
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.location_on),
                                                Text(filterList[index]['address']),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 70,
                                        height: 30,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(230, 255, 230, 1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '$year Years',
                                          style: const TextStyle(color: Color(0xFF43BA82)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                          ;
                        },
                      )
          ),
        ),
      ),
    );
  }

  Future<String> getLocationAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String formattedAddress =
            " ${placemark.administrativeArea} , ${placemark.country}";
        return formattedAddress;
      } else {
        return "Address not Found";
      }
    } catch (e) {}
    return "";
  }
}
