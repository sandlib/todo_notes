import 'dart:io' show Platform;

import 'package:ads/ads.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_todo/database_helper.dart';
import 'package:personal_todo/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Function updateTaskList;
  final Task task;
  AddTaskScreen({this.updateTaskList, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title;
  String _priority;
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  List<String> priority = ["Low", "Medium", "High"];

  Ads appads, appads2;

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
        builder: (BuildContext context, Widget child) => Theme(
              child: child,
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                  primary: Color(0xFF96bb7c),
                ),
              ),
            ),
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
    }
    _dateController.text = _dateFormat.format(date);
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      //insert task to database

      Task task = Task(title: _title, date: _date, priority: _priority);
      if (widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseHelper.instance.updateTask(task);
      }

      //update the task
      widget.updateTaskList();
      print('$_title $_date $_priority');
      Navigator.pop(context);
    }
  }

  final String appId = Platform.isAndroid
      ? 'ca-app-pub-2567202150499835~5852853130'
      : 'ca-app-pub-2567202150499835~7273746015';

  final String bannerUnitId = Platform.isAndroid
      ? 'ca-app-pub-2567202150499835/5428335394'
      : 'ca-app-pub-2567202150499835/8395255994';

  final String bannerUnitId2 = Platform.isAndroid
      ? 'ca-app-pub-2567202150499835/5480306284'
      : 'ca-app-pub-2567202150499835/8997891223';

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task.title;
      _date = widget.task.date;
      _priority = widget.task.priority;
    }
    _dateController.text = _dateFormat.format(_date);

    //Assign a listener
    var eventListener = (MobileAdEvent event) {
      if (event == MobileAdEvent.opened) {
        print("evenetListener: The opened ad is clicked on.");
      }
    };
    appads = Ads(
      appId,
      bannerUnitId: bannerUnitId,
      keywords: <String>['ibm', 'computers'],
      contentUrl: 'http://www.ibm.com',
      childDirected: false,
      testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
      testing: false,
      listener: eventListener,
    );
    appads2 = Ads(
      appId,
      bannerUnitId: bannerUnitId2,
      keywords: <String>['ibm', 'computers'],
      contentUrl: 'http://www.ibm.com',
      childDirected: false,
      testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
      testing: false,
      listener: eventListener,
    );
    appads.showBannerAd();
    appads.showBannerAd(state: this, anchorOffset: null);
  }

  @override
  void dispose() {
    _dateController.dispose();

    super.dispose();
    appads.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  widget.task == null ? 'Add Task' : 'Update Task',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          validator: (input) => input.trim().isEmpty
                              ? "Please enter a task title"
                              : null,
                          onSaved: (input) => _title = input,
                          initialValue: _title,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          onTap: _handleDatePicker,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Date',
                            labelStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: DropdownButtonFormField(
                          isDense: true,
                          icon: Icon(
                            Icons.arrow_drop_down_circle,
                            color: Theme.of(context).primaryColor,
                          ),
                          iconSize: 22.0,
                          items: priority
                              .map((String priorities) => DropdownMenuItem(
                                    value: priorities,
                                    child: Text(
                                      priorities,
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.black),
                                    ),
                                  ))
                              .toList(),
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            labelStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          validator: (input) => _priority == null
                              ? "Please select a priority level"
                              : null,
                          onChanged: (value) {
                            setState(() {
                              appads2.showBannerAd(
                                  state: this, anchorOffset: null);
                              _priority = value;
                            });
                          },
                          value: _priority,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: FlatButton(
                          child: Text(
                            widget.task == null ? 'Add' : 'Update',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          onPressed: () => _submit(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
