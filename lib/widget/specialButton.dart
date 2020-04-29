import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecialButton extends StatelessWidget {
  SpecialButton({this.text, this.onPressed, this.color, this.textColor, this.height, this.width, this.rounded});
  final String text;
  final Function onPressed;
  final Color textColor;
  final Color color;
  final double width, height, rounded;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rounded),
      ),
      constraints: BoxConstraints.tightFor(width: width, height: height),
      fillColor: color,
      child: Text(
        text,
        style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
      ),
      elevation: 2.0,
    );
  }
}
