import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(21.5397, 71.5776);
  PageController pageController = PageController(initialPage: 0);
  List<LocationInfo> locations = [];
  int selectedLocationIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchLocationData();
  }

  Future<void> fetchLocationData() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('locations').get();
    final List<LocationInfo> fetchedLocations = snapshot.docs
        .map((doc) => LocationInfo.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    setState(() {
      locations = fetchedLocations;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController!.animateCamera(
        CameraUpdate.newLatLng(locations[selectedLocationIndex].position));
    pageController.jumpToPage(selectedLocationIndex);
  }

  Set<Marker> _generateMarkers() {
    Set<Marker> markers = {};
    for (int i = 0; i < locations.length; i++) {
      markers.add(
        Marker(
          onTap: () {
            _onMarkerTapped(i);
          },
          markerId: MarkerId('marker_$i'),
          position: locations[i].position,
          infoWindow: InfoWindow(
            title: locations[i].userName,
            snippet: locations[i].address,
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }
    return markers;
  }

  void _onMarkerTapped(int index) {
    setState(() {
      selectedLocationIndex = index;
    });
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 100),
      curve: Curves.ease,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      selectedLocationIndex = index;
      mapController!.animateCamera(
          CameraUpdate.newLatLng(locations[selectedLocationIndex].position));
    });

    if (index == locations.length - 1) {
      // If the last page is reached, wrap around to the first page.
      pageController.jumpToPage(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Slider'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            markers: _generateMarkers(),
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(zoom: 15.0, target: _center),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              child: PageView.builder(
                controller: pageController,
                itemCount: locations.length,
                onPageChanged: (int index) {
                  _onPageChanged(index);
                },
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            locations[index].userName,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(locations[index].address),
                        ),
                        // Add other information fields here
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationInfo {
  final LatLng position;
  final String userName;
  final String address;

  LocationInfo({
    required this.position,
    required this.userName,
    required this.address,
  });

  factory LocationInfo.fromMap(Map<String, dynamic> map) {
    return LocationInfo(
      position: LatLng(map['latitude'], map['longitude']),
      userName: map['userName'],
      address: map['address'],
    );
  }
}
