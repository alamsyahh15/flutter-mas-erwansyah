import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_flutterapps/network/networkprovider.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  bool isValid = true;
  File image;
  String keyword1;
  String keyword2;
  TextEditingController etTitleNews = new TextEditingController();
  TextEditingController etContentNews = new TextEditingController();
  BaseEndPoint network = NetworkProvider();

  _AddItemPageState(){
    etTitleNews.addListener((){
      if(etTitleNews.text.isEmpty) {
        setState(() {
          isValid = true;
          keyword1 = "";
        });
      } else {
        setState(() {
          isValid = false;
          keyword1 = etTitleNews.text;
        });
      }
    });

    etContentNews.addListener((){
      if(etContentNews.text.isEmpty){
        setState(() {
          isValid = true;
          keyword2 = "";
        });
      } else {
        setState(() {
          isValid = false;
          keyword2 = etContentNews.text;
        });
      }
    });

  }

  Future _takeImage1() async{
    print("Pick Is Called");
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(imageFile != null){
      setState(() {
        image = imageFile;
      });
    }
  }

  Future _takeImage2() async{
    print("Pick Is Called");
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if(imageFile != null){
      setState(() {
        image = imageFile;
      });
    }
  }

  String serverToken  = "AAAA3S59AI4:APA91bHbLK1N33YnTzBZy98c45ePVbWULn5mDAsQGp_OvI7pxhwJl-x1DDJZBBdwS7h5xBJspM8RGyaIC812IsZjW2ISEOP75xtm-hlkc6Z0iP2sEmCWbdNDb2NgGNXeXfHXVaL6IPCw";
  String firebaseUrl = "https://fcm.googleapis.com/fcm/send";
  Future<Map<String,dynamic>>sendMessage()async{
    await http.post(firebaseUrl,
        headers: {'Content-Type': 'application/json', 'Authorization': 'key=$serverToken'},
        body: jsonEncode(<String, dynamic>{
          "registration_ids" : ["e_X4SdXiydk:APA91bECszdbzKHS_eRMRlFBdk9MCL6PO06UvU4bbsV36rYawzNbmUtQJHRc1pkIDOdM9XRhiu9olxOP2_D-S1XnR5jKdTXFNGH9Xa1KrRymoUmGL_CQGZajCoHx1fzIkQD9-373HOE_","e_X4SdXiydk:APA91bECszdbzKHS_eRMRlFBdk9MCL6PO06UvU4bbsV36rYawzNbmUtQJHRc1pkIDOdM9XRhiu9olxOP2_D-S1XnR5jKdTXFNGH9Xa1KrRymoUmGL_CQGZajCoHx1fzIkQD9-373HOE_"],
          "collapse_key" : "type_a",
          "notification" : {
            "body" : "Isi nya Notifikasi ",
            "title": "Judul Notifikasi"
          },
          "data" : {
            "body" : "Body of Your Notification in Data",
            "title": "Title of Your Notification in Title",
            "key_1" : "Value for key_1",
            "key_2" : "Value for key_2"
          }
        })
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Data"),
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: FlatButton(
              onPressed: isValid
              ? null
              : (){
                network.saveData(image,etTitleNews.text,etContentNews.text);
                sendMessage();
                Navigator.pop(context);
              },

              child: isValid
              ? Text("Posting", style: TextStyle(color: Colors.grey),)
              : Text("Posting", style: TextStyle(color: Colors.white),),
            ),
          )
        ],
      ),

      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 16),
                  child: Text("Form ADd News", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.deepPurple
                  ),),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 8,left: 16,right: 16, bottom: 8),
                child: TextFormField(
                  controller: etTitleNews,
                  decoration: InputDecoration(
                    labelText: "Title News",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(),
                    )
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 8,left: 16,right: 16, bottom: 8),
                child: TextFormField(
                  maxLines: 15,
                  controller: etContentNews,
                  decoration: InputDecoration(
                    labelText: "Title News",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(),
                    )
                  ),
                ),
              ),

              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 16,right: 16, bottom: 8),
                  child: image == null
                  ? null
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(image),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 16,right: 16,bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      width: 140,
                      child: MaterialButton(
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                        ),
                        onPressed: _takeImage1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(Icons.image, color: Colors.white,),
                            Text("Form Gallery", style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width:8 ,),
                    SizedBox(
                      height: 50,
                      width: 145,
                      child: MaterialButton(
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)
                        ),
                        onPressed: _takeImage2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(Icons.camera, color: Colors.white,),
                            Text("Form Camera", style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )



            ],
          )
        ],
      ),

    );
  }
}
