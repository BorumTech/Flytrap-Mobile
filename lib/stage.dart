import 'package:flutter/material.dart';

class StagePage extends StatefulWidget {
  const StagePage({Key? key}) : super(key: key);

  @override
  State<StagePage> createState() => _StagePageState();
}

class _StagePageState extends State<StagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stage"),
      ),
      body: const Center(
        child: Text("Stage"),
      ),
    );
  }
}
