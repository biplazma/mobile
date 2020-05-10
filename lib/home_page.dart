import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biplazma/auth_service.dart';
import 'package:biplazma/settings_page.dart';
import 'package:biplazma/util/app_colors.dart';
import 'package:biplazma/util/app_constant.dart';
import 'package:biplazma/util/helper.dart';
import 'util/app_routes.dart';
import 'util/app_textStyles.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Firestore firestore = Firestore.instance;
  String userName;

  Future<List<dynamic>> getStatistics() async {
    var firestore = Firestore.instance;

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userData = await firestore.collection("users").document(user.uid).get();
    userName = userData.data['firstName'];

    AppConstant.isPlasmaRequested = userData.data['isPlasmaRequested'];
    AppConstant.donateAgreement = userData.data['donateAgreement'];

    authService.updateLastSeen(user);

    QuerySnapshot qn = await firestore.collection('statistics').getDocuments();

    return qn.documents;
  }

  @override
  void initState() {
    super.initState();
    getStatistics();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light, statusBarColor: Colors.transparent));
    return Scaffold(
      appBar: buildAppBar(context),
      extendBodyBehindAppBar: true,
      body: buildBody(context),
    );
  }

  DoubleBackToCloseApp buildBody(BuildContext context) {
    return DoubleBackToCloseApp(
      snackBar: SnackBar(content: Text('Çıkmak için tekrar basın')),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.linearGradient),
            child: FutureBuilder(
              future: getStatistics(),
              builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 5,
                    ));
                  default:
                    if (snapshot.hasError) {
                      return Text(snapshot.error);
                    } else if (snapshot.data.length == 0 || snapshot.data == null) {
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.inbox, size: 50, color: Colors.black26),
                            Text("Veri yok !", style: Theme.of(context).textTheme.headline5),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(userName + ',', style: AppTextStyles.titleStyle),
                                Helper.sizedBoxH10,
                                Text(Helper.getGreetingForCurrentTime(), style: AppTextStyles.titleStyle),
                                Helper.sizedBoxH100,
                                Text('Şuan', style: AppTextStyles.subtitleStyle),
                                Helper.sizedBoxH10,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    buildDonorContainer('Bağışçı', snapshot.data[0].data['donorCount'].toString()),
                                    Helper.sizedBoxW10,
                                    buildDonorContainer('Plazma Bekleyen', snapshot.data[0].data['requestCount'].toString()),
                                  ],
                                ),
                                Helper.sizedBoxH10,
                                Align(alignment: Alignment.centerRight, child: Text('kişi var.', style: AppTextStyles.subtitleStyle)),
                                Helper.sizedBoxH50,
                                Visibility(
                                    visible: !AppConstant.isPlasmaRequested,
                                    child: buildButton('Plazma Bağışla', () {
                                      if (AppConstant.donateAgreement != null && AppConstant.donateAgreement) {
                                        Navigator.pushNamed(context, AppRoutes.pagePlasmaRequests);
                                      } else {
                                        Navigator.pushNamed(context, AppRoutes.pageDonatePlasma);
                                      }
                                    })),
                                Helper.sizedBoxH20,
                                buildButton('Plazma Talebi Oluştur', () {
                                  if (!AppConstant.isPlasmaRequested) {
                                    Navigator.pushNamed(context, AppRoutes.pageRequestPlasma).then((value) {
                                      if (value == true) {
                                        setState(() {});
                                      }
                                    });
                                  } else {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Uyarı!'),
                                            content: Text('Plazma talebiniz sistemde bulunuyor. Tekrar oluşturmanıza gerek yok.'),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Tamam'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                }),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Container buildButton(String buttonTitle, Function onPressed) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        color: Colors.white,
        elevation: 10,
        shape: StadiumBorder(),
        onPressed: onPressed,
        child: Text(buttonTitle, style: AppTextStyles.buttonTextStyle),
      ),
    );
  }

  Expanded buildDonorContainer(String title, String subtitle) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.opacity20White, borderRadius: _borderRadius10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text(title, style: AppTextStyles.containerTextStyle), Text(subtitle, style: AppTextStyles.titleStyle)],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(title: Text('BiPlazma'), centerTitle: false, elevation: 0, backgroundColor: Colors.transparent, actions: <Widget>[
      IconButton(icon: buildSettingsIcon(), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())))
    ]);
  }

  BorderRadius get _borderRadius10 => BorderRadius.all(Radius.circular(10));
  Icon buildSettingsIcon() => Icon(Icons.settings, color: Colors.white);
}
