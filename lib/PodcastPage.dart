import 'dart:async';
import 'dart:convert' show json;

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/NewsTabs.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;

import 'EventsTabs.dart';


class HomePage extends StatefulWidget {

  final String url;

  const HomePage({Key key, this.url}) : super(key: key);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  List data;
  int _currentIndex = 0;

  //Map<int, List> _saved = new Map();

  Future<String> getData() async {
    try {
      var response = await http.get(widget.url);
      this.setState(() {
        print(widget.url);
        Map decoded = json.decode(response.body);
        data = decoded['feeds'];
      });
      return "Success!";
    }
    catch (e) {
      return "No Internet";
      //return new SnackBar(content: new Text("No Internet Connectivity"),duration: ,new Duration(seconds: 5));
    }
  }

  bool isInternetConnectivity() {
    var connectivityResult = new Connectivity()
        .checkConnectivity(); // User defined class
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(child: new ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
                margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                elevation: 4.0,
                child: new Column(
                    children: <Widget>[
                      new Container(
                        padding: new EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 8.0),
                        child: new InkWell(
                          onTap: () =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                  new WebviewScaffold(url:
                                  (data[index]['feed']['url']),
                                    appBar: new AppBar(title: new Text(
                                        data[index]["feed"]["title"])),
                                  ))
                              ),
                          child: new Wrap(
                            spacing: 8.0,
                            // gap between adjacent chips
                            runSpacing: 4.0,
                            // gap between lines
                            direction: Axis.horizontal,
                            // main axis (rows or columns)

                            children: <Widget>[
                              new Container(
                                  height: 16.0),

                              new Text(data[index]['feed']["title"],
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold),),

                              data[index]["feed"]["small_feed_image_url"] ==
                                  null
                                  ? new Container(
                                //  height: 50.0,
                                  decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                        image: new AssetImage(
                                            'assets/podcastImage.jpg'),
                                        fit: BoxFit.fitWidth),
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(16.0)),
                                    border: new Border.all(
                                      color: Colors.pinkAccent,
                                      width: 2.0,
                                    ),
                                  ))

                                  : new Container(
//                                    height: 250.0,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new NetworkImage(
                                        data[index]["feed"]["small_feed_image_url"]),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(16.0)),
                                ),
                                constraints: BoxConstraints(
                                    maxHeight: 250.0,
                                    minHeight: 100.0,
                                    minWidth: 300.0
                                ),
                              ),

                              new Container(
                                height: 16.0,
                              ),

                              new Text(data[index]['feed']["description"],
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold),),

                            ],

                          ),

                        ),
                      ),
                      new Container(
                        height: 16.0,
                      ),

//                        new Container(
//                            child: Row(
//                                mainAxisAlignment: MainAxisAlignment
//                                    .spaceEvenly,
//
//                                children: [
//                                  new Icon(Icons.share),
//                                  new InkWell(
//                                    onTap: () {
//                                      setState(() {
//                                        if (_saved.containsKey(index)) {
//                                          _saved.remove(index);
//                                          print(data[index]["url" +
//                                              "was  there"]);
//                                        } else {
//                                          _saved[index] = data[index][""]; //  _alreadySaved[index] = true;
//                                        }
//                                      });
//                                    },
//                                    child: new Icon(
//                                      _saved.containsKey(index)
//                                          ? Icons.favorite
//                                          : Icons
//                                          .favorite_border,
//                                      color: _saved.containsKey(index) ? Colors
//                                          .red : null,),
//
//                                  )
//                                ]
//                            )
//                        ),
                      new Container(
                        height: 16.0,
                      )
                    ]
                )

            );
          }
      )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) =>
            setState(() {
              _currentIndex = newIndex;
              switch (_currentIndex) {
                case 0:
                  null;
                  break;
                case 1:
                  print("In the newstabs");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsTabs()),
                  );
                  break;
                case 2:
                  print("In the eventstabs");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventsTabs()),
                  );
                  break;
              }
              print(_currentIndex);
            }),
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.search),
              title: new Text('Search'),
              backgroundColor: Colors.blue

          ),

          BottomNavigationBarItem(
              icon: new Icon(Icons.book),
              title: new Text('News'),
              backgroundColor: Colors.blue
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.event),
              title: Text('Events'),
              backgroundColor: Colors.blue

          ),
        ],
      ),

    );
  }

  void _navigatePage(context, index) {

  }
}