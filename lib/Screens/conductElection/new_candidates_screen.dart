import 'package:flutter/material.dart';

class NewCandidatesScreen extends StatefulWidget {
  static const route = '/NewCandidatesScreen';
  @override
  _NewCandidatesScreenState createState() => _NewCandidatesScreenState();
}

class _NewCandidatesScreenState extends State<NewCandidatesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Candidates'),
          actions: [IconButton(icon: Icon(Icons.add), onPressed: null)],
        ),
        body: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://png.pngtree.com/png-clipart/20190924/original/pngtree-businessman-user-avatar-free-vector-png-image_4827807.jpg'),
          ),
        ));
  }
}
