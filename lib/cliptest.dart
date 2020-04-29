import 'package:flutter/material.dart';

import 'widget/painter/painter4.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: CustomPaint(
            painter: Screen4Painter(),
            child: Container(
              child: Center(child: Text("TEST")),
            ),
          ),
        ),
      ),
    );
  }
}
