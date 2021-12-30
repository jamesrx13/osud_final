import 'package:firebase_database/firebase_database.dart';

class UserModel {
  late String id;
  late String email;
  late String cellPhone;
  late String name;

  UserModel({
    required this.id,
    required this.email,
    required this.cellPhone,
    required this.name,
  });

  UserModel.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key!;
    email = snapshot.value['email'];
    cellPhone = snapshot.value['phone'];
    name = snapshot.value['fullName'];
  }
}
