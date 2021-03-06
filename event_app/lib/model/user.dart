import 'package:firebase_database/firebase_database.dart';
// mudei o nome da classe para não dar conflito com o do firebase
// não consegui fazer um alias

class MyUser {
  String? key;
  late String name;
  late String email;
  late String password;

  MyUser(this.name, this.email, this.password);

  MyUser.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value['name'],
        email = snapshot.value['email'],
        password = snapshot.value['password'];

  toJson() {
    return {"name": name, "email": email, "password": password};
  }

  MyUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
  }
}
