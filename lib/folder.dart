import 'package:flytrap_mobile/audio.dart';

class FullFolder {
  final AudioList audios;
  final FolderList folders;

  final FolderPreview previewMetadata;

  const FullFolder(
      {required this.audios,
      required this.folders,
      required this.previewMetadata});

  factory FullFolder.fromJson(Map<String, dynamic> json) => FullFolder(
      audios: AudioList.fromJson(json["audio"]),
      folders: FolderList.fromJson(json["folder"]),
      previewMetadata: FolderPreview.fromJson(json["root"]));
}

class FolderPreview {
  final String alphaId;
  final String name;

  FolderPreview({String? alphaId, String? name})
      : name = name ?? "Flytrap Audio",
        alphaId = alphaId ?? "";

  factory FolderPreview.fromJson(Map<String, dynamic> json) =>
      FolderPreview(alphaId: json["alpha_id"], name: json["folder_name"]);
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
