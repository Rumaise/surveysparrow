import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surveysparrow/frontend/homepage.dart';
import 'package:surveysparrow/frontend/login_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth_firebase = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  String username = '';
  String email = '';
  String password = '';
  String confirm_password = '';

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
                  child: ListView(children: <Widget>[
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
                            "Hey there!",
                            style: TextStyle(
                                color: Color.fromRGBO(38, 166, 154, 1),
                                fontSize: 35,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Let's set up your account.",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
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
                                          padding: EdgeInsets.only(
                                              left: 8, right: 3),
                                          child: Icon(Icons.person,
                                              color: Colors.grey),
                                        ),
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 15.0, 20.0, 15.0),
                                        hintText: "Name",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(32.0))),
                                    validator: (val) => val.isEmpty
                                        ? 'Enter your username'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => username = (val));
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
                                          padding: EdgeInsets.only(
                                              left: 8, right: 3),
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
                                          padding: EdgeInsets.only(
                                              left: 10, right: 5),
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
                                        hintText: "Set Password",
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
                                          padding: EdgeInsets.only(
                                              left: 10, right: 5),
                                          child: Icon(Icons.vpn_key,
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
                                        hintText: "Confirm Password",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(32.0))),
                                    validator: (val) => val.length < 6
                                        ? 'Enter a password with more than 6 chars'
                                        : null,
                                    obscureText: _secureText,
                                    onChanged: (val) {
                                      setState(() => confirm_password = (val));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 15,
                    ),
                    Container(
                      // color: Colors.red,
                      height: MediaQuery.of(context).size.height / 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 17,
                              width: MediaQuery.of(context).size.width / 5,
                              child: RaisedButton(
                                child: Center(
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                color: Color.fromRGBO(38, 166, 154, 1),
                                onPressed: () {
                                  auth_firebase
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password)
                                      .then((value) => firestore
                                              .collection("users")
                                              .doc(value.user.uid)
                                              .set({
                                            'name': username,
                                            'email': email,
                                            'password': password
                                          }));
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
                                      builder: (context) => LogInPage()));
                            },
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(color: Colors.grey),
                                    text: "Already have an account?",
                                    children: <TextSpan>[
                                  TextSpan(
                                    text: ' Sign In',
                                    style: TextStyle(
                                      color: Color.fromRGBO(38, 166, 154, 1),
                                    ),
                                  )
                                ])),
                          ),
                        ],
                      ),
                    ),
                  ])),
            )));
  }
}
