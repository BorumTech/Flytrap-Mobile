import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CurrentPage());
  }
}

class _CurrentPageState extends State<CurrentPage> {
  int _currentIndex = 0;
  final screens = const [FilesPage(), MyRoomsPage(), SettingsPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(index: _currentIndex, children: screens),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
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
        ));
  }
}

class CurrentPage extends StatefulWidget {
  const CurrentPage({Key? key}) : super(key: key);

  @override
  State<CurrentPage> createState() => _CurrentPageState();
}

class FilesPage extends StatefulWidget {
  const FilesPage({Key? key}) : super(key: key);

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flytrap Audio",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class MyRoomsPage extends StatelessWidget {
  const MyRoomsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rooms")),
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
                    Navigator.push(
                      context,
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
                seat(1),
                seat(2),
                seat(3),
                seat(4),
                seat(5),
                seat(6),
                seat(7),
                seat(8),
                seat(9),
                seat(10),
                seat(11),
                seat(12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget seat(int index) => Container(
      width: 100,
      height: 100,
      color: Colors.green,
      child: Center(
        child: Text(
          index.toString(),
          style: const TextStyle(fontSize: 24),
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
