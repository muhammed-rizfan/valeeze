import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:valeeze/screens/auth/login_page.dart';
import 'package:valeeze/screens/home/home_page.dart';
import 'package:valeeze/screens/home/main_screen.dart';
import 'package:valeeze/screens/onboarding/onboarding_page.dart';

class RootPage extends StatefulWidget {
  RootPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  loadSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;

    print('login status is' + '$status');
    // var onBoarding = prefs.getBool('onboard') ?? true;
    var onBoarding = false;
    setState(() {
      // if (!onBoarding) {
      authStatus = status ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      // }
    });
  }

  @override
  initState() {
    super.initState();
    loadSharedPrefs();

    /* widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus = userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      });
    });*/
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return OnboardingPage();
      case AuthStatus.signedIn:
        return MainScreen();
    }
  }
}
