import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart' as SearchBarPackage;
import 'package:geolocator/geolocator.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:recase/recase.dart';

import '../../model/model.dart';
import '../../model/service.dart';
import '../account_type.dart';
import 'detailpersonpage.dart';
import 'merchant_drawer.dart';

class FirebaseItem {
  final String name;
  final double latitude;
  final double longitude;
  final String documentId;
  final String imageUrl;
  final String dob;

  FirebaseItem({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.documentId,
    required this.imageUrl,
    required this.dob,
  });
}



class SearchDemo extends StatefulWidget {
  @override
  _SearchDemoState createState() => _SearchDemoState();
}

class _SearchDemoState extends State<SearchDemo> {
  late SearchBarPackage.SearchBar searchBar;
  List<FirebaseItem> items = [];
  List<FirebaseItem> filteredItems = [];

  _SearchDemoState() {
    searchBar = SearchBarPackage.SearchBar(
      inBar: true,
      buildDefaultAppBar: buildAppBar,
      setState: setState,
      onChanged: (query) {
        filterItems(query);
      },
      onSubmitted: (query) {
        // Optional: Handle the search query submission here
      },
      onCleared: () {
        clearFilter();
      },
    );
    fetchFirebaseData();
    getCurrentLocation();
  }
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;
  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentLatitude = position.latitude;
      currentLongitude = position.longitude;
    });
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text("Homeless",style: TextStyle(color: Colors.black),),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      actions: [
        searchBar.getSearchAction(context),
        IconButton(icon:Icon(Icons.dehaze),onPressed: (){
          _scaffoldkey.currentState!.openEndDrawer();
        },)
      ],

    );
  }

  void fetchFirebaseData() async {
    final querySnapshot =
    await FirebaseFirestore.instance.collection('HomeLessMembers').get();

    if (querySnapshot.docs.isNotEmpty) {
      final List<FirebaseItem> data = querySnapshot.docs
          .where((document) =>
      document['fullName'] != null &&
          document['latitude'] != null &&
          document['longitude'] != null)
          .map((document) {
        final documentData = document.data();
        return FirebaseItem(
            name: documentData['fullName'],
            latitude: double.parse( documentData['latitude']),
            longitude:double.parse( documentData['longitude']),
            documentId: document.id,
            imageUrl: document['profileImageUrl'],
            dob:document['dob']
        );
      })
          .toList();

      setState(() {
        items = data;
        filteredItems = List.from(items);
      });
    }
  }

  void filterItems(String query) {
    setState(() {
      filteredItems = items
          .where((item) =>
          item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void clearFilter() {
    setState(() {
      filteredItems = List.from(items);
    });
  }
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

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
        key:_scaffoldkey,
        appBar: searchBar.build(context),
        endDrawer: AppDrawer(),

       /* drawer:  SizedBox(
          width: 200,
          child: Drawer(
            child:
            SafeArea(
              child: Column(
                children: [


                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Sign Out'),
                    onTap: () {
                      // Sign out the user when the "Sign Out" button is pressed
                      AuthService().signOut();
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Account_type()));
                      //Navigator.pop(context); // Close the drawer
                    },
                  ),
                ],
              ),

            ),
          ),
        ),*/
        body:  ValueListenableBuilder<bool>(
          valueListenable: searchBar.isSearching,
          builder: (context, isSearching, child) {
            if (isSearching) {
              return ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  double distance = calculateDistance(
                      currentLatitude, currentLongitude, item.latitude, item.longitude);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            ReCase(item.name!).titleCase,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          subtitle: Row(
                            children: [
                              Icon(Icons.location_searching_outlined),
                              SizedBox(width: 10),
                              Text("${formatDistance(distance)} away"),
                            ],
                          ),
                          onTap: () {
                            // Handle item click, you can access the document ID using item.documentId
                            homeless user = homeless(
                                latitude: item.latitude,
                                longitude: item.longitude,
                                documentId: item.documentId,
                                profileImageUrl: item.imageUrl,
                                dob: DateTime.parse(item.dob),
                                fullName: item.name
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PersonDetailPage(user:user),
                              ),
                            );
                          },
                        ),
                      ),
                      Divider()
                    ],
                  );
                },
              );
            } else {
              return   RefreshIndicator(
                onRefresh: ()async{
                  setState(() {

                  });
                },
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('HomeLessMembers').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator(); // Loading indicator
                    }

                    // Convert the Firebase data to a list of user profiles
                    final List<DocumentSnapshot> documents = snapshot.data!.docs;
                    List<Map<String, dynamic>> profiles = documents
                        .map((document) {
                      final profileData = document.data() as Map<String, dynamic>;
                      final documentId = document.id; // Get the document ID
                      profileData['documentId'] = documentId; // Add document ID to the data
                      return profileData;
                    }).toList();

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: .8// Adjust as needed
                      ),
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        final profile = profiles[index];
                        double distance = calculateDistance(
                            currentLatitude,
                            currentLongitude,
                            double.parse(profile["latitude"]),
                            double.parse(profile["longitude"])
                        );

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: InkWell(
                              onTap: () {
                                homeless user = homeless(
                                    latitude: double.parse(profile["latitude"]),
                                    longitude: double.parse(profile["longitude"]),
                                    documentId: profile['documentId'],
                                    profileImageUrl: profile['profileImageUrl'],
                                    dob: DateTime.parse(profile['dob']),
                                    fullName: profile['fullName']
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PersonDetailPage(user:user),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * .16,
                                    width: MediaQuery.of(context).size.width * .5,
                                    child: Image.network(profile['profileImageUrl']),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0, top: 20),
                                    child: Text(
                                      ReCase( profile['fullName']).titleCase   ,
                                      style: TextStyle(
                                        color: Color(0xFF1F2D36),
                                        fontSize: 16,
                                        fontFamily: 'SF Pro Text',
                                        fontWeight: FontWeight.bold,
                                        height: 0.07,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:10.0),
                                    child: Text("${calculateAge(DateTime.parse(profile['dob']))} years"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:10.0,top: 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_searching,size: 16,),
                                        Expanded(child: Text("${formatDistance(distance)} away"))

                                      ],
                                    ),
                                  )

                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ); // Replace this with your default widget when not searching
            }
          },
        ),
      ),
    );
  }

  int calculateAge(DateTime birthDate) {
    final currentDate = DateTime.now();
    final age = currentDate.year - birthDate.year;

    // Check if the birthday hasn't occurred this year yet
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      return age - 1;
    } else {
      return age;
    }
  }
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371.0; // Radius of the Earth in kilometers

    // Helper function to convert degrees to radians
    double degreesToRadians(double degrees) {
      return degrees * (pi / 180);
    }

    // Convert latitude and longitude from degrees to radians
    double lat1Rad = degreesToRadians(lat1);
    double lon1Rad = degreesToRadians(lon1);
    double lat2Rad = degreesToRadians(lat2);
    double lon2Rad = degreesToRadians(lon2);

    // Haversine formula
    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;
    double a = pow(sin(dLat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance * 1000.0; // Convert to meters
  }
  String formatDistance(double distance) {
    if (distance >= 1000) {
      // Convert to kilometers if the distance is 1000 meters or more
      double kmDistance = distance / 1000;
      return '${kmDistance.toStringAsFixed(2)} km'; // 2 decimal points for kilometers
    } else {
      return '${distance.toStringAsFixed(0)} meters'; // 2 decimal points for meters
    }// 2 decimal points
  }
}
