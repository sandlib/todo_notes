import 'package:flutter/material.dart';
import 'package:personal_todo/todo_list_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: TODOListScreen.id,
    debugShowCheckedModeBanner: false,
    title: 'TODOApp',
    theme: ThemeData(
      primaryColor: Color(0xFF184d47),
    ),
    routes: {'todoHome': (context) => TODOListScreen()},
  ));
}
