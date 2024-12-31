import 'dart:convert';
import 'package:shared/models/person.dart';
import 'package:objectbox/objectbox.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

//class for vehicle
@Entity()
class Vehicle {

  @Id()
  int id; 
  String regId;
  String vehicleType;
  bool isDeleted;
  Person? owner;
  
  String get personOwner {
    return jsonEncode(owner?.toJson());
  }

  set personOwner(String json) {
    owner = Person.fromJson(jsonDecode(json));  
  }

  //constructor with optional id, if not supplied a uid is created
  Vehicle({int? id, required this.regId, required this.vehicleType, bool? isDeleted, this.owner }) 
    : id = id ?? -1, isDeleted = isDeleted ?? false;

  //deserialize from json
  factory Vehicle.fromJson(Map<String,dynamic> json) {
    return Vehicle (
      id: json["id"],
      regId: json["regId"],
      vehicleType: json["vehicleType"],
      isDeleted: json["isDeleted"],
      owner: Person.fromJson(json["owner"])
    );
  
  }

  //serialize to json, we add in owner as an object instead of only the ownerId
  Map<String, dynamic> toJson() => {
    "id": id,
    "regId": regId,
    "vehicleType": vehicleType,
    "isDeleted": isDeleted,
    "owner": owner?.toJson()
  };

  //return a string with some predefined details
  String get printDetails => "$id $regId $vehicleType ${owner?.name}";

}

//enum for vehicle type
enum VehicleType { 
  bil, mc, lastbil, ospecificerad;
}
 