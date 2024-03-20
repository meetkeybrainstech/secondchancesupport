import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homeless/Screen/Organization/chat_person.dart';
import 'package:homeless/Screen/Organization/chats.dart';



class Add_contact_chat_person extends StatefulWidget {
  const Add_contact_chat_person({Key? key}) : super(key: key);

  @override
  State<Add_contact_chat_person> createState() =>
      _Add_contact_chat_personState();
}

class _Add_contact_chat_personState extends State<Add_contact_chat_person> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Contact"),
        backgroundColor: Color(0xFF46BA80),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
          FirebaseFirestore.instance
              .collection("HomeLessMembers")
              //.where('uid', isNotEqualTo:  FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData) {
              return Center(
                child: Text("No User Found"),
              );
            }
            print(snapshot.data!.docs.length);
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                if(snapshot.data!.docs[index].id ==  FirebaseAuth.instance.currentUser?.uid){
                  return Container();
                }
               return InkWell(
                 onTap: ()async{
                   final chatRoomRef =
                   FirebaseFirestore.instance.collection('donor').doc(FirebaseAuth.instance.currentUser!.uid);
                   // Add the current user's UID to the "participate" list
                   await chatRoomRef.update({
                     'usersChats': FieldValue.arrayUnion([snapshot.data!.docs[index].id]),
                   }).catchError((e)=>print(e));
                 print(snapshot.data!.docs[index].id);
                   final chat1RoomRef = FirebaseFirestore.instance.collection('HomeLessMembers').doc(snapshot.data!.docs[index].id);
                   // Add the current user's UID to the "participate" list
                   await chat1RoomRef.update({
                     'usersChats': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                   });
                   ChatPerson chatPerson = ChatPerson(
                       senderId :FirebaseAuth.instance.currentUser!.uid,
                       receiverId:snapshot.data!.docs[index].id,
                      name:snapshot.data!.docs[index]["fullName"]
                   );
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatScreen(chatPerson: chatPerson,)));
                 },
                 child: ListTile(
                    title: Text(snapshot.data!.docs[index]["fullName"].toString()),
                    leading:ClipOval(
                      child: CachedNetworkImage(imageUrl: snapshot.data!.docs[index]["profileImageUrl"],
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                    )
                  ),
               );

              },
            );
          }),
    );
  }
}
