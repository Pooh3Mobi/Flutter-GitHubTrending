import 'dart:convert';
import 'dart:io';
import 'package:feedparser/feedparser.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();

}
class FeedStatus{
  FeedStatus(this.feed, this.msg);
  final List<Entry> feed;
  final String msg;
}
class _MyHomePageState extends State<MyHomePage> {
  var _result = new FeedStatus(null, "Loading");

  _MyHomePageState() {
    _getFeed();
  }

  _getFeed() async {
    var url = 'http://github-trends.ryotarai.info/rss/github_trends_java_daily.rss';
    var httpClient = new HttpClient();

    FeedStatus result;
    try {
      setState(() {
        _result = new FeedStatus(null, "Loading");
      });
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var rss = await response.transform(UTF8.decoder).join();
        Feed f = parse(rss, strict: false);
        List<FeedItem> items = f.items;
        List<Entry> entries = items
            .map(
                (i) => new Entry(
                i.title.split(" ")[0],
                i.description,
                i.link
            ))
            .toList();
        result = new FeedStatus(entries, null);
      } else {
        result = new FeedStatus(
            null,
            'Error getting rss feed:\nHttp status ${response.statusCode}'
        );
      }
    } catch (exception) {
      result = new FeedStatus(
          null,
          'Failed getting rss feed:\n' + exception.toString()
      );
    }

    print(result);
    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: _result.msg != null ?
      new Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  <Widget>[
              new Text(
                  _result.msg,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontFamily: "Rock Salt",
                    fontSize: 17.0,
                  )
              )
            ]
        ),
      ) :
      new ListView.builder(
        itemBuilder: (BuildContext context, int index) => new EntryItem(_result.feed[index], index),
        itemCount: _result.feed.length,
      ),
    );
  }
}


// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, this.description, this.link);
  final String title;
  final String description;
  final String link;
}

class EntryItem extends StatelessWidget {
  const EntryItem(this.entry, this.position);

  final Entry entry;
  final int position;

  Widget _buildTiles(Entry root, BuildContext context) {
    return new Container(
      height: 160.0,
      color: const Color(0x08000000),
      padding: new EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
      child: new Card(
        color: Colors.white,
        child: new ListTile(
//            leading: const Icon(Icons.account_circle),
          key: new PageStorageKey<Entry>(root),
          title: new Text("No.${position +1} ${root.title}"),
          subtitle: new Container(
              padding: new EdgeInsets.fromLTRB(16.0, 16.0, 4.0, 18.0),
              child: new Text("description:\n${root.description}")
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
              _launchURL(root.link);
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("You tapped # $position"),
            ));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry, context);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}