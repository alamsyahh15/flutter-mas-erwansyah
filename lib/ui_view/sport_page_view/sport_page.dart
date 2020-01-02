import 'package:flutter/material.dart';
import 'package:news_flutterapps/ui_view/all_page_view/slider_home_all.dart';

import 'list_sport.dart';

class SportPage extends StatefulWidget {
  @override
  _SportPageState createState() => _SportPageState();
}

class _SportPageState extends State<SportPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 30.0),
        children: <Widget>[
          SliderHome(),
          SizedBox(height:20,),
          ListSport(),
        ],
      ),

    );
  }
}
