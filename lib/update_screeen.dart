import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key,
    required this.userID,
  required this.name,
  required this.gender,
  required this.email,
  required this.password,

  });
  final String userID;
  final String name;
  final String gender;
  final String email;
  final String password;

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

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

    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: pass.text);



      // FirebaseFirestore.instance.collection("user").add({
      //   "name" : name.text,
      //   "gender" : gender.text,
      //   "email" : email.text,
      //   "pass": pass.text
      // });

      FirebaseFirestore.instance.collection("user").doc(widget.userID).update({
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
  void initState() {
    // TODO: implement initState
    name.text = widget.name;
    gender.text = widget.gender;
    email.text = widget.email;
    pass.text = widget.password;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Form"),
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
            }, child: Text("Update"))


          ],
        ),
      ),
    );
  }
}
