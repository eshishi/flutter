import 'package:flutter/material.dart';
import 'package:flutter_study/my_appbar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AreaGraph extends StatefulWidget {
  const AreaGraph({Key? key}) : super(key: key);

  @override
  _AreaGraphState createState() => _AreaGraphState();
}

class _AreaGraphState extends State<AreaGraph> {
  late List<ExpenseData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCartesianChart(
        legend: Legend(isVisible: true),
        tooltipBehavior: _tooltipBehavior,
        series: <ChartSeries>[
          StackedArea100Series<ExpenseData, String>(
              dataSource: _chartData,
              xValueMapper: (ExpenseData exp, _) => exp.expenseCategory,
              yValueMapper: (ExpenseData exp, _) => exp.son,
              name: 'ダメ',
              color: HexColor('E86262'),
              markerSettings: const MarkerSettings(
                isVisible: true,
              )),
          StackedArea100Series<ExpenseData, String>(
              dataSource: _chartData,
              xValueMapper: (ExpenseData exp, _) => exp.expenseCategory,
              yValueMapper: (ExpenseData exp, _) => exp.mother,
              name: '普通',
              color: HexColor('DAD44A'),
              markerSettings: const MarkerSettings(
                isVisible: true,
              )),
          StackedArea100Series<ExpenseData, String>(
              dataSource: _chartData,
              xValueMapper: (ExpenseData exp, _) => exp.expenseCategory,
              yValueMapper: (ExpenseData exp, _) => exp.father,
              name: '素晴らしい',
              color: HexColor('98E37E'),
              markerSettings: const MarkerSettings(
                //点のやつを表示するか
                isVisible: true,
              )),
        ],
        primaryXAxis: CategoryAxis(),
      ),
    );
  }

  List<ExpenseData> getChartData() {
    final List<ExpenseData> chartData = [
      ExpenseData('3/8', 100, 40, 45),
      ExpenseData('3/9', 33, 45, 54),
      ExpenseData('3/10', 43, 23, 20),
      ExpenseData('3/11', 32, 54, 23),
      ExpenseData('3/12', 56, 18, 43),
      ExpenseData('3/13', 23, 54, 33),
    ];
    return chartData;
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

class ExpenseData {
  ExpenseData(this.expenseCategory, this.father, this.mother, this.son);
  final String expenseCategory;
  final num father;
  final num mother;
  final num son;
}
