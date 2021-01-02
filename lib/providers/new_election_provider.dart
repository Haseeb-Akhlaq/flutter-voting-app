import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Candidate {
  final String name;
  final String picUrl;
  final int voteCount;
  Candidate({
    this.name,
    this.picUrl,
    this.voteCount = 0,
  });

  factory Candidate.fromDocument(doc) {
    return Candidate(
      name: doc['name'],
      picUrl: doc['picUrl'],
      voteCount: doc['description'],
    );
  }
}

class Election {
  final String id;
  final String ownerId;
  final String ownerName;
  final String ownerPhoto;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime createdAt;
  List<Candidate> candidates;

  Election(
      {this.id,
      this.ownerId,
      this.ownerName,
      this.ownerPhoto,
      this.title,
      this.description,
      this.startTime,
      this.endTime,
      this.createdAt,
      this.candidates});

  factory Election.fromDocument(DocumentSnapshot doc) {
    //print(doc['candidates'][0]['name']);

    return Election(
      id: doc['id'],
      title: doc['title'],
      description: doc['description'],
      startTime: doc['startTime'].toDate(),
      endTime: doc['endTime'].toDate(),
      createdAt: doc['createdAt'].toDate(),
      candidates: doc['candidates']
          .map<Candidate>((i) => Candidate.fromDocument(i))
          .toList(),
    );
  }
}

class NewElectionProvider extends ChangeNotifier {
  String electionId = (Random().nextInt(9000000) + 1000000).toString();
  Election newElection;

  void createNewElectionPart1(String title, String description,
      DateTime startingTime, DateTime endingTime) {
    newElection = Election(
        id: electionId,
        title: title,
        description: description,
        startTime: startingTime,
        endTime: endingTime,
        candidates: []);
  }

  Future<void> createNewElectionPart2(
      List<Candidate> candidates, currentUser) async {
    newElection.candidates = candidates;

    List<Map> jsonCadidates = candidates
        .map((e) => {
              'name': e.name,
              'picUrl': e.picUrl,
              'voteCount': e.voteCount,
            })
        .toList();

    await FirebaseFirestore.instance
        .collection('createdPolls')
        .doc(currentUser.currentUserId)
        .collection('onGoingPolls')
        .doc(newElection.id)
        .set({
      'id': newElection.id,
      'ownerId': currentUser.currentUserId,
      'ownerName': currentUser.userName,
      'ownerPhoto': currentUser.profilePhoto,
      'title': newElection.title,
      'description': newElection.description,
      'startTime': newElection.startTime,
      'endTime': newElection.endTime,
      'createdAt': DateTime.now(),
      'candidates': jsonCadidates,
    });
    electionId = (Random().nextInt(9000000) + 1000000).toString();
  }
}
