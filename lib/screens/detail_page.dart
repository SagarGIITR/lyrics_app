import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lyrics_app/models/song_details.dart';
import 'package:lyrics_app/models/song_lyrics.dart';
import 'package:lyrics_app/models/song_list.dart' as ListSong;
import 'package:lyrics_app/networking/response.dart';
import 'package:lyrics_app/screens/homepage.dart';
import 'package:lyrics_app/blocs/song_detail_bloc.dart';
import 'package:lyrics_app/blocs/connectivity_service.dart';

import '../blocs/song_lyrics_bloc.dart';

class DetailPage extends StatefulWidget {
  final ListSong.Track selectedTrack;

  DetailPage({required this.selectedTrack});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final ConnectivityService _connectivityService;
  late final SongDetailBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connectivityService = ConnectivityService();
    _bloc = SongDetailBloc(trackId: widget.selectedTrack.trackId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5.0,
        centerTitle: true,
        title: const Text(
          'Track Details',
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
            if (snapshot.hasData) {
              switch (snapshot.data) {
                case ConnectivityResult.mobile:
                case ConnectivityResult.wifi:
                  _bloc.fetchSongDetails();
                  //print('NET2 : ');
                  return RefreshIndicator(
                    onRefresh: () => _bloc.fetchSongDetails(),
                    child: StreamBuilder<ResponseStatus<SongDetails>>(
                      stream: _bloc.songDetailStream.asBroadcastStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data!.status) {
                            case Status.LOADING:
                              return Loading(
                                loadingMessage: snapshot.data!.message,
                              );
                              break;
                            case Status.COMPLETED:
                              return TrackDetails(
                                songDetails: snapshot.data!.data,
                                trackId: widget.selectedTrack.trackId,
                              );
                              break;
                            case Status.ERROR:
                              return const Text('Errror');
                              break;
                          }
                        }
                        return Loading(
                          loadingMessage: 'Connecting',
                        );
                      },
                    ),
                  );
                  break;
                case ConnectivityResult.none:
                  //print('No Net : ');
                  return const Center(
                    child: Text('No internet'),
                  );
                  break;
              }
            }
            return Text('Check Connectivity object');
          }),
    );
  }
}

class TrackDetails extends StatefulWidget {
  final SongDetails songDetails;
  final int trackId;
  TrackDetails({required this.songDetails, required this.trackId});

  @override
  _TrackDetailsState createState() => _TrackDetailsState();
}

class _TrackDetailsState extends State<TrackDetails> {
  late final SongLyricsBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = SongLyricsBloc(trackId: widget.trackId);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Track track = widget.songDetails.message.body.track;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: <Widget>[
          InfoTile(
            heading: 'Name',
            body: track.trackName,
          ),
          InfoTile(
            heading: 'Artist',
            body: track.artistName,
          ),
          InfoTile(
            heading: 'Album Name',
            body: track.albumName,
          ),
          InfoTile(
            heading: 'Explicit',
            body: track.explicit == 1 ? 'True' : 'False',
          ),
          InfoTile(
            heading: 'Rating',
            body: track.trackRating.toString(),
          ),
          StreamBuilder<ResponseStatus<SongLyrics>>(
              stream: _bloc.songLyricsStream.asBroadcastStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status) {
                    case Status.LOADING:
                      return Loading(
                        loadingMessage: snapshot.data!.message,
                      );
                      break;
                    case Status.COMPLETED:
                      return InfoTile(
                        heading: 'Lyrics',
                        body:
                            snapshot.data!.data.message.body.lyrics.lyricsBody,
                      );
                      break;
                    case Status.ERROR:
                      break;
                  }
                }
                return Loading(
                  loadingMessage: '',
                );
              })
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String heading;
  final String body;
  InfoTile({required this.heading, required this.body});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(
          height: 15.0,
        ),
        Text(
          heading,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
        ),
        Text(
          body,
          style: const TextStyle(fontSize: 20.0),
        ),
      ],
    );
  }
}
