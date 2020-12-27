import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:voting_app/Screens/conductElection/new_candidates_screen.dart';

class NewElectionsScreen extends StatefulWidget {
  @override
  _NewElectionsScreenState createState() => _NewElectionsScreenState();
}

class _NewElectionsScreenState extends State<NewElectionsScreen> {
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;

  TextEditingController _controller1 = TextEditingController();
  bool valueChanged1 = false;
  String _valueChanged1 = '';
  String _valueToValidate1 = '';
  String _valueSaved1 = '';

  TextEditingController _controller2 = TextEditingController();
  bool valueChanged2 = false;
  String _valueChanged2 = '';
  String _valueToValidate2 = '';
  String _valueSaved2 = '';

  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController(
        text: DateTime.now().subtract(Duration(minutes: 5)).toString());
    _controller2 = TextEditingController(
        text: DateTime.now().add(Duration(days: 1)).toString());
  }

  @override
  void dispose() {
    _controller1.dispose();
    _descriptionFocusNode.dispose();
    _controller2.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (2 == 2) {
    } else {
      try {} catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Election'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Title'),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide a value.';
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Description'),
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            focusNode: _descriptionFocusNode,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a description.';
                              }
                              if (value.length < 10) {
                                return 'Should be at least 10 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          DateTimePicker(
                            type: DateTimePickerType.dateTimeSeparate,
                            dateMask: 'd MMM, yyyy',
                            controller: _controller1,
                            // initialValue: DateTime.now().toString(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            icon: Icon(Icons.event),
                            dateLabelText: 'Start Date',
                            timeLabelText: "Hour",
                            use24HourFormat: false,
                            //locale: Locale('pt', 'BR'),
                            selectableDayPredicate: (date) {
                              if (2 == 3) {
                                return false;
                              }
                              return true;
                            },
                            onChanged: (val) => setState(() {
                              print('$val--------------------------');
                              var date;
                              if (val.contains('AM') || val.contains('PM')) {
                                date = DateFormat("yyyy-MM-dd hh:mm aaa")
                                    .parse(val);
                              } else {
                                date =
                                    DateFormat("yyyy-MM-dd hh:mm").parse(val);
                              }
                              print('$date--------------------------');
                              _valueChanged1 = date.toString();
                              valueChanged1 = true;
                            }),
                            validator: (val) {
                              var selectedDate;
                              if (valueChanged1) {
                                selectedDate = DateFormat("yyyy-MM-dd hh:mm:ss")
                                    .parse(_valueChanged1); //converting
                              } else {
                                selectedDate = DateTime.parse(val);
                              }
                              if (selectedDate.isBefore(DateTime.now())) {
                                return 'Please Select Time in Future';
                              }
                              if (selectedDate.isAfter(
                                  DateTime.now().add(Duration(days: 7)))) {
                                return 'Select before 7 days from now';
                              }
                              setState(() => _valueToValidate1 = val);
                              return null;
                            },
                            onSaved: (val) =>
                                setState(() => _valueSaved1 = val),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          DateTimePicker(
                            type: DateTimePickerType.dateTimeSeparate,
                            dateMask: 'd MMM, yyyy',
                            controller: _controller2,
                            // initialValue: DateTime.now().toString(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            icon: Icon(Icons.event),
                            dateLabelText: 'End Date',
                            timeLabelText: "Hour",
                            use24HourFormat: false,
                            //locale: Locale('pt', 'BR'),
                            selectableDayPredicate: (date) {
                              if (2 == 3) {
                                return false;
                              }
                              return true;
                            },
                            onChanged: (val) => setState(() {
                              print(val);
                              var date;
                              if (val.contains('AM') || val.contains('PM')) {
                                date = DateFormat("yyyy-MM-dd hh:mm aaa")
                                    .parse(val);
                              } else {
                                date =
                                    DateFormat("yyyy-MM-dd hh:mm").parse(val);
                              }
                              print(date);
                              _valueChanged2 = date.toString();
                              valueChanged2 = true;
                            }),
                            validator: (val) {
                              print(val);
                              var selectedDate;
                              var startDate;
                              if (valueChanged2) {
                                selectedDate = DateFormat("yyyy-MM-dd hh:mm:ss")
                                    .parse(_valueChanged2);
                              } else {
                                selectedDate =
                                    DateTime.parse(_controller2.text);
                              }

                              if (valueChanged1) {
                                startDate = DateFormat("yyyy-MM-dd hh:mm:ss")
                                    .parse(_valueChanged1);
                              } else {
                                startDate = DateTime.parse(_controller1.text);
                              }

                              if (selectedDate.isBefore(
                                  startDate.add(Duration(hours: 2)))) {
                                return 'Election must be 2 hours long';
                              }

                              if (selectedDate.isBefore(startDate)) {
                                return 'Select Date After start Date';
                              }
                              if (selectedDate
                                  .isAfter(startDate.add(Duration(days: 15)))) {
                                return 'Election can be 15days long';
                              }
                              setState(() => _valueToValidate2 = val);
                              return null;
                            },
                            onSaved: (val) =>
                                setState(() => _valueSaved2 = val),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, NewCandidatesScreen.route);
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
                          'Next',
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
    );
  }
}
