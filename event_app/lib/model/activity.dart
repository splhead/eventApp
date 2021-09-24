import 'package:firebase_database/firebase_database.dart';

class Activity {
  String? key;
  late String title;
  late String speaker;
  late String schedule;
  late bool confirmed;

  Activity(this.title, this.speaker, this.schedule, this.confirmed);

  Activity.fromSnapShot(DataSnapshot snapshot)
      : key = snapshot.key,
        title = snapshot.value['title'],
        speaker = snapshot.value['speaker'],
        schedule = snapshot.value['schedule'],
        confirmed = snapshot.value['confirmed'];

  toJson() {
    return {
      "title" : title,
      "speaker" : speaker,
      "schedule" : schedule,
      "confirmed" : confirmed
    };
  }

  Activity.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    speaker = json['speaker'];
    schedule = json['schedule'];
    confirmed = json['confirmed'];
  }

  void setKey(String? value) {
    key = value;
  }
}
