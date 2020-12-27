import 'package:flutter/material.dart';

class OngoingElectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongoing Elections'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Ongoing Elections'),
      ),
    );
  }
}
