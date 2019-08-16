import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quebra_cabeca/puzzle_piece.dart';

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
  final int rows = 3;
  final int cols = 3;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File _image;

  List<Widget> pieces = [];

  Future getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _image = image;
        pieces.clear();
      });
      splitImage(Image.file(image));
    }
  }

  // we need to find out the image size, to be used in the PuzzlePiece widget
  Future<Size> getImageSize(Image image) async {
    final Completer<Size> completer = Completer<Size>();

    image.image.resolve(const ImageConfiguration()).addListener(
          (ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      },
    );

    final Size imageSize = await completer.future;

    return imageSize;
  }

  // aqui dividiremos a imagem em pequenos pedaços usando as linhas e colunas definidas acima; Cada peça será adicionada a uma pilha...
  void splitImage(Image image) async {
    Size imageSize = await getImageSize(image);

    for (int x = 0; x < widget.rows; x++) {
      for (int y = 0; y < widget.cols; y++) {
        setState(() {
          pieces.add(PuzzlePiece(key: GlobalKey(),
              image: image,
              imageSize: imageSize,
              row: x,
              col: y,
              maxRow: widget.rows,
              maxCol: widget.cols));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: new Center(
          child: _image == null
            ? new Text('No image selected.')
            : Stack(children: pieces)
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
                         onTap: () {
                           getImage(ImageSource.camera);
                          // é assim que você descarta o modal bottom sheet depois de fazer uma escolha
                            Navigator.pop(context);
                         },
                       ),
                       new ListTile(
                         leading: new Icon(Icons.image),
                         title: new Text('Gallery'),
                         onTap: () {
                           getImage(ImageSource.gallery);
                           Navigator.pop(context);
                         }
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