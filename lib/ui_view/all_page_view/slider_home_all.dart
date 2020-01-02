import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news_flutterapps/model/model_news.dart';
import 'package:news_flutterapps/network/constantfile.dart';
import 'package:news_flutterapps/network/networkprovider.dart';

class SliderHome extends StatefulWidget {
  @override
  _SliderHomeState createState() => _SliderHomeState();
}

class _SliderHomeState extends State<SliderHome> {
  BaseEndPoint network = NetworkProvider();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.deepPurple,
                  ),
                  Text(
                    "News Top Rated",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.deepPurple),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.list,
                  size: 15,
                  color: Colors.deepPurple,
                ),
              )
            ],
          ),
        ),
        Container(
          height: 300,
          child: FutureBuilder(
            future: network.getNews("getNews"),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? new ItemCarousel(list: snapshot.data)
                  : new Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
        )
      ],
    );
  }
}

class ItemCarousel extends StatelessWidget {
  List list;
  ItemCarousel({this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int index) {
          final Item data = list[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(10),
              width: 210,
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Positioned(
                    bottom: 15,
                    child: Container(
                      height: 120,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data.newsTitle,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            Text(
                              data.newsContent,
                              style: TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 3,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 2.0),
                              blurRadius: 6.0)
                        ]),
                    child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: data.newsImage,
                          child: ClipRRect(
                            child: Image(
                              height: 180,
                              width: 180,
                              image: NetworkImage(
                                  ConstantFile().imageUrl + data.newsImage),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          bottom: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 90,
                                height: 25,
                                child: RaisedButton(
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  color: Colors.deepPurple,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.keyboard_arrow_up,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Politic",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
