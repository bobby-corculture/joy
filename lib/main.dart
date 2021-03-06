import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:corculture_personal_growth/meditation.dart';
import 'package:corculture_personal_growth/lessons.dart';
import 'package:corculture_personal_growth/email.dart';
import 'package:corculture_personal_growth/audio_handler.dart';

late AudioHandler audioHandler; // singleton.

Future<void> main() async {
  // initialize flutter bindings before trying to init AndroidAlarmManager
  WidgetsFlutterBinding.ensureInitialized();
  await AudioPlayerHandler.instance();
  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joy',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Joy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VoidCallback navigationPusher(Widget widget) {
    return () {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget),
        );
    };
  }

  void todo() {
  }

  Widget makeButton({required VoidCallback onPressed, required Widget child}) {
    return ElevatedButton(
      onPressed: () => setState(() => onPressed()),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _doubleCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            makeButton(
              onPressed: navigationPusher(const Lessons()),
              child: const Text('Lessons'),
            ),
            Spacer(),
            makeButton(
              onPressed: navigationPusher(MeditationPage()),
              child: const Text('Meditate'),
            ),
            Spacer(),
            makeButton(
              onPressed: todo,
              child: const Text('Report'),
            ),
            Spacer(),
            makeButton(
              onPressed: todo,
              child: const Text('Manage mood'),
            ),
            Spacer(),
            makeButton(
              onPressed: todo,
              child: const Text('Find local help'),
            ),
            Spacer(),
            makeButton(
              onPressed: todo,
              child: const Text('Offer local help'),
            ),
            Spacer(),
            makeButton(
              onPressed: todo,
              child: const Text('Donate'),
            ),
            Spacer(),
            makeButton(
              onPressed: navigationPusher(FeedBackPage()),
              child: const Text('Contact us'),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
