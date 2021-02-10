import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyPortfolio extends StatefulWidget {
  @override
  _MyPortfolioState createState() => _MyPortfolioState();
}

class _MyPortfolioState extends State<MyPortfolio> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My PortFolio'),
      ),
      body: WebView(
        initialUrl: "https://abrar-altaf92.web.app",
        onWebViewCreated: (WebViewController c) {
          _controller.complete(c);
        },
      ),
    );
  }
}
