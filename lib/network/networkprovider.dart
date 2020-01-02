import 'dart:io';
import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:news_flutterapps/model/model_news.dart';
import 'package:news_flutterapps/network/constantfile.dart';

abstract class BaseEndPoint {
  Future<List> getNews(String endpoint);
  Future<List> getCulinary(String endpoint);
  Future<List> getSport(String endpoint);
  Future<List> getTravel(String endpoint);
  Future<Null> updateNews(String id, String titleNews);
  Future<Null> updateImage(File image, String idNews);
  Future<Null> deleteData(String id);
  Future<Null> saveData(File image, String title, String content);
  Future<String> loginUser(String email, String password);
  Future<String> registerUser(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> sendEmailVerification();
  Future<void> signOut();
  Future<bool> isEmailVerified();
}

final _firebaseAuth = FirebaseAuth.instance;

class NetworkProvider implements BaseEndPoint {
  @override
  Future<List<Item>> getCulinary(String endpoint) async {
    // TODO: implement getCulinary
    final response = await http.get(ConstantFile().baseUrl + endpoint);
    ResultNews data = resultNewsFromJson(response.body);
    return data.item;
  }

  @override
  Future<List<Item>> getNews(String endpoint) async {
    // TODO: implement getNews
    final response = await http.get(ConstantFile().baseUrl + endpoint);
    ResultNews data = resultNewsFromJson(response.body);
    return data.item;
  }

  @override
  Future<List<Item>> getSport(String endpoint) async {
    // TODO: implement getSport
    final response = await http.get(ConstantFile().baseUrl + endpoint);
    ResultNews data = resultNewsFromJson(response.body);
    return data.item;
  }

  @override
  Future<List<Item>> getTravel(String endpoint) async {
    // TODO: implement getTravel
    final response = await http.get(ConstantFile().baseUrl + endpoint);
    ResultNews data = resultNewsFromJson(response.body);
    return data.item;
  }

  @override
  Future<Null> updateImage(File image, String idNews) async {
    // TODO: implement updateImage

    //open byte stream
    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));

    // get file length
    var length = await image.length();

    //string url
    var url = Uri.parse(ConstantFile().baseUrl + "changeImage");
    var request = new http.MultipartRequest('POST', url);
    var multipart = new http.MultipartFile('userfile', stream, length,
        filename: image.path);
    request.files.add(multipart);
    request.fields['id'] = idNews;

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }
    return response.statusCode;
  }

  @override
  Future<Null> updateNews(String id, String titleNews) async {
    final response = await http.post(ConstantFile().baseUrl + "updateNews",
        body: {"idnews": id, "titlenews": titleNews});
    return response.statusCode;
  }

  @override
  Future<Null> deleteData(String id) async {
    final response = await http
        .post(ConstantFile().baseUrl + "deleteNews", body: {'id': id});
    return response.statusCode;
  }

  @override
  Future<Null> saveData(File image, String title, String content) async {
    // TODO: implement saveData

    //open byte stream
    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));

    // get file length
    var length = await image.length();

    //string url
    var url = Uri.parse(ConstantFile().baseUrl + "addNews");
    var request = new http.MultipartRequest('POST', url);
    var multipart = new http.MultipartFile('userfile', stream, length,
        filename: image.path);
    request.files.add(multipart);
    request.fields['title'] = title;
    request.fields['content'] = content;

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }

    return null;
  }

  @override
  Future<FirebaseUser> getCurrentUser() async {
    // TODO: implement getCurrentUser
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Future<bool> isEmailVerified() async {
    // TODO: implement isEmailVerified
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  @override
  Future<String> loginUser(String email, String password) async {
    // TODO: implement loginUser
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  @override
  Future<String> registerUser( String email, String password) async{
    // TODO: implement registerUser
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email
        , password: password)).user;
    return user.uid;
  }

  @override
  Future<void> sendEmailVerification() async{
    // TODO: implement sendEmailVerification
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    return _firebaseAuth.signOut();
  }
}
