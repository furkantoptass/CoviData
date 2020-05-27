import 'package:covidata/apis/corona_service.dart';
import 'package:covidata/constants.dart';
import 'package:covidata/details/details_screen.dart';
import 'package:covidata/info/info_screen.dart';
import 'package:covidata/models/index.dart';
import 'package:covidata/widgets/counter.dart';
import 'package:covidata/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  double offset = 0;

  var service = CoronaService.instance;
  Future<Covid19> _dataFuture;
  Covid19 _data;
  String _dropdownValue = 'Türkiye';

  _fetchData() {
    _dataFuture = service.fetchCovidData();
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  Widget _buildCounterWidget(BuildContext context) {
    return FutureBuilder(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.error != null) {
          print(snapshot.error);
          return Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Center(
              child: const Text('Veriler alınırken bir hata oluştu.'),
            ),
          );
        } else {
          if (_data == null) _data = snapshot.data;
          final Covid19 _todaysUpdate = snapshot.data;
          final CountryData _countryData =
              _todaysUpdate.countryData[kCountries[_dropdownValue]].last;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Counter(
                  color: kInfectedColor,
                  number: _countryData.todayConfirmedText,
                  fontSize: _dropdownValue == 'Tüm Dünya' ? 32.0 : null,
                  title: "Vaka",
                ),
              ),
              Expanded(
                child: Counter(
                  color: kDeathsColor,
                  number: _countryData.todayDeathsText,
                  title: "Ölüm",
                ),
              ),
              Expanded(
                child: Counter(
                  color: kRecoveredColor,
                  number: _countryData.todayRecoveredText,
                  title: "İyileşen",
                ),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "Tek yapman gereken",
              textBottom: "evde kalmak.",
              offset: offset,
              buttonIcon: 'Menu',
              buttonAlignment: CrossAxisAlignment.end,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return InfoScreen();
                    },
                  ),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color(0xFFE5E5E5),
                ),
              ),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                  const SizedBox(width: 20),
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                      value: _dropdownValue,
                      items: kCountries.keys
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              Hero(
                                tag: value,
                                child: SvgPicture.asset(
                                  'assets/icons/flags/${kCountries[value]}.svg',
                                  height: 24.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontWeight: _dropdownValue == value
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: _dropdownValue == value
                                        ? kPrimaryColor
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (_dropdownValue != newValue)
                          setState(() {
                            _dropdownValue = newValue;
                            _buildCounterWidget(context);
                          });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Bugünkü Durum\n",
                              style: kTitleTextstyle,
                            ),
                            TextSpan(
                              text:
                                  "En son güncelleme: ${DateFormat('d MMM HH:mm').format(DateTime.now())}",
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      RaisedButton(
                        // TODO: Veriler yüklenirken butonu devredışı bırak
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DetailsScreen(
                                  data: _data,
                                  heroTag: _dropdownValue,
                                  countryName: kCountries[_dropdownValue],
                                );
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Detayları gör",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        color: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: _buildCounterWidget(context),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Virüsün Yayılımı",
                        style: kTitleTextstyle,
                      ),

                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(20),
                    height: 178,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/map.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
