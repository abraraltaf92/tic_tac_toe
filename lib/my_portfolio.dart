import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tic_tac_toe/util/config.dart';

class MyPortfolio extends StatefulWidget {
  MyPortfolio({@required this.isDark});
  final bool isDark;
  @override
  _MyPortfolioState createState() => _MyPortfolioState();
}

class _MyPortfolioState extends State<MyPortfolio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About Us'),
          centerTitle: true,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Center(
                child: Image.asset(
              'images/board.png',
              color: Colors.grey.withOpacity(0.03),
            )),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Config.xDimension(context, 5.09),
                  vertical: Config.yDimension(context, 3.94)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    'Actually not us, its me!\nI\nam\na\nFlutter Developer\n who loves to build responsive and scalable apps for Android, IOS and Web. I am currently in a race to grab as much I can from the innovative world to create more innovations. I believe in unlearning errors. And I love to code ; ',
                    style: TextStyle(wordSpacing: 1, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  AutoSizeText(
                    'Also, it\'s just a beginning, a lot of stuff is in the pipeline. Show your love by supporting me and share your review about the app and also specify the kind of apps you want from the developer in the future. ',
                    style: TextStyle(wordSpacing: 1, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: Config.yDimension(context, 3.29),
                  ),
                  TextButton(
                      style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent)),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              if (Platform.isIOS) {
                                return CupertinoAlertDialog(
                                  title: const Text("Rate this app"),
                                  content: const Text(
                                      'You like this app ? Then take a little bit of your time to leave a rating :'),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          LaunchReview.launch(
                                              writeReview: false);
                                        },
                                        child: const Text('OK'))
                                  ],
                                );
                              } else {
                                return AlertDialog(
                                  title: const Text("Rate this app"),
                                  content: const Text(
                                      'You like this app ? Then take a little bit of your time to leave a rating :'),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          LaunchReview.launch();
                                        },
                                        child: const Text('OK'))
                                  ],
                                );
                              }
                            });
                      },
                      child: AutoSizeText('Rate this app',
                          style: TextStyle(
                              height: 1.5,
                              color: Theme.of(context).accentColor,
                              decoration: TextDecoration.underline))),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () async {
                        const url = 'https://www.buymeacoffee.com/abraraltaf92';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Image.asset('images/bmc.png'),
                      style: ButtonStyle(
                          backgroundColor: widget.isDark
                              ? MaterialStateColor.resolveWith(
                                  (states) => Colors.white54)
                              : null),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
