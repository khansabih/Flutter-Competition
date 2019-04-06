import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'homePage.dart';
class writeDetails extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new writeDetailsState();
  }
}
class writeDetailsState extends State{

  final TextEditingController n = new TextEditingController();
  final TextEditingController desc = new TextEditingController();
  File image;
  String dlAdd;
  int prgrs=0;

  Future getImageFromGallery() async{
    var temp = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = temp;
    });
  }
  Widget showImage() {
    return Container(
      height: 245.0,
      width: 345.0,
      child: new DecoratedBox(decoration:new BoxDecoration(
          shape: BoxShape.rectangle,
          image: new DecorationImage(image: new FileImage(image))
      )),
    );
  }
  Future uploadingImages() async {

      final StorageReference mStorageRef = FirebaseStorage.instance.ref().child('images/${n.text}${DateTime.now()}.png');
      final StorageUploadTask uploadTask = mStorageRef.putFile(image);
      setState(() {
        prgrs=1;
      });
      final StorageTaskSnapshot uploadComplete = await uploadTask.onComplete;
      var dURL = await mStorageRef.getDownloadURL();
      setState(() {
        dlAdd = dURL as String;
        prgrs=0;
      });
  }
  void submitDetails() async{
    if(image!=null)
    await uploadingImages();
    Firestore.instance.collection('posts').document().setData({
      'n':'${n.text}',
      'd':'${desc.text}',
      'r':'${dlAdd}',
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=>homePage()));
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            margin:EdgeInsets.all(20),
            child: TextField(
              controller: n,
              decoration: InputDecoration(
                hintText: "Your name"
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: TextField(
              controller: desc,
              decoration: InputDecoration(
                  hintText: "Tell us about your recommendation"
              ),
              maxLines: null,
            ),
          ),
          Container(
            child: GestureDetector(child: image==null?new Icon(Icons.add_a_photo):showImage(),
              onTap: (prgrs==0)?(){getImageFromGallery();}:(){}),
          ),
          SizedBox(height: 15),
          GestureDetector(
            child: Center(child: (prgrs==0)?Center(child: Text("Post"),
            ):CircularProgressIndicator(),
            ),
            onTap: (){if(desc.text==""){}else{submitDetails();}},
          )
        ],
      ),
    );
  }
}