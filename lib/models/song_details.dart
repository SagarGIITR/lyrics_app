class SongDetails {
  SongDetails({
    required this.message,
  });
  late final Message message;
  
  SongDetails.fromJson(Map<String, dynamic> json){
    message = Message.fromJson(json['message']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message.toJson();
    return _data;
  }
}

class Message {
  Message({
    required this.header,
    required this.body,
  });
  late final Header header;
  late final Body body;
  
  Message.fromJson(Map<String, dynamic> json){
    header = Header.fromJson(json['header']);
    body = Body.fromJson(json['body']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['header'] = header.toJson();
    _data['body'] = body.toJson();
    return _data;
  }
}

class Header {
  Header({
    required this.statusCode,
    required this.executeTime,
  });
  late final int statusCode;
  late final double executeTime;
  
  Header.fromJson(Map<String, dynamic> json){
    statusCode = json['status_code'];
    executeTime = json['execute_time'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status_code'] = statusCode;
    _data['execute_time'] = executeTime;
    return _data;
  }
}

class Body {
  Body({
    required this.track,
  });
  late final Track track;
  
  Body.fromJson(Map<String, dynamic> json){
    track = Track.fromJson(json['track']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['track'] = track.toJson();
    return _data;
  }
}

class Track {
  Track({
    required this.trackId,
    required this.trackName,
    required this.trackNameTranslationList,
    required this.trackRating,
    required this.commontrackId,
    required this.instrumental,
    required this.explicit,
    required this.hasLyrics,
    required this.hasSubtitles,
    required this.hasRichsync,
    required this.numFavourite,
    required this.albumId,
    required this.albumName,
    required this.artistId,
    required this.artistName,
    required this.trackShareUrl,
    required this.trackEditUrl,
    required this.restricted,
    required this.updatedTime,
    required this.primaryGenres,
  });
  late final int trackId;
  late final String trackName;
  late final List<dynamic> trackNameTranslationList;
  late final int trackRating;
  late final int commontrackId;
  late final int instrumental;
  late final int explicit;
  late final int hasLyrics;
  late final int hasSubtitles;
  late final int hasRichsync;
  late final int numFavourite;
  late final int albumId;
  late final String albumName;
  late final int artistId;
  late final String artistName;
  late final String trackShareUrl;
  late final String trackEditUrl;
  late final int restricted;
  late final String updatedTime;
  late final PrimaryGenres primaryGenres;
  
  Track.fromJson(Map<String, dynamic> json){
    trackId = json['track_id'];
    trackName = json['track_name'];
    trackNameTranslationList = List.castFrom<dynamic, dynamic>(json['track_name_translation_list']);
    trackRating = json['track_rating'];
    commontrackId = json['commontrack_id'];
    instrumental = json['instrumental'];
    explicit = json['explicit'];
    hasLyrics = json['has_lyrics'];
    hasSubtitles = json['has_subtitles'];
    hasRichsync = json['has_richsync'];
    numFavourite = json['num_favourite'];
    albumId = json['album_id'];
    albumName = json['album_name'];
    artistId = json['artist_id'];
    artistName = json['artist_name'];
    trackShareUrl = json['track_share_url'];
    trackEditUrl = json['track_edit_url'];
    restricted = json['restricted'];
    updatedTime = json['updated_time'];
    primaryGenres = PrimaryGenres.fromJson(json['primary_genres']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['track_id'] = trackId;
    _data['track_name'] = trackName;
    _data['track_name_translation_list'] = trackNameTranslationList;
    _data['track_rating'] = trackRating;
    _data['commontrack_id'] = commontrackId;
    _data['instrumental'] = instrumental;
    _data['explicit'] = explicit;
    _data['has_lyrics'] = hasLyrics;
    _data['has_subtitles'] = hasSubtitles;
    _data['has_richsync'] = hasRichsync;
    _data['num_favourite'] = numFavourite;
    _data['album_id'] = albumId;
    _data['album_name'] = albumName;
    _data['artist_id'] = artistId;
    _data['artist_name'] = artistName;
    _data['track_share_url'] = trackShareUrl;
    _data['track_edit_url'] = trackEditUrl;
    _data['restricted'] = restricted;
    _data['updated_time'] = updatedTime;
    _data['primary_genres'] = primaryGenres.toJson();
    return _data;
  }
}

class PrimaryGenres {
  PrimaryGenres({
    required this.musicGenreList,
  });
  late final List<dynamic> musicGenreList;
  
  PrimaryGenres.fromJson(Map<String, dynamic> json){
    musicGenreList = List.castFrom<dynamic, dynamic>(json['music_genre_list']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['music_genre_list'] = musicGenreList;
    return _data;
  }
}