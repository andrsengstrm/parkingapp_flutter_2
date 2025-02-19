import 'package:server/server_config.dart';
import 'package:shared/models/vehicle.dart';
import 'package:shared/objectbox.g.dart';
import 'package:shared/repositories/repository_interface.dart';

class VehicleRepository implements RepositoryInterface<Vehicle> {

  Box itemBox = ServerConfig().store.box<Vehicle>();

  @override
  Future<Vehicle?> create(Vehicle item) async {
    item.isDeleted = false;
    itemBox.put(item, mode: PutMode.insert);
    return item;
  }

  @override
  Future<Vehicle?> readById(int id) async {
    return itemBox.get(id);
  }

  Future<List<Vehicle>?> readByOwnerEmail(String email) async {
    var items = itemBox.getAll().where((v) => v.owner.email == email && !v.isDeleted).toList().cast<Vehicle>();
    return items;
  }


  @override
  Future<List<Vehicle>?> read() async {
    var itemList = itemBox.getAll().where((v) => !v.isDeleted).cast<Vehicle>().toList();
    return itemList;
  }


  @override
  Future<Vehicle?> update(int id, Vehicle item) async {
    itemBox.put(item, mode: PutMode.update);
    return item;
  }

  @override
  Future<Vehicle?> delete(int id) async {
    var itemToDelete = itemBox.get(id);
    itemToDelete.isDeleted = true;
    if(itemToDelete != null) {
      itemBox.put(itemToDelete, mode: PutMode.update);
      //itemBox.remove(id); 
    }
    return itemToDelete;
  }

}
