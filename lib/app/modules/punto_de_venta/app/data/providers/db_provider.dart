abstract class DBProvider {
  //copilot
  Future<void> open();
  Future<void> close();
  Future<void> delete();

  //By Eder Jahir G B
  Future<void> insert(String path, Map<String, dynamic> data);
  Future<void> update(String path, Map<String, dynamic> data);
}
