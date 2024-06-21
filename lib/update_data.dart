import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
class UpdateData extends StatefulWidget {
  const UpdateData({super.key,
  required this.uID,
    required this.uName,
    required this.uImage
  });
  final String uID;
  final String uName;
  final String uImage;

  @override
  State<UpdateData> createState() => _UpdateDataState();
}
class _UpdateDataState extends State<UpdateData> {
  Uint8List? webImage;
  File? appImage;

  final TextEditingController name = TextEditingController();

  void userWithImage()async{
    if (kIsWeb) {
      await FirebaseStorage.instance.refFromURL(widget.uImage).delete();
      UploadTask uploadTask = FirebaseStorage.instance.ref().child("userImage").child(widget.uID).putData(webImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imgUrl = await taskSnapshot.ref.getDownloadURL();
      addUser(imgUrl:imgUrl);
    }
    else {
      await FirebaseStorage.instance.refFromURL(widget.uImage).delete();
      UploadTask uploadTask = FirebaseStorage.instance.ref().child("userImage").child(widget.uID).putFile(appImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imgUrl = await taskSnapshot.ref.getDownloadURL();
      addUser(imgUrl: imgUrl);
    }
  }
  void addUser({String? imgUrl}) async{
    await FirebaseFirestore.instance.collection("uimage").doc(widget.uID).update({
      "username" : name.text,
      "userimage" : imgUrl
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    name.text = widget.uName;
    super.initState();
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
                child: kIsWeb ? webImage == null ? CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(widget.uImage),
                ) : CircleAvatar(
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
            }, child: Text("Update Data")),

            SizedBox(
              height: 40,
            ),

          ],
        ),
      ),
    );
  }
}
