import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:link_text/link_text.dart';
// import 'package:shortid/shortid.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final String uid;
  final String username;
  HomePage({Key key, @required this.uid, this.username}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  String longUrl = '';
  String shortUrl = '';

  generateAndAdd(String urlLong, String uidUser) async {
    var url = "https://api.shrtco.de/v2/shorten?url=${urlLong}";
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    print(result);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uidUser)
        .collection("links")
        .doc()
        .set({
      'shortlink': result['result']['short_link'],
      'fullshortlink': result['result']['full_short_link'],
      'shortlink_2': result['result']['short_link2'],
      'fullshortlink_2': result['result']['full_short_link2'],
      'sharelink': result['result']['share_link'],
      'fullsharelink': result['result']['full_share_link'],
      'originallink': result['result']['original_link'],
      'time': DateTime.parse(Timestamp.now().toDate().toString())
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: Image.asset("assets/images/logo_sparrow.png"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              onPressed: () {
                // print(shortid.generate());
              })
        ],
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Stack(
            children: [
              Container(
                height: 200,
                color: Colors.grey,
              ),
              SizedBox(
                height: 20,
              ),
              new Container(
                alignment: Alignment.topCenter,
                padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .15,
                    right: 20.0,
                    left: 20.0),
                child: new Container(
                  height: 300.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  width: MediaQuery.of(context).size.width,
                  child: new Card(
                    color: Colors.white,
                    elevation: 4.0,
                    child: Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 16,
                          width: MediaQuery.of(context).size.width / 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              style: TextStyle(color: Colors.grey),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(left: 8, right: 3),
                                    child: Icon(Icons.link, color: Colors.grey),
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: "Enter Long URL",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
                              validator: (val) => val.isEmpty
                                  ? 'Enter long url you need to shorten'
                                  : null,
                              onChanged: (val) {
                                setState(() => longUrl = (val));
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 20,
                            width: MediaQuery.of(context).size.width / 6,
                            child: RaisedButton(
                              child: Center(
                                child: Text(
                                  "Generate URL",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              color: Color.fromRGBO(38, 166, 154, 1),
                              onPressed: () {
                                generateAndAdd(longUrl, widget.uid);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  // color: Colors.red,
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 2,
                        // color: Colors.white,
                        child: Card(
                          color: Colors.white,
                          elevation: 4.0,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.uid)
                                .collection("links")
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError)
                                return new Text('Error: ${snapshot.error}');
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return new Text('Loading...');
                                default:
                                  return new ListView(
                                    shrinkWrap: true,
                                    children: snapshot.data.docs
                                        .map((DocumentSnapshot document) {
                                      return Card(
                                        elevation: 5,
                                        child: new ListTile(
                                          leading: Icon(
                                            Icons.link,
                                            color:
                                                Color.fromRGBO(38, 166, 154, 1),
                                          ),
                                          title: Linkify(
                                            onOpen: (link) async {
                                              if (await canLaunch(link.url)) {
                                                await launch(link.url);
                                              } else {
                                                throw 'Could not launch $link';
                                              }
                                            },
                                            text:
                                                "ShortLink: ${document.get("fullshortlink")}",
                                            style:
                                                TextStyle(color: Colors.grey),
                                            linkStyle:
                                                TextStyle(color: Colors.green),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                RichText(
                                                    text: TextSpan(
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                        text: "OriginalLink:",
                                                        children: <TextSpan>[
                                                      TextSpan(
                                                        text: document.get(
                                                            "originallink"),
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              38, 166, 154, 1),
                                                        ),
                                                      )
                                                    ])),
                                                RichText(
                                                    text: TextSpan(
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                        text: "SharableLink:",
                                                        children: <TextSpan>[
                                                      TextSpan(
                                                        text: document
                                                            .get(
                                                                "fullsharelink")
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              38, 166, 154, 1),
                                                        ),
                                                      )
                                                    ])),
                                              ],
                                            ),
                                          ),
                                          trailing: IconButton(
                                              icon: Icon(
                                                Icons.content_copy,
                                                color: Color.fromRGBO(
                                                    38, 166, 154, 1),
                                              ),
                                              onPressed: () async {}),
                                        ),
                                      );
                                    }).toList(),
                                  );
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
