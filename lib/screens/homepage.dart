import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lyrics_app/blocs/connectivity_service.dart';
import 'package:lyrics_app/blocs/song_list_bloc.dart';
import 'package:lyrics_app/models/song_list.dart';
import 'package:lyrics_app/screens/detail_page.dart';

import '../networking/response.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ConnectivityService _connectivityService = ConnectivityService();
  final SongListBloc _listBloc = SongListBloc();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivityService.dispose();
    _listBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 5.0,
        centerTitle: true,
        title: const Text(
          'Lyrics App',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<ConnectivityResult>(
        stream:
            _connectivityService.connectivityResultStream.asBroadcastStream(),
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case ConnectivityResult.mobile:
            case ConnectivityResult.wifi:
              _listBloc.fetchList();
              return RefreshIndicator(
                onRefresh: () => _listBloc.fetchList(),
                child: StreamBuilder<ResponseStatus<SongList>>(
                  stream: _listBloc.songListStream.asBroadcastStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          return Loading(
                              loadingMessage: snapshot.data!.message);
                          break;
                        case Status.COMPLETED:
                          return MusicList(songList: snapshot.data!.data);
                          break;
                        case Status.ERROR:
                          break;
                      }
                    }
                    return Loading(loadingMessage: 'Connecting');
                  },
                ),
              );
              break;
            case ConnectivityResult.none:
              return const Center(
                child: Text('No internet'),
              );
              break;
            case ConnectivityResult.bluetooth:
              // TODO: Handle this case.
              break;
            case ConnectivityResult.ethernet:
              // TODO: Handle this case.
              break;
          }
          return Container();
        },
      ),
    );
  }
}

class MusicList extends StatelessWidget {
  final SongList songList;
  MusicList({required this.songList});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) {
          Track track = songList.message.body.trackList[index].track;
          return TrackTile(
            track: track,
          );
        },
        itemCount: songList.message.body.trackList.length,
        //shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;

  Loading({required this.loadingMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ],
      ),
    );
  }
}

class TrackTile extends StatelessWidget {
  final Track track;
  TrackTile({
    required this.track,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => DetailPage(
                    selectedTrack: track,
                  ))),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black26, width: 1.0),
            ),
          ),
          child: ListTile(
            leading: const Icon(Icons.library_music),
            title: Text(
              track.trackName,
            ),
            subtitle: Text(track.albumName),
            trailing: SizedBox(
              width: 110,
              child: Text(
                track.artistName,
                softWrap: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
