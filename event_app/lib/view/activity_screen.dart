import 'package:event_app/controller/activity_controller.dart';
import 'package:event_app/model/activity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'menu.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool _confirmada = false;
  final TextEditingController _palestra = TextEditingController();
  final TextEditingController _palestrante = TextEditingController();
  final TextEditingController _horario = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> formState = GlobalKey<FormFieldState>();
  final globalKey = GlobalKey<ScaffoldState>();

  List<Activity> atividades = <Activity>[];
  late DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    databaseReference = ActivityController().getAllActivities('activity');
    databaseReference.onChildAdded.listen(_verificaAtividade);
    databaseReference.onChildChanged.listen((event) {});
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
      key: globalKey,
      appBar: AppBar(
        title: Text(
          'ATIVIDADES',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Flexible(child: Container(width: 0, height: 0)),
          Flexible(
              child: atividades.isNotEmpty
                  ? _listagem(context)
                  : Center(
                      child: Container(
                          child: Text('Não há atividades cadastradas!'))))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          _cadastrarAtividade();
        },
      ),
      drawer: Menu(),
    );
  }

  Widget _listagem(BuildContext context) {
    return FirebaseAnimatedList(
        query: databaseReference,
        itemBuilder:
            (_, DataSnapshot snapshot, Animation<double> animation, int index) {
          return Card(
            child: ListTile(
              leading: atividades[index].confirmed
                  ? Icon(Icons.check)
                  : Icon(Icons.maximize),
              title: Text("${atividades[index].title}"),
              subtitle: Text("${atividades[index].speaker} \n"
                  "${atividades[index].schedule}"),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _alertaDelete(context, atividades[index]);
                      });
                },
              ),
            ),
          );
        });
  }

  Widget _alertaDelete(BuildContext context, Activity atividade) {
    return AlertDialog(
      title: Text('Remover atividade'),
      content: Text('Você deseja remover a atividade "${atividade.title}" ?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar', style: TextStyle(color: Colors.black54))),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteAtividade(context, atividade.key);
            },
            child: Text('Ok', style: TextStyle(color: Colors.deepPurple),))
      ],
    );
  }

  void _cadastrarAtividade() {
    showDialog(
        context: context,
        builder: (BuildContext context) => Form(
              key: formKey,
              child: SimpleDialog(
                title: Text('Atividade'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: _palestra,
                      decoration:
                          InputDecoration(hintText: "Título da palestra"),
                      validator:  (val) => val == "" ? val : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Palestrante"),
                      controller: _palestrante,
                      validator:  (val) => val == "" ? val : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Horário"),
                      controller: _horario,
                      validator:  (val) => val == "" ? val : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: FormField<bool>(
                      key: formState,
                      initialValue: _confirmada,
                      builder: (FormFieldState<bool> state) {
                        return CheckboxListTile(
                            value: state.value,
                            title: Text('Confirmada?'),
                            selected: _confirmada,
                            onChanged: state.didChange);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.black),
                          )),
                      TextButton(
                          onPressed: () {
                            _confirmada = formState.currentState?.value;
                            _cadastraAtividade(globalKey, context, _confirmada);
                          },
                          child: Text(
                            'Ok',
                            style: TextStyle(color: Colors.deepPurple),
                          )),
                    ],
                  )
                ],
              ),
            ));
  }

  void _cadastraAtividade(GlobalKey<ScaffoldState> globalKey,
      BuildContext context, bool confirmada) async {
    try {
      if (formKey.currentState!.validate()) {
        Activity activity = Activity(
            _palestra.text, _palestrante.text, _horario.text, confirmada);

        ActivityController().addActivity("activity", activity);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Atividade cadastrada com sucesso.')));

        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ActivityScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Preencha os campos em branco')));
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível cadastrar a atividade.')));
    }
  }

  void _deleteAtividade(BuildContext context, String? key) {
    try {
      ActivityController().deleteActivity('activity', key);
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ActivityScreen()));
    } catch(error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível remover a atividade.')));
    }
  }
}
