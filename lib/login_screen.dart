import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_flutter_09e1/fetch_screen.dart';
import 'package:form_flutter_09e1/home_screen.dart';
import 'package:form_flutter_09e1/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isHide = true;

  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  void uesrLogin()async{

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: pass.text);

      SharedPreferences userCred = await SharedPreferences.getInstance();
      userCred.setString("email", email.text);



      Navigator.push(context, MaterialPageRoute(builder: (context) => FetchScreen(),));


    } on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Login Form"),
        centerTitle: true,
      ),

      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [

            SizedBox(height: 10,),

            // TextFormField(
            //   keyboardType: TextInputType.text,
            //   decoration: InputDecoration(
            //     label: Text("Enter Your Name"),
            //     hintText: "John Doe",
            //     prefixIcon: Icon(Icons.person),
            //     border: OutlineInputBorder()
            //   ),
            // ),
            //
            // SizedBox(height: 10,),
            //
            // TextFormField(
            //   keyboardType: TextInputType.phone,
            //   decoration: InputDecoration(
            //       label: Text("Enter Your Age"),
            //       hintText: "18",
            //       prefixIcon: Icon(Icons.line_axis_sharp),
            //       border: OutlineInputBorder()
            //   ),
            // ),

            SizedBox(height: 10,),

            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  label: Text("Enter Your Email"),
                  hintText: "john@gmail.com",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder()
              ),
            ),

            SizedBox(height: 10,),

            TextFormField(
              controller: pass,
              obscureText: isHide,
              decoration: InputDecoration(
                  label: Text("Enter Your Password"),
                  hintText: "john***D",
                  prefixIcon: Icon(Icons.key),
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      isHide = ! isHide;
                    });
                  }, icon:  isHide == true ? Icon(Icons.remove_red_eye) : Icon(Icons.panorama_fish_eye)),
                  border: OutlineInputBorder()
              ),
            ),

            SizedBox(height: 10,),

            ElevatedButton(onPressed: (){
              debugPrint("${email.text}");
              debugPrint("${pass.text}");
              uesrLogin();
            }, child: Text("Login")),

  ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome(),));
            }, child: Text("Go To Register"))


          ],
        ),
      ),
    );
  }
}
