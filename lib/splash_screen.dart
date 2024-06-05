import 'dart:async';

import 'package:flutter/material.dart';
import 'package:form_flutter_09e1/fetch_screen.dart';
import 'package:form_flutter_09e1/home_screen.dart';
import 'package:form_flutter_09e1/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String uEmail = "";

  Future getUserData()async{
    SharedPreferences userCred = await SharedPreferences.getInstance();
    var isUserAuth = userCred.getString("email");
    return isUserAuth;
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData().then((value) => value != null ? Timer(Duration(milliseconds: 2500), () => Navigator.push(context, MaterialPageRoute(builder: (context) => FetchScreen(),)),) : Timer(Duration(milliseconds: 2500), () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),)),),);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Splash Screen"),)
    );
  }
}
