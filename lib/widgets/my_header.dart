import 'package:covidata/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyHeader extends StatefulWidget {
  final String image;
  final double offset;
  final String textTop;
  final String textBottom;
  final String buttonIcon;
  final CrossAxisAlignment buttonAlignment;
  final Function onTap;
  const MyHeader({
    Key key,
    @required this.image,
    @required this.offset,
    this.textTop,
    this.textBottom,
    @required this.buttonIcon,
    @required this.buttonAlignment,
    @required this.onTap,
  }) : super(key: key);

  @override
  _MyHeaderState createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeader> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 50, right: 20),
        height: 350,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF3383CD),
              Color(0xFF11249F),
            ],
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/virus.png"),
          ),
        ),
        child: Column(
          crossAxisAlignment: widget.buttonAlignment,
          children: <Widget>[
            GestureDetector(
              onTap: widget.onTap,
              child: widget.buttonIcon == 'Menu'
                  ? SvgPicture.asset("assets/icons/menu.svg")
                  : Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: (widget.offset < 0) ? 0 : widget.offset,
                    left: 20.0,
                    child: SvgPicture.asset(
                      widget.image,
                      width: 230,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  Positioned(
                    top: 40 - widget.offset / 2,
                    left: 170,
                    child: Text(
                      (widget.textTop ?? '') + '\n' + (widget.textBottom ?? ''),
                      style: kHeadingTextStyle.copyWith(
                        fontSize: 17.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
