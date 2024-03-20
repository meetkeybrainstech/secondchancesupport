import 'package:flutter/material.dart';



class Wallet_page extends StatefulWidget {
  const Wallet_page({Key? key}) : super(key: key);

  @override
  State<Wallet_page> createState() => _Wallet_pageState();
}

class _Wallet_pageState extends State<Wallet_page> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: const Text("Wallet"),
        backgroundColor: Colors.grey[50],
        foregroundColor: Colors.black,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * .9,
              height: MediaQuery.of(context).size.height * .2,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/wallet_bg.png",),
                  fit: BoxFit.fill
                ),
                color: const Color(0xFF43BA82),
                borderRadius: BorderRadius.circular(20)
              ),
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30,),
                  Text(
                    '\$500.00',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontFamily: 'SF Pro Text',
                      fontWeight: FontWeight.w800,
                      height: 0.03,
                    ),
                  ),
                  Text(
                    'Your Balance',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'SF Pro Text',
                      fontWeight: FontWeight.w500,
                      height: 2,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .98,
              height: MediaQuery.of(context).size.height * .55,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 16,
                    offset: Offset(0, 0),
                    spreadRadius: 2,
                  )
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin:const EdgeInsets.only(top: 20,left: 16),
                      child: const Text(
                        'Transactions',
                        style: TextStyle(
                          color: Color(0xFF787878),
                          fontSize: 13,
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w400,
                          height: 0.08,
                        ),
                      ),
                    ),
                    ListTile(

                      leading: Container(
                        margin: const EdgeInsets.only(left: 20),
                        width: 2,
                        height: 40,
                        decoration: const BoxDecoration(color: Color(0xFFFF4949)),
                      ),
                      title: const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: TextStyle(
                              color: Color(0xFF1F2D36),
                              fontSize: 16,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                          Text(
                            'Sent on 12 July,2023',
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 12,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w300,
                              height: 1,
                            ),
                          ),
                        ],

                      ),
                      trailing: const Column(
                        children: [
                          Text(
                            '\$1357.67',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFFFF4949),
                              fontSize: 16,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w600,
                              height:2,
                            ),
                          ),
                          Text(
                            '04:04 PM',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 12,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: const Divider(height: 2,thickness: 2,)),
                    ListTile(

                      leading: Container(
                        margin: const EdgeInsets.only(left: 20),
                        width: 2,
                        height: 40,
                        decoration: const BoxDecoration(color: Color(0xFF43BA82)),
                      ),
                      title: const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Madelyn Ekstrom',
                            style: TextStyle(
                              color: Color(0xFF1F2D36),
                              fontSize: 16,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                          Text(
                            'Received on 11 July,2023',
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 12,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w300,
                              height: 1,
                            ),
                          ),
                        ],

                      ),
                      trailing: const Column(
                        children: [
                          Text(
                            '\$50.00',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF43BA82),
                              fontSize: 16,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w600,
                              height:2,
                            ),
                          ),
                          Text(
                            '04:04 PM',
                            textAlign: TextAlign.right,
                            style:  TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 12,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: const Divider(height: 2,thickness: 2,)),
                    ListTile(

                      leading: Container(
                        margin: const EdgeInsets.only(left: 20),
                        width: 2,
                        height: 40,
                        decoration: const BoxDecoration(color: Color(0xFFFF4949)),
                      ),
                      title: const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Martin Levin',
                            style: TextStyle(
                              color: Color(0xFF1F2D36),
                              fontSize: 16,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                          Text(
                            'Sent on 25 June,2023',
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 12,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w300,
                              height: 1,
                            ),
                          ),
                        ],

                      ),
                      trailing: const Column(
                        children: [
                          Text(
                            '\$135.35',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFFFF4949),
                              fontSize: 16,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w600,
                              height:2,
                            ),
                          ),
                          Text(
                            '04:04 PM',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 12,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: const Divider(height: 2,thickness: 2,)),
                    ListTile(

                      leading: Container(
                        margin: const EdgeInsets.only(left: 20),
                        width: 2,
                        height: 40,
                        decoration: const BoxDecoration(color: Color(0xFF43BA82)),
                      ),
                      title: const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Marley Geidt',
                            style: TextStyle(
                              color: Color(0xFF1F2D36),
                              fontSize: 16,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                          Text(
                            'Received on 18 June,2023',
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 12,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w300,
                              height: 1,
                            ),
                          ),
                        ],

                      ),
                      trailing: const Column(
                        children: [
                          Text(
                            '\$1878.00',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF43BA82),
                              fontSize: 16,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w600,
                              height:2,
                            ),
                          ),
                          Text(
                            '04:04 PM',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 12,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: const Divider(height: 2,thickness: 2,)),
                    ListTile(

                      leading: Container(
                        margin: const EdgeInsets.only(left: 20),
                        width: 2,
                        height: 40,
                        decoration: const BoxDecoration(color: Color(0xFFFF4949)),
                      ),
                      title: const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cooper Schleifer',
                            style: TextStyle(
                              color: Color(0xFF1F2D36),
                              fontSize: 16,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                          Text(
                            'Sent on 26 May,2023',
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 12,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w300,
                              height: 1,
                            ),
                          ),
                        ],

                      ),
                      trailing: const Column(
                        children: [
                          Text(
                            '\$150.00',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFFFF4949),
                              fontSize: 16,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w600,
                              height:2,
                            ),
                          ),
                          Text(
                            '10:10 AM',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 12,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: const Divider(height: 2,thickness: 2,)),
                    ListTile(

                      leading: Container(
                        margin: const EdgeInsets.only(left: 20),
                        width: 2,
                        height: 40,
                        decoration: const BoxDecoration(color: Color(0xFF43BA82)),
                      ),
                      title: const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mira Lubin',
                            style: TextStyle(
                              color: Color(0xFF1F2D36),
                              fontSize: 16,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                          Text(
                            'Received on 22 May,2023',
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 12,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w300,
                              height: 1,
                            ),
                          ),
                        ],

                      ),
                      trailing: const Column(
                        children: [
                          Text(
                            '\$125.25',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF43BA82),
                              fontSize: 16,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w600,
                              height:2,
                            ),
                          ),
                          Text(
                            '04:25 PM',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 12,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),

                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),

                  /*  if (_bannerAd != null)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: _bannerAd!.size.width.toDouble(),
                          height: _bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd!),
                        ),
                      ),*/

                      Container(
                          padding: EdgeInsets.all(10),
                          child: Image.asset("assets/google_ad.png"))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
