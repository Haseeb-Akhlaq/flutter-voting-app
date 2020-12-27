import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_app/auth_class.dart';

class ProfileScreen extends StatefulWidget {
  static const route = '/profile_screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = Provider.of<Auth>(context, listen: false).currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Profile'),
        centerTitle: true,
      ),
      body: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.lightBlue, Color(0xffBCFFE5)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 15),
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.height * .1,
                          backgroundImage: NetworkImage(
                            currentUser.profilePhoto,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          currentUser.userName,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            profileCounter(10, 'Total Polls'),
                            profileCounter(2, 'Active Polls'),
                            profileCounter(8, 'Previous Polls')
                          ],
                        ),
                        RaisedButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('polls')
                                .doc('dArjcGVEoACRo6jQvxbx')
                                .update(
                              {
                                'candidates': FieldValue.arrayUnion([
                                  {'Muneeb': 3}
                                ]),
                              },
                            );
                          },
                          child: Text('Call firebase'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            logoutButton(),
          ],
        ),
      ),
    );
  }

  Widget logoutButton() {
    return GestureDetector(
      onTap: () async {
        await Provider.of<Auth>(context, listen: false).signOut();
        Navigator.of(context).pop();
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red,
          boxShadow: [
            BoxShadow(
              color: Colors.red,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Text(
          'Logout',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Column profileCounter(int number, String category) {
    return Column(
      children: [
        Text(
          number.toString(),
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
        Text(category),
      ],
    );
  }
}
