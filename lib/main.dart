import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Storage Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Firebase Storage Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseStorage storage;
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    storage = FirebaseStorage.instance;
  }

  Future<File> _downloadImage(String url) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String fileName = url.split('/').last;
    File file = File('$tempPath/$fileName');
    if (file.existsSync()) {
      return file;
    }
    final ref = storage.refFromURL(url);
    await ref.writeToFile(file);
    return file;
  }

  void _onButtonPressed() async {
    String url = "gs://image-f70ce.appspot.com/SELOGO.jpg";
    File file = await _downloadImage(url);
    setState(() {
      imageUrl = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _onButtonPressed,
              child: Text("Load Image"),
            ),
            SizedBox(height: 16.0),
            imageUrl != ""
                ? Image.file(
                    File(imageUrl),
                    width: 200.0,
                    height: 200.0,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
