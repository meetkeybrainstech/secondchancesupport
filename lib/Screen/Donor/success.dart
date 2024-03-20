import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomClipPath extends CustomClipper<Path> {
  final double screenHeight;
  final double screenWidth;
  CustomClipPath(this.screenHeight, this.screenWidth);
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 120);
    path.lineTo(500, 450);
    path.lineTo(500, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
class MyCustomLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.7,
          child: Stack(
            children: [
              Container(
                color: Color.fromRGBO(244, 211, 181, 0.81),
              ),
              ClipPath(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromRGBO(88, 84, 84, 1),
                ),
                clipper: CustomClipPath(300, 300),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
                child: Center(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Thank',
                            style: GoogleFonts.greatVibes(
                                textStyle: TextStyle(
                                  fontSize: 60,
                                  color: Color.fromARGB(255, 69, 190, 170),
                                  decoration: TextDecoration.none,
                                )),
                            // TextStyle(X`
                            //     color: Color.fromARGB(255, 69, 190, 170),
                            //     decoration: TextDecoration.none,
                            //     ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            'You',
                            style: GoogleFonts.greatVibes(
                                textStyle: TextStyle(
                                  fontSize: 60,
                                  color: Color.fromARGB(255, 69, 190, 170),
                                  decoration: TextDecoration.none,
                                )),
                            // TextStyle(
                            //     color: Color.fromARGB(255, 69, 190, 170),
                            //     decoration: TextDecoration.none,
                            //     ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Image.asset(
                          'assets/correct.gif',
                          height: 100,
                        ),
                        Text('Your Donation has been',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              decoration: TextDecoration.none,
                            )),
                        Text('made successfully.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              decoration: TextDecoration.none,
                            )),
                      ],
                    )),
              )
              // Add additional widgets here if needed
            ],
          ),
        ),
      ),
    );
  }
}