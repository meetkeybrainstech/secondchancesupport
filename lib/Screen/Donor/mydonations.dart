import 'package:flutter/material.dart';

import 'donor_drawer.dart';


class MyDonation extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final List<Map<String, dynamic>> dataList = [
    {
      'username': 'User1',
      'date': '29th Jan 2023',
      'amount': '\$100 USD',
      'imagePath': 'assets/user_1.png',
    },
    {
      'username': 'User2',
      'date': '30th Jan 2023',
      'amount': '\$150 USD',
      'imagePath': 'assets/user_2.png',
    },
    // Add more data entries as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(

          centerTitle: true,
          title: Text('My Donations',style: TextStyle(
              color: Colors.black
          ),),
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
              //fillColor: Colors.transparent, // Set the background color to transparent
              constraints: BoxConstraints.tight(Size(40.0, 40.0)), // Set the button size
              padding: EdgeInsets.all(8.0), // Adjust the padding as needed
              elevation: 2.0, // Add elevation if desired
              highlightElevation: 4.0, // Add elevation when pressed if desired
              // Set the border color and width
            )

          ],
          backgroundColor: Colors.white,
        ),
        endDrawer: AppDrawer(),
        body: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            final entry = dataList[index];
            return MyListTile(
              username: entry['username'],
              date: entry['date'],
              amount: entry['amount'],
              imagePath: entry['imagePath'],
            );
          },
        ),

    );
  }
}

class MyListTile extends StatelessWidget {
  final String username;
  final String date;
  final String amount;
  final String imagePath;

  MyListTile({
    required this.username,
    required this.date,
    required this.amount,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imagePath),
        radius: 25, // Adjust the radius as needed
      ),
      title: Text(username),
      subtitle: Text(date),
      trailing: Text(amount),
    );
  }
}
