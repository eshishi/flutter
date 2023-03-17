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
    _chartData = _getChartData();
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
          _getStackedArea100Series(
              dataSource: _chartData,
              xValueMapper: (ExpenseData exp, _) => exp.expenseCategory,
              yValueMapper: (ExpenseData exp, _) => exp.son,
              name: 'ダメダメ',
              color: HexColor('E86262')),
          _getStackedArea100Series(
              dataSource: _chartData,
              xValueMapper: (ExpenseData exp, _) => exp.expenseCategory,
              yValueMapper: (ExpenseData exp, _) => exp.mother,
              name: 'ダメ',
              color: HexColor('DAD44A')),
          _getStackedArea100Series(
              dataSource: _chartData,
              xValueMapper: (ExpenseData exp, _) => exp.expenseCategory,
              yValueMapper: (ExpenseData exp, _) => exp.father,
              name: '素晴らしい',
              color: HexColor('98E37E'),
              markerSettings: const MarkerSettings(isVisible: true)),
        ],
        primaryXAxis: CategoryAxis(),
      ),
    );
  }

  ChartSeries<ExpenseData, String> _getStackedArea100Series({
    required List<ExpenseData> dataSource,
    required String Function(ExpenseData, int) xValueMapper,
    required num Function(ExpenseData, int) yValueMapper,
    required String name,
    required Color color,
    MarkerSettings? markerSettings,
  }) {
    return StackedArea100Series<ExpenseData, String>(
        dataSource: dataSource,
        xValueMapper: xValueMapper,
        yValueMapper: yValueMapper,
        name: name,
        color: color,
        markerSettings:
            markerSettings ?? const MarkerSettings(isVisible: false));
  }

  List<ExpenseData> _getChartData() {
    return [
      ExpenseData('3/11', 23, 45, 84),
      ExpenseData('3/12', 43, 23, 50),
      ExpenseData('3/13', 32, 54, 43),
      ExpenseData('3/14', 56, 18, 43),
      ExpenseData('3/15', 63, 34, 33),
      ExpenseData('3/16', 73, 34, 23),
      ExpenseData('3/17', 83, 24, 13),
    ];
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
