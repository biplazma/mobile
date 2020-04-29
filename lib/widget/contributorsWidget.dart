import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdi/mdi.dart';
import 'package:biplazma/model/contributors.dart';
import 'package:url_launcher/url_launcher.dart';

class ContributorsWidget extends StatefulWidget {
  final Contributor cont;
  ContributorsWidget({@required this.cont, Key key}) : super(key: key);

  @override
  _ContributorsWidgetState createState() => _ContributorsWidgetState();
}

class _ContributorsWidgetState extends State<ContributorsWidget> {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[Color(0xffF2045A), Color(0xff970A3D)]),
          ),
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                        width: 60,
                        height: 60,
                        errorWidget: (context, url, error) => Icon(Mdi.account),
                        placeholder: (context, url) => const CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              strokeWidth: 5,
                            ),
                        imageUrl: widget.cont.photoUrl),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.cont.name, style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white)),
                      Text(widget.cont.title, style: GoogleFonts.openSans(fontWeight: FontWeight.w300, fontSize: 15, color: Colors.white))
                    ],
                  ),
                  Spacer(),
                  Icon(
                    Mdi.instagram,
                    size: 50,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            onTap: () {
              launchURL('https://www.instagram.com/' + widget.cont.link);
            },
          ),
        ),
      ),
    );
  }
}
