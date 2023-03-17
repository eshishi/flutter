import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class KMNHome extends StatefulWidget {
  const KMNHome({Key? key}) : super(key: key);

  @override
  State<KMNHome> createState() => _KMNHomeState();
}

class _KMNHomeState extends State<KMNHome> {
  FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  //状態のテキスト格納用変数
  String status = '';

  //吹き出しテキスト格納用変数
  String bubble = '';

  @override
  var stateNum;

  @override
  void initState() {
    stateNum = 0;
    super.initState();
    ref
        .child('test/-NQcUOvNQPtZmec-M65n/data')
        .orderByChild('timestamp')
        .limitToLast(1)
        .onValue
        .listen(
      (event) {
        var snapshot = event.snapshot;
        if (snapshot.value != null) {
          setState(
            () {
              stateNum = snapshot.children.first.child('state').value;
              if (snapshot.value == 0) {
                bubble = '素晴らしいにゃ！そのままの姿勢で頑張るにゃ!';
                status = '素晴らしい';
              } else if (snapshot.value == 1) {
                bubble = 'ダメにゃ、姿勢が崩れてるにゃ～';
                status = 'ダメ';
              } else {
                bubble = 'ダメダメにゃ～、もっと頑張るにゃ～';
                status = 'ダメダメ';
              }
            },
          );
        }
      },
    );
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
          //状態を示す人形画像
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 380,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.50),
                    child: Image.asset('images/nekoze_cat_01.png'),
                  ),
                ),
              ),
              //テキスト(現在の状態)
              const Positioned(
                top: 50,
                left: 0,
                right: 180,
                child: SizedBox(
                  height: 150,
                  child: Center(
                    child: Text(
                      '現在の状態',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              //status(状態を表す文字)
              Positioned(
                bottom: 30,
                left: 85,
                right: 0,
                child: SizedBox(
                  height: 1100,
                  child: Center(
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              //左下のアイコン画像
              Positioned(
                bottom: 70,
                left: 0,
                child: Image.asset(
                  'images/neko_icon.png',
                  width: 90,
                  height: 90,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 650.0, left: 85),
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
                child: Text(bubble),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: BubbleBorder(
                    width: 1,
                    radius: 10,
                  ),
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

class BubbleBorder extends ShapeBorder {
  BubbleBorder({
    required this.width,
    required this.radius,
  });

  final double width;
  final double radius;

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(width);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(
      rect.deflate(width / 2.0),
      textDirection: textDirection,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final r = radius;
    final rs = radius / 2;
    final w = rect.size.width;
    final h = rect.size.height;

    return Path()
      ..addPath(
        Path()
          ..moveTo(r, 0)
          ..lineTo(w - r, 0)
          ..arcToPoint(Offset(w, r), radius: Radius.circular(r))
          ..lineTo(w, h - rs)
          ..arcToPoint(Offset(w - r, h), radius: Radius.circular(r))
          ..lineTo(r, h)
          ..arcToPoint(Offset(0, h - r), radius: Radius.circular(r))
          ..lineTo(0, h / 2)
          ..relativeLineTo(-12, -12)
          ..lineTo(0, h / 2 - 10)
          ..lineTo(0, r)
          ..arcToPoint(Offset(r, 0), radius: Radius.circular(r)),
        Offset(rect.left, rect.top),
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black;
    canvas.drawPath(
      getOuterPath(
        rect.deflate(width / 2.0),
        textDirection: textDirection,
      ),
      paint,
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}
