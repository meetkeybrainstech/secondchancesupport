import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'chat_person.dart';

class ChatMessage {
  final String senderId;
  final String messageText;
  final String time;
  bool isSelected;
  String? messageId;
  ChatMessage(
      {required this.senderId,
      required this.messageText,
      required this.time,
      this.isSelected = false,
      required this.messageId // Initially not selected
      });
}

class ChatScreen extends StatefulWidget {
  final ChatPerson chatPerson;
  ChatScreen({required this.chatPerson});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _textController = TextEditingController();
  User? _user;
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _selectedMessages = []; // List to store selected messages
  bool _isSelectMode = false; // Flag to track if select mode is active
  List selectedindex = [];
  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  void _toggleSelectMode() {
    setState(() {
      _isSelectMode = !_isSelectMode;
      _selectedMessages
          .clear(); // Clear selected messages when toggling the mode
    });
  }

  void _deleteSelectedMessages() {
    // Implement your logic here to delete selected messages
    // You can use _selectedMessages list to get the messages to delete
    // After deleting, make sure to remove them from the UI
  }

  void _toggleMessageSelection(ChatMessage message) {
    setState(() {
      if (_selectedMessages.contains(message)) {
        _selectedMessages.remove(message);
      } else {
        _selectedMessages.add(message);
      }
    });
    print(_selectedMessages.length);
  }

  void markChatAsRead(String chatId) {
    // Get a reference to the chat document
    DocumentReference chatDocRef =
        FirebaseFirestore.instance.collection('chats').doc(chatId);

    // Update the 'isRead' field to true in all messages of the chat
    chatDocRef
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .get()
        .then((querySnapshot) {
      for (DocumentSnapshot messageDoc in querySnapshot.docs) {
        messageDoc.reference.update({'isRead': true});
      }
    });
  }

  Stream<List<QuerySnapshot<Object?>>> getData() {
    var chat_id1 =
        widget.chatPerson.senderId + "_" + widget.chatPerson.receiverId;
    var chat_id2 =
        widget.chatPerson.receiverId + "_" + widget.chatPerson.senderId;
    Stream<QuerySnapshot<Object?>> stream1 = FirebaseFirestore.instance
        .collection('chats')
        .doc(chat_id1)
        .collection("messages")
        .orderBy('time')
        .snapshots();
    Stream<QuerySnapshot<Object?>> stream2 = FirebaseFirestore.instance
        .collection('chats')
        .doc(chat_id2)
        .collection("messages")
        .orderBy('time')
        .snapshots();

    return Rx.combineLatest2(stream1, stream2,
        (QuerySnapshot<Object?> snapshot1, QuerySnapshot<Object?> snapshot2) {
      return [snapshot1, snapshot2];
    });
  }

  Stream<QuerySnapshot> _initializeChatMessagesStream() {
    final user1 = widget.chatPerson.senderId;
    final user2 = widget.chatPerson.receiverId;
    final chatId1 = user1 + "_" + user2;
    final chatId2 = user2 + "_" + user1;

    final chatMessagesStream1 = _firestore
        .collection('chats/$chatId1/messages')
        .orderBy('time')
        .snapshots();
    final chatMessagesStream2 = _firestore
        .collection('chats/$chatId2/messages')
        .orderBy('time')
        .snapshots();

    return StreamGroup.merge([chatMessagesStream1, chatMessagesStream2]);
  }

  void _sendMessage(String text) async {
    final user1 = widget.chatPerson.senderId;
    final user2 = widget.chatPerson.receiverId;
    final chatId1 = user1 + "_" + user2;
    final chatId2 = user2 + "_" + user1;

    DocumentReference chatDocRef1 = _firestore.collection("chats").doc(chatId1);
    DocumentSnapshot chatDocSnapshot1 = await chatDocRef1.get();
    DocumentReference chatDocRef2 = _firestore.collection("chats").doc(chatId2);
    DocumentSnapshot chatDocSnapshot2 = await chatDocRef2.get();
    chatDocRef1.collection("messages").add({
      'senderId': user1,
      'message': text,
      'time': DateTime.now().toLocal().toString(),
      'isRead': false,
    });

    // Scroll to the bottom
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    _textController.clear();
  }

