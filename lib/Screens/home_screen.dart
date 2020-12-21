import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_app/auth_class.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('logout'),
          onPressed: () async {
            await Provider.of<Auth>(context, listen: false).signOut();
          },
        ),
      ),
    );
  }
}
