import 'package:covidata/constants.dart';
import 'package:covidata/details/my_chart.dart';
import 'package:covidata/details/pie_chart.dart';
import 'package:covidata/models/index.dart';
import 'package:covidata/widgets/counter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Widget buildBodyWidget(
    {BuildContext context, Covid19 data, String countryName}) {
  var _countryData = data.countryData[countryName].last;
  List<PieSeries<ChartData, String>> getPieSeries() {
    final List<ChartData> _chartData = <ChartData>[
      ChartData(
          x: 'Vaka',
          y: _countryData.confirmed,
          text: '1,234',
          pointColor: kInfectedColor),
      ChartData(
          x: 'Ölüm',
          y: _countryData.deaths,
          text: '1,234',
          pointColor: kDeathsColor),
      ChartData(
          x: 'İyileşen',
          y: _countryData.recovered,
          text: '1,234',
          pointColor: kRecoveredColor),
    ];
    return <PieSeries<ChartData, String>>[
      PieSeries<ChartData, String>(
        animationDuration: 1500,
        dataSource: _chartData,
        radius: '100%',
        explode: true,
        explodeOffset: '10%',
        startAngle: 180,
        endAngle: 180,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        pointColorMapper: (ChartData data, _) => data.pointColor,
        selectionSettings: SelectionSettings(
          enable: true,
          unselectedOpacity: 0.5,
        ),
      ),
    ];
  }

  List<ChartData> getColumnChartData() {
    final List<ChartData> _chartData = <ChartData>[];
    var value = data.countryData[countryName];
    value.forEach((element) {
      if (element.confirmed > 0) {
        _chartData.add(
          ChartData(
              x: DateFormat("yyyy-MM-dd").parse(element.date),
              y: element.todayConfirmed),
        );
      }
    });

    return _chartData;
  }

  List<ChartData> getLineChartData(StatsType statsType) {
    final List<ChartData> _chartData = <ChartData>[];
    var value = data.countryData[countryName];
    value.forEach((element) {
      if (element.confirmed > 0) {
        _chartData.add(ChartData(
            x: DateFormat("yyyy-MM-dd").parse(element.date),
            y: statsType == StatsType.confirmed
                ? element.confirmed
                : statsType == StatsType.deaths
                    ? element.deaths
                    : statsType == StatsType.recovered
                        ? element.recovered
                        : statsType == StatsType.sick
                            ? element.sick
                            : element.confirmed));
      }
    });

    return _chartData;
  }

  List<LineSeries<ChartData, DateTime>> getLineSeries() {
    final List<ChartData> _chartDataConfirmed =
        getLineChartData(StatsType.confirmed);
    final List<ChartData> _chartDataSick = getLineChartData(StatsType.sick);
    final List<ChartData> _chartDataDeaths = getLineChartData(StatsType.deaths);
    final List<ChartData> _chartDataRecovered =
        getLineChartData(StatsType.recovered);

    return <LineSeries<ChartData, DateTime>>[
      LineSeries<ChartData, DateTime>(
        color: kInfectedColor,
        animationDuration: 1500,
        enableTooltip: true,
        dataSource: _chartDataConfirmed,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        width: 5,
        name: 'Vaka',
      ),
      LineSeries<ChartData, DateTime>(
        color: kPrimaryColor,
        animationDuration: 1500,
        enableTooltip: true,
        dataSource: _chartDataSick,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        width: 5,
        name: 'Aktif Hasta',
      ),
      LineSeries<ChartData, DateTime>(
        color: kDeathsColor,
        animationDuration: 1500,
        enableTooltip: true,
        dataSource: _chartDataDeaths,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        width: 5,
        name: 'Ölüm',
      ),
      LineSeries<ChartData, DateTime>(
        color: kRecoveredColor,
        animationDuration: 1500,
        enableTooltip: true,
        dataSource: _chartDataRecovered,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        width: 5,
        name: 'İyileşen',
      ),
    ];
  }

  List<ColumnSeries<ChartData, DateTime>> getColumnSeries() {
    final List<ChartData> _chartData = getColumnChartData();

    return <ColumnSeries<ChartData, DateTime>>[
      ColumnSeries<ChartData, DateTime>(
        color: kInfectedColor,
        animationDuration: 1500,
        enableTooltip: true,
        dataSource: _chartData,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        width: 1,
        name: 'Yeni Vaka',
      ),
    ];
  }

  return Column(
    children: <Widget>[
      MyPieChart(
        confirmed: _countryData.confirmed,
        sick: _countryData.sick,
        recovered: _countryData.recovered,
        deaths: _countryData.deaths,
      ),
      const SizedBox(height: 10.0),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Counter(
                  color: kInfectedColor,
                  number: _countryData.confirmedText,
                  title: "Vaka",
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Counter(
                  color: kDeathsColor,
                  number: _countryData.deathsText,
                  title: "Ölüm",
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Counter(
                  color: kRecoveredColor,
                  number: _countryData.recoveredText,
                  title: "İyileşen",
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 10.0),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Counter(
                  color: kSickColor,
                  number: _countryData.sickText,
                  title: "Aktif Hasta",
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Counter(
                  color: kDeathsColor,
                  number: _countryData.fatalityRateText,
                  title: "Ölüm Oranı",
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Counter(
                  color: kRecoveredColor,
                  number: _countryData.recoveryRateText,
                  title: "İyileşme Oranı",
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 20.0),
      MyChart(
        text: 'Toplam',
        series: getLineSeries(),
      ),
      SizedBox(height: 20.0),
      MyChart(
        text: 'Günlük Yeni Vaka Sayısı',
        seriesType: 'column',
        columnSeries: getColumnSeries(),
      ),
      SizedBox(height: 30.0),
    ],
  );
}
