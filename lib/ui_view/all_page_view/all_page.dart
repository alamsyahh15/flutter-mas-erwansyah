import 'package:flutter/material.dart';

import 'list_update_all.dart';
import 'slider_home_all.dart';

class AllPage extends StatefulWidget {
  @override
  _AllPageState createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 30.0),
          children: <Widget>[
            SliderHome(),
            SizedBox(height:20,),
            ListUpdate(),
          ],
      ),

    );
  }
}








