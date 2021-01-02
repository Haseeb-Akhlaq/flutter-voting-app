import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_app/providers/auth_provider_class.dart';
import 'package:voting_app/providers/new_election_provider.dart';

class OngoingElectionScreen extends StatefulWidget {
  @override
  _OngoingElectionScreenState createState() => _OngoingElectionScreenState();
}

class _OngoingElectionScreenState extends State<OngoingElectionScreen> {
  AppUser currentUser;

  @override
  void initState() {
    currentUser =
        Provider.of<AuthProvider>(context, listen: false).currentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongoing Elections'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('createdPolls')
                .doc(currentUser.currentUserId)
                .collection('onGoingPolls')
                .orderBy('createdAt', descending: true)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(
                  child: Text('Error Occurred'),
                );
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              List<Election> onGoingElections = snapshot.data.documents
                  .map<Election>((data) => Election.fromDocument(data))
                  .toList();
              return ListView.separated(
                itemCount: onGoingElections.length,
                separatorBuilder: (ctx, index) {
                  return SizedBox(height: 8);
                },
                itemBuilder: (ctx, index) {
                  return ElectionListTile(
                      onGoingElections[index].title,
                      onGoingElections[index].id,
                      onGoingElections[index].startTime,
                      onGoingElections[index].endTime);
                },
              );
            },
          )),
    );
  }
}

class ElectionListTile extends StatelessWidget {
  final String title;
  final String id;
  final DateTime startTime;
  final DateTime endTime;

  const ElectionListTile(this.title, this.id, this.startTime, this.endTime);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(3.0),
          bottomLeft: Radius.circular(3.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(
                width: 5,
                color: Colors.green,
              ),
            ),
          ),
          child: ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    constraints: BoxConstraints(),
                    icon: Icon(
                      Icons.bookmark_border,
                      color: Colors.blue,
                    ),
                    onPressed: () {},
                  )
                ],
              ),
              subtitle: Container(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Id: $id'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        'From: ${DateFormat.yMMMd().add_jm().format(startTime)}'),
                    SizedBox(
                      height: 5,
                    ),
                    Text('To: ${DateFormat.yMMMd().add_jm().format(endTime)}'),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
