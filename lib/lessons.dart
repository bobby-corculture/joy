import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;
import 'package:logger/logger.dart';
import 'package:json_annotation/json_annotation.dart';

class Lessons extends StatefulWidget {

  const Lessons({Key? key}) : super(key: key);

  @override
  State<Lessons> createState() => _LessonsState();
}

class Lesson {
  String mdContent;
  String path;
  String? title;
  List<String> tags = [];
  Lesson({this.title, required this.mdContent, required this.path}) {
    tags = path.split("/");
  }
}

class _LessonsState extends State<Lessons> {
  // static RegExp mdRE = RegExp(r"^---.*\n((.|\n)*?)\n---.*\n((.|\n)*)", multiLine: true);
  static RegExp mdRE = RegExp(r"^---(?:\s|\n)*$((?:.|\r|\n)*)^---(?:\s|\n)*$((?:.|\r|\n)*)", multiLine: true);
  static List<Lesson> _lessons = [];
  static Random random = Random();

  int _currLesson = 0;

  List<Lesson> lessons() {
    if (_lessons.isEmpty) {
      // TODO read all lessons from assets
      //  DefaultAssetBundle.of(context).loadString
      //         ("assets/manual/" + file)
      rootBundle.loadString('AssetManifest.json').then((_) {
        setState(() {
          _lessons = [];
          Map assets = jsonDecode(_);
          int i = 0;
          assets.forEach((key, value) {
            if (key.toString().startsWith("assets/lessons/")) {
              _lessons.add(Lesson(title: "Lesson loading", mdContent: "Lesson loading", path:""));
              int q = i;
              rootBundle.loadString(key).then((_) {
                var match = mdRE.firstMatch(_);
                Map headers = Map.fromIterable(
                    match?.group(1)?.split('\r?\n').map((_) => _.split(':')) ?? [],
                    key: (_) => _[0],
                    value: (_) => _[1]);
                _lessons[q] = Lesson(title: headers['title'], mdContent: match?.group(2) ?? "Could not parse lesson", path: key);
              });
              ++i;
            }
          });
        });
      });
      _lessons.add(Lesson(title: "Asset Manifest", mdContent: 'assetManifest', path:"nowhere"));
    }

    return _lessons;
  }

  Lesson currLesson() {
    _currLesson = _currLesson % lessons().length;
    return lessons()[_currLesson];
  }

  Widget displayMarkdown(Lesson lesson){
    var style = md.MarkdownStyleSheet(
      textAlign: WrapAlignment.center,
      h1Align: WrapAlignment.center,
    );
    // Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    return md.Markdown(styleSheet: style, data: lesson.mdContent);
  }

  void shuffle() {
    setState(() {
      _currLesson = random.nextInt(lessons().length);
    });
  }

  void previous() {
    setState(() {
      --_currLesson;
    });
  }

  void next() {
    setState(() {
      ++_currLesson;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lessons'),
      ),
      body: displayMarkdown(currLesson()),
      persistentFooterButtons: [
        ElevatedButton(
          child: new Icon(Icons.shuffle),
          onPressed: shuffle,
        ),
        ElevatedButton(
          child: new Icon(Icons.arrow_back),
          onPressed: previous,
        ),
        ElevatedButton(
          child: new Icon(Icons.arrow_forward),
          onPressed: next,
        ),
      ],
    );
  }
}

