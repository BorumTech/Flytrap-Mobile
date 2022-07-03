class Audio {
  final String alphaId;
  final String name;
  final DateTime timeCreated;

  const Audio({
    required this.alphaId,
    required this.name,
    required this.timeCreated,
  });

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
        alphaId: json["alpha_id"],
        name: json["file_name"],
        timeCreated: DateTime.parse(json["time_created"]),
      );
}

class AudioList {
  List<Audio> audios;

  get length => audios.length;

  AudioList({required this.audios});

  factory AudioList.fromJson(Map<String, dynamic> json) {
    AudioList audioList = AudioList(audios: []);
    for (var audio in json["data"]) {
      audioList.audios.add(Audio.fromJson(audio));
    }
    return audioList;
  }
}
