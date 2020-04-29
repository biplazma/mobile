import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:biplazma/util/app_colors.dart';
import 'package:biplazma/util/helper.dart';

class TCNumberFields extends StatefulWidget {
  final TextEditingController tcNumberController;

  const TCNumberFields({Key key, this.tcNumberController}) : super(key: key);
  @override
  _TCNumberFieldsState createState() => _TCNumberFieldsState();
}

class _TCNumberFieldsState extends State<TCNumberFields> {
  var tcNumberMask = new MaskTextInputFormatter(mask: '###########', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return TextField(
        inputFormatters: [tcNumberMask],
        cursorColor: AppColors.colorPrimary,
        controller: widget.tcNumberController,
        cursorRadius: Radius.circular(20),
        keyboardType: TextInputType.number,
        style: GoogleFonts.openSans(textStyle: TextStyle(color: AppColors.colorPrimary, fontWeight: FontWeight.bold)),
        decoration: Helper.appInputDecoration('11 haneli T.C. Kimlik numaranızı giriniz.', false));
  }
}
