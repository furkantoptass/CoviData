import 'package:covidata/constants.dart';
import 'package:covidata/details/details_body.dart';
import 'package:covidata/details/details_header.dart';
import 'package:covidata/models/covid19.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final Covid19 data;
  final String countryName;
  final String heroTag;

  DetailsScreen({
    @required this.data,
    @required this.countryName,
    @required this.heroTag,
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DetailsHeader(
              heroTag: widget.heroTag,
              image: "assets/icons/flags/${widget.countryName}.svg",
              offset: offset,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
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
                      child: buildBodyWidget(
                          context: context,
                          data: widget.data,
                          countryName: widget.countryName),
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
