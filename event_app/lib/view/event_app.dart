import 'dart:developer';

import 'package:event_app/view/login_screen.dart';
import 'package:event_app/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class EventApp extends StatefulWidget {
  const EventApp({Key? key}) : super(key: key);

  @override
  _EventAppState createState() => _EventAppState();
}

class _EventAppState extends State<EventApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            log('Erro ao inicializar firebase');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: "Nosso Evento",
              home: LoginScreen(),
            );
          }
          return SplashScreen();
        });
  }
}
