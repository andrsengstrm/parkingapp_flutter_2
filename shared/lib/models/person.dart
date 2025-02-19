import 'package:objectbox/objectbox.dart';

//class for owner of a vehicle
@Entity()
class Person {
  @Id()
  int id;
  String personId;
  String name;
  String email;
  String? config;

  //constructor with optional id, it not supplied we create a uid
  Person({int? id, required this.personId, required this.name, required this.email, this.config }) : id = id ?? -1;

  //deserialize from json
  Person.fromJson(Map<String, dynamic> json)
    : id = json["id"] as int,
      personId = json["personId"] as String,
      name = json["name"] as String,
      email = json["email"] as String,
      config = json["config"] as String?;

  //serialize to json
  Map<String, dynamic> toJson() => {
    "id": id,
    "personId": personId,
    "name": name,
    "email": email,
    "config": config
  };

  //return a string with some predefined details
  String get printDetails => "$id $name $personId $email";

}