  String _formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date).toLocal();
    final DateTime now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'Today';
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }
  }

  String _formatTime(String timeString) {
    final dateTime = DateTime.parse(timeString);
    final formattedTime = DateFormat('HH:mm').format(dateTime.toLocal());
    return formattedTime;
  }

  Widget _buildTextComposer() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              maxLines: null,
              controller: _textController,
              decoration: InputDecoration.collapsed(
                  hintText: 'Type your message',
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.swap_horiz,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {});
            },
          ),
          InkWell(
            onTap: () {
              if (_textController.text == null) {
                return;
              } else {
                _sendMessage(_textController.text);
              }
            },
            child: SizedBox(
              height: 28,
              child: Image(
                image: AssetImage('assets/send.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  deleteMessages() async {
    for (var i = 0; i < selectedindex.length; i++) {
      print(_selectedMessages[i].messageText);
      if (_selectedMessages[i].senderId == widget.chatPerson.senderId) {
        FirebaseFirestore.instance
            .collection("chats")
            .doc(
                widget.chatPerson.senderId + "_" + widget.chatPerson.receiverId)
            .collection("messages")
            .doc(_selectedMessages[i].messageId)
            .delete();
      } else {

        FirebaseFirestore.instance
            .collection("chats")
            .doc(
            widget.chatPerson.receiverId + "_" + widget.chatPerson.senderId)
            .collection("messages")
            .doc(_selectedMessages[i].messageId)
            .delete();
      }
    }
    setState(() {
      selectedindex.clear();
      _selectedMessages.clear();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46BA80),
        title: Text(widget.chatPerson.name),
        centerTitle: true,
        actions: [
          selectedindex.length > 0
              ? IconButton(
                  onPressed: () {
                    deleteMessages();
                  },
                  icon: Icon(Icons.delete_outlined))
              : Container()
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<QuerySnapshot<Object?>>>(
              stream: getData() as Stream<List<QuerySnapshot<Object?>>>,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return Center(child: Text("No Messages found"));
                }
                markChatAsRead(widget.chatPerson.receiverId +
                    "_" +
                    widget.chatPerson.senderId);
                final List<QueryDocumentSnapshot<Object?>> list1 =
                    snapshot.data![0].docs;
                final List<QueryDocumentSnapshot<Object?>> list2 =
                    snapshot.data![1].docs;

                // Combine and sort the lists as needed
                List<QueryDocumentSnapshot<Object?>> combinedList = [
                  ...list1,
                  ...list2
                ];
                combinedList.sort((a, b) => (a['time']).compareTo(b['time']));
                var messages = combinedList;
                if (messages.length == 0) {
                  return Center(
                    child: Text("No chats Found"),
                  );
                }
                // print(messages.length);
                // Add messages from the second user's collection

                List<Widget> messageWidgets = [];
                String? previousDate;

                for (var i = 0; i < messages.length; i++) {
                  var message = messages[i];
                  var senderId = message['senderId'];
                  var messageText = message['message'];
                  var time = message['time'];
                  var isSender = senderId == _user!.uid;

                  final formattedDate = _formatDate(time);

                  if (previousDate != formattedDate) {
                    // Display date header when date changes
                    previousDate = formattedDate;
                    messageWidgets.add(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            height: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[600],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 5, right: 5),
                              child: Text(
                                formattedDate,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  messageWidgets.add(
                    GestureDetector(
                      onLongPress: () {
                        setState(() {
                          if (selectedindex.contains(i)) {
                            _selectedMessages.remove(ChatMessage(
                                senderId: senderId,
                                messageText: messageText,
                                time: time,
                                messageId: message.id));
                            selectedindex.remove(i);
                          } else {
                            _selectedMessages.add(ChatMessage(
                                senderId: senderId,
                                messageText: messageText,
                                time: time,
                                messageId: message.id));
                            selectedindex.add(i);
                          }
                        });
                      },
                      child: Container(
                        color: selectedindex.contains(i)
                            ? Colors.blue.shade100
                            : Colors.transparent,
                        child: isSender
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(_formatTime(time)),
                                    ),
                                    ChatBubble(
                                      clipper: ChatBubbleClipper2(
                                          type: BubbleType.sendBubble),
                                      alignment: isSender
                                          ? Alignment.topRight
                                          : Alignment.topLeft,
                                      backGroundColor:
                                          isSender ? Colors.white : Colors.grey,
                                      child: Container(
                                        constraints: BoxConstraints(
                                            // maxWidth: MediaQuery.of(context).size.width * 0.7,
                                            ),
                                        // padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          messageText,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    ChatBubble(
                                      clipper: ChatBubbleClipper1(
                                          type: BubbleType.receiverBubble),
                                      alignment: isSender
                                          ? Alignment.topRight
                                          : Alignment.topLeft,
                                      backGroundColor:
                                          isSender ? Colors.white : Colors.grey,
                                      child: Container(
                                        constraints: BoxConstraints(
                                            // maxWidth: MediaQuery.of(context).size.width * 0.7,
                                            ),
                                        // padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          "  " + messageText,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(_formatTime(time)),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController, // Attach the ScrollController
                  itemCount: messageWidgets.length,
                  itemBuilder: (context, index) {
                    return messageWidgets[index];
                  },
                );
              },
            ),
          ),
          Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
  }
}
