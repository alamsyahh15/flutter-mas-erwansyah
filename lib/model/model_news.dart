// To parse this JSON data, do
//
//     final resultNews = resultNewsFromJson(jsonString);

import 'dart:convert';

ResultNews resultNewsFromJson(String str) => ResultNews.fromJson(json.decode(str));

String resultNewsToJson(ResultNews data) => json.encode(data.toJson());

class ResultNews {
  String message;
  int status;
  List<Item> item;

  ResultNews({
    this.message,
    this.status,
    this.item,
  });

  factory ResultNews.fromJson(Map<String, dynamic> json) => ResultNews(
    message: json["message"],
    status: json["status"],
    item: List<Item>.from(json["item"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "item": List<dynamic>.from(item.map((x) => x.toJson())),
  };
}

class Item {
  String newsId;
  String newsTitle;
  String newsContent;
  String newsImage;
  String newsCategory;

  Item({
    this.newsId,
    this.newsTitle,
    this.newsContent,
    this.newsImage,
    this.newsCategory,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    newsId: json["news_id"],
    newsTitle: json["news_title"],
    newsContent: json["news_content"],
    newsImage: json["news_image"],
    newsCategory: json["news_category"],
  );

  Map<String, dynamic> toJson() => {
    "news_id": newsId,
    "news_title": newsTitle,
    "news_content": newsContent,
    "news_image": newsImage,
    "news_category": newsCategory,
  };
}
