import 'package:clippy_flutter/triangle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'donationPage.dart';
import 'donor_drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CustomInfoWindowExample(),
    );
  }
}

class MarkerData {
  final LatLng position;
  final String name;
  final String imageAsset;
  final String buttonText;
  final String docId;

  MarkerData({
    required this.position,
    required this.name,
    required this.imageAsset,
    required this.buttonText,
    required this.docId
  });
}

class CustomInfoWindowExample extends StatefulWidget {
  @override
  _CustomInfoWindowExampleState createState() =>
      _CustomInfoWindowExampleState();
}

class _CustomInfoWindowExampleState extends State<CustomInfoWindowExample> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  List<MarkerData> markerDataList = [];
  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();
  bool isLoading = true;
  final LatLng _latLng = LatLng(37.7749, -122.4194);
  final double _zoom = 15.0;

  void _fetchMarkerDataFromFirestore() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('HomeLessMembers').get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          markerDataList = querySnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return MarkerData(
              position: LatLng(double.parse(data['latitude']), double.parse(data['longitude'])),
              name: data['fullName'],
              imageAsset: data['profileImageUrl'],
              buttonText: "Donate",
              docId: doc.id
            );
          }).toList();
        });

        // Clear existing markers and add new markers from markerDataList
        _markers.clear();
        _markers.addAll(markerDataList.map((data) {
          return Marker(
            markerId: MarkerId(data.position.toString()),
            position: data.position,
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 130,
                            width: 180,
                            child: Card(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                    Image(image: NetworkImage(data.imageAsset),width: 160,height: 120,fit: BoxFit.cover,),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    data.name,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Triangle.isosceles(
                          edge: Edge.BOTTOM,
                          child: Container(
                            color: Colors.blue,
                            width: 20.0,
                            height: 10.0,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 232,
                      left: 46,
                      child: SizedBox(
                        height: 20,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>DonationPage(id: data.docId,)));
                            // Handle button click for this marker here
                          },
                          child: Text(
                            data.buttonText,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                data.position,
              );
            },
          );
        }));
      }
    } catch (e) {
      print('Error fetching marker data: $e');
    }
    finally {
      // Set loading state to false when data is fetched
      setState(() {
        isLoading = false;
      });
    }
  }

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    _fetchMarkerDataFromFirestore();
 //   _addMarkers();
  }

  void _addMarkers() {
    for (var data in markerDataList) {
      _markers.add(
        Marker(
          markerId: MarkerId(data.position.toString()),
          position: data.position,
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 130,
                          width: 180,
                          child: Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                  Image(image: AssetImage(data.imageAsset)),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  data.name,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Triangle.isosceles(
                        edge: Edge.BOTTOM,
                        child: Container(
                          color: Colors.blue,
                          width: 20.0,
                          height: 10.0,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 232,
                    left: 46,
                    child: SizedBox(
                      height: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle button click for this marker here
                        },
                        child: Text(
                          data.buttonText,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              data.position,
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

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
        key: _scaffoldkey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Homeless',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          actions: [
            RawMaterialButton(
              onPressed: () {
                _scaffoldkey.currentState!.openEndDrawer();
              },
              child: Icon(
                Icons.dehaze,
                size: 20.0,
                color: Colors.black,
              ),
              shape: CircleBorder(
                side: BorderSide(color: Colors.black, width: 2.0),
              ),
              constraints:
              BoxConstraints.tight(Size(40.0, 40.0)),
              padding: EdgeInsets.all(8.0),
              elevation: 2.0,
              highlightElevation: 4.0,
            )
          ],
          backgroundColor: Colors.white,
        ),
        endDrawer: AppDrawer(),
        body: isLoading ? Center(child: CircularProgressIndicator()) : Stack(
          children: <Widget>[
            GoogleMap(
              onTap: (position) {
                _customInfoWindowController.hideInfoWindow!();
              },
              onCameraMove: (position) {
                _customInfoWindowController.onCameraMove!();
              },
              onMapCreated: (GoogleMapController controller) async {
                _customInfoWindowController.googleMapController = controller;
              },
              markers: _markers,
              initialCameraPosition: CameraPosition(
                target: markerDataList[0].position,
                zoom: _zoom,
              ),
            ),
            if (isLoading) // Display loading indicator while fetching data
              Center(
                child: Center(child: CircularProgressIndicator()),
              ),
            CustomInfoWindow(
              controller: _customInfoWindowController,
              height: 256,
              width: 170,
              offset: 50,
            ),
          ],
        ),
      ),
    );
  }
}
