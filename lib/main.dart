import 'package:covidata/constants.dart';
import 'package:covidata/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart';

void main() {
  SyncfusionLicense.registerLicense(
      "NT8mJyc2IWhia31ifWN9Z2FoYmF8YGJ8ampqanNiYmlmamlmanMDHmg7Mj86PzcmIT4mIGpkEzQ+Mjo/fTA8Pg==");
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoviData',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            bodyText2: TextStyle(color: kBodyTextColor),
          )),
      home: HomeScreen(),
    );
  }
}
