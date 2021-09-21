import 'package:event_app/controller/user_controller.dart';
import 'package:event_app/view/event_screen.dart';
import 'package:event_app/view/login_screen.dart';
import 'package:flutter/material.dart';

import 'activity_screen.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Drawer(
          child: ListView(
            children: [
              _header('Silas P Ladislau'),
              ListTile(
                title: Text('Agenda'),
                leading: Icon(Icons.today),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => EventScreen()));
                },
              ),
              ListTile(
                title: Text('Atividades'),
                leading: Icon(Icons.today),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ActivityScreen()));
                },
              ),
              ListTile(
                title: Text('Sair'),
                leading: Icon(Icons.exit_to_app),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  UserController().logout();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()));
                },
              ),
            ],
          ),
        ));
  }

  Widget _header(String nome) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: Colors.deepPurple),
      accountName: Text(nome),
      accountEmail: Text('splhead@gmail.com'),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 80,
        child: Text(
          'S',
          style: TextStyle(fontSize: 40, color: Colors.black54),
        ),
      ),
    );
  }
}
