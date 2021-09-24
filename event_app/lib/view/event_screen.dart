import 'package:event_app/controller/activity_controller.dart';
import 'package:event_app/model/activity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'menu.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<dynamic> atividades = [];
  late DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    databaseReference = ActivityController().getAllActivities('activity');
    databaseReference.onChildAdded.listen(_verificaAtividade);
  }

  void _verificaAtividade(Event event) {
    setState(() {
      Activity atividade = Activity.fromSnapShot(event.snapshot);
      atividade.setKey(event.snapshot.key);
      atividades.add(atividade);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NOSSO EVENTO',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: Menu(),
      body: Scaffold(
        body: Column(
          children: [
            Flexible(
                flex: 0,
                child: Container(
                  width: 0,
                  height: 0,
                )),
            Flexible(
                flex: 1,
                child: atividades.isNotEmpty
                    ? _listagem(context)
                    : Container(
                        child: Center(
                            child: Text('Não há atividades cadastradas')),
                      ))
          ],
        ),
      ),
    );
  }

  _listagem(BuildContext context) {
    return FirebaseAnimatedList(
        query: databaseReference,
        itemBuilder:
            (_, DataSnapshot snapshot, Animation<double> animation, int index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black26,
                radius: 25,
                child: Text(
                  '${atividades[index].speaker.substring(0, 1)}',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              title: Text(
                "${atividades[index].title}",
                style: TextStyle(fontWeight: FontWeight.w400,
                    color: atividades[index].confirmed ? Colors.deepPurple: Colors.black ),
              ),
              subtitle: Text("${atividades[index].speaker} \n"
                  "${atividades[index].schedule}"),
              trailing: atividades[index].confirmed ? Icon(Icons.check) : Icon(Icons.maximize),
            ),
          );
        });
  }
}
