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

  @override
  void initState() {
    super.initState();
    getStatistics();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light, statusBarColor: Colors.transparent));
    return Scaffold(
      appBar: _buildAppBar,
      extendBodyBehindAppBar: true,
      body: _buildBody,
    );
  }

  DoubleBackToCloseApp get _buildBody {
    return DoubleBackToCloseApp(
      snackBar: SnackBar(content: Text(AppConstant.homeSnackBar)),
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
                    return Helper.buildLoadingIndicator;
                  default:
                    if (snapshot.hasError)
                      return Text(snapshot.error);
                    else if (snapshot.data.length == 0 || snapshot.data == null)
                      return _buildNoData;
                    else
                      return buildData(snapshot);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Center buildData(AsyncSnapshot<List> snapshot) {
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
              Text(AppConstant.now, style: AppTextStyles.subtitleStyle),
              Helper.sizedBoxH10,
              buildPlasmaData(snapshot),
              Helper.sizedBoxH10,
              Align(alignment: Alignment.centerRight, child: Text('kişi var.', style: AppTextStyles.subtitleStyle)),
              Helper.sizedBoxH50,
              Visibility(visible: !AppConstant.isPlasmaRequested, child: buildButton(AppConstant.donatePlasma, donatePlasmaFunc)),
              Helper.sizedBoxH20,
              buildButton(AppConstant.createRequestPlasma, createRequestPlasmaFunc),
            ],
          ),
        ),
      ),
    );
  }

  Row buildPlasmaData(AsyncSnapshot<List> snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        buildDonorContainer(AppConstant.donation, snapshot.data[0].data['donorCount'].toString()),
        Helper.sizedBoxW10,
        buildDonorContainer(AppConstant.requestPlasma, snapshot.data[0].data['requestCount'].toString()),
      ],
    );
  }

  Expanded get _buildNoData {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Icon(Icons.inbox, size: 50, color: Colors.white), Text(AppConstant.noData, style: AppTextStyles.subtitleStyle)],
      ),
    );
  }

  Container buildButton(String buttonTitle, Function onPressed) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        color: Colors.white,
        elevation: ,
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
        child: Center(child: Column(children: <Widget>[Text(title, style: AppTextStyles.containerTextStyle), Text(subtitle, style: AppTextStyles.titleStyle)])),
      ),
    );
  }

  AppBar get _buildAppBar {
    return AppBar(title: Text('BiPlazma'), centerTitle: false, elevation: 0, backgroundColor: Colors.transparent, actions: <Widget>[
      IconButton(icon: buildSettingsIcon(), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())))
    ]);
  }

  AlertDialog get _buildAlertDialog {
    return AlertDialog(
      title: Text(AppConstant.alertTitle),
      content: Text(AppConstant.alertDescription),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actions: <Widget>[FlatButton(child: Text(AppConstant.ok), onPressed: () => Navigator.of(context).pop())],
    );
  }

  BorderRadius get _borderRadius10 => BorderRadius.all(Radius.circular(10));
  Icon buildSettingsIcon() => Icon(Icons.settings, color: Colors.white);

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

  void donatePlasmaFunc() {
    if (AppConstant.donateAgreement != null && AppConstant.donateAgreement)
      Navigator.pushNamed(context, AppRoutes.pagePlasmaRequests);
    else
      Navigator.pushNamed(context, AppRoutes.pageDonatePlasma);
  }

  void createRequestPlasmaFunc() {
    if (!AppConstant.isPlasmaRequested) {
      Navigator.pushNamed(context, AppRoutes.pageRequestPlasma).then((value) {
        if (value == true) setState(() {});
      });
    } else
      showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => _buildAlertDialog);
  }
}
