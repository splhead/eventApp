import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserController extends StatefulWidget {
  const UserController({Key? key}) : super(key: key);

  Future<ApiResponse> adicionarParticipante(
      MyUser user, GlobalKey<FormState> formKey) {
    return createState()._cadastrar(user, formKey);
  }

  Future<ApiResponse> login(
      MyUser user, GlobalKey<FormState> formKey) {
    return createState()._login(user, formKey);
  }

  Future<void> logout(
      ) {
    return createState()._logout();
  }

  @override
  _UserControllerState createState() => _UserControllerState();
}

class _UserControllerState extends State<UserController> {
  late String firebaseUserUid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  static _UserControllerState? _instance;

  _UserControllerState._() {}

  factory _UserControllerState() =>  _instance ??= _UserControllerState._();

  // static _UserControllerState get instance =>
  //     _instance ??= _UserControllerState._();

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<ApiResponse> _cadastrar(
      MyUser user, GlobalKey<FormState> formKey) async {

    try {
      // Usuario firebase
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      final User fUser = result.user;

      // dados para atualizar o usuário
      await fUser.updateProfile(displayName: user.name);

      firebaseUserUid = fUser.uid;
      DocumentReference refUser = FirebaseFirestore.instance.collection("user")
          .doc(firebaseUserUid);
      refUser.set({
        "name": user.name,
        "email": user.email,
        "password": user.password
      });

      formKey.currentState?.save();
      formKey.currentState?.reset();
      
      return ApiResponse.ok(msg: 'Usuário cadastrado com sucesso');
    } catch (error) {
      print(error);

      if (error is PlatformException) {
        print("Error code: ${error.code}");
        return ApiResponse.error(msg: "Erro ao criar usuário \n\n Este e-mail já foi utilizado em nosso cadastro.");
      }

      return ApiResponse.error(msg: 'Não foi possível criar o usuário');
    }

  }

  Future<ApiResponse> _login(MyUser user, GlobalKey<FormState> formKey) async {
    try {
      formKey.currentState?.save();
      formKey.currentState?.reset();

      await _auth.signInWithEmailAndPassword(email: user.email, password: user.password);

      return ApiResponse.ok(msg: 'Você realizou o login com sucesso');

    } catch (error) {
      print(error);
      return ApiResponse.error(msg: 'Não foi possível realizar o login');
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
  }
}

class ApiResponse<T> {
  late bool ok;
  String? msg;
  T? result;

  ApiResponse.ok({this.result, this.msg}) {
    this.ok = true;
  }

  ApiResponse.error({this.result, this.msg}) {
    ok = false;
  }
}
