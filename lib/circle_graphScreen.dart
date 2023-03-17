import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_database/firebase_database.dart';

class CircleGraphScreen extends StatefulWidget {
  const CircleGraphScreen({Key? key}) : super(key: key);

  @override
  State<CircleGraphScreen> createState() => _CircleGraphScreenState();
}

class _CircleGraphScreenState extends State<CircleGraphScreen> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  num state0Count = 0;
  num state1Count = 0;
  num state2Count = 0;
  num totalValue = 0;
  DateTime today = DateTime.now();

  @override
  void initState() {
    try {
      super.initState();
      ref
          .child('test/-NQcUOvNQPtZmec-M65n/data')
          .once()
          .then((DatabaseEvent event) {
        var snapshot = event.snapshot.children.map((e) => e.value).toList();
        var j = snapshot[0].toString();
        String timeStr = '';
        for (int i = 22; i < 35; i++) {
          timeStr += j[i];
        }
        print(timeStr);
        // print(j[22]);
        // print(j[34]);
        for (var snap in snapshot) {
          var a = snap.toString();
          if (a[8] == '0') {
            setState(() {
              state0Count += 1;
            });
          } else if (a[8] == '1') {
            setState(() {
              state1Count += 1;
            });
          } else {
            setState(() {
              state2Count += 1;
            });
          }
        }

        print('State 0 Count: $state0Count');
        print('State 1 Count: $state1Count');
        print('State 2 Count: $state2Count');
      });

      // for (var element in chartData) {
      //   totalValue += element.count;
      // }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(HexColor('98E37E'), '素晴らしい', state0Count),
      ChartData(HexColor('EFEB7E'), 'ダメ', state1Count),
      ChartData(HexColor('E77C7C'), 'ダメダメ', state2Count),
    ];

    // final List<ChartData> chartData = [
    //   ChartData(HexColor('98E37E'), '素晴らしい', 120),
    //   ChartData(HexColor('EFEB7E'), 'ダメ', 25),
    //   ChartData(HexColor('E77C7C'), 'ダメダメ', 37),
    // ];

    return Scaffold(
      body: Center(
        child: Container(
          //下に空白
          padding: const EdgeInsets.only(bottom: 32),
          //背景画像
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/R30％.png'),
              fit: BoxFit.cover,
            ),
          ),
          //グラフ本体
          child: SfCircularChart(
            series: <CircularSeries>[
              PieSeries<ChartData, String>(
                enableTooltip: true,
                dataSource: chartData,
                pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (ChartData data, _) => data.status,
                yValueMapper: (ChartData data, _) => data.count,
              )
            ],
            //下の状態の名前の部分
            legend: Legend(
              height: '220',
              isVisible: true,
              title: LegendTitle(
                  text: '今日の状態',
                  textStyle: const TextStyle(
                    fontSize: 24,
                    color: Colors.blue,
                  )),
              padding: 40,
              textStyle: TextStyle(fontSize: 24),
              iconHeight: 33,
              iconWidth: 20,
              position: LegendPosition.bottom,
              borderColor: Colors.black,
              borderWidth: 2,
              backgroundColor: HexColor('FFFFFF'),
              orientation: LegendItemOrientation.vertical, // 縦に表示
            ),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.color, this.status, this.count);
  final Color color;
  final String status;
  final num count;
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
