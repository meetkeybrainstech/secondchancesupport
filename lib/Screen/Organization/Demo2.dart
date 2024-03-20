import 'package:flutter/material.dart';

import '../account_type.dart';

class splash_screen extends StatefulWidget {
  String id;
   splash_screen({Key? key,required this.id}) : super(key: key);

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:  InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Account_type() ));
          },
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width * .8,
              height: 50,
              decoration: ShapeDecoration(
                color: Color(0xFF46BA80),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Sign to your Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'SF Pro Text',
                    fontWeight: FontWeight.w600,
                    height: 2,
                  ))),
        ),
        body: Stack(
          children: [
            Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 0,
                    child: ClipPath(
                      clipper: MyClipper(),
                      child: Container(
//       margin: EdgeInsets.only(top: size.height * 0.5),
                        height: MediaQuery.of(context).size.height * 0.55,
                        width: MediaQuery.of(context).size.width,
                        color: Color(0xFF1F2D36),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .06,
                            ),
                            Text(
                              'Let us help the community',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w600,
                                height: 4,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: Text(
                                'Lorem ipsum dolor sit amet consectetur. Dui risus vel risus sed nulla.Lorem ipsum dolor sit amet consectetur. Dui risus vel risus sed nulla.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6000000238418579),
                                  fontSize: 16,
                                  fontFamily: 'SF Pro Text',
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ]
            ),
            Container(
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * .1),
              width:  MediaQuery.of(context).size.width * .8,
              height: MediaQuery.of(context).size.height > 600 ? MediaQuery.of(context).size.height * .5 :MediaQuery.of(context).size.height * .3 ,
              child: ClipRRect(
                child: Image.asset('assets/img.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.moveTo(0, size.height);

    path.lineTo(0, size.height * 0.25);
//    path.lineTo(size.width, size.height);
//    path.lineTo(size.width, size.height * 0.5);

    path.quadraticBezierTo(size.width / 2, -30, size.width, size.height * 0.25);

    path.lineTo(size.width, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
