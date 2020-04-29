import 'package:circular_check_box/circular_check_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:biplazma/auth_service.dart';
import 'package:biplazma/model/data.dart';
import 'package:biplazma/util/app_routes.dart';
import 'package:biplazma/util/app_textStyles.dart';
import 'package:biplazma/widget/specialButton.dart';
import 'package:toast/toast.dart';
import 'util/app_colors.dart';
import 'util/helper.dart';
import 'widget/appBar.dart';

enum Q1 { yes, no }
enum Q2 { yes, no }

class DonatePlasma extends StatefulWidget {
  @override
  _DonatePlasmaState createState() => _DonatePlasmaState();
}

Q1 selectedQ1;
Q2 selectedQ2;

class _DonatePlasmaState extends State<DonatePlasma> {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffD70652), Color(0xffFF025E)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final TextEditingController cityTEController = TextEditingController();
  final TextEditingController countyTEController = TextEditingController();
  List<CityData> cityData = [];
  List<CountyData> countyData = [];

  String cityValue = '';
  String cityCodeValue = '';
  String countyValue = '';
  String countyCodeValue = '';
  bool agreement = false;
  bool isSuccess = false;

  void getData() async {
    List<CityData> _cityTemp = await getCityData();
    List<CountyData> _countyTemp = await getCountyData();
    setState(() {
      cityData = _cityTemp;
      countyData = _countyTemp;
    });
  }

  void getCityCode(String city) async {
    cityData.forEach((element) {
      if (element.il == city) {
        cityCodeValue = element.ilKodu;
        print(cityCodeValue);
      }
    });
  }

  void getCountyCode(String county) async {
    countyData.forEach((element) {
      if (element.ilceAdi == county) {
        countyCodeValue = element.ilceKodu;
        print(countyCodeValue);
      }
    });
  }

  List<String> getCitySuggestions(String query) {
    List<String> city = List();
    cityData.forEach((element) {
      city.add(element.il.toString());
    });
    city.retainWhere((element) => element.toLowerCase().contains(query.toLowerCase()));
    return city;
  }

  List<String> getCountySuggestions(String query) {
    List<String> county = List();
    countyData.forEach((element) {
      if (cityCodeValue == element.ilKodu) {
        county.add(element.ilceAdi.toString());
      }
    });
    county.retainWhere((element) => element.toLowerCase().contains(query.toLowerCase()));
    return county;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (cityData.isEmpty && countyData.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(title: "Yükleniyor"),
        backgroundColor: Colors.white,
        body: Center(
          child: LoadingIndicator(
            indicatorType: Indicator.ballScaleMultiple,
            color: AppColors.colorPrimary,
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: CustomAppBar(title: 'Bağış Yap'),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Visibility(
                  visible: !isSuccess,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildTitle("İl"),
                      Helper.sizedBoxH10,
                      TypeAheadFormField(
                        getImmediateSuggestions: true,
                        itemBuilder: (BuildContext context, itemData) => Card(child: ListTile(title: Text(itemData, style: AppTextStyles.selectTextStyle))),
                        onSuggestionSelected: (suggestion) {
                          cityTEController.text = suggestion;
                          cityValue = suggestion;
                          countyTEController.text = '';
                          countyValue = '';
                          getCityCode(suggestion);
                        },
                        errorBuilder: (context, Object error) => _noFound('İl'),
                        textFieldConfiguration: Helper.appTextFConfig(cityTEController, "İl"),
                        noItemsFoundBuilder: (context) => _noFound('İl'),
                        suggestionsCallback: (pattern) => getCitySuggestions(pattern),
                        onSaved: (value) => cityValue = value,
                      ),
                      Helper.sizedBoxH20,
                      buildTitle("İlçe"),
                      Helper.sizedBoxH10,
                      TypeAheadFormField(
                        getImmediateSuggestions: true,
                        itemBuilder: (BuildContext context, itemData) => Card(child: ListTile(title: Text(itemData, style: AppTextStyles.selectTextStyle))),
                        onSuggestionSelected: (suggestion) {
                          countyTEController.text = suggestion;
                          countyValue = suggestion;
                          getCountyCode(suggestion);
                        },
                        errorBuilder: (context, Object error) => _noFound('İlçe'),
                        textFieldConfiguration: Helper.appTextFConfig(countyTEController, "İlçe"),
                        noItemsFoundBuilder: (context) => _noFound('İlçe'),
                        suggestionsCallback: (pattern) => getCountySuggestions(pattern),
                        onSaved: (value) => countyValue = value,
                      ),
                      Helper.sizedBoxH20,
                      Container(
                        child: Text("COVID-19 enfeksiyonu tanısı aldığınızı gösteren laboratuvar test sonucunuz var mı?",
                            style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                      ),
                      Helper.sizedBoxH20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SpecialButton(
                            text: "Evet",
                            onPressed: () {
                              setState(() {
                                selectedQ1 = Q1.yes;
                              });
                            },
                            textColor: selectedQ1 == Q1.yes ? Colors.white : AppColors.colorPrimary,
                            color: selectedQ1 == Q1.yes ? AppColors.colorPrimary : Colors.white,
                            width: 90,
                            height: 42,
                            rounded: 15,
                          ),
                          Helper.sizedBoxW20,
                          SpecialButton(
                            text: "Hayır",
                            onPressed: () {
                              setState(() {
                                selectedQ1 = Q1.no;
                              });
                            },
                            textColor: selectedQ1 == Q1.no ? Colors.white : AppColors.colorPrimary,
                            color: selectedQ1 == Q1.no ? AppColors.colorPrimary : Colors.white,
                            width: 90,
                            height: 42,
                            rounded: 15,
                          ),
                        ],
                      ),
                      Helper.sizedBoxH50,
                      Container(
                        child: Text("Tedavinizin tamamlandığını (covid-19 testinin negatif olduğu) gösteren test sonucunuz var mı?",
                            style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                      ),
                      Helper.sizedBoxH20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SpecialButton(
                            text: "Evet",
                            onPressed: () {
                              setState(() {
                                selectedQ2 = Q2.yes;
                              });
                            },
                            textColor: selectedQ2 == Q2.yes ? Colors.white : AppColors.colorPrimary,
                            color: selectedQ2 == Q2.yes ? AppColors.colorPrimary : Colors.white,
                            width: 90,
                            height: 42,
                            rounded: 15,
                          ),
                          Helper.sizedBoxW20,
                          SpecialButton(
                            text: "Hayır",
                            onPressed: () {
                              setState(() {
                                selectedQ2 = Q2.no;
                              });
                            },
                            textColor: selectedQ2 == Q2.no ? Colors.white : AppColors.colorPrimary,
                            color: selectedQ2 == Q2.no ? AppColors.colorPrimary : Colors.white,
                            width: 90,
                            height: 42,
                            rounded: 15,
                          ),
                        ],
                      ),
                      Helper.sizedBoxH30,
                      Row(
                        children: <Widget>[
                          CircularCheckBox(
                              value: agreement,
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              inactiveColor: AppColors.colorHint,
                              activeColor: AppColors.colorPrimary,
                              onChanged: (bool x) {
                                setState(() {
                                  agreement = !agreement;
                                });
                              }),
                          Expanded(child: Text("Girdiğim bilgilerin doğru olduğunu kabul ediyorum."))
                        ],
                      ),
                      Helper.sizedBoxH30,
                      Center(
                        child: SpecialButton(
                          text: "Bağış Yap",
                          color: AppColors.colorPrimary,
                          textColor: Colors.white,
                          width: 280,
                          height: 45,
                          rounded: 20,
                          onPressed: () async {
                            if (cityTEController.text.length > 0 && countyTEController.text.length > 0) {
                              if (selectedQ1 == Q1.yes && selectedQ2 == Q2.yes) {
                                if (agreement) {
                                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                                  authService.updateLastSeen(user);
                                  authService.updateDonorCount(user, cityTEController.text, countyTEController.text);
                                  setState(() {
                                    isSuccess = true;
                                  });
                                  Future.delayed(Duration(seconds: 3)).then((value) {
                                    Navigator.of(context).pop();
                                    Navigator.pushNamed(context, AppRoutes.pagePlasmaRequests);
                                  });
                                } else {
                                  Toast.show('Girdiğiniz bilgilerin doğru olduğunu kabul etmediniz.', context, duration: 3);
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Uyarı'),
                                      content: Text('Gerekli şartları sağlamadığınız için plazma bağışı yapamazsınız.'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Tamam'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } else {
                              Toast.show('İl ve İlçe seçmediniz.', context, duration: 3);
                            }
                          },
                        ),
                      ),
                      Helper.sizedBoxH30,
                    ],
                  ),
                ),
                Visibility(
                  visible: isSuccess,
                  child: Column(
                    children: <Widget>[
                      Lottie.asset('assets/json/anim/success.json', width: 300, height: 300),
                      Text(
                        'Talebiniz başarıyla alındı.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}

Widget _noFound(String _notFound) => Padding(padding: const EdgeInsets.all(20.0), child: Text("$_notFound Bulunamadı", style: AppTextStyles.h6TextStyle));
Text buildTitle(String title) => Text(title, style: AppTextStyles.h6TextStyle);
