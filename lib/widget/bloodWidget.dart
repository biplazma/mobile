import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:biplazma/util/app_colors.dart';

class BloodWidget extends StatefulWidget {
  final String bloodGroup;
  final bool onOff;
  final GestureTapCallback onPressed;
  const BloodWidget({Key key, @required this.bloodGroup, @required this.onOff, @required this.onPressed}) : super(key: key);
  @override
  _BloodWidgetState createState() => _BloodWidgetState();
}

class _BloodWidgetState extends State<BloodWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(11.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            color: widget.onOff ? AppColors.colorPrimary : Colors.white,
            child: InkWell(
              splashColor: widget.onOff ? AppColors.colorPrimary : Colors.white,
              borderRadius: BorderRadius.circular(50),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(25),
                color: AppColors.colorPrimary,
                strokeWidth: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                  child: Center(
                    child: Text(
                      widget.bloodGroup,
                      style: GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.bold, color: widget.onOff ? Colors.white : AppColors.colorPrimary),
                    ),
                  ),
                ),
              ),
              onTap: widget.onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
