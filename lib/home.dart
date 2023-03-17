import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  var stateNum;
  List<String> stateList = ['素晴らしい', 'ダメ', 'ダメダメ'];
  String nowState = '素晴らしい';

  @override
  void initState() {
    try {
      stateNum = 0;
      super.initState();
      ref
          .child('test/-NQcUOvNQPtZmec-M65n/data')
          .orderByChild('timestamp')
          .limitToLast(1)
          .onValue
          .listen((event) {
        var snapshot = event.snapshot;
        if (snapshot.value != null) {
          setState(() {
            stateNum = snapshot.children.first.child('state').value;
            nowState = stateList[stateNum];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/R30％.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  'images/nekoze_cat_0$stateNum.png',
                  height: 300,
                ),
              ),
              const Positioned(
                top: 20,
                left: 100,
                child: Text(
                  '現在の状態',
                  style: TextStyle(
                      fontFamily: AutofillHints.birthday,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Container(
                // width: 600,
                // height: 400,
                // color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: Positioned(
                        // bottom: 30,
                        // left: 100,
                        child: Text(
                          nowState,
                          // style: const TextStyle(
                          //     // backgroundColor: Colors.red,
                          //     fontSize: 36,
                          //     fontWeight: FontWeight.w900,
                          //     color: Colors.black),
                          style: GoogleFonts.delaGothicOne(
                              textStyle: Theme.of(context).textTheme.headline4,
                              color: Colors.red,
                              fontSize: 56),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
