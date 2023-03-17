import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  var stateNum;

  @override
  void initState() {
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
        });
      }
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   ref
  //       .child('test/-NQcUOvNQPtZmec-M65n/data')
  //       .orderByChild('timestamp')
  //       .limitToLast(1)
  //       .once()
  //       .then((snapshot) {
  //     setState(() {
  //       stateNum = snapshot.snapshot.children.first.child('state').value;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/R30％.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            '$stateNum',
            style: TextStyle(fontSize: 24),
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
