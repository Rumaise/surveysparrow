import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surveysparrow/frontend/homepage.dart';
import 'package:surveysparrow/frontend/register_user.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormState>();

  //variable for email and password

  String email = "";
  String password = "";

  //password visiblity

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width / 3.5,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 7,
                  // color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Welcome back!",
                        style: TextStyle(
                            color: Color.fromRGBO(38, 166, 154, 1),
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "sign in to your account.",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                  // color: Colors.blue,
                  width: MediaQuery.of(context).size.width / 2,
                  child: SafeArea(
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 30, right: 30, bottom: 10),
                                child: TextFormField(
                                  style: TextStyle(color: Colors.grey),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 2.0,
                                        ),
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                      prefixIcon: Padding(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 3),
                                        child: Icon(Icons.mail,
                                            color: Colors.grey),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      hintText: "Email",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0))),
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter your email' : null,
                                  onChanged: (val) {
                                    setState(() => email = (val));
                                  },
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 30, right: 30, bottom: 10),
                                child: TextFormField(
                                  style: TextStyle(color: Colors.grey),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 2.0,
                                        ),
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                      prefixIcon: Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, right: 5),
                                        child: Icon(Icons.lock,
                                            color: Colors.grey),
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: showHide,
                                        icon: Icon(_secureText
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      hintText: "Password",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0))),
                                  validator: (val) => val.length < 6
                                      ? 'Enter a password with more than 6 chars'
                                      : null,
                                  obscureText: _secureText,
                                  onChanged: (val) {
                                    setState(() => password = (val));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // color: Colors.red,
                  margin: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height / 6,
                  width: MediaQuery.of(context).size.width / 3,
                  // color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 17,
                          width: MediaQuery.of(context).size.width / 5,
                          child: RaisedButton(
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            color: Color.fromRGBO(38, 166, 154, 1),
                            onPressed: () {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password)
                                  .then((currentUser) => FirebaseFirestore
                                      .instance
                                      .collection("users")
                                      .doc(currentUser.user.uid)
                                      .get()
                                      .then((DocumentSnapshot result) =>
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(
                                                        uid: currentUser
                                                            .user.uid,
                                                        username: email,
                                                      ))))
                                      .catchError((err) => print(err)))
                                  .catchError((err) => print(err));
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterUser()));
                        },
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.grey),
                                text: "Don\'t have an account?",
                                children: <TextSpan>[
                              TextSpan(
                                text: ' Register here',
                                style: TextStyle(
                                  color: Color.fromRGBO(38, 166, 154, 1),
                                ),
                              )
                            ])),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
