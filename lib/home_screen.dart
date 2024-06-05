import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_flutter_09e1/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void userLogout()async{
    await FirebaseAuth.instance.signOut();
    SharedPreferences userCred = await SharedPreferences.getInstance();
    userCred.clear();
    Navigator.push(context,  MaterialPageRoute(builder: (context) => LoginScreen(),));
  }

  String userEmail = "";

  Future getUserEmail()async{
    SharedPreferences userCred = await SharedPreferences.getInstance();
    
    var uEmail = userCred.getString("email");
    return uEmail;
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserEmail().then((value) {
      setState(() {
        userEmail = value;
      });
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userEmail),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){userLogout();}, icon: Icon(Icons.logout))
        ],
      ),
    );
  }
}
