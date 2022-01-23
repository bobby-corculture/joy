import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_service/audio_service.dart';

class AudioPlayerHandler extends BaseAudioHandler {
  final _player = AssetsAudioPlayer.newPlayer();
  final Playable gongAudio = Audio("assets/audio/gong_deep_single.ogg");
  static AudioHandler? _audioHandler = null;

  static Future<AudioHandler> instance() async {
    if (_audioHandler == null) {
      _audioHandler = await AudioService.init(
        builder: () => AudioPlayerHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'org.corculture.joy.audio',
          androidNotificationChannelName: 'Audio playback',
          androidNotificationOngoing: true,
        ),
      );
    }

    // the ?? should never be executed; I just didn't see a better way to do this in Dart
    return _audioHandler ?? AudioPlayerHandler();
  }
  @override
  Future<void> play() => _player.open(gongAudio);

  @override
  Future<void> pause() => _player.pause();
}