import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/notifiers/haptics.dart';
import 'package:tic_tac_toe/ui/home.dart';
import 'package:tic_tac_toe/notifiers/music.dart';
import 'package:tic_tac_toe/notifiers/sound.dart';
import 'package:tic_tac_toe/notifiers/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.bgm.initialize();
  Flame.audio.disableLog();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) =>
            ThemeProvider(isDarkMode: prefs.getBool('isDarkTheme') ?? true),
      ),
      ChangeNotifierProvider(
          create: (_) =>
              SoundProvider(isSound: prefs.getBool('isSound') ?? true)),
      ChangeNotifierProvider(
          create: (_) => HapticProvider(
              isHaptic: prefs.getBool('isHaptic') ?? false,
              isHapticPemission: prefs.getBool('isHapticPermission') ?? true)),
      ChangeNotifierProvider(
          create: (_) => MusicProvider(
                isMusic: prefs.getBool('isMusic') ?? false,
              )),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    Flame.audio.loadAll([
      'bubble_popping.mp3',
      'draw.mp3',
      'house_party.mp3',
      'whoosh.mp3',
      'win.mp3'
    ]);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1700),
      vsync: this,
    )..forward();
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -50.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    Flame.audio.clearAll();
    Flame.bgm.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return GetMaterialApp(
        title: 'Tic Tac Toe',
        theme: themeProvider.getTheme,
        debugShowCheckedModeBanner: false,
        home: animatedSplashScreen(themeProvider: themeProvider),
      );
    });
  }

  AnimatedSplashScreen animatedSplashScreen(
      {@required ThemeProvider themeProvider}) {
    return AnimatedSplashScreen(
      duration: 3,
      backgroundColor: themeProvider.getTheme.backgroundColor,
      nextScreen: Home(),
      splashTransition: SplashTransition.scaleTransition,
      splash: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Lottie.asset(
                'assets/images/splashScreen.json',
              ),
            ),
            slideTransition(),
            fadeTransition()
          ],
        ),
      ),
      splashIconSize: 250,
    );
  }

  SlideTransition slideTransition() {
    return SlideTransition(
      position: _offsetAnimation,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: AutoSizeText(
          'HI THERE, I\'M',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  FadeTransition fadeTransition() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TypewriterAnimatedTextKit(
            text: ['Abrar', 'Altaf'],
            totalRepeatCount: 1,
            speed: Duration(milliseconds: 350),
            textStyle: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: AutoSizeText(
              'developer of the app',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
