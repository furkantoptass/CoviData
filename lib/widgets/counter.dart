import 'package:auto_size_text/auto_size_text.dart';
import 'package:covidata/constants.dart';
import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  final Color color;
  final String number;
  final double fontSize;
  final String title;
  const Counter({
    Key key,
    this.color,
    this.number,
    this.fontSize,
    this.title,
  }) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

var myGroup = AutoSizeGroup();

class _CounterState extends State<Counter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withOpacity(.26),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: widget.color,
                width: 2,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        AutoSizeText(
          widget.number,
          style: TextStyle(
            fontSize: widget.fontSize ?? 40.0,
            color: widget.color,
          ),
          maxLines: 1,
          group: myGroup,
        ),
        AutoSizeText(
          widget.title,
          style: kSubTextStyle,
          maxLines: 1,
        ),
      ],
    );
  }
}
