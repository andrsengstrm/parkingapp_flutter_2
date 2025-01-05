import 'package:server/server_config.dart';
import 'package:shared/models/person.dart';
import 'package:shared/objectbox.g.dart';
import 'package:shared/repositories/repository_interface.dart';

class PersonRepository implements RepositoryInterface<Person> {

  Box itemBox = ServerConfig().store.box<Person>();

  @override
  Future<Person?> create(Person item) async {
    itemBox.put(item, mode: PutMode.insert);
    return item;
  }

  @override
  Future<Person?> readById(int id) async {
    return itemBox.get(id);
  }

  Future<Person?> readByEmail(String email) async {
    return itemBox.getAll().where((p) => p.email == email).firstOrNull;
  }


  @override
  Future<List<Person>?> read() async {
    var itemList = itemBox.getAll().cast<Person>();
    return itemList;
  }


  @override
  Future<Person?> update(int id, Person item) async {
    itemBox.put(item, mode: PutMode.update);
    return item;
  }

  @override
  Future<Person?> delete(int id) async {
    var itemToDelete = itemBox.get(id);
    if(itemToDelete != null) {
      itemBox.remove(id);
    }
    return itemToDelete;
  }

}
