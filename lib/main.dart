import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mate/constants.dart';
import 'package:flutter_mate/feed.dart';
import 'package:flutter_mate/start_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter_mate/network.dart';
import 'package:flutter_mate/profile.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatefulWidget {
  static GlobalKey<NavigatorState> navKeyStat;      // navigator key for stful widget
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String message = "---";
  StreamSubscription _subs;
  final navKey = GlobalKey<NavigatorState>();     // 

  @override
  void initState() {
    // initializes the deep-link listener and links the NavKey
    _initDeepLinkListener();
    super.initState();
    MyApp.navKeyStat = navKey;
  }

  @override
  void dispose() {
    // dispose off deep-link listener and call dispose on super
    _disposeDeepLinkListener();
    super.dispose();
  }

  void _initDeepLinkListener() async {
    
    _subs = getLinksStream().listen((String link) {
      print("init deeplink listener");
      _checkDeepLink(link);
    }, cancelOnError: true);
  }

  void _checkDeepLink(String link) {
    // checks deep-link and directly calls the profile page on succes
    if (link != null) {
      String code = link.substring(link.indexOf(RegExp('code=')) + 5);
      proceedToProfile(code);
    }
  }

  void proceedToProfile(String code) async {
    //show loading bar and block user
    _showLoading();
    bool p = await Network().loginWithGitHub(code);
    // remove loading bar
    navKey.currentState.pop();
    if (p) {                                                  // on successful load of user profile
      navKey.currentState.pushReplacementNamed("/profile");
    } else {                                                  // unable to load the user profile
      showDialog(
        //eror dialog
          context: StartScreen.popContext,
          builder: (context) {
            return AlertDialog(
                content: Text("Some Server Error Occured, Please Try Again"));
          });
      print("Server Error");
    }
  }

  void _disposeDeepLinkListener() {
    // 
    print("dispose deeplink listener");
    if (_subs != null) {
      _subs.cancel();
      _subs = null;
    }
  }

  void _showLoading() {
    showDialog(
        context: StartScreen.popContext,
        barrierDismissible: false,
        builder: (context) {
          // stop back button pop
          return WillPopScope(
            onWillPop: () => Future<bool>.value(false),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // builds main app UI with the routes configured
    return MaterialApp(
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      title: 'FlutterMate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        // the various routes used
        '/': (context) => StartScreen(),    // landing page
        '/profile': (context) => Profile(), // load logged-in user's profile
        '/feed': (context) => Feed()        // load feed for user
      },
    );
  }
}
