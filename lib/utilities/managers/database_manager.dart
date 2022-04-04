import 'dart:io';
import 'package:assignment1/models/doctor_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:assignment1/utilities/extensions/common_extensions.dart';

class DatabaseManager {

  static DatabaseManager? _instance;
  DatabaseManager._internal() {
    _instance = this;
  }

  static DatabaseManager get shared => _instance ?? DatabaseManager._internal();

  late Database _database;

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Assignment1.db");
    _database = await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      _database = db;
      await _createDoctorTable();
    });
  }

  static initDB() async {
    await DatabaseManager.shared._initDatabase();
  }

}

extension on DatabaseManager {

  _createDoctorTable() async {
    await _database.execute("CREATE TABLE Doctor ("
        "id INTEGER PRIMARY KEY,"
        "first_name TEXT,"
        "last_name TEXT,"
        "profile_pic TEXT,"
        "profile_pic_local TEXT,"
        "favorite INTEGER,"
        "primary_contact_no TEXT,"
        "rating TEXT,"
        "email_address TEXT,"
        "qualification TEXT,"
        "description TEXT,"
        "specialization TEXT,"
        "languagesKnown TEXT,"
        "dob TEXT,"
        "is_edited INTEGER"
        ")");
  }

}

extension ExtDatabaseManager1 on DatabaseManager {

  insertDoctor(DoctorModel model) async {
    var res = await _database.insert("Doctor", model.toJson());
    return res;
  }

  insertDoctors(List<DoctorModel> list, void Function() completion) {
    Batch batch = _database.batch();
    for (var model in list) {
      Map<String, dynamic> map = model.toJson();
      batch.insert("Doctor", map);
    }
    batch.commit().then((value) => completion());
  }

  updateDoctor(DoctorModel model) async {
    model.isEdited = true;
    var res = await _database.update("Doctor", model.toJson(), where: "id = ?", whereArgs: [model.id]);
    return res;
  }

  getAllDoctorIDs(void Function(List<int>) completion) {
    _database.rawQuery("SELECT id FROM Doctor").then((value) {
      List<int> list = value.map((e) => e["id"].toString().toInt() ?? 0).toList();
      List<int> filtered = list.where((element) => element != 0).toList();
      completion(filtered);
    });
  }

  Future<List<DoctorModel>> getAllDoctors() async {
    var res = await _database.query("Doctor");
    List<DoctorModel> list = res.isNotEmpty ? res.map((c) => DoctorModel.fromJson(c)).toList() : [];
    return list;
  }

}