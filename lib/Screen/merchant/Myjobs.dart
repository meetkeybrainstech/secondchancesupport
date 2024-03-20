import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homeless/Screen/Donor/Add_job_post_Screen.dart';

class JobPost {
  final String title;
  final String location;
  final String description;
  final String date;

  JobPost({
    required this.title,
    required this.location,
    required this.description,
    required this.date,
  });
}
String getCurrentUserUid() {
  final user = FirebaseAuth.instance.currentUser;
  return user?.uid ?? ''; // Return an empty string if user is null
}
class MyJobs extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final List<JobPost> jobPosts = [
    JobPost(
      title: 'Job Post Title 1',
      location: 'Location 1',
      description: 'Description 1',
      date: '29th Jan 2023',
    ),
    JobPost(
      title: 'Job Post Title 2',
      location: 'Location 2',
      description: 'Description 2',
      date: '30th Jan 2023',
    ),
    // Add more JobPost objects as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text('Job Post',style: TextStyle(
              color: Colors.black
          ),),
          elevation: 0,
          backgroundColor: Colors.white,
        ),

        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('DonorjobPosts')
              .where('uid', isEqualTo: getCurrentUserUid())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No job posts found'),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final jobPosts = snapshot.data!.docs;

            return ListView.builder(
              itemCount: jobPosts.length,
              itemBuilder: (context, index) {
                final jobPost = jobPosts[index];
                final jobData = jobPost.data() as Map<String, dynamic>;

                return MyCard(
                  title: jobData['jobTitle'],
                  location: jobData['jobLocation'],
                  description: jobData['jobDescription'],
                  date: jobData['date'],
                  id:jobPost.id

                );
              },
            );
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>add_job_post_screen()));
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF46BA80),
        ),

    );
  }

}

class MyCard extends StatelessWidget {
  final String title;
  final String location;
  final String description;
  final String date;
  final String id;

  MyCard({
    required this.title,
    required this.location,
    required this.description,
    required this.date,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Text(title),
            subtitle: Text(location),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                FirebaseFirestore.instance.collection("DonorjobPosts").doc(id).delete();
                },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Posted on $date',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
