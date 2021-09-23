import 'package:event_app/service/firebase_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ActivityController extends StatefulWidget {
  const ActivityController({Key? key}) : super(key: key);

  void addActivity(String table, Object data) {
    createState()._addActivity(table, data);
  }

  DatabaseReference getAllActivities(String table) {
    return createState()._getAllActivities(table);
  }

  @override
  _ActivityControllerState createState() => _ActivityControllerState();
}

class _ActivityControllerState extends State<ActivityController> {

  FirebaseService firebaseService = FirebaseService();
  static _ActivityControllerState? _instance;

  _ActivityControllerState._();

  factory _ActivityControllerState() => _instance ??= _ActivityControllerState._();

  // static _ActivityControllerState get instance => _instance ?? _ActivityControllerState._();

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _addActivity(String table, Object data) {
    firebaseService.saveDataRealTime(table, data);
  }

  DatabaseReference _getAllActivities(String table) {
    return firebaseService.getDataRealTime(table);
  }
}
