import 'package:event_app/view/login_screen.dart';
import 'package:flutter/material.dart';

class EventApp extends StatelessWidget {
  const EventApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Nosso evento",
      home: LoginScreen()
    );
  }
}
