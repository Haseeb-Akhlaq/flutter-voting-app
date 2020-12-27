import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_app/Screens/conductElection/new_candidates_screen.dart';
import 'package:voting_app/auth_class.dart';

import './Screens/conductElection/election_main_screen.dart';
import './Screens/landing_screen.dart';
import './Screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Auth(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LandingScreen(),
        routes: {
          ConductElectionScreen.route: (ctx) => ConductElectionScreen(),
          ProfileScreen.route: (ctx) => ProfileScreen(),
          NewCandidatesScreen.route: (ctx) => NewCandidatesScreen(),
        },
      ),
    );
  }
}
