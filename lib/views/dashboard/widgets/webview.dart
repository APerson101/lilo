import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatelessWidget {
  WebView(this.gift_link);
  String gift_link;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebviewScaffold(
        url: gift_link,
        appBar: new AppBar(
          title: new Text("Widget webview"),
        ),
      ),
    );
  }
}
