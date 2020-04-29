import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity/connectivity.dart';

class WebViewPage extends StatefulWidget {
  final url;
  final String title;
  WebViewPage(this.url, this.title);
  @override
  createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final _key = UniqueKey();
  int _stackToView = 1;
  Widget webviewChild;

  void pageloaded(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    check().then((internet) {
      if (internet != null && internet) {
        setState(() {
          webviewChild = CircularProgressIndicator(
            backgroundColor: Colors.white,
            strokeWidth: 5,
          );
        });
      } else {
        setState(() {
          webviewChild = Text('İnternet bağlantın yok :/');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: IndexedStack(
            index: _stackToView,
            children: [
              WebView(
                key: _key,
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: widget.url,
                onPageFinished: pageloaded,
              ),
              Container(
                child: Center(
                  child: webviewChild,
                ),
              ),
            ],
          ),
        ));
  }
}
