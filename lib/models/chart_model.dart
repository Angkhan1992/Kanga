import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class LinearSales {
  final int timeLevel;
  final double value;

  LinearSales(this.timeLevel, this.value);
}

List<charts.Series<LinearSales, int>> createLineChartData(
    String title, List<List<LinearSales>> data) {
  List<charts.Series<LinearSales, int>> result = [];
  for (var item in data) {
    charts.Color barColor;
    switch (data.indexOf(item)) {
      case 1:
        barColor = charts.MaterialPalette.yellow.shadeDefault;
        break;
      case 2:
        barColor = charts.MaterialPalette.purple.shadeDefault;
        break;
      case 3:
        barColor = charts.MaterialPalette.blue.shadeDefault;
        break;
      case 4:
        barColor = charts.MaterialPalette.green.shadeDefault;
        break;
      case 5:
        barColor = charts.MaterialPalette.deepOrange.shadeDefault;
        break;
      case 6:
        barColor = charts.MaterialPalette.red.shadeDefault;
        break;
      default:
        barColor = charts.MaterialPalette.pink.shadeDefault;
        break;
    }

    var resultItem = charts.Series<LinearSales, int>(
      id: title,
      colorFn: (_, __) => barColor,
      domainFn: (LinearSales sales, _) => sales.timeLevel,
      measureFn: (LinearSales sales, _) => sales.value,
      data: item,
    );
    result.add(resultItem);
  }
  return result;
}

class SimpleLineChart extends StatelessWidget {
  final List<charts.Series<dynamic, num>> seriesList;
  final bool? animate;
  final charts.NumericExtents range;

  SimpleLineChart(
    this.seriesList, {
    this.animate,
    this.range = const charts.NumericExtents(-2.0, 2.0),
  });

  @override
  Widget build(BuildContext context) {
    var domainAxis = charts.NumericAxisSpec(
      renderSpec: charts.GridlineRendererSpec(
        labelStyle: charts.TextStyleSpec(
            fontSize: 10, color: charts.MaterialPalette.white),
      ),
      showAxisLine: true,
    );
    var primaryAxis = charts.NumericAxisSpec(
      // viewport: charts.NumericExtents.unbounded,
      renderSpec: charts.GridlineRendererSpec(
        labelStyle: charts.TextStyleSpec(
            fontSize: 10, color: charts.MaterialPalette.white),
      ),
      viewport: range,
    );
    return new charts.LineChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis: primaryAxis,
      domainAxis: domainAxis,
    );
  }
}

class TimeSeriesSales {
  final DateTime time;
  final double value;

  TimeSeriesSales(this.time, this.value);

  static TimeSeriesSales? getValueFromTime(
      List<TimeSeriesSales> data, DateTime dateTime) {
    for (var item in data) {
      if (item.time == dateTime) {
        return item;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      "time": this.time.toIso8601String(),
      "value": this.value,
    };
  }
}

List<charts.Series<TimeSeriesSales, DateTime>> createSelectionChartData(
    String title, List<List<TimeSeriesSales>> data) {
  List<charts.Series<TimeSeriesSales, DateTime>> result = [];
  for (var item in data) {
    charts.Color barColor = charts.MaterialPalette.green.shadeDefault;
    if (data.indexOf(item) == 1) {
      barColor = charts.MaterialPalette.yellow.shadeDefault;
    }

    var resultItem = charts.Series<TimeSeriesSales, DateTime>(
      id: title,
      colorFn: (_, __) => barColor,
      domainFn: (TimeSeriesSales sales, _) => sales.time,
      measureFn: (TimeSeriesSales sales, _) => sales.value,
      data: item,
    );
    result.add(resultItem);
  }
  return result;
}

class SelectionChart extends StatelessWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final Function(charts.SelectionModel model) onSelection;

  const SelectionChart({
    Key? key,
    required this.seriesList,
    required this.onSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: true,
      selectionModels: [
        new charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: onSelection,
        )
      ],
    );
  }
}
