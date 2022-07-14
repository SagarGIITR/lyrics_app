import 'dart:async';
import 'package:lyrics_app/models/song_list.dart';
import 'package:lyrics_app/networking/response.dart';
import 'package:lyrics_app/networking/api_manager.dart';
import 'package:lyrics_app/constant/strings.dart';

class SongListBloc {
  final ApiManager _manager = ApiManager();

  final _songListController =
      StreamController<ResponseStatus<SongList>>.broadcast();

  StreamSink<ResponseStatus<SongList>> get songListSink =>
      _songListController.sink;
  Stream<ResponseStatus<SongList>> get songListStream =>
      _songListController.stream;

  SongListBloc() {
    fetchList();
  }

  fetchList() async {
    songListSink.add(ResponseStatus.loading('Loading list. '));
    try {
      SongList musicList = await fetchMusicListData();
      songListSink.add(ResponseStatus.completed(musicList));
    } catch (e) {
      songListSink.add(ResponseStatus.error(e.toString()));
      print(e);
    }
  }

  Future<SongList> fetchMusicListData() async {
    final response =
        await _manager.get("chart.tracks.get?apikey=${Strings.apikey}");
    return SongList.fromJson(response);
  }

  dispose() {
    _songListController.close();
  }
}
