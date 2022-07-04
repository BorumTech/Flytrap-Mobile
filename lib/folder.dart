import 'package:flytrap_mobile/audio.dart';

class FullFolder {
  final AudioList audios;
  final FolderList folders;

  const FullFolder({required this.audios, required this.folders});

  factory FullFolder.fromJson(Map<String, dynamic> json) => FullFolder(
        audios: AudioList.fromJson(json["audio"]),
        folders: FolderList.fromJson(json["folder"]),
      );
}

class FolderPreview {
  static final _defaultDate = DateTime(2019);

  final String alphaId;
  final String name;
  final DateTime timeCreated;

  FolderPreview({
    required this.alphaId,
    required this.name,
    required this.timeCreated,
  });

  factory FolderPreview.root() => FolderPreview(
      alphaId: "", name: "Flytrap Audio", timeCreated: _defaultDate);

  factory FolderPreview.fromJson(Map<String, dynamic> json) => FolderPreview(
      alphaId: json["alpha_id"],
      name: json["folder_name"],
      timeCreated: json["time_created"] != null
          ? DateTime.parse(json["time_created"])
          : DateTime.now());
}

class FolderList {
  List<FolderPreview> folders;

  int get length => folders.length;

  FolderList({required this.folders});

  factory FolderList.fromJson(Map<String, dynamic> json) {
    FolderList folderList = FolderList(folders: []);
    for (var folder in json["data"]) {
      folderList.folders.add(FolderPreview.fromJson(folder));
    }
    return folderList;
  }
}
