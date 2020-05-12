import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mdi/mdi.dart';
import 'package:biplazma/auth_service.dart';
import 'package:biplazma/contributors_page.dart';
import 'package:biplazma/splash_page.dart';
import 'package:biplazma/util/helper.dart';
import 'package:biplazma/widget/appBar.dart';
import 'package:url_launcher/url_launcher.dart';
import "util/app_colors.dart";
import 'util/app_constant.dart';
import 'util/app_textStyles.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.transparent));
    return Scaffold(
      appBar: CustomAppBar(title: "Ayarlar"),
      persistentFooterButtons: <Widget>[_buildSnackBar],
      body: Padding(
        padding: EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            buildMaterialButton(AppConstant.github, Mdi.github, AppColors.githubBoxColor, launchGitHub),
            Helper.sizedBoxH20,
            buildMaterialButton(AppConstant.contributors, Mdi.accountGroup, AppColors.contributorsBoxColor, pushContributorsPage),
            Spacer(),
            _buildLogoutButton,
          ],
        ),
      ),
    );
  }

  RaisedButton get _buildLogoutButton {
    return RaisedButton(
      onPressed: () => logout(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(gradient: AppColors.linearGradient, borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          constraints: BoxConstraints(maxWidth: double.infinity, minHeight: MediaQuery.of(context).size.height * 0.06),
          alignment: Alignment.center,
          child: Text(AppConstant.logout, style: AppTextStyles.logoutBTNTextStyle),
        ),
      ),
    );
  }

  MaterialButton buildMaterialButton(String _title, IconData _icon, Color _color, Function _function) {
    return MaterialButton(
      height: MediaQuery.of(context).size.height * 0.13,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      onPressed: () => _function(),
      color: _color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[Icon(_icon, color: Colors.white, size: 30), Helper.sizedBoxW10, Text(_title, style: AppTextStyles.appBarTextStyle)],
      ),
    );
  }

  Container get _buildSnackBar {
    return Container(
      width: MediaQuery.of(context).copyWith().size.width,
      child: FlatButton(
        child: Text(AppConstant.settingsSnackBarDesc, style: AppTextStyles.selectTextStyle),
        onPressed: () => launchURL(AppConstant.twitterURL),
      ),
    );
  }

  void pushContributorsPage() => Navigator.push(context, MaterialPageRoute(builder: (context) => ContributorsPage()));

  launchGitHub() async => (await canLaunch(AppConstant.githubURL) == true) ? await launch(AppConstant.githubURL) : throw 'Could not launch URL';
  launchURL(String url) async => (await canLaunch(url) == true) ? await launch(url) : throw 'Could not launch $url';

  void logout() {
    authService.signOut();
    Helper.setUserToken('');
    Helper.setRegister(false);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashPage()), (r) => false);
  }
}
