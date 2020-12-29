import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final bool male;
  final Function pickedImage;

  const ImageInput(this.pickedImage, this.male);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _image;
  final picker = ImagePicker();

  Future pickImage(ImageSource source) async {
    try {
      final pickedFile = await picker.getImage(
          source: source, maxWidth: 400, imageQuality: 30);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });

      widget.pickedImage(_image);

      print('image selected------------------------------');
      // String fileName = basename(pickedFile.path);
      // final firebaseStorageRef =
      // FirebaseStorage.instance.ref().child('candidates/$fileName');
      // final uploadTask = firebaseStorageRef.putFile(_image);
      // final taskSnapshot =
      // await uploadTask.whenComplete(() => print('image uploaded'));
      // taskSnapshot.ref.getDownloadURL().then(
      //       (value) => print("Done: $value"),
      // );
    } catch (err) {
      print('User cancelled the popUp');
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        pickImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      pickImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1, color: Colors.grey),
              image: DecorationImage(
                image: _image != null
                    ? FileImage(
                        _image,
                      )
                    : widget.male
                        ? NetworkImage(
                            'https://png.pngtree.com/png-clipart/20200225/original/pngtree-businessman-avatar-icon-vector-download-vector-user-icon-avatar-silhouette-social-png-image_5257566.jpg')
                        : NetworkImage(
                            'https://png.pngtree.com/png-clipart/20200225/original/pngtree-business-office-girl-avatar-icon-vector-download-png-image_5257568.jpg'),
              )),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              _showPicker(context);
            },
          ),
        ),
      ],
    );
  }
}
