import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Puzzle',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Flutter Puzzle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: new Center(
          child: new Text('No image selected.'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           showModalBottomSheet(context: context,
               builder: (BuildContext context) {
                 return SafeArea(
                   child: new Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       new ListTile(
                         leading: new Icon(Icons.camera),
                         title: new Text('Camera'),
                         onTap: () => null,
                       ),
                       new ListTile(
                         leading: new Icon(Icons.image),
                         title: new Text('Gallery'),
                         onTap: () => null,
                       ),
                     ],
                   ),
                 );
               }
           );
         },
        tooltip: 'New Image',
        child: Icon(Icons.add),
      ),
    );
  }
}