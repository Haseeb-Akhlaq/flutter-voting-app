import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:voting_app/providers/auth_provider_class.dart';
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
  bool isLoading = false;

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

  Future<void> conductElection() async {
    if (listOfCandidates.length < 2) {
      Toast.show(
        "Must have 2 Candidates",
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.CENTER,
        backgroundColor: Colors.red,
        backgroundRadius: 0,
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<NewElectionProvider>(context, listen: false)
          .createNewElectionPart2(listOfCandidates, currentUser);
      Navigator.of(context).pop(true);
    } on FirebaseException catch (err) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(err.message)));
    } catch (err) {
      print(err);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    currentUser =
        Provider.of<AuthProvider>(context, listen: false).currentUser();
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
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
                                backgroundImage: NetworkImage(
                                    listOfCandidates[index].picUrl),
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
                      onTap: () async {
                        await conductElection();
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
