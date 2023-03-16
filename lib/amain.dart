import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('テスト'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await ref.child("gyro").child("2023-03-15").set({
                "state": 0,
                "timestamp": DateTime.now().millisecondsSinceEpoch,
              });
            },
            child: const Text('データを書き込む'),
          ),
        ),
      ),
    );
  }
}
