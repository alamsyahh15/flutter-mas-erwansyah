import 'package:flutter/material.dart';
import 'package:news_flutterapps/ui_view/all_page_view/slider_home_all.dart';

import 'list_travel.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 30.0),
        children: <Widget>[
          SliderHome(),
          SizedBox(height:20,),
          ListTravel(),
        ],
      ),

    );
  }
}
