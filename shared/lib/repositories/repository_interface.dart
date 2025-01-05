abstract interface class RepositoryInterface<T> {

  Future<T?> create(T item);
  Future<List<T>?> read();
  Future<T?> readById(int id);
  Future<T?> update(int id, T item);
  Future<T?> delete(int id);

}