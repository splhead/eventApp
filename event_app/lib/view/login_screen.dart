import 'package:event_app/controller/user_controller.dart';
import 'package:event_app/model/user.dart';
import 'package:event_app/utils/utils.dart';
import 'package:event_app/view/event_screen.dart';
import 'package:event_app/view/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text('NOSSO EVENTO', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Container(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Flexible(
                      flex: 1,
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 150,
                        height: 150,
                      )),
                  Flexible(
                      child: TextFormField(
                    maxLength: 100,
                    decoration: InputDecoration(hintText: 'E-mail'),
                    validator: (val) => val == "" ? val : null,
                    controller: _email,
                    keyboardType: TextInputType.text,
                  )),
                  Flexible(
                      child: TextFormField(
                    maxLength: 20,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Senha'),
                    validator: (val) => val == "" ? val : null,
                    controller: _senha,
                    keyboardType: TextInputType.text,
                  )),
                  Flexible(
                      child: TextButton(
                    onPressed: () {
                      _login(context, globalKey);
                    },
                    child: Text(
                      'Entrar',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurple)),
                  )),
                  Flexible(
                      child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => SignUpScreen()));
                    },
                    child: Text(
                      'Cadastrar',
                      style: TextStyle(color: Colors.black),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context, GlobalKey<ScaffoldState> globalKey) async {
    MyUser user = MyUser("", _email.text, Utils.convertToMD5(_senha.text));

    if (formKey.currentState!.validate()) {
      ApiResponse response = await UserController().login(user, formKey);

      if (response.msg != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.msg!)));

        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => EventScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Não foi possível realizar o login')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Preencha os campos em branco')));
    }
  }
}
