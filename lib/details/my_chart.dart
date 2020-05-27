import 'package:covidata/models/chart_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyChart extends StatelessWidget {
  final String text;
  final String seriesType;
  final List<LineSeries<ChartData, DateTime>> series;
  final List<ColumnSeries<ChartData, DateTime>> columnSeries;

  const MyChart({this.text, this.seriesType, this.series, this.columnSeries});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.bottom,
        ),
        primaryXAxis: DateTimeAxis(
          intervalType: DateTimeIntervalType.auto,
          dateFormat: DateFormat.MMMd(),
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(color: Colors.transparent),
          title: AxisTitle(
            text: text,
            textStyle: ChartTextStyle(),
          ),
        ),
        series: seriesType == null ? series : columnSeries,
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }
}
