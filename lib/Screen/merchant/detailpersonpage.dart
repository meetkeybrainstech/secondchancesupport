import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

import 'package:homeless/Screen/merchant/enterOtpPage.dart';
import 'package:recase/recase.dart';

import '../../model/model.dart';

class PersonDetailPage extends StatefulWidget {
   homeless? user;

  PersonDetailPage({Key? key,required this.user}) : super(key: key);
  @override
  State<PersonDetailPage> createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends State<PersonDetailPage> {
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }
  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentLatitude = position.latitude;
      currentLongitude = position.longitude;
    });
  }
  TextEditingController a = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double distance = calculateDistance(
        currentLatitude,
        currentLongitude,
        widget.user!.latitude!,
        widget.user!.longitude!
    );
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromRGBO(237,237,237,1),
        height: 1000,
        // width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Container(
                  // height: 100,
                  // width: 100,
                  padding:
                  const EdgeInsets.all(15), // Padding for the border width
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 229, 223, 223), // Background color of the circle
                    borderRadius: BorderRadius.circular(
                        150), // Half of th e sum of radius and border width
                    border: Border.all(
                      color: Colors.transparent, // Border color
                      // width: 5, // Border width
                    ),
                  ),
                  child:  CircleAvatar(
                    maxRadius: 100,
                    backgroundColor:
                    Colors.transparent, // Transparent background color
                    backgroundImage: NetworkImage("${widget.user!.profileImageUrl.toString()}")
                    // You can set a background image or initials here if needed
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Text(
                  ReCase( widget.user!.fullName!).titleCase  ,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                const SizedBox(
                  height: 14,
                ),
                 Text(
                  '${calculateAge(widget.user!.dob!)} years',
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
                const SizedBox(
                  height: 14,
                ),
                 Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_searching),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${formatDistance(distance)} away',
                        style: TextStyle(color: Colors.grey[700], fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 105,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    leading: const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Amount',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                    title: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.transparent), // Remove the border
                      ),
                      child: TextField(
                        controller: a,
                        decoration: const InputDecoration(
                          border: InputBorder.none, // Remove underline
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: 30,
                          height: 1
                        ),
                        textAlign: TextAlign.center, // Align text to the center
                      ),
                    ),
                    trailing: const Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text(
                        'US Dollars',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyHomePage()));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      color: const Color.fromARGB(255, 69, 190, 170),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Text(
                                'REQUEST PAYMENT',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // child: ElevatedButton(
                      //   onPressed: () {
                      //     // Handle the donation button press
                      //     // Navigator.push(
                      //     //   context,
                      //     //   MaterialPageRoute(
                      //     //     builder: (context) => MyCustomLayout(),
                      //     //   ),
                      //     // );
                      //   },
                      //   child: Text('REQUEST PAYMENT'),
                      // ),
                    ),
                  ),
                )
              ],
            ),
          ),
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