import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_flutter_09e1/update_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}
class _AddDataState extends State<AddData> {
  Uint8List? webImage;
  File? appImage;

  final TextEditingController name = TextEditingController();

  void userWithImage()async{
    if (kIsWeb) {
      String userID = Uuid().v1();
      UploadTask uploadTask = FirebaseStorage.instance.ref().child("userImage").child(userID).putData(webImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imgUrl = await taskSnapshot.ref.getDownloadURL();
      addUser(userID: userID,imgUrl:imgUrl);
    }
    else {
      String userID = Uuid().v1();
      UploadTask uploadTask = FirebaseStorage.instance.ref().child("userImage").child(userID).putFile(appImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imgUrl = await taskSnapshot.ref.getDownloadURL();
      addUser(userID: userID, imgUrl: imgUrl);
    }
  }
  void addUser({String? userID, String? imgUrl}) async{
    await FirebaseFirestore.instance.collection("uimage").doc(userID).set({
      "userID" : userID,
      "username" : name.text,
    "userimage" : imgUrl
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: ()async{
                if(kIsWeb){
                  XFile? selectImage = await ImagePicker().pickImage(source: ImageSource.gallery);

                if (selectImage !=null) {
                  var convertedImage = await selectImage.readAsBytes();
                  setState(() {
                    webImage = convertedImage;
                  });
                }  else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image not selected")));
                }
              }
                else{
                  XFile? selectImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (selectImage != null) {
                    File convertedImage = File(selectImage.path);
                    setState(() {
                      appImage = convertedImage;
                    });
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image not selectes")));
                  }
                }
                },
              child: kIsWeb ? CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey,
                backgroundImage: webImage != null ? MemoryImage(webImage!) : null,
              ) : CircleAvatar(
              radius: 60,
            backgroundColor: Colors.blue,
                  )
            ),
            Container(
              width: 160,
              child: TextFormField(
                controller: name,
              ),
            ),

            SizedBox(
              height: 40,
            ),

            ElevatedButton(onPressed: (){
              userWithImage();
            }, child: Text("Add Data")),

            SizedBox(
              height: 40,
            ),

            StreamBuilder(stream: FirebaseFirestore.instance.collection("uimage").snapshots(), builder: (context, snapshot) {
              if (snapshot.hasData) {
                var dataLength = snapshot.data!.docs.length;
                return dataLength != 0 ? ListView.builder(
                  itemCount: dataLength,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                    String uImage = snapshot.data!.docs[index]["userimage"];
                    String uName = snapshot.data!.docs[index]["username"];
                    String uID = snapshot.data!.docs[index]["userID"];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(uImage),
                        ),
                        title: Text(uName),
                        subtitle: Text(uID),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateData(
                                    uID: uID,
                                    uName: uName,
                                    uImage: uImage),));
                              }, icon: Icon(Icons.update)),
                              IconButton(onPressed: ()async{
                                try{
                                 await FirebaseFirestore.instance.collection("uimage").doc(uID).delete();
                                  await FirebaseStorage.instance.refFromURL(uImage).delete();
                                }catch(ex){
                                  debugPrint(ex.toString());
                                }

                              }, icon: Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      );
                    },) : Text("Nothing to show");
              } else if (snapshot.hasError){
                return Icon(Icons.error_outline);
              }  else {
                return CircularProgressIndicator();
              }
            },)
          ],
        ),
      ),
    );
  }
}
