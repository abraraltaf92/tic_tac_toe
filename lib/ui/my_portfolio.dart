import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:tic_tac_toe/util/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tic_tac_toe/util/config.dart';

class MyPortfolio extends StatelessWidget {
  MyPortfolio({@required this.isDark, @required this.isSound});

  final bool isDark;
  final bool isSound;
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
              'assets/images/board.png',
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
                    aboutMe,
                    style: TextStyle(wordSpacing: 1, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  AutoSizeText(
                    itsJustABeginning,
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
                        if (isSound) {
                          HapticFeedback.lightImpact();
                        }
                        showDialog(
                            context: context,
                            builder: (_) {
                              if (Platform.isIOS) {
                                return CupertinoAlertDialog(
                                  title: const Text("Rate this app"),
                                  content: const Text(
                                    appRating,
                                  ),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          if (isSound) {
                                            HapticFeedback.lightImpact();
                                          }
                                          Navigator.of(context).pop();
                                          try {
                                            LaunchReview.launch(
                                                writeReview: false);
                                          } catch (e) {
                                            print(e.toString());
                                          }
                                        },
                                        child: const Text('OK'))
                                  ],
                                );
                              } else {
                                return AlertDialog(
                                  title: const Text("Rate this app"),
                                  content: const Text(appRating),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          if (isSound) {
                                            HapticFeedback.lightImpact();
                                          }
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
                        if (isSound) {
                          HapticFeedback.lightImpact();
                        }
                        const url = buyMeACoffee;
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Image.asset('assets/images/bmc.png'),
                      style: ButtonStyle(
                          backgroundColor: isDark
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
