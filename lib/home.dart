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
  List<String> stateList = ['素晴らしい ', 'ダメ', 'ダメダメ'];
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
      debugPrint('$e');
      // debugPrint('home');
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
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  nowState,
                  style: GoogleFonts.delaGothicOne(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      color: Colors.red,
                      fontSize: 56),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
