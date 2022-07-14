import 'dart:async';
import 'package:lyrics_app/constant/strings.dart';
import 'package:lyrics_app/models/song_details.dart';
import 'package:lyrics_app/networking/response.dart';
import 'package:lyrics_app/networking/api_manager.dart';

class SongDetailBloc {
  late final StreamController<ResponseStatus<SongDetails>> _songDetailController;
  final ApiManager _provider = ApiManager();
  int trackId;
  StreamSink<ResponseStatus<SongDetails>> get SongDetailSink =>
      _songDetailController.sink;

  Stream<ResponseStatus<SongDetails>> get songDetailStream =>
      _songDetailController.stream;

  SongDetailBloc({required this.trackId}) {
    _songDetailController =
        StreamController<ResponseStatus<SongDetails>>.broadcast();
  }

  fetchSongDetails() async {
    SongDetailSink.add(ResponseStatus.loading('Loading'));
    try {
      SongDetails songDetails = await fetchSongDetailsData(trackId);
      SongDetailSink.add(ResponseStatus.completed(songDetails));
    } catch (error) {
      SongDetailSink.add(ResponseStatus.error(error.toString()));
      print(error);
    }
  }

  Future<SongDetails> fetchSongDetailsData(int trackId) async {
    final response = await _provider
        .get("track.get?track_id=$trackId&apikey=${Strings.apikey}");
    return SongDetails.fromJson(response);
  }

  dispose() {
    _songDetailController.close();
  }
}
