import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Latlng to Address'),
        ),
        body: Center(
          child: AddressWidget(),
        ),
      ),
    );
  }
}

class AddressWidget extends StatefulWidget {
  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  double latitude = 40.7128; // Replace with your latitude
  double longitude = -74.0060; // Replace with your

  String address = "Fetching Address...";

  @override
  void initState() {
    super.initState();
    getLocationAddress();
  }

  Future<void> getLocationAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String formattedAddress = " ${placemark.administrativeArea} , ${placemark.country}";
        setState(() {
          address = formattedAddress;
        });
      } else {
        setState(() {
          address = "Address not found";
        });
      }
    } catch (e) {
      setState(() {
        address = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Latitude: $latitude',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'Longitude: $longitude',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 20),
        Text(
          'Address:',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          address,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
