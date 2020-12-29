import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:voting_app/Screens/conductElection/election_main_screen.dart';
import 'package:voting_app/Screens/profile_screen.dart';
import 'package:voting_app/providers/new_election_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Compainer'),
          actions: [
            IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.pushNamed(context, ProfileScreen.route);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HomeThumbnail(
                  imageAddress: 'assets/svg/ballot.svg',
                  buttonText: 'Participate',
                  imageColor: null,
                ),
                HomeThumbnail(
                  imageAddress: 'assets/svg/office.svg',
                  buttonText: 'Conduct',
                  imageColor: Color(0xff000081),
                )
              ],
            ),
          ),
        ));
  }
}

class HomeThumbnail extends StatelessWidget {
  final String imageAddress;
  final String buttonText;
  final Color imageColor;

  const HomeThumbnail({this.imageAddress, this.buttonText, this.imageColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: EdgeInsets.only(bottom: 25, top: 10),
        color: Color(0xffFFEBF1),
        alignment: Alignment.center,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              child: SvgPicture.asset(
                imageAddress,
                fit: BoxFit.contain,
                color: imageColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                final test =
                    Provider.of<NewElectionProvider>(context, listen: false)
                        .testCall();
                Navigator.pushNamed(context, ConductElectionScreen.route);
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.8,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
