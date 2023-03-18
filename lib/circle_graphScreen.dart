// import 'dart:ffi';

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
  num state0Percent = 0;
  num state1Percent = 0;
  num state2Percent = 0;
  DateTime now = DateTime.now();

  @override
  void initState() {
    try {
      super.initState();
      var dateOnly = DateTime(now.year, now.month, now.day);
      // print(now);
      // print(dateOnly);
      var nowUnixTime = dateOnly.millisecondsSinceEpoch;
      // print(nowUnixTime);
      ref
          .child('test/-NQcUOvNQPtZmec-M65n/data')
          .orderByChild('timestamp')
          .startAt(nowUnixTime)
          .once()
          .then((DatabaseEvent event) {
        var snapshot = event.snapshot.children.map((e) => e.value).toList();

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
        setState(() {
          totalValue = state0Count + state1Count + state2Count;
          state0Percent = (state0Count * 100 ~/ totalValue);
          state1Percent = (state1Count * 100 ~/ totalValue);
          state2Percent = (state2Count * 100 ~/ totalValue);
        });

        print('State 0 Count: $state0Count');
        print('State 1 Count: $state1Count');
        print('State 2 Count: $state2Count');
      });

      // for (var element in chartData) {
      //   totalValue += element.count;
      // }
    } catch (e) {
      print(e);
      print('cirecle');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData;
    if (totalValue != 0) {
      chartData = [
        ChartData(HexColor('98E37E'), '素晴らしい  $state0Percent%', state0Count),
        ChartData(HexColor('EFEB7E'), 'ダメ $state1Percent%', state1Count),
        ChartData(HexColor('E77C7C'), 'ダメダメ $state2Percent%', state2Count),
        // ChartData(HexColor('98E37E'), '素晴らしい  10%', state0Count),
        // ChartData(HexColor('EFEB7E'), 'ダメ 13%', state1Count),
        // ChartData(HexColor('E77C7C'), 'ダメダメ 13%', state2Count),
      ];
    } else {
      chartData = [
        // ChartData(HexColor('98E37E'), '素晴らしい  $state0Percent%', state0Count),
        // ChartData(HexColor('EFEB7E'), 'ダメ $state1Percent%', state1Count),
        // ChartData(HexColor('E77C7C'), 'ダメダメ $state2Percent%', state2Count),
        ChartData(HexColor('98E37E'), '読み込み中...', 0),
        ChartData(HexColor('EFEB7E'), '読み込み中...', 0),
        ChartData(HexColor('E77C7C'), '読み込み中...', 0),
      ];
    }

    // final List<ChartData> chartData = [
    //   ChartData(HexColor('98E37E'), '素晴らしい', 120),
    //   ChartData(HexColor('EFEB7E'), 'ダメ', 25),
    //   ChartData(HexColor('E77C7C'), 'ダメダメ', 37),
    // ]; 5032

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
