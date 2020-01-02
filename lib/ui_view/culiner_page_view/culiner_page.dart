import 'package:flutter/material.dart';
import 'package:news_flutterapps/ui_view/all_page_view/slider_home_all.dart';

import 'list_culinary.dart';

class CulinerPage extends StatefulWidget {
  @override
  _CulinerPageState createState() => _CulinerPageState();
}

class _CulinerPageState extends State<CulinerPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 30.0),
        children: <Widget>[
          SliderHome(),
          SizedBox(height:20,),
          ListCuliner(),
        ],
      ),

    );
  }
}
