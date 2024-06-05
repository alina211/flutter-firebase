import 'dart:js_interop_unsafe';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_flutter_09e1/main.dart';
import 'package:form_flutter_09e1/update_screeen.dart';


class FetchScreen extends StatefulWidget {
  const FetchScreen({super.key});

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("user").snapshots(),
          builder: (context, snapshot) {


            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }

            if(snapshot.hasData){

              var dataLength = snapshot.data!.docs.length;

              return dataLength != 0 ? ListView.builder(
                itemCount: dataLength,
                itemBuilder: (context, index) {

                  String userName = snapshot.data!.docs[index]["name"];
                  String userID = snapshot.data!.docs[index]["id"];
                  String userEmail = snapshot.data!.docs[index]["email"];
                  String userGender = snapshot.data!.docs[index]["gender"];
                  String userPass = snapshot.data!.docs[index]["pass"];

                  return ListTile(
                    title: Text(userName),
                    subtitle: Text(userEmail),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(onPressed: ()async{
                            await FirebaseFirestore.instance.collection("user").doc(userID).delete();

                          }, icon: Icon(Icons.delete, color: Colors.red,)),
                          IconButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateScreen(
                                name: userName,
                                gender: userGender,
                                email: userEmail,
                                password: userPass,
                              userID: userID,
                            ),));
                          }, icon: Icon(Icons.update)),
                        ],
                      ),
                    ),
                  );
                },) : Center(child: Text("Nothing to show"),);
            }


            if(snapshot.hasError) {
              return Center(child: Icon(Icons.error,color: Colors.red,),);
            }

            return Container();
          },),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome(),));

      },child: Icon(Icons.add),),
    );
  }
}
