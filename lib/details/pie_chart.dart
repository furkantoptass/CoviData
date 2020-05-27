import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'indicator.dart';

class PieChartSample2 extends StatefulWidget {
  final int confirmed;
  final int sick;
  final int recovered;
  final int deaths;

  const PieChartSample2({
    Key key,
    @required this.confirmed,
    @required this.sick,
    @required this.recovered,
    @required this.deaths,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex;
  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 20 : 15;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: kRecoveredColor,
            value: widget.recovered.toDouble(),
            title:
                '%${(widget.recovered / widget.confirmed * 100).toStringAsFixed(1)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: kSickColor,
            value: widget.sick.toDouble(),
            title:
                '%${(widget.sick / widget.confirmed * 100).toStringAsFixed(1)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 2:
          return PieChartSectionData(
            color: kDeathsColor,
            value: widget.deaths.toDouble(),
            title:
                '%${(widget.deaths / widget.confirmed * 100).toStringAsFixed(1)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        default:
          return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData:
                          PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                            touchedIndex = -1;
                          } else {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections()),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                  color: kSickColor,
                  text: 'Aktif Hasta',
                  isSquare: false,
                ),
                const SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: kDeathsColor,
                  text: 'Ölüm',
                  isSquare: false,
                ),
                const SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: kRecoveredColor,
                  text: 'İyileşen',
                  isSquare: false,
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
