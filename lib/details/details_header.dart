import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailsHeader extends StatefulWidget {
  final String heroTag;
  final String image;
  final double offset;
  const DetailsHeader({
    Key key,
    this.heroTag,
    @required this.image,
    @required this.offset,
  }) : super(key: key);

  @override
  _DetailsHeaderState createState() => _DetailsHeaderState();
}

class _DetailsHeaderState extends State<DetailsHeader> {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: (widget.offset < 0) ? 0 : widget.offset + 40,
                    left: 90.0,
                    child: Hero(
                      tag: widget.heroTag,
                      child: SvgPicture.asset(
                        widget.image,
                        width: 180,
                        fit: BoxFit.fitWidth,
                      ),
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
