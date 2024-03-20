import 'package:flutter/material.dart';

class CustomSnackbar extends StatelessWidget {
  final String message;

  CustomSnackbar({required this.message});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          SizedBox(width: 8),
          Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      duration: Duration(seconds: 2),
    );
  }
}