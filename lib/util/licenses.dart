import 'package:flutter/material.dart';
import 'package:tic_tac_toe/util/constants.dart';
import 'package:url_launcher/url_launcher.dart';

showLicense({BuildContext context}) {
  return showAboutDialog(
      context: context,
      applicationIcon: Image.asset(
        'assets/images/logo.png',
        width: MediaQuery.of(context).size.width * 0.1,
      ),
      applicationVersion: '0.0.1',
      applicationName: 'Tic Tac Toe',
      applicationLegalese: 'Developed by Abrar Altaf Lone',
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: const Text(
            licenseContent,
          ),
        ),
        TextButton(
          child: Opacity(
            opacity: 0.8,
            child: Text(
              'Tic Tac Toe animation by OkenwA on LottieFiles',
              style:
                  TextStyle(fontSize: 10, decoration: TextDecoration.underline),
            ),
          ),
          onPressed: () async {
            const url = boardAnimationLink;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
        TextButton(
          child: Opacity(
            opacity: 0.8,
            child: Text(
              'Confetti Party animation by Bit Bit on LottieFiles',
              style: TextStyle(
                fontSize: 10,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          onPressed: () async {
            const url = winnerSurpriseLink;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
        TextButton(
          child: Opacity(
            opacity: 0.8,
            child: Text(
              'Sound from https://www.zapsplat.com',
              style: TextStyle(
                fontSize: 10,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          onPressed: () async {
            const url = additionalSoundEffectsLink;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
      ]);
}
