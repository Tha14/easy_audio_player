import 'package:flutter/material.dart';
import 'package:easy_audio_player/widgets/play_list_View.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:easy_audio_player/services/audio_player_service.dart';
import 'package:easy_audio_player/widgets/buttons/control_buttons.dart';
import 'package:easy_audio_player/widgets/buttons/loop_button.dart';
import 'package:easy_audio_player/widgets/buttons/shuffle_button.dart';
import 'package:easy_audio_player/widgets/players/minimal_audio_player.dart';
import 'package:easy_audio_player/widgets/seekbar.dart';

class FullAudioPlayer extends StatelessWidget {
  const FullAudioPlayer({Key? key, required this.playlist, this.autoPlay = true}) : super(key: key);
  final ConcatenatingAudioSource playlist;
  final bool autoPlay;

  @override
  Widget build(BuildContext context) {
    final _audioPlayer = AudioPlayerService();
    return MinimalAudioPlayer(
      audioPlayer: _audioPlayer,
      autoPlay: autoPlay,
      playlist: playlist,
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<SequenceState?>(
              stream: _audioPlayer.player.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) return const SizedBox();
                final metadata = state!.currentSource!.tag as MediaItem;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: Image.network(metadata.artUri.toString()))),
                      ),
                    ),
                    //? title and album
                    Text(metadata.title, style: Theme.of(context).textTheme.titleLarge),
                    Text(metadata.album ?? ''),
                  ],
                );
              },
            ),
          ),
          ControlButtons(_audioPlayer.player),
          AudioPlayerSeekBar(audioPlayer: _audioPlayer),
          const SizedBox(height: 8.0),
          Row(
            children: [
              LoopButton(player: _audioPlayer.player),
              Expanded(
                child: Text(
                  "Playlist",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              ShuffleButton(player: _audioPlayer.player)
            ],
          ),
          PlaylistView(player: _audioPlayer.player, playlist: playlist)
        ],
      ),
    );
  }
}
