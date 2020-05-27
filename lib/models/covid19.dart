import 'dart:collection';

import 'package:covidata/utils/utils.dart';

class Covid19 {
  final HashMap<String, List<CountryData>> countryData;

  Covid19({this.countryData});

  factory Covid19.fromJson(Map<String, dynamic> parsedJson) {
    var map = HashMap<String, List<CountryData>>();
    List<CountryData> dataList;
    parsedJson.forEach((key, value) {
      var list = parsedJson[key] as List;
      dataList = list.map((i) => CountryData.fromJson(i)).toList();
      map.putIfAbsent(key, () => dataList);
    });

    return Covid19(countryData: map);
  }
}

class CountryData {
  final String date;
  final int confirmed;
  final int deaths;
  final int recovered;
  final int sick;
  final int todayConfirmed;
  final int todayDeaths;
  final int todayRecovered;

  CountryData({
    this.date,
    this.confirmed,
    this.deaths,
    this.recovered,
    this.sick,
    this.todayConfirmed,
    this.todayDeaths,
    this.todayRecovered,
  });

  String get confirmedText {
    return Utils.numberFormatter.format(confirmed);
  }

  String get deathsText {
    return Utils.numberFormatter.format(deaths);
  }

  String get recoveredText {
    return Utils.numberFormatter.format(recovered);
  }

  String get todayConfirmedText {
    return Utils.numberFormatter.format(todayConfirmed);
  }

  String get todayDeathsText {
    return Utils.numberFormatter.format(todayDeaths);
  }

  String get todayRecoveredText {
    return Utils.numberFormatter.format(todayRecovered);
  }

  double get fatalityRate {
    return (deaths.toDouble() / confirmed.toDouble()) * 100;
  }

  String get fatalityRateText {
    return "${fatalityRate.toStringAsFixed(2)}%";
  }

  double get recoveryRate {
    return (recovered.toDouble() / confirmed.toDouble()) * 100;
  }

  String get recoveryRateText {
    return "${recoveryRate.toStringAsFixed(2)}%";
  }

  double get sickRate {
    return (sick.toDouble() / confirmed.toDouble()) * 100;
  }

  String get sickText {
    return Utils.numberFormatter.format(sick);
  }

  factory CountryData.fromJson(Map<String, dynamic> parsedJson) {
    return CountryData(
      date: parsedJson['date'],
      confirmed: parsedJson['confirmed'],
      deaths: parsedJson['deaths'],
      recovered: parsedJson['recovered'],
      sick: parsedJson['sick'],
      todayConfirmed: parsedJson['todayConfirmed'],
      todayDeaths: parsedJson['todayDeaths'],
      todayRecovered: parsedJson['todayRecovered'],
    );
  }
}
