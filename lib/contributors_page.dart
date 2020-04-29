import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biplazma/model/contributors.dart';
import 'package:biplazma/widget/contributorsWidget.dart';

class ContributorsPage extends StatefulWidget {
  ContributorsPage({Key key}) : super(key: key);

  @override
  _ContributorsPageState createState() => _ContributorsPageState();
}

class _ContributorsPageState extends State<ContributorsPage> {
  List contributors = [
    Contributor("Furkan Kaya", "Developer", "fkaya08",
        "https://scontent-atl3-1.cdninstagram.com/v/t51.2885-19/90227257_503509530314179_6947981969267359744_n.jpg?_nc_ht=scontent-atl3-1.cdninstagram.com&_nc_ohc=adk2qfIFH4AAX8-tMg9&oh=b942d81da9dfc34b0e9f6a29548b947f&oe=5ECD4CE5"),
    Contributor("Adem Özcan", "Developer", "ademozcan68",
        "https://scontent-atl3-1.cdninstagram.com/v/t51.2885-19/75419812_2487750068161889_4216648936724627456_n.jpg?_nc_ht=scontent-atl3-1.cdninstagram.com&_nc_ohc=n7uMsZV4f5IAX-JqOy7&oh=19377e262edeb43866e2b98c9c599ce7&oe=5ECEAD71"),
    Contributor("Berk Bıyıkçı", "Developer", "berkbiyikci",
        "https://scontent-atl3-1.cdninstagram.com/v/t51.2885-19/84258577_2631915350376267_8376463069437493248_n.jpg?_nc_ht=scontent-atl3-1.cdninstagram.com&_nc_ohc=hWJFT0iw_voAX9Wq1Ml&oh=b67621380cbc3960d5b74d4acf1437d6&oe=5ECECFA1"),
    Contributor("Muhammet Ömer", "Developer", "mukireus",
        "https://scontent-atl3-1.cdninstagram.com/v/t51.2885-19/91540410_209213050346937_8423880801170489344_n.jpg?_nc_ht=scontent-atl3-1.cdninstagram.com&_nc_ohc=Z6B89JoA1PQAX_6zq50&oh=d8bacf9b499c3d7e216760678374b585&oe=5ECD4D94"),
    Contributor("Onur Kaya", "Destekçi", "empatisoft",
        "https://instagram.fist4-1.fna.fbcdn.net/v/t51.2885-19/11373935_847133418739275_181152241_a.jpg?_nc_ht=instagram.fist4-1.fna.fbcdn.net&_nc_ohc=ObqjgdydeNoAX9jYpSb&oh=8d884dbc6f5ab4e3c046a62c9c7b9999&oe=5ECDF673"),
    Contributor("Emre Yazar", "Destekçi", "razayerme",
        "https://scontent-otp1-1.cdninstagram.com/v/t51.2885-19/44884218_345707102882519_2446069589734326272_n.jpg?_nc_ht=scontent-otp1-1.cdninstagram.com&_nc_ohc=_Lu1YZqlcLgAX-BAwim&oh=6063e7e7dff6fdd6d107144e28d8cc0c&oe=5ECC7B8F&ig_cache_key=YW5vbnltb3VzX3Byb2ZpbGVfcGlj.2"),
    Contributor("Ali Vapur", "Tester", "ali_vapur",
        "https://scontent-atl3-1.cdninstagram.com/v/t51.2885-19/92191142_1835685593230882_4835849393921851392_n.jpg?_nc_ht=scontent-atl3-1.cdninstagram.com&_nc_ohc=ZmDBq_YphPYAX_MLJds&oh=631d96c9560ced202f852f1a937ad57f&oe=5ECEEBB6"),
    Contributor("Mert Can Güven", "Tester", "mrtcn_gvn",
        "https://scontent-atl3-1.cdninstagram.com/v/t51.2885-19/93198764_531702794377154_1137870783855460352_n.jpg?_nc_ht=scontent-atl3-1.cdninstagram.com&_nc_ohc=r7gCcLazxtQAX9FabTx&oh=3c6967713c45afe1f4bb4cc63b59d8f3&oe=5ECF5785"),
    Contributor("Celal Topcu", "Tester", "ertugrul.celal",
        "https://scontent-atl3-1.cdninstagram.com/v/t51.2885-19/70594793_1234053060110006_8342984026998439936_n.jpg?_nc_ht=scontent-atl3-1.cdninstagram.com&_nc_ohc=cHdie77Anm8AX8s_5sH&oh=36280c32941445b9e0f9ad0c41ab762d&oe=5ECC03BF")
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.transparent));
    return Scaffold(
        appBar: AppBar(
            title: Text('Katkıda Bulunanlar', style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold)),
            centerTitle: true,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[Color(0xffD70652), Color(0xffFF025E)])),
            )),
        body: SingleChildScrollView(
            child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 10),
                  child: Text(
                    "GELİŞTİRİCİLER",
                    style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
              ContributorsWidget(cont: contributors[0]),
              ContributorsWidget(cont: contributors[1]),
              ContributorsWidget(cont: contributors[2]),
              ContributorsWidget(cont: contributors[3]),
              Padding(
                padding: const EdgeInsets.only(top: 35, bottom: 10),
                child: Text(
                  "TEŞEKKÜRLER",
                  style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ContributorsWidget(cont: contributors[4]),
              ContributorsWidget(cont: contributors[5]),
              Padding(
                padding: const EdgeInsets.only(top: 35, bottom: 10),
                child: Text(
                  "TEST EDENLER",
                  style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ContributorsWidget(cont: contributors[6]),
              ContributorsWidget(cont: contributors[7]),
              ContributorsWidget(cont: contributors[8]),
              SizedBox(height: 15)
            ],
          ),
        )));
  }
}
