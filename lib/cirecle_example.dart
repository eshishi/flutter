import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<CatChartData> chartData;
  num totalValue = 0;
  @override
  void initState() {
    chartData = [
      CatChartData('Persian', 15000),
      CatChartData('Munchkin', 25000),
      CatChartData('Billy', 5000),
      CatChartData('Scottish fold', 50000),
      CatChartData('Himalayan', 10000),
    ];
    for (var element in chartData) {
      totalValue += element.total;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SfCircularChart(
          legend: Legend(
            overflowMode: LegendItemOverflowMode.wrap,
            isVisible: true,
            legendItemBuilder: (String legendText, dynamic series,
                dynamic point, int seriesIndex) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 125,
                  child: Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: series.renderPoints[point.index].color,
                        ),
                        margin: const EdgeInsets.only(right: 8.0),
                      ),
                      Text(
                        '$legendText ${(point.y / (totalValue / 100)).round()}%',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          series: [
            PieSeries<CatChartData, String>(
                animationDuration: 700,
                dataSource: chartData,
                radius: '50%',
                explode: true,
                explodeGesture: ActivationMode.singleTap,
                xValueMapper: (CatChartData data, _) => data.category,
                yValueMapper: (CatChartData data, _) => data.total,
                dataLabelMapper: (CatChartData data, _) => data.category,
                sortingOrder: SortingOrder.descending,
                legendIconType: LegendIconType.circle,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  builder: (dynamic data, dynamic point, dynamic series,
                      int pointIndex, int seriesIndex) {
                    return Text(
                      data.category +
                          ' ${(data.total / (totalValue / 100)).round()}' +
                          '%',
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                  connectorLineSettings:
                      const ConnectorLineSettings(type: ConnectorType.curve),
                  overflowMode: OverflowMode.shift,
                  showZeroValue: false,
                  labelPosition: ChartDataLabelPosition.outside,
                ))
          ]),
    );
  }
}

class CatChartData {
  CatChartData(this.category, this.total);
  final String category;
  final num total;
}
