import 'package:event_app/controller/user_controller.dart';
import 'package:event_app/model/user.dart';
import 'package:event_app/utils/utils.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nome = TextEditingController();
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
                    decoration: InputDecoration(hintText: 'Nome'),
                    validator: (val) => val == "" ? val : null,
                    controller: _nome,
                    keyboardType: TextInputType.text,
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
                      _cadastraUsuario(globalKey);
                    },
                    child: Text(
                      'Cadastrar',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurple)),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _cadastraUsuario(GlobalKey<ScaffoldState> globalKey) async {
    MyUser user = MyUser(_nome.text, _email.text, Utils.convertToMD5(_senha.text));

    if (formKey.currentState!.validate()) {
      ApiResponse response =
          await UserController().adicionarParticipante(user, formKey);

      if (response.msg != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.msg!)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Não foi possível cadastrar o usuário')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Preencha os campos em branco')));
    }
  }
}
