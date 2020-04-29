import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:biplazma/util/app_colors.dart';

class PhoneNumberWidget extends StatefulWidget {
  final TextEditingController phoneNumberController;

  const PhoneNumberWidget({Key key, this.phoneNumberController}) : super(key: key);

  @override
  _PhoneNumberWidgetState createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<PhoneNumberWidget> {
  @override
  Widget build(BuildContext context) {
    var maskFormatter = new MaskTextInputFormatter(mask: '+90 (5##) ###-##-##', filter: {"#": RegExp(r'[0-9]')});
    return TextField(
      inputFormatters: [maskFormatter],
      cursorColor: AppColors.colorPrimary,
      cursorRadius: Radius.circular(20),
      controller: widget.phoneNumberController,
      keyboardType: TextInputType.phone,
      style: GoogleFonts.openSans(textStyle: TextStyle(color: AppColors.colorPrimary, fontWeight: FontWeight.bold)),
      decoration: InputDecoration(
        focusedBorder: buildOutlineInputBorder(),
        enabledBorder: buildOutlineInputBorder(),
        prefixIcon: Icon(Icons.phone, color: AppColors.colorPrimary),
        hintText: "+90 (5**) *** ** **",
        hintStyle: TextStyle(color: AppColors.colorHint),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder() =>
      OutlineInputBorder(borderRadius: const BorderRadius.all(const Radius.circular(30.0)), borderSide: BorderSide(color: AppColors.colorPrimary));
}
