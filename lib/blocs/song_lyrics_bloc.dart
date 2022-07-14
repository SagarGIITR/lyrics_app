import 'dart:async';
import 'package:lyrics_app/networking/response.dart';
import 'package:lyrics_app/models/song_lyrics.dart';
import 'package:lyrics_app/constant/strings.dart';
import 'package:lyrics_app/networking/api_manager.dart';

class SongLyricsBloc {
  late final StreamController<ResponseStatus<SongLyrics>> _songLyricsController;
  final ApiManager _provider = ApiManager();
  final int trackId;

  StreamSink<ResponseStatus<SongLyrics>> get songLyricsSink =>
      _songLyricsController.sink;
  Stream<ResponseStatus<SongLyrics>> get songLyricsStream =>
      _songLyricsController.stream;

  SongLyricsBloc({required this.trackId}) {
    _songLyricsController =
        StreamController<ResponseStatus<SongLyrics>>.broadcast();
    fetchSongLyrics();
  }
  fetchSongLyrics() async {
    songLyricsSink.add(ResponseStatus.loading('Loading lyrics'));
    try {
      SongLyrics musicLyrics = await fetchSongLyricsData(trackId);
      songLyricsSink.add(ResponseStatus.completed(musicLyrics));
    } catch (e) {
      songLyricsSink.add(ResponseStatus.error(e.toString()));
      print(e);
    }
  }

  Future<SongLyrics> fetchSongLyricsData(int trackId) async {
    final response = await _provider
        .get("track.lyrics.get?track_id=$trackId&apikey=${Strings.apikey}");
    return SongLyrics.fromJson(response);
  }

  dispose() {
    _songLyricsController.close();
  }
}
