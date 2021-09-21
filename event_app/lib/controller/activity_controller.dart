import 'package:event_app/service/firebase_service.dart';
import 'package:flutter/material.dart';

class ActivityController extends StatefulWidget {
  const ActivityController({Key? key}) : super(key: key);

  void addActivity(String table, Object data) {
    createState()._addActivity(table, data);
  }

  @override
  _ActivityControllerState createState() => _ActivityControllerState.instance;
}

class _ActivityControllerState extends State<ActivityController> {

  FirebaseService firebaseService = FirebaseService();
  static late _ActivityControllerState _instance;

  _ActivityControllerState._() {}

  static _ActivityControllerState get instance => _instance ?? _ActivityControllerState._();

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _addActivity(String table, Object data) {
    firebaseService.saveDataRealTime(table, data);
  }
}