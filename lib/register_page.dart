import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biplazma/auth_service.dart';
import 'package:biplazma/home_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:biplazma/util/app_colors.dart';
import 'package:biplazma/util/helper.dart';
import 'package:biplazma/widget/appBar.dart';
import 'package:biplazma/widget/bloodWidget.dart';
import 'package:biplazma/widget/slider/customSlider.dart';
import 'package:biplazma/widget/specialButton.dart';
import 'package:biplazma/widget/textFields/phoneNumberWidget.dart';
import 'package:biplazma/widget/textFields/tcnNumberWidget.dart';
import 'package:toast/toast.dart';
import 'util/app_constant.dart';

class RegisterPage extends StatefulWidget {
  final String username;
  final bool isGoogleLogin;

  RegisterPage({Key key, this.username, this.isGoogleLogin}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String phoneNumber;
  String gender = 'Male';
  String bloodGroup = '0 RH -';
  String age = '18';
  double yasSlider = 18;
  bool selectedItem = false;
  Map<String, bool> blood = {
    "0 RH -": true,
    "0 RH +": false,
    "A RH -": false,
    "A RH +": false,
    "B RH -": false,
    "B RH +": false,
    "AB RH -": false,
    "AB RH +": false
  };
  final TextEditingController nameSurnameController = TextEditingController();
  final TextEditingController tcNumberController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  void isGoogleLogin() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    nameSurnameController.text = user.displayName;
  }

  @override
  void initState() {
    super.initState();
    if (widget.isGoogleLogin) {
      isGoogleLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Bilgilerim'),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.10),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Helper.sizedBoxH30,
                Text('Selam ' + widget.username.split(" ")[0] + ",", style: GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.bold)),
                Helper.sizedBoxH10,
                Text('Uygulamayı kullanabilmen için birazcık daha fazla bilgiye ihtiyacımız var...',
                    style: GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.colorSubtitle)),
                Helper.sizedBoxH30,
                Visibility(
                  visible: !widget.isGoogleLogin,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('İsim Soyisim', style: GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.bold)),
                      Helper.sizedBoxH20,
                      TextField(
                        cursorColor: AppColors.colorPrimary,
                        cursorRadius: Radius.circular(20),
                        keyboardType: TextInputType.text,
                        controller: nameSurnameController,
                        style: GoogleFonts.openSans(textStyle: TextStyle(color: AppColors.colorPrimary, fontWeight: FontWeight.bold)),
                        decoration: Helper.appInputDecoration('İsminizi ve soyisminizi giriniz.', false),
                      ),
                      Helper.sizedBoxH20,
                    ],
                  ),
                ),
                Text('T.C. Kimlik No', style: GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.bold)),
                Helper.sizedBoxH20,
                TCNumberFields(tcNumberController: tcNumberController),
                Helper.sizedBoxH20,
                Text('Yaş', style: GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.bold)),
                Helper.sizedBoxH20,
                SliderWidget(),
                Helper.sizedBoxH30,
                Text('Cinsiyet', style: GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.bold)),
                Helper.sizedBoxH10,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                        borderRadius: BorderRadius.circular(50),
                        child: Column(
                          children: <Widget>[
                            SvgPicture.asset(
                              AppConstant.svgMale,
                              height: 94,
                              color: selectedItem ? AppColors.colorSubtitle : AppColors.colorPrimary,
                            ),
                            Text(
                              'Erkek',
                              style: TextStyle(color: selectedItem ? AppColors.colorSubtitle : AppColors.colorPrimary),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            selectedItem = false;
                            gender = 'Male';
                          });
                        }),
                    InkWell(
                        borderRadius: BorderRadius.circular(50),
                        child: Column(
                          children: <Widget>[
                            SvgPicture.asset(
                              AppConstant.svgFemale,
                              height: 94,
                              color: selectedItem ? AppColors.colorPrimary : AppColors.colorSubtitle,
                            ),
                            Text(
                              'Kadın',
                              style: TextStyle(color: selectedItem ? AppColors.colorPrimary : AppColors.colorSubtitle),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            selectedItem = true;
                            gender = 'Female';
                          });
                        }),
                  ],
                ),
                Helper.sizedBoxH20,
                Text('Kan Grubu', style: GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.bold)),
                Helper.sizedBoxH10,
                Container(
                    height: MediaQuery.of(context).size.height * .092,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: blood.length,
                      itemBuilder: (BuildContext context, int index) {
                        return BloodWidget(
                          bloodGroup: blood.keys.toList()[index],
                          onOff: blood.values.toList()[index],
                          onPressed: () {
                            setState(() {
                              blood.forEach((key, value) {
                                blood[key] = key == blood.keys.toList()[index] ? true : false;
                              });
                              bloodGroup = blood.keys.toList()[index];
                            });
                          },
                        );
                      },
                    )),
                Helper.sizedBoxH30,
                Text('Telefon', style: GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.bold)),
                Helper.sizedBoxH10,
                PhoneNumberWidget(
                  phoneNumberController: phoneNumberController,
                ),
                Helper.sizedBoxH30,
                Center(
                  child: SpecialButton(
                    text: "Giriş Yap",
                    color: AppColors.colorPrimary,
                    textColor: Colors.white,
                    width: 280,
                    height: 42,
                    rounded: 20,
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (phoneNumberController.text.length > 0 && tcNumberController.text.length > 0 && nameSurnameController.text.length > 0) {
                        try {
                          FirebaseUser user = await FirebaseAuth.instance.currentUser();
                          authService.updateUserData(
                              user, nameSurnameController.text, age, gender, bloodGroup, phoneNumberController.text, tcNumberController.text);
                          Helper.setRegister(true);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                        } catch (e) {}
                      } else {
                        Toast.show('Tüm alanları doldurmalısınız!', context, duration: 3);
                      }
                    },
                  ),
                ),
                Helper.sizedBoxH20,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
