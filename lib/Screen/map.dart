import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  int user_index;
  MapScreen(
  {
    required this.user_index,
}
);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  GoogleMapController? mapController;
  final LatLng _center = const LatLng(21.5397, 71.5776);
  PageController pageController = PageController(initialPage: 0);
  List<LocationInfo> locations = [
    LocationInfo(
      profile_image: "assets/user_1.png",
      position: const LatLng(40.7128,-74.0060), // Initial location
      userName: 'John Doe',
      address: 'New York City, New York',
      year: 28,
      deviceAllocated: 'Yes',
      deviceSerial: 'G4567HGFGH87654',
      donationReceived: '\$200',
      walletBalance: 5000.0,
      memberSince: '01 Jan, 2023',
    ),
    LocationInfo(
      profile_image: "assets/user_2.png",
      position: const LatLng(34.0522,-118.2437), // Example location 1
      userName: 'Alice Johnson',
      address: 'Los Angeles, California',
      year: 32,
      deviceAllocated: 'No',
      deviceSerial: 'H9876GFFG5678',
      donationReceived: '\$5678.90',
      walletBalance: 1200.0,
      memberSince: '2 Feb, 2023',
    ),
    LocationInfo(
      profile_image: "assets/user_3.png",
      position: const LatLng(41.8781,-87.6298), // Example location 1
      userName: 'Madelyn Ekstrom',
      address: 'Chicago, Illinois',
      year: 30,
      deviceAllocated: 'Yes',
      deviceSerial: 'H9876GFFGSDFF',
      donationReceived: '\$2000',
      walletBalance: 1000.0,
      memberSince: '15 Feb, 2023',
    ),
    LocationInfo(
      profile_image: "assets/user_4.png",
      position: const LatLng(25.7617, -80.1918), // Example location 1
      userName: 'Martin Levin',
      address: 'Miami, Florida',
      year: 32,
      deviceAllocated: 'No',
      deviceSerial: 'H9876GFFG5678',
      donationReceived: '\$5678.90',
      walletBalance: 1200.0,
      memberSince: '20 May, 2023',
    ),
    LocationInfo(
      profile_image: "assets/user_5.png",
      position: const LatLng(39.7392,-104.9903), // Example location 1
      userName: 'Marley Geldt',
      address: 'Denver, Colorado',
      year: 32,
      deviceAllocated: 'No',
      deviceSerial: 'H9876GFFG5678',
      donationReceived: '\$560',
      walletBalance: 2300.0,
      memberSince: '15 June, 2023',
    ),
    LocationInfo(
      profile_image: "assets/user_6.png",
      position: const LatLng(47.6062, -122.3321), // Example location 1
      userName: 'Mira Lubin',
      address: 'Seattle, Washington',
      year: 32,
      deviceAllocated: 'No',
      deviceSerial: 'H9876GFFG5678',
      donationReceived: '\$750',
      walletBalance: 3500.0,
      memberSince: '22 July, 2023',
    ),
    LocationInfo(
      profile_image: "assets/user_6.png",
      position: const LatLng(47.6062, -122.3321), // Example location 1
      userName: 'Mira Lubin',
      address: 'Seattle, Washington',
      year: 32,
      deviceAllocated: 'No',
      deviceSerial: 'H9876GFFG5678',
      donationReceived: '\$750',
      walletBalance: 3500.0,
      memberSince: '22 July, 2023',
    ),

    // Add more locations as needed
  ];
  int selectedLocationIndex = 0;

  @override
  void initState() {
    super.initState();
    print(widget.user_index);
    //_onPageChanged(widget.user_index);
    //pageController.jumpToPage(widget.user_index);
  }

  void _onMapCreated(GoogleMapController controller) {

    mapController = controller;
    //_onPageChanged(widget.user_index);
    mapController!.animateCamera(
        CameraUpdate.newLatLng(locations[selectedLocationIndex].position));
    pageController.jumpToPage(widget.user_index);
  }

  Set<Marker> _generateMarkers() {
    Set<Marker> markers = {};
    for (int i = 0; i < locations.length; i++) {
      markers.add(
        Marker(
          onTap: (){
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    LocationInfo currentLocation = locations[selectedLocationIndex];

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        // title: Text('Location Slider'),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GoogleMap(
            markers: _generateMarkers(),
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(zoom: 11.0, target: _center),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              height: height > 660 ? MediaQuery.of(context).size.height*.45 :  MediaQuery.of(context).size.height*.57, // Adjust the height as needed
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
                          leading: Container(
                            width: 62,
                            height: 62,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: AssetImage('${locations[index].profile_image}'), // Replace with actual image path
                                fit: BoxFit.fill,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          title: Text(
                            currentLocation.userName,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(currentLocation.address,style: const TextStyle(
                              fontSize: 10
                          ),),
                          trailing: Container(
                            width: 67,
                            height: 24,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0x1443BA82),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child:  Text(
                              '${locations[index].year.toString()} Years',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Color(0xFF43BA82),
                                fontSize: 12,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w500,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          title:  const Text(
                            'Device allotted ',
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 14,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              height:  1 ,
                            ),
                          ),
                          trailing: Text(
                            '${locations[index].deviceAllocated}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color(0xFF1F2D36),
                              fontSize: 14,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w500,
                              height: .04,
                            ),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 15),
                            width: MediaQuery.of(context).size.width * .80,
                            child: const Divider(height: 1,thickness: 2,)),
                        ListTile(
                          title:  const Text(
                            'Device serial ',
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 14,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                          trailing: Text(
                            '${locations[index].deviceSerial}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color(0xFF1F2D36),
                              fontSize: 14,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 15),
                            width: MediaQuery.of(context).size.width * .80,
                            child: const Divider(height: 1,thickness: 2,)),
                        ListTile(
                          title:  const Text(
                            'Donation received ',
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 14,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                          trailing: Text(
                            '${locations[index].donationReceived}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color(0xFF1F2D36),
                              fontSize: 14,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 15),
                            width: MediaQuery.of(context).size.width * .80,
                            child: const Divider(height: 1,thickness: 2,)),
                        ListTile(
                          title:  const Text(
                            'Wallet balance ',
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 14,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                          trailing: Text(
                            '\$${locations[index].walletBalance}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color(0xFF1F2D36),
                              fontSize: 14,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 15),
                            width: MediaQuery.of(context).size.width * .80,
                            child: const Divider(height: 1,thickness: 2,)),
                        ListTile(
                          title:  const Text(
                            'Member since ',
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 14,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                          trailing: Text(
                            '${locations[index].memberSince}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color(0xFF1F2D36),
                              fontSize: 14,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                        ),

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
  final int year;
  final String deviceAllocated;
  final String deviceSerial;
  final String donationReceived;
  final double walletBalance;
  final String memberSince;
  final String profile_image;

  LocationInfo({
    required this.position,
    required this.userName,
    required this.address,
    required this.year,
    required this.deviceAllocated,
    required this.deviceSerial,
    required this.donationReceived,
    required this.walletBalance,
    required this.memberSince,
    required this.profile_image
  });
}
