import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

import '../../model/service.dart';
import '../account_type.dart';
import 'Add_contact_chat_person.dart';
import 'chats.dart';


class ChatPerson {
  final String
  chatId; // Combine sender and receiver IDs to create a unique chat ID
  final String senderId;
  final String receiverId;
  final String name;
  final String? image;
  final String? lastMessage;
  final String? time;
  final int? countmessages;

  ChatPerson(
      {required this.senderId,
        required this.receiverId,
        required this.name,
        this.image,
        this.lastMessage,
        this.time,
        this.countmessages})
      : chatId = '$senderId' +
      '_' +
      '$receiverId'; // Combine sender and receiver IDs

  @override
  int get hashCode => chatId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ChatPerson && chatId == other.chatId;
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//  late Timer _timer;
  User? _user;
  String _formatTime(String timeString) {
    final dateTime = DateTime.parse(timeString).toLocal();
    final now = DateTime.now().toLocal();
    final yesterday = now.subtract(Duration(days: 1));

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return '${DateFormat('hh:mm a').format(dateTime)}';
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }
  }

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          isLoading = false;
        });
      });
    });
    Timer.periodic(Duration(seconds: 2), (Timer t) => setState((){}));
  }

  Stream<List<ChatPerson>> _getChattedUsersStream() async* {
    if (_user == null) {
      yield []; // Yield an empty list if user is null
      return;
    }

    final userId = _user!.uid;

    final chatStream = _firestore.collection("merchants").doc(userId).snapshots();

    await for (var documentSnapshot in chatStream) {
      final List<dynamic> userChats = documentSnapshot.get('usersChats') ?? [];

      final List<ChatPerson> chattedUsers = [];

      for (final userDocId in userChats) {
        final userDoc = await _firestore.collection('HomeLessMembers').doc(userDocId).get();

        if (userDoc.exists) {
          final chatId = userDoc.id;
          final userName = userDoc['fullName'] as String;
          final image = userDoc["profileImageUrl"] as String;

          // Fetch the last message and time here
          var lastMessageQuery = await FirebaseFirestore.instance
              .collection("chats")
              .doc(userId + "_" + chatId)
              .collection("messages")
              .orderBy('time', descending: true)
              .limit(1)
              .get();
          QuerySnapshot lastMessageQuery1 = await FirebaseFirestore.instance
              .collection("chats")
              .doc(chatId + "_" + userId)
              .collection("messages")
              .orderBy('time', descending: true)
              .limit(1)
              .get();
          String lastMessage = '';
          String lastTime = '';

          if (lastMessageQuery.docs.isNotEmpty && lastMessageQuery1.docs.isNotEmpty) {
            List<QueryDocumentSnapshot> mergedDocs = []
              ..addAll(lastMessageQuery.docs)
              ..addAll(lastMessageQuery1.docs);
            mergedDocs.sort((a, b) {
              String timeAString = a['time'] as String;
              String timeBString = b['time'] as String;

              // Convert the time strings to DateTime objects for comparison
              DateTime timeADate = DateTime.parse(timeAString);
              DateTime timeBDate = DateTime.parse(timeBString);

              return timeBDate.compareTo(timeADate);
            });

            //print(mergedDocs.first["time"]);
            lastMessage = mergedDocs.first["message"] as String;
            lastTime = mergedDocs.first["time"] as String;
          }else if(lastMessageQuery.docs.isNotEmpty){

            lastMessage = lastMessageQuery.docs.first['message'] as String;
            lastTime = lastMessageQuery.docs.first['time'] as String;
            //   lastTime = _formatTime(lastTime);
          } else {
            lastMessageQuery = await FirebaseFirestore.instance
                .collection("chats")
                .doc(chatId + "_" + userId)
                .collection("messages")
                .orderBy('time', descending: true)
                .limit(1)
                .get();
            if (lastMessageQuery.docs.isNotEmpty) {
              lastMessage = lastMessageQuery.docs.first['message'] as String;
              lastTime = lastMessageQuery.docs.first['time'] as String;
              //  lastTime = _formatTime(lastTime);
            }
          }

          // Calculate the count of unread messages
          var countmessages = 0;
          await FirebaseFirestore.instance
              .collection("chats/${chatId + '_' + userId}/messages")
              .where('isRead', isEqualTo: false)
              .get()
              .then((querySnapshot) {
            countmessages = querySnapshot.size;
          });

          final chatPerson = ChatPerson(
            senderId: userId,
            receiverId: chatId,
            name: userName,
            image: image,
            lastMessage: lastMessage,
            time: lastTime,
            countmessages: countmessages,
          );
          chattedUsers.add(chatPerson);
        }
      }

      yield chattedUsers; // Yield the list of chatted users for each snapshot
    }
  }



  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Messages',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
      ),
    //  endDrawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Add_contact_chat_person()));
        },
        backgroundColor: Color(0xFF46BA80),
        child: Icon(Icons.add),
      ),

      body: RefreshIndicator(
        onRefresh: ()async{
          setState(() {
          });
        },
        child: StreamBuilder<List<ChatPerson>>(
          stream: _getChattedUsersStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return isLoading
                  ? Center(child: CircularProgressIndicator()) // You can also use ProgressDialog here
                  : Center(
                child: Text('No chatted users found.'),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            List<ChatPerson> chattedUsers = snapshot.data!;
            chattedUsers.sort((a, b) => b.time!.compareTo(a.time!));

            return ListView.builder(
              itemCount: chattedUsers.length,
              itemBuilder: (context, index) {
                final chatPerson = chattedUsers[index];
                var lastMessage = chatPerson.lastMessage == "" ||
                    chatPerson.lastMessage!.isEmpty
                    ? "No message yet"
                    : chatPerson.lastMessage.toString();
                print(chatPerson.time);
                return Column(
                  children: [
                    ListTile(
                      leading: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: chatPerson.image.toString(),
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(chatPerson.name.toString()),
                      subtitle: Text(lastMessage),
                      trailing: chatPerson.countmessages == 0
                          ? Text(
                        chatPerson.time == ""
                            ? ""
                            : _formatTime(chatPerson.time.toString())
                            .toString(),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                          : CircleAvatar(
                        backgroundColor: Color(0xFF46BA80),
                        maxRadius: 15,
                        child: Text(
                          chatPerson.countmessages.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () async {
                        // Navigate to the chat screen with chatPerson as a parameter.
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) =>
                                ChatScreen(chatPerson: chatPerson)),
                          ),
                        );
                        // No need to manually refresh the list when returning from chat screen.
                      },
                    ),
                    Divider(),
                  ],
                );
              },
            );
          },
        ),
      )
      ,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: UserListScreen(),
  ));
}