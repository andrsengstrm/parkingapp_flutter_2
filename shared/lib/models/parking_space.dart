import 'package:objectbox/objectbox.dart';

//class for parking space
@Entity()
class ParkingSpace {

  @Id()
  int id;
  String address;
  double pricePerHour;
  bool isDeleted;

  //constructor with optional id, if not supplied we create an uid
  ParkingSpace({int? id, required this.address, required this.pricePerHour, bool? isDeleted})
    : id = id ?? -1, isDeleted = isDeleted ?? false;

  //deserialize from json
  ParkingSpace.fromJson(Map<String, dynamic> json)
    : id = json["id"] as int,
      address = json["address"] as String,
      pricePerHour = json["pricePerHour"] as double,
      isDeleted = json["isDeleted"] as bool;

  //serialize to json
  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "pricePerHour": pricePerHour,
    "isDeleted": isDeleted
  };

  //return some predefined details
  String get printDetails => "$id $address ${pricePerHour.toStringAsFixed(2)}";

}