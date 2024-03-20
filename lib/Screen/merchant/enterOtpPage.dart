// import 'package:flutter/material.dart';
// import 'package:pin_input_text_field/pin_input_text_field.dart';

// class OTPPage extends StatefulWidget {
//   @override
//   State<OTPPage> createState() => _OTPPageState();
// }

// class _OTPPageState extends State<OTPPage> {
//   List<TextEditingController> _otpControllers =
//       List.generate(6, (_) => TextEditingController());

//   @override
//   void dispose() {
//     for (var controller in _otpControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.grey),
//         backgroundColor: Colors.grey[200],
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           "Confirm",
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       body: Container(
//         color: Colors.blueGrey[100],
//         child: Center(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 80,
//               ),
// Text(
//   'Enter a 6 Digit unique idenfication number \n\t\t\t\t\t\t\t\t\t\t\t\t\t to complete the process',
//   style: TextStyle(fontSize: 16),
// ),
//               buildOtpFields(),
//               SizedBox(
//                 height: 30,
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "29 years",
//                 style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.grey),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "300m",
//                 style: const TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildOtpFields() {
//     List<Widget> fields = [];
//     for (int i = 0; i < 6; i++) {
//       fields.add(
//         SizedBox(
//           width: 40,
//           child: TextField(
//             controller: _otpControllers[i],
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               counterText: '', // Remove the character counter
//             ),
//             maxLength: 1,
//             onChanged: (otp) {
//               // Automatically move to the next field after entering a digit
//               if (otp.isNotEmpty) {
//                 if (i < 5) {
//                   FocusScope.of(context).nextFocus();
//                 }
//               }
//             },
//           ),
//         ),
//       );
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: fields,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Confirm',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromRGBO(237,237,237,1),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 60),
                const Text(
                  'Enter a 6 Digit unique idenfication number \n\t\t\t\t\t\t\t\t\t\t\t\t\t to complete the process',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 60),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: PinInputTextField(
                      keyboardType: TextInputType.text,
                      pinLength: 6, // Set the OTP length to 6
                      controller: otpController,

                      decoration: BoxLooseDecoration(
                        strokeColorBuilder: const FixedColorBuilder(Colors.black),
                      ),
                      autoFocus: true,
                      textInputAction: TextInputAction.done,
                      onSubmit: (pin) {
                        // Handle the OTP submission here
                        print("Entered OTP: $pin");
                        // You can verify the OTP here and proceed accordingly
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      maxRadius: 10,
                      child: Icon(
                        Icons.question_mark_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text(
                      "What's this?",
                      style: TextStyle(fontSize: 16, color:Color.fromARGB(255, 69, 190, 170)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(28.0),
                  child: Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 180,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    color: Color.fromARGB(255, 69, 190, 170),
                    child: const Center(
                        child: Text(
                          "REQUEST PAYMENT",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}