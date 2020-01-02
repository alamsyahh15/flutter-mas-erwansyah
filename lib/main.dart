import 'package:flutter/material.dart';
import 'package:news_flutterapps/page_ui/login_register_page.dart';
import 'page_ui/page_home.dart';

void main() => runApp(MaterialApp(
  home: PageHome(),
  theme: ThemeData(
    primaryColor: Colors.deepPurple,
    accentColor: Colors.white70,
    scaffoldBackgroundColor: Color(0xFFF3F5F7)
  ),
));
