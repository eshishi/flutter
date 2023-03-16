import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CircleGraphScreen extends StatefulWidget {
  const CircleGraphScreen({Key? key}) : super(key: key);

  @override
  State<CircleGraphScreen> createState() => _CircleGraphScreenState();
}

class _CircleGraphScreenState extends State<CircleGraphScreen> {
  num totalValue = 0;
  final List<ChartData> chartData = [
    ChartData(HexColor('98E37E'), '素晴らしい', 100),
    ChartData(HexColor('EFEB7E'), '普通', 38),
    ChartData(HexColor('E77C7C'), 'ダメ', 34),
  ];
  @override
  void initState() {
    for (var element in chartData) {
      totalValue += element.count;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              isVisible: true,
              title: LegendTitle(
                  text: '今日の状態',
                  textStyle: const TextStyle(
                    fontSize: 24,
                    color: Colors.blue,
                  )),
              position: LegendPosition.bottom,
              borderColor: Colors.black,
              borderWidth: 2,
              backgroundColor: HexColor('FFFFFF'),
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
  final double count;
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
