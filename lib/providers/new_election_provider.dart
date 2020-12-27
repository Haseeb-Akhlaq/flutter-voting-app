import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Candidate {
  final String name;
  final String picUrl;
  final int voteCount;
  Candidate({
    this.name,
    this.picUrl,
    this.voteCount,
  });

  factory Candidate.fromDocument(DocumentSnapshot doc) {
    return Candidate(
      name: doc['name'],
      picUrl: doc['picUrl'],
      voteCount: doc['description'],
    );
  }
}

class Election {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final List<Candidate> candidates;

  Election(
      {this.id,
      this.title,
      this.description,
      this.startTime,
      this.endTime,
      this.candidates});

  factory Election.fromDocument(DocumentSnapshot doc) {
    return Election(
      id: doc['id'],
      title: doc['title'],
      description: doc['description'],
      startTime: doc['startTime'],
      endTime: doc['endTime'],
      candidates:
          doc['candidates'].map((i) => Candidate.fromDocument(i)).toList(),
    );
  }
}

class NewElectionProvider extends ChangeNotifier {}
