import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flytrap_mobile/audio.dart';
import 'package:flytrap_mobile/folder.dart';
import 'package:flytrap_mobile/stage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const routeHome = '/';
const routeSettings = '/settings';
const routePrefixFolders = '/folders/';
const routePrefixAudios = '/audio/';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flytrap Audio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CurrentPage(),
    );
  }
}

class _CurrentPageState extends State<CurrentPage> {
  var _currentIndex = 0;

  late final screens = [
    FolderPage(preview: FolderPreview.root()),
    const MyRoomsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (index) {
          // debugPrint("index: $index");
          setState(() => _currentIndex = index);
          // _navigatorKey.currentState!
          //     .pushNamedAndRemoveUntil(screens[index], (route) => false);
          // debugPrint("Navigated to ${screens[index]}");
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: 'Live Broadcasts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class CurrentPage extends StatefulWidget {
  const CurrentPage({Key? key}) : super(key: key);

  @override
  State<CurrentPage> createState() => _CurrentPageState();
}

class FolderPage extends StatefulWidget {
  const FolderPage({super.key, required this.preview});

  final FolderPreview preview;

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  late Future<FullFolder> folderData;
  late Future<FolderList> folderList;
  late Future<AudioList> audioList;

  Future<FullFolder> fetchFolder() async {
    final response = await http.get(
      Uri.parse(
          'https://api.audio.borumtech.com/v1/folder?folder_id=${widget.preview.alphaId}'),
      headers: {
        HttpHeaders.authorizationHeader:
            'Basic f590aaf962d6460fb0218dbf270f1877',
      },
    );

    if (response.statusCode == 200) {
      debugPrint("Response: ${response.body}");
      return FullFolder.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to load files: ${jsonDecode(response.body)["error"]["message"]}');
    }
  }

  @override
  void initState() {
    super.initState();
    folderData = fetchFolder();
    folderList = folderData.then((folder) => folder.folders);
    audioList = folderData.then((folder) => folder.audios);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.preview.name,
          textAlign: TextAlign.center,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            folderData = fetchFolder();
            folderList = folderData.then((folder) => folder.folders);
            audioList = folderData.then((folder) => folder.audios);
          });
        },
        child: ListView(
          children: [
            FutureBuilder<FolderList>(
              future: folderList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Wrap(
                    children: snapshot.data!.folders.map(
                      (folder) {
                        debugPrint(folder.toString());
                        return SizedBox(
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? MediaQuery.of(context).size.width / 2
                              : MediaQuery.of(context).size.width / 4,
                          height: 150,
                          child: ListTile(
                            title: Text(folder.name),
                            leading: const Icon(Icons.folder),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FolderPage(
                                    preview: folder,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            FutureBuilder<AudioList>(
              future: audioList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Wrap(
                    children: snapshot.data!.audios.map((audio) {
                      debugPrint(audio.toString());
                      return SizedBox(
                        width: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.width / 2
                            : MediaQuery.of(context).size.width / 4,
                        height: 150,
                        child: ListTile(
                          title: Text(audio.name),
                          leading: const Icon(Icons.audio_file),
                          style: ListTileStyle.list,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    AudioPage(metadata: audio)));
                          },
                        ),
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AudioPage extends StatefulWidget {
  const AudioPage({super.key, required this.metadata});

  final Audio metadata;

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.metadata.name),
      ),
    );
  }
}

class MyRoomsPage extends StatelessWidget {
  const MyRoomsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(automaticallyImplyLeading: false, title: const Text("Rooms")),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CreateRoomPage(),
                      ),
                    );
                  },
                  child: const Text("Create", style: TextStyle(fontSize: 18)),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const JoinRoom()));
                    },
                    child: const Text("Join", style: TextStyle(fontSize: 18)))
              ],
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                roomPreview(1),
                roomPreview(2),
                roomPreview(3),
                roomPreview(4),
                roomPreview(5),
                roomPreview(6),
                roomPreview(7)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget roomPreview(int index) => Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: TextButton(
        onPressed: () {},
        child: Text("Room $index"),
      ),
    );

class JoinRoom extends StatelessWidget {
  const JoinRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Join Room"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: const TextField(
                style: TextStyle(fontSize: 36),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 5,
                decoration: InputDecoration(
                    labelText: "Room Code",
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.all(6)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SeatSelectionPage()));
              },
              child: const Text("Join Room as Performer"),
            ),
            ElevatedButton(
                onPressed: () async {
                  final Uri url =
                      Uri.parse("https://www.youtube.com/watch?v=dQw4w9WgXcQ");

                  if (!await launchUrl(url)) throw 'Could not launch $url';
                },
                child: const Text("Join Room as Listener")),
          ],
        ),
      );
}

class SeatSelectionPage extends StatefulWidget {
  const SeatSelectionPage({Key? key}) : super(key: key);

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seat Selection"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        scrollDirection: Axis.vertical,
        children: [
          const Text(
              "Select a seat. Stronger and more essential players tend to seat first.",
              style: TextStyle(fontSize: 24)),
          Container(
            margin: const EdgeInsets.all(10.0),
            alignment: Alignment.bottomCenter,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 50.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 40.0,
              children: [
                seat(context, 1),
                seat(context, 2),
                seat(context, 3),
                seat(context, 4),
                seat(context, 5),
                seat(context, 6),
                seat(context, 7),
                seat(context, 8),
                seat(context, 9),
                seat(context, 10),
                seat(context, 11),
                seat(context, 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget seat(BuildContext context, int index) => Container(
      width: 100,
      height: 100,
      color: Colors.green,
      child: Center(
        child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const StagePage()));
          },
          child: Text(
            index.toString(),
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );

class CreateRoomPage extends StatelessWidget {
  CreateRoomPage({Key? key}) : super(key: key);

  final Random _random = Random();

  int generateCode() => _random.nextInt(89999) + 10000;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Create Room"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Room Code: ${generateCode()}",
                style: const TextStyle(fontSize: 24)),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: const SizedBox(
                width: 300,
                child: TextField(
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                      labelText: "Password",
                      alignLabelWithHint: true,
                      contentPadding: EdgeInsets.all(6)),
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 25.0),
              child: const SizedBox(
                width: 300,
                child: TextField(
                  style: TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                    labelText: "Room Name",
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.all(6),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Number of Performers",
                  style: TextStyle(fontSize: 24),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: const SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SeatSelectionPage()));
              },
              child: const Text("Create Room"),
            ),
          ],
        ),
      );
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          const Text("Settings"),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
