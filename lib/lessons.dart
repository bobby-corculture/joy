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
  List<String> tags = [];
  Lesson({required this.mdContent, required this.path}) {
    tags = path.split("/");
  }
}

class _LessonsState extends State<Lessons> {
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
            _lessons.add(Lesson(mdContent: "Lesson loading", path:""));
            int q = i;
            rootBundle.loadString(key).then((_) {
              _lessons[q] = Lesson(mdContent: _, path: key);
            });
            ++i;
          });
        });
      });
      _lessons.add(Lesson(mdContent: 'assetManifest', path:"nowhere"));
      _lessons.add(Lesson(mdContent: "2 Could not find any lessons.", path:"void"));
      _lessons.add(Lesson(mdContent: "3 Could not find any lessons.", path:"void/nullspace"));
    }

    return _lessons;
  }

  Lesson currLesson() {
    _currLesson = _currLesson % lessons().length;
    return lessons()[_currLesson];
  }

  md.Markdown displayMarkdown(Lesson lesson){

    return md.Markdown(data: lesson.mdContent);
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

