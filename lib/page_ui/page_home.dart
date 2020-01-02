import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_flutterapps/ui_view/all_page_view/all_page.dart';
import 'package:news_flutterapps/ui_view/culiner_page_view/culiner_page.dart';
import 'package:news_flutterapps/ui_view/sport_page_view/sport_page.dart';
import 'package:news_flutterapps/ui_view/travel_page_view/travel_page.dart';

import 'add_item_page.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class PageHome extends StatefulWidget {
  final drawerItem = [
    new DrawerItem("Cart", Icons.add_shopping_cart),
    new DrawerItem("Travel", Icons.card_travel),
    new DrawerItem("Info", Icons.info)
  ];

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome>
    with SingleTickerProviderStateMixin {
  TabController controllerTabs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerTabs = new TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controllerTabs.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: Text("Muhamad Alamsyah"),
            accountEmail: Text("muhamad.a.syah31@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: Text(
                "A",
                style: TextStyle(fontSize: 40),
              ),
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
            ),
            otherAccountsPictures: <Widget>[
              CircleAvatar(
                child: Icon(
                  Icons.exit_to_app,
                  size: 25,
                ),
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
              )
            ],
          ),
        ]),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
              width: 160,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Text(
                  "Mbaca Wewara",
                  style: TextStyle(color: Colors.deepPurple),
                ),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
            Text(
              "The News Application",
              style: TextStyle(fontSize: 10, color: Colors.white),
            )
          ],
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 16),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ))
        ],
      ),
      body: TabBarView(
        controller: controllerTabs,
        children: <Widget>[AllPage(), CulinerPage(), SportPage(), TravelPage()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddItemPage()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        elevation: 2.0,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 32,
        shape: CircularNotchedRectangle(),
        color: Color(0xFF512DA8),
        child: new TabBar(controller: controllerTabs, tabs: <Widget>[
          Tab(
            icon: Icon(Icons.dashboard),
          ),
          Tab(
            icon: Icon(Icons.cake),
          ),
          Tab(
            icon: Icon(Icons.security),
          ),
          Tab(
            icon: Icon(Icons.airplanemode_active),
          )
        ]),
      ),
    );
  }
}
