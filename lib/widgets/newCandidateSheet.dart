import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:voting_app/widgets/image_input.dart';

class NewCandidate extends StatefulWidget {
  final Function addCandi;
  //
  NewCandidate(this.addCandi);

  @override
  _NewCandidateState createState() => _NewCandidateState();
}

class _NewCandidateState extends State<NewCandidate> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();
  bool maleGender = true;
  File pickedImage;
  String candidateName;
  bool isLoading = false;
  final _titleController = TextEditingController();

  void getImage(image) {
    pickedImage = image;
    print(pickedImage);
  }

  void changeGender(index) {
    setState(() {
      if (index == 0) {
        maleGender = true;
      } else {
        maleGender = false;
      }
    });
  }

  Future<String> uploadImageToStorageAndGetUrl(File pickedImage) async {
    String candidatePicUrl;
    if (pickedImage != null) {
      String fileName = basename(pickedImage.path);
      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child('candidates/$fileName');
      final uploadTask = firebaseStorageRef.putFile(pickedImage);
      final taskSnapshot =
          await uploadTask.whenComplete(() => print('image uploaded'));
      await taskSnapshot.ref.getDownloadURL().then(
        (value) {
          candidatePicUrl = value;
        },
      );
    } else {
      if (maleGender) {
        candidatePicUrl =
            'https://png.pngtree.com/png-clipart/20200225/original/pngtree-businessman-avatar-icon-vector-download-vector-user-icon-avatar-silhouette-social-png-image_5257566.jpg';
      } else {
        candidatePicUrl =
            'https://png.pngtree.com/png-clipart/20200225/original/pngtree-business-office-girl-avatar-icon-vector-download-png-image_5257568.jpg';
      }
    }
    print(candidatePicUrl);
    return candidatePicUrl;
  }

  Future<void> addNewCandidate(BuildContext ctx) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    _form.currentState.save();
    String picUrl = await uploadImageToStorageAndGetUrl(pickedImage);

    widget.addCandi(candidateName, picUrl);

    setState(() {
      isLoading = false;
    });
  }

  void showErrSnackBar(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            key: scaffoldKey,
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.568,
                child: Card(
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Name'),
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    //FocusScope.of(context).requestFocus(_descriptionFocusNode);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please provide a value.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    candidateName = value;
                                  },
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                GenderSwitch(changeGender),
                                SizedBox(
                                  height: 20,
                                ),
                                ImageInput(getImage, maleGender),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              try {
                                await addNewCandidate(context);
                                Navigator.of(context).pop();
                              } on FirebaseException catch (err) {
                                showErrSnackBar(err.message);
                              } catch (err) {
                                showErrSnackBar('Error Ocurred');
                              }
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
                                'Add',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

class GenderSwitch extends StatelessWidget {
  final Function changeGender;

  const GenderSwitch(this.changeGender);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w300,
          ),
        ),
        ToggleSwitch(
          minWidth: 90.0,
          initialLabelIndex: 0,
          cornerRadius: 20.0,
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.green,
          activeBgColor: Colors.green,
          inactiveFgColor: Colors.white,
          labels: ['Male', 'Female'],
          icons: [Icons.add, Icons.subtitles],
          onToggle: (index) {
            changeGender(index);
          },
        ),
      ],
    );
  }
}
