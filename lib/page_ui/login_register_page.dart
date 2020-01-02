import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:news_flutterapps/network/networkprovider.dart';
import 'package:news_flutterapps/page_ui/page_home.dart';
import 'package:news_flutterapps/ui_view/login_register_view/clipper_view.dart';

class LoginRegisterPage extends StatefulWidget {
  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  BaseEndPoint network = NetworkProvider();
  String email;
  String password;
  String name;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var myToken = "";
  var myMap = {};
  var title = '';
  var body = "";


  String userId = "";
  //login and register fuctions

  void _loginUser() async {


    userId = await network.loginUser(
        _emailController.text, _passwordController.text);
    if (userId.length == 0 && _emailController.text == null) {
//      _showDialogError();
    print("gagal");
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PageHome()));
    }
    print("user sign id : $userId");
    _emailController.clear();
    _passwordController.clear();
  }

  void _registerUser() async {
    name = _nameController.text;
    email = _emailController.text;
    password = _passwordController.text;

    userId = await network.registerUser(email, password);
    network.sendEmailVerification();

    // saveData(teks, email, displayName, uid)
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
  }


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();





  Widget _input(Icon icon, String hint, TextEditingController controller,
      bool obsecure, TextInputType inputType) {
    return Container(
      padding: EdgeInsets.only(left: 20,right: 20),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        obscureText: obsecure,
        style: TextStyle(
          fontSize: 20,
        ),
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 20, fontWeight:  FontWeight.bold),
          hintText: hint,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2
            )
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 3
              )
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 30,right: 10),
            child: IconTheme(
              child: icon,
              data: IconThemeData(color: Theme.of(context).primaryColor),
            ),
          )
        ),
      ),
    );
  }

  Widget _button(String text, Color splashColor, Color highlightColor,
      Color fillColor, Color textColor, void function()) {
    return RaisedButton(
      onPressed: () {
        function();
      },
      highlightElevation: 0.0,
      splashColor: splashColor,
      highlightColor: highlightColor,
      elevation: 0.0,
      color: fillColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }

  Widget logo() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 220,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                child: Align(
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    width: 150,
                    height: 150,
                  ),
                ),
                height: 154,
              ),
            ),
            Positioned(
              child: Container(
                height: 154,
                child: Align(
                  child: Text(
                    "AN",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 92,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.width * 0.15,
              bottom: MediaQuery.of(context).size.width * 0.046,
              right: MediaQuery.of(context).size.width * 0.22,
              child: Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width * 0.08,
              height: MediaQuery.of(context).size.width * 0.08,
              bottom: 0,
              right: MediaQuery.of(context).size.width * 0.32,
              child: Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var android = AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var platform  = InitializationSettings(android,ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async{
        print("on message $message");

        // Jadikan myMap sebagai message
        myMap = message;
        displayNotification(message);
      },
      onResume: (Map<String, dynamic> message) async{
        print("on resume $message");
      },
      onLaunch: (Map<String, dynamic> message) async{
        print("on launch $message");
      },

    );


    _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true,alert: true, badge: true)
    );

    _firebaseMessaging.getToken().then((token){
      updateToken(token);
      print(token);
      myToken = token;
    });
  }

  displayNotification(Map<String, dynamic>message)async{
    var android = new AndroidNotificationDetails("1", "channelName", "channelDescription");
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    message.forEach((nTitle,nBody){
      title = nTitle;
      body = nBody;
    });
    await flutterLocalNotificationsPlugin.show(0,
        message['notification']['title'],
        message['notification']['body'],
        platform);
  }
  void updateToken(String token){
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/$token').set({"token": token});
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;

    void _loginSheet() {
      _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 10,
                          top: 10,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    height: 50,
                    width: 50,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 140,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                child: Align(
                                  child: Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  child: Text("LOGIN",
                                      style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  alignment: Alignment.center,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20, top: 20),
                          child: _input(
                            Icon(Icons.email),
                            "EMAIL",
                            _emailController,
                            false,
                            TextInputType.emailAddress,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: _input(
                            Icon(Icons.lock),
                            "PASSWORD",
                            _passwordController,
                            false,
                            TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Container(
                            child: _button("LOGIN", Colors.white, primary,
                                primary, Colors.white, _loginUser),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height / 1.1,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
        );
      });
    }

    void _registerSheet() {
      _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 10,
                          top: 10,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    height: 50,
                    width: 50,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 140,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                child: Align(
                                  child: Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  padding:
                                      EdgeInsets.only(bottom: 25, right: 40),
                                  child: Text("REGI",
                                      style: TextStyle(
                                          fontSize: 44,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  alignment: Alignment.center,
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  width: 130,
                                  padding: EdgeInsets.only(top: 40, left: 28),
                                  child: Text("STER",
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  alignment: Alignment.center,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20, top: 60),
                          child: _input(
                            Icon(Icons.email),
                            "DISPLAY NAME",
                            _nameController,
                            false,
                            TextInputType.emailAddress,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: _input(
                            Icon(Icons.email),
                            "EMAIL",
                            _emailController,
                            false,
                            TextInputType.emailAddress,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: _input(
                            Icon(Icons.lock),
                            "PASSWORD",
                            _passwordController,
                            false,
                            TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Container(
                            child: _button("REGISTER", Colors.white, primary,
                                primary, Colors.white, _registerUser),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height / 1.1,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
        );
      });
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          logo(),
          Center(
            child: Text(
              myToken,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 80, left: 20, right: 20),
            child: Container(
              height: 50,
              child: _button("Login", primary, Colors.white, Colors.white,
                  primary, _loginSheet),
            ),
          ),
          Padding(
            child: Container(
              child: OutlineButton(
                onPressed: () {
                  _registerSheet();
                },
                highlightedBorderColor: Colors.white,
                borderSide: BorderSide(color: Colors.white, width: 2.0),
                highlightColor: Theme.of(context).primaryColor,
                splashColor: Colors.white,
                highlightElevation: 0.0,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Text(
                  "Register",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              height: 50,
            ),
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          ),
          Expanded(
            child: Align(
              child: ClipPath(
                child: Container(
                  color: Colors.white,
                  height: 300,
                ),
                clipper: BottomWaveClipper(),
              ),
              alignment: Alignment.bottomCenter,
            ),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }
}
