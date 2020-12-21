import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voting_app/auth_class.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  Future<void> _signInWithGoogle() async {
    try {
      AppUser loggedUser =
          await Provider.of<Auth>(context, listen: false).signInWithGoogle();
      print(loggedUser.uid);
    } on PlatformException catch (err) {
      print(err.message);
    } catch (err) {
      print(
          '${err.toString()}----------------------------------------------------------');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: 200,
            child: Image.asset('assets/loginButton/fbButton.png'),
          ),
          Container(
            alignment: Alignment.center,
            child: RaisedButton.icon(
              icon: Icon(Icons.login),
              label: Text('Sign In Anonymously'),
              color: Colors.greenAccent,
              onPressed: () async {
                AppUser loggedUser =
                    await Provider.of<Auth>(context, listen: false)
                        .signInAnonymously();
                print(loggedUser.uid);
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: RaisedButton.icon(
              icon: Icon(Icons.login),
              label: Text('Sign In with Google'),
              color: Colors.redAccent,
              onPressed: _signInWithGoogle,
            ),
          )
        ],
      ),
    );
  }
}
