import 'package:flutter/material.dart';
import 'package:voting_app/Screens/conductElection/New_election_screen.dart';
import 'package:voting_app/Screens/conductElection/ongoing_elections_screen.dart';
import 'package:voting_app/Screens/conductElection/previousElections.dart';

class ConductElectionScreen extends StatefulWidget {
  static const route = '/conduct_screen';
  @override
  _ConductElectionScreenState createState() => _ConductElectionScreenState();
}

class _ConductElectionScreenState extends State<ConductElectionScreen> {
  PageController _pageController = PageController();
  int barCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            barCurrentIndex = index;
          });
        },
        children: [
          OngoingElectionScreen(),
          NewElectionsScreen(),
          PreviousElectionsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        currentIndex: barCurrentIndex,
        onTap: (index) {
          setState(() {
            barCurrentIndex = index;
            _pageController.animateToPage(barCurrentIndex,
                duration: Duration(microseconds: 600), curve: Curves.linear);
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Ongoing'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.restore), label: 'Previous'),
        ],
      ),
    );
  }
}
