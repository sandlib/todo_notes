import 'package:flutter/material.dart';
import 'package:personal_todo/todo_list_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: TODOListScreen.id,
    title: 'TODOApp',
    theme: ThemeData(primarySwatch: Colors.red),
    routes: {'todoHome': (context) => TODOListScreen()},
  ));
}
