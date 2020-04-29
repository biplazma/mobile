import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mdi/mdi.dart';
import 'package:biplazma/auth_service.dart';
import 'package:biplazma/util/app_colors.dart';
import 'package:biplazma/util/helper.dart';
import 'package:biplazma/widget/appBar.dart';
import 'package:url_launcher/url_launcher.dart';

class PlasmaRequests extends StatefulWidget {
  PlasmaRequests({Key key}) : super(key: key);

  @override
  _PlasmaRequestsState createState() => _PlasmaRequestsState();
}

class _PlasmaRequestsState extends State<PlasmaRequests> {
  bool isLoaded = false;

  Future<List<dynamic>> getRequests() async {
    var firestore = Firestore.instance;

    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    var userData = await firestore.collection("users").document(user.uid).get();
    var userProvince = userData.data['province'];

    authService.updateLastSeen(user);

    QuerySnapshot qn = await firestore.collection('requests').where('province', isEqualTo: userProvince).orderBy('createdDate').getDocuments();

    return qn.documents;
  }

  @override
  void initState() {
    super.initState();
    getRequests().then((value) {
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
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
        backgroundColor: Color(0xffF6F7FC),
        appBar: AppBar(
            title: Text('Plazma Talepleri', style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold)),
            centerTitle: true,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[Color(0xffD70652), Color(0xffFF025E)])),
            )),
        body: FutureBuilder(
          future: getRequests(),
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Mdi.alertCircle, size: 50, color: Colors.black26),
                        Helper.sizedBoxH10,
                        Text("Plazma talebi bulunamadı!", style: Theme.of(context).textTheme.headline5),
                      ],
                    ),
                  );
                } else {
                  return Center(
                      child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ListView.separated(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        var user = snapshot.data[index];
                        return plasmaRequestCard(
                            name: user.data['name'],
                            bloodGroup: user.data['bloodGroup'],
                            phoneNumber: user.data['phoneNumber'],
                            hospital: user.data['hospitalName'],
                            photoUrl: user.data['photoUrl'],
                            onPressed: () {
                              launch('tel://${user.data['phoneNumber']}');
                            });
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(
                        color: Colors.transparent,
                        height: 25,
                      ),
                    ),
                  ));
                }
            }
          },
        ),
      );
    }
  }

  Widget plasmaRequestCard({String name, String phoneNumber, String hospital, String bloodGroup, String photoUrl, Function onPressed}) {
    return RaisedButton(
      padding: EdgeInsets.all(0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
      ),
      color: Colors.white,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 200,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 20,
              top: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                    width: 60,
                    height: 60,
                    errorWidget: (context, url, error) => Icon(Mdi.account),
                    placeholder: (context, url) => const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 5,
                        ),
                    imageUrl: photoUrl),
              ),
            ),
            Positioned(
              left: 90,
              top: 38,
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              right: 25,
              top: 25,
              child: SvgPicture.asset(
                "assets/svg/kan.svg",
                width: 50,
              ),
            ),
            Positioned(
              right: 37,
              top: 55,
              child: Text(
                bloodGroup.replaceAll(' RH ', '').trim(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Positioned(
              left: 25,
              bottom: 65,
              child: Icon(
                Icons.call,
                size: 25,
                color: Color(0xffE30556),
              ),
            ),
            Positioned(
              left: 25,
              bottom: 20,
              child: Icon(
                Icons.pin_drop,
                size: 25,
                color: Color(0xffE30556),
              ),
            ),
            Positioned(
              left: 68,
              bottom: 70,
              child: Text(
                phoneNumber,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Positioned(
              left: 68,
              bottom: 20,
              child: Container(
                width: 250,
                child: AutoSizeText(
                  hospital,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
