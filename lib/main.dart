import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_flutter_09e1/firebase_options.dart';
import 'package:form_flutter_09e1/login_screen.dart';
import 'package:form_flutter_09e1/splash_screen.dart';
import 'package:uuid/uuid.dart';

import 'add_data.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddData(),
    );
  }
}


class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  bool isHide = true;

  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController pass = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  void userRegister()async{

    String userID = Uuid().v1();

      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: pass.text);


        
        // FirebaseFirestore.instance.collection("user").add({
        //   "name" : name.text,
        //   "gender" : gender.text,
        //   "email" : email.text,
        //   "pass": pass.text
        // });

        FirebaseFirestore.instance.collection("user").doc(userID).set({
          "id" : userID,
          "name" : name.text,
          "gender" : gender.text,
          "email" : email.text,
          "pass": pass.text
        });
        
        // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
        Navigator.pop(context);
      } on FirebaseAuthException catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Form"),
        centerTitle: true,
      ),

      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [

            SizedBox(height: 10,),

            TextFormField(
              controller: name,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                label: Text("Enter Your Name"),
                hintText: "John Doe",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder()
              ),
            ),

            SizedBox(height: 10,),

            TextFormField(
              controller: gender,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  label: Text("Enter Your Gender"),
                  hintText: "M / F",
                  prefixIcon: Icon(Icons.line_axis_sharp),
                  border: OutlineInputBorder()
              ),
            ),

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
              userRegister();
            }, child: Text("Register"))


          ],
        ),
      ),
    );
  }
}


