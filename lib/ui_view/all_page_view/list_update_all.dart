import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_flutterapps/model/model_news.dart';
import 'package:news_flutterapps/network/constantfile.dart';
import 'package:news_flutterapps/network/networkprovider.dart';
import 'package:news_flutterapps/page_ui/page_detail_news.dart';

class ListUpdate extends StatefulWidget {
  @override
  _ListUpdateState createState() => _ListUpdateState();
}

class _ListUpdateState extends State<ListUpdate> {
  BaseEndPoint network = NetworkProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    network.getNews("getNews");
  }

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
                    "News Update",
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
                  color: Colors.deepPurple,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 350,
          child: FutureBuilder(
            future: network.getNews("getNews"),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? new ItemUpdate(list: snapshot.data)
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

class ItemUpdate extends StatelessWidget {
  List list;
  ItemUpdate({this.list});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int index) {
          final Item data = list[index];
          return Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailNews(
                    detailId: data.newsId,
                    detailTitle: data.newsTitle,
                    detailContent: data.newsContent,
                    detailImage: data.newsImage,
                  )));
                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                ConstantFile().imageUrl + data.newsImage,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 100,
                                height: 25,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  color: Colors.deepPurple,
                                  onPressed: () {},
                                  child: Text(
                                    "Politic",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),

                              // Untuk Title
                              Text(
                                data.newsTitle,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),

                              // Untuk Content
                              Text(
                                data.newsContent,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 3,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
