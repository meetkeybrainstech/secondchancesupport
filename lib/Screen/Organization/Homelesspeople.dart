import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'AddMember.dart';
import 'EditMemberPage.dart';

class HomelessPeople extends StatefulWidget {
  @override
  _HomelessPeopleState createState() => _HomelessPeopleState();
}

class _HomelessPeopleState extends State<HomelessPeople> {
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46BA80),

        title: isSearching
            ? TextField(
          controller: searchController,
          style: TextStyle(
            color: Colors.black,
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(Icons.search, color: Colors.white),
            hintText: "Search...",
            hintStyle: TextStyle(color: Colors.white),
          ),
        )
            : Row(
          children: [
            Text(
              "Home",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "less Member",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: isSearching
                ? Icon(Icons.close, color: Colors.white)
                : Icon(Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                searchController.clear();
                searchQuery = '';
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF46BA80),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMemberPage()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('HomeLessMembers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No data available');
          }

          List<DocumentSnapshot> userProfiles = snapshot.data!.docs;

          // Filter the data based on the search query
          List<DocumentSnapshot> filteredUserProfiles = userProfiles
              .where((profile) =>
              profile['fullName'].toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two cards per row
              childAspectRatio: 0.75, // Aspect ratio of the cards (adjust as needed)
            ),
            itemCount: filteredUserProfiles.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditMemberPage(
                        memberId: filteredUserProfiles[index].id,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 150,
                            child: Image.network(
                              filteredUserProfiles[index]['profileImageUrl'],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0, top: 21),
                            child: Text(
                              '${filteredUserProfiles[index]['fullName']}',
                              style: const TextStyle(
                                color: Color(0xFF1F2D36),
                                fontSize: 18,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w500,
                                height: 0.07,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 18.0,
                            ),
                            child: Container(
                              width: 70,
                              height: 30,
                              child: Text(
                                "${calculateAge(DateTime.parse(filteredUserProfiles[index]['dob'])).toString()} Years",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  int calculateAge(DateTime dob) {
    DateTime now = DateTime.now();
    int age = now.year - dob.year;

    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }

    return age;
  }
}

List<Map<String, dynamic>> details = []; // Your data
