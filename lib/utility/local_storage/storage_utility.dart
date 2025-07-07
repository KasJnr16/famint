import 'package:get_storage/get_storage.dart';

class UniLocalStorage {
  late final GetStorage _storage;

  //Singleton instance
  static UniLocalStorage? _instance;

  UniLocalStorage._internal();

  factory UniLocalStorage.instance() {
    _instance ??= UniLocalStorage._internal();
    return _instance!;
  }

  //Assign user based storage
  static Future<void> init(String bucketName) async {
    await GetStorage.init(bucketName);
    _instance = UniLocalStorage._internal();
    _instance!._storage = GetStorage(bucketName);
  }

  //save data
  Future<void> saveData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  //read data
  T? readData<T>(String key) {
    return _storage.read<T>(key);
  }

  //remove data
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  //clear all data
  Future<void> clearAll() async {
    await _storage.erase();
  }
}
