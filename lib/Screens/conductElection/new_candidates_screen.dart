import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_app/providers/auth_class.dart';
import 'package:voting_app/providers/new_election_provider.dart';
import 'package:voting_app/widgets/newCandidateSheet.dart';

class NewCandidatesScreen extends StatefulWidget {
  static const route = '/NewCandidatesScreen';
  @override
  _NewCandidatesScreenState createState() => _NewCandidatesScreenState();
}

class _NewCandidatesScreenState extends State<NewCandidatesScreen> {
  List<Candidate> listOfCandidates = [];
  AppUser currentUser;

  void addNewCandidate(String name, String url) {
    print(url);
    final newCandidate = Candidate(name: name, picUrl: url);
    setState(() {
      listOfCandidates.add(newCandidate);
    });
  }

  void _startAddNewCandidate(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewCandidate(addNewCandidate),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Candidates'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _startAddNewCandidate(context);
                })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                    itemCount: listOfCandidates.length,
                    separatorBuilder: (ctx, int) {
                      return Divider();
                    },
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              NetworkImage(listOfCandidates[index].picUrl),
                        ),
                        title: Text(listOfCandidates[index].name),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                          ),
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              listOfCandidates.removeAt(index);
                            });
                          },
                        ),
                      );
                    }),
              ),
              GestureDetector(
                onTap: () {
                  Provider.of<NewElectionProvider>(context, listen: false)
                      .createNewElectionPart2(listOfCandidates, currentUser);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Conduct Election',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
