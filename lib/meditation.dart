import 'package:flutter/material.dart';
import 'package:corculture_personal_growth/components/text_fields.dart';
import 'package:corculture_personal_growth/lessons.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class MeditationPage extends StatefulWidget {
  MeditationPage({Key? key}) : super(key: key);

  final String title = 'Meditation';

  @override
  _MeditationPageState createState() => _MeditationPageState();

  static AssetsAudioPlayer? player = null;
  static Playable gongAudio = Audio("assets/audio/gong_deep_single.ogg");

  static void initialize() {
    player = AssetsAudioPlayer.newPlayer();
  }

  static void playGong() {
    // TODO try https://pub.dev/packages/audio_service to play
    // in AndroidAlarmManager callback
    player?.open(gongAudio);
  }
}

class _MeditationPageState extends State<MeditationPage> {
  Lesson randomLesson = Lesson(
      title: 'Random lesson here',
      mdContent: '* some lesson\n* more lesson',
      path: 'random/lesson');

  void delayGong() {
    const int tmpAlarmID = 0;
    AndroidAlarmManager.oneShot(
        const Duration(seconds: 5),
        tmpAlarmID,
        MeditationPage.playGong);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lessons'),
      ),
      body: displayMarkdown(randomLesson),
      persistentFooterButtons: [
        ElevatedButton(
          child: new Icon(Icons.shuffle),
          onPressed: MeditationPage.playGong,
        ),
        ElevatedButton(
          child: new Icon(Icons.arrow_forward),
          onPressed: delayGong,
        ),
      ],
    );
  }
}