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

class _MyHomePageState extends State<MyHomePage> {

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
      body:  new ListView.builder(
        itemBuilder: (BuildContext context, int index) => new EntryItem(data[index]),
        itemCount: data.length,
      ),
    );
  }
}


// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title);
  final String title;
}

final List<Entry> data = <Entry>[
  new Entry('Entry 1'),
  new Entry('Entry 2'),
  new Entry('Entry 3'),
  new Entry('Entry 4'),
  new Entry('Entry 5'),
  new Entry('Entry 6'),
  new Entry('Entry 7'),
  new Entry('Entry 8'),
  new Entry('Entry 9'),
  new Entry('Entry 10'),
  new Entry('Entry 11'),
  new Entry('Entry 12'),
  new Entry('Entry 13'),
  new Entry('Entry 14'),
  new Entry('Entry 15'),
  new Entry('Entry 16'),
  new Entry('Entry 17'),
  new Entry('Entry 18'),
  new Entry('Entry 19'),
  new Entry('Entry 20'),
];

class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    return new ListTile(
      key: new PageStorageKey<Entry>(root),
      title: new Text(root.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}