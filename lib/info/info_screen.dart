import 'package:covidata/constants.dart';
import 'package:covidata/info/prevent_card.dart';
import 'package:covidata/info/symptom_card.dart';
import 'package:covidata/widgets/my_header.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
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
            MyHeader(
              image: "assets/icons/coronadr.svg",
              textTop: "Covid-19 hakkında",
              textBottom: "bilgi sahibi ol.",
              offset: offset,
              buttonIcon: 'Back',
              buttonAlignment: CrossAxisAlignment.start,
              onTap: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Semptomlar",
                    style: kTitleTextstyle,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SymptomCard(
                        image: "assets/images/headache.png",
                        title: "Baş ağrısı",
                      ),
                      SymptomCard(
                        image: "assets/images/cough.png",
                        title: "Öksürme",
                      ),
                      SymptomCard(
                        image: "assets/images/fever.png",
                        title: "Ateş",
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("Korunma", style: kTitleTextstyle),
                  SizedBox(height: 20),
                  PreventCard(
                    text:
                        "Dışarıya çıkman gerektiğinde mutlaka maske kullan. Daha önce kullandığın maskeyi bir daha kullanma.",
                    image: "assets/images/wear_mask.png",
                    title: "Maske tak",
                  ),
                  PreventCard(
                    text:
                        "Ellerini en az 20-30 saniye boyunca sabunla yıka. En az %60 alkollü el dezenfektanı da kullanabilirsin.",
                    image: "assets/images/wash_hands.png",
                    title: "Ellerini yıka",
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
