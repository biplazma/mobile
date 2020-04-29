import 'package:circular_check_box/circular_check_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:biplazma/auth_service.dart';
import 'package:biplazma/model/data.dart';
import 'package:biplazma/util/app_textStyles.dart';
import 'package:biplazma/widget/specialButton.dart';
import 'package:biplazma/widget/textFields/phoneNumberWidget.dart';
import 'package:toast/toast.dart';
import 'util/app_colors.dart';
import 'util/helper.dart';
import 'widget/appBar.dart';

class RequestPlasma extends StatefulWidget {
  @override
  _RequestPlasmaState createState() => _RequestPlasmaState();
}

class _RequestPlasmaState extends State<RequestPlasma> {
  List<String> hospital = ["Numune Hastanesi", "Ankara Hastanesi", "Hacettepe Hastanesi"];

  final TextEditingController cityTEController = TextEditingController();
  final TextEditingController countyTEController = TextEditingController();
  final TextEditingController hospitalTEController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  List<CityData> cityData = [];
  List<CountyData> countyData = [];
  List<HospitalData> hospitalData = [];

  String cityValue = '';
  String cityCodeValue = '';
  String countyValue = '';
  String countyCodeValue = '';
  String hospitalValue = '';

  String hospitalDropdownValue = 'Hacettepe Hastanesi';

  bool agreement = false;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    List<CityData> _cityTemp = await getCityData();
    List<CountyData> _countyTemp = await getCountyData();
    List<HospitalData> _hospitalTemp = await getHospitalData();
    setState(() {
      cityData = _cityTemp;
      countyData = _countyTemp;
      hospitalData = _hospitalTemp;
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

  List<String> getHospitalSuggestions(String query) {
    List<String> hospital = List();
    hospitalData.forEach((element) {
      if (countyCodeValue == element.ilceKodu) {
        hospital.add(element.kurum.toString());
      }
    });
    hospital.retainWhere((element) => element.toLowerCase().contains(query.toLowerCase()));
    return hospital;
  }

  @override
  Widget build(BuildContext context) {
    if (cityData.isEmpty && countyData.isEmpty && hospitalData.isEmpty) {
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
        appBar: CustomAppBar(title: 'Plazma Talebi'),
        body: Center(
            child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Visibility(
                visible: !isSuccess,
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Helper.sizedBoxH10,
                        Helper.sizedBoxH20,
                        buildTitle("İl"),
                        Helper.sizedBoxH10,
                        TypeAheadFormField(
                          getImmediateSuggestions: true,
                          itemBuilder: (BuildContext context, itemData) => Card(child: ListTile(title: Text(itemData, style: AppTextStyles.selectTextStyle))),
                          onSuggestionSelected: (suggestion) {
                            this.cityTEController.text = suggestion;
                            this.cityValue = suggestion;
                            this.countyTEController.text = '';
                            this.countyValue = '';
                            this.hospitalTEController.text = '';
                            this.hospitalValue = '';
                            getCityCode(suggestion);
                          },
                          errorBuilder: (context, Object error) => _noFound('İl'),
                          textFieldConfiguration: Helper.appTextFConfig(this.cityTEController, "İl"),
                          noItemsFoundBuilder: (context) => _noFound('İl'),
                          suggestionsCallback: (pattern) => getCitySuggestions(pattern),
                          onSaved: (value) => this.cityValue = value,
                        ),
                        Helper.sizedBoxH20,
                        buildTitle("İlçe"),
                        Helper.sizedBoxH10,
                        TypeAheadFormField(
                          getImmediateSuggestions: true,
                          itemBuilder: (BuildContext context, itemData) => Card(child: ListTile(title: Text(itemData, style: AppTextStyles.selectTextStyle))),
                          onSuggestionSelected: (suggestion) {
                            this.countyTEController.text = suggestion;
                            this.countyValue = suggestion;
                            getCountyCode(suggestion);
                          },
                          errorBuilder: (context, Object error) => _noFound('İlçe'),
                          textFieldConfiguration: Helper.appTextFConfig(this.countyTEController, "İlçe"),
                          noItemsFoundBuilder: (context) => _noFound('İlçe'),
                          suggestionsCallback: (pattern) => getCountySuggestions(pattern),
                          onSaved: (value) => this.countyValue = value,
                        ),
                        Helper.sizedBoxH20,
                        buildTitle("Hastane"),
                        Helper.sizedBoxH10,
                        TypeAheadFormField(
                          getImmediateSuggestions: true,
                          itemBuilder: (BuildContext context, itemData) => Card(child: ListTile(title: Text(itemData, style: AppTextStyles.selectTextStyle))),
                          onSuggestionSelected: (suggestion) {
                            this.hospitalTEController.text = suggestion;
                            this.hospitalValue = suggestion;
                          },
                          errorBuilder: (context, Object error) => _noFound('Hastane'),
                          textFieldConfiguration: Helper.appTextFConfig(this.hospitalTEController, "Hastane"),
                          noItemsFoundBuilder: (context) => _noFound('Hastane'),
                          suggestionsCallback: (pattern) => getHospitalSuggestions(pattern),
                          onSaved: (value) => this.hospitalValue = value,
                        ),
                        Helper.sizedBoxH20,
                        buildTitle("İrtibat No"),
                        Helper.sizedBoxH10,
                        PhoneNumberWidget(
                          phoneNumberController: phoneNumberController,
                        ),
                      ],
                    ),
                    Helper.sizedBoxH20,
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
                        Expanded(child: Text("Girdiğim bilgilerin doğru olduğunu ve irtibat numaramın bağışçılarla paylaşılmasını kabul ediyorum."))
                      ],
                    ),
                    Helper.sizedBoxH20,
                    SpecialButton(
                      text: "Talep Oluştur",
                      color: AppColors.colorPrimary,
                      textColor: Colors.white,
                      width: 280,
                      height: 42,
                      rounded: 20,
                      onPressed: () async {
                        if (cityValue != null && countyValue != null && hospitalValue != null && phoneNumberController.text.length > 0) {
                          if (agreement) {
                            try {
                              FirebaseUser user = await FirebaseAuth.instance.currentUser();
                              authService.updateLastSeen(user);
                              authService.requestPlasm(user, cityValue, countyValue, hospitalValue, agreement);
                              authService.updateRequestCount();
                              setState(() {
                                Helper.setPlasmaRequested(true);
                                isSuccess = true;
                              });
                              Future.delayed(Duration(seconds: 3)).then((value) {
                                Navigator.of(context).pop(true);
                              });
                            } catch (e) {}
                          } else {
                            Toast.show('Girdiğiniz bilgilerin doğru olduğunu ve irtibat numaramın bağışcılarla paylaşılmasını kabul etmediniz.', context,
                                duration: 3);
                          }
                        } else {
                          Toast.show('Tüm alanları doldurmalısınız!', context, duration: 3);
                        }
                      },
                    ),
                    Helper.sizedBoxH10,
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
        )),
      );
    }
  }

  Widget _noFound(String _notFound) => Padding(padding: const EdgeInsets.all(20.0), child: Text("$_notFound Bulunamadı", style: AppTextStyles.h6TextStyle));
  Text buildTitle(String title) => Text(title, style: AppTextStyles.h6TextStyle);
}
