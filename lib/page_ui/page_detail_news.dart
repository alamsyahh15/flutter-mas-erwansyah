import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_flutterapps/network/constantfile.dart';
import 'package:news_flutterapps/network/networkprovider.dart';

// ignore: must_be_immutable
class DetailNews extends StatefulWidget {
  String detailImage, detailTitle, detailContent, detailId;

  DetailNews(
      {this.detailImage, this.detailTitle, this.detailContent, this.detailId});

  @override
  _DetailNewsState createState() => _DetailNewsState();
}

class _DetailNewsState extends State<DetailNews> {
  File image;
  TextEditingController etNewsDetail = new TextEditingController();
  BaseEndPoint network = NetworkProvider();

  Widget _buildWidget(MediaQueryData mediaQueryData) {
    return Container(
      width: double.infinity,
      height: mediaQueryData.size.height / 1.8,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(48)),
          image: image == null
              ? DecorationImage(
                  image: NetworkImage(
                      ConstantFile().imageUrl + widget.detailImage),
                  fit: BoxFit.cover)
              : DecorationImage(image: FileImage(image), fit: BoxFit.cover)),
    );
  }

  Widget _titleNews(MediaQueryData mediaQueryData) {
    return SizedBox(
      height: mediaQueryData.size.height / 2,
      child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constrains) {
              return Stack(
                children: <Widget>[
                  Positioned(
                    child: Text(
                      widget.detailTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'CoralPen',
                        fontSize: 72,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    top: constrains.maxHeight - 100,
                  ),
                  Positioned(
                    child: SizedBox(
                      width: 100,
                      height: 25,
                      child: RaisedButton(
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        onPressed: () {},
                        child: Text(
                          "Politic",
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Campton_Light'),
                        ),
                      ),
                    ),
                    top: constrains.maxHeight - 30,
                  )
                ],
              );
            },
          )),
    );
  }

  Future<Widget> _showDialog() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 250,
                    child: Center(
                        child: image == null
                            ? Center(
                                child: Text("Not Image Selected"),)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image,
                                  fit: BoxFit.cover,
                                ),
                              )),
                  ),

                  TextFormField(
                    controller: etNewsDetail,
                    decoration: InputDecoration(
                      labelText: "Title News",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide()
                      )
                    ),
                  )
                ],
              ),
            ),

            title: Center(child: Text("Edit Information"),),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  if(etNewsDetail == null || image == null){
                    Navigator.pop(context);
                  } else {
                    network.updateNews(widget.detailId, etNewsDetail.text);
                    network.updateImage(image, widget.detailId);
                    Navigator.pop(context);
                    setState(() {
                      Navigator.pop(context);
                    });
                  }
                },
                child: Text("Update"),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Close"),
              )
            ],
          );
        });
  }

  Future _takeImage() async{
    print("Pick Is Called");
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if(imageFile != null){
      setState(() {
        image = imageFile;
      });
    }
  }


  void _confirmDelete(){
    AlertDialog alertDialog = new AlertDialog(
      content: Text("Are You Sure Delete This Item ?"),
      actions: <Widget>[
        RaisedButton(
          child: Text("Yes"),
          color: Colors.green,
          onPressed: (){
            network.deleteData(widget.detailId);
            Navigator.pop(context);
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        RaisedButton(
          child: Text("Cancel"),
          color: Colors.red,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, child: alertDialog);
  }

  Widget _editButton(MediaQueryData mediaQueryData) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
            top: mediaQueryData.size.height / 1.6 - 32, right: 32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: FloatingActionButton(
                heroTag: 'btnTag1',
                onPressed: () {
                  _showDialog();
                },
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                backgroundColor: Colors.deepPurple,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              child: FloatingActionButton(
                heroTag: 'btnTag2',
                onPressed: () {
                  _takeImage();
                },
                child: Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
                backgroundColor: Colors.deepPurple,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              child: FloatingActionButton(
                heroTag: 'btnTag3',
                onPressed: () {
                  _confirmDelete();
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateNews(MediaQueryData mediaQueryData) {
    return Padding(
      padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: mediaQueryData.size.height / 1.79 + 24,
          bottom: mediaQueryData.padding.bottom + 16),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Jakarta, 24 Desember 2019"),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              floating: true,
              pinned: false,
              snap: false,
              expandedHeight: MediaQuery.of(context).size.height / 1.63,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Stack(
                  children: <Widget>[
                    _buildWidget(mediaQuery),
                    _editButton(mediaQuery),
                    _titleNews(mediaQuery),
                    _dateNews(mediaQuery),
                  ],
                ),
              ),
            )
          ];
        },
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Container(
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.detailContent),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
