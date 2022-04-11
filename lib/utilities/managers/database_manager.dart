import 'dart:io';
import 'package:assignment1/models/doctor_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Boxes {

  Boxes._();

  static const String doctor = "doctor";

}

class DatabaseManager {

  static DatabaseManager? _instance;
  DatabaseManager._internal() {
    _instance = this;
  }

  static DatabaseManager get shared => _instance ?? DatabaseManager._internal();

  late Database _database;
  late Box _box;

  _initDatabase() async {
    // Hive initialization
    await Hive.initFlutter();

    // sqflite initialization
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
    await DatabaseManager.registerAdapters();
  }

  static registerAdapters() {
    Hive.registerAdapter(DoctorModelAdapter());
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
        "blood_group TEXT,"
        "height TEXT,"
        "weight TEXT,"
        "is_edited INTEGER"
        ")");
  }

  Future<Box<T>> getBox<T>(String name) async {
    Box<T> box = await Hive.openBox<T>(name);
    return box;
  }

}

extension ExtDatabaseManager1 on DatabaseManager {

  insertDoctor(DoctorModel model) async {
    Box<DoctorModel> box = await getBox<DoctorModel>(Boxes.doctor);
    var res = await box.add(model);
    return res;
    // var res = await _database.insert("Doctor", model.toJson());
    // return res;
  }

  insertDoctors(List<DoctorModel> list, void Function() completion) {
    getBox<DoctorModel>(Boxes.doctor).then((value) {
      value.addAll(list).whenComplete(() => completion());
    });
    // Batch batch = _database.batch();
    // for (var model in list) {
    //   Map<String, dynamic> map = model.toJson();
    //   batch.insert("Doctor", map);
    // }
    // batch.commit().then((value) => completion());
  }

  updateDoctor(DoctorModel model) async {
    Box<DoctorModel> box = await getBox<DoctorModel>(Boxes.doctor);
    var res = await box.put(model.key, model);
    return res;
    // model.isEdited = true;
    // var res = await _database.update("Doctor", model.toJson(), where: "id = ?", whereArgs: [model.id]);
    // return res;
  }

  getAllDoctorIDs(void Function(List<int>) completion) {
    getBox<DoctorModel>(Boxes.doctor).then((value) {
      List<int> list = value.values.map((e) => e.id ?? 0).where((element) => element != 0).toList();
      print("Get IDs :: $list");
      completion(list);
    });
    // _database.rawQuery("SELECT id FROM Doctor").then((value) {
    //   List<int> list = value.map((e) => e["id"].toString().toInt() ?? 0).toList();
    //   List<int> filtered = list.where((element) => element != 0).toList();
    //   completion(filtered);
    // });
  }

  Future<List<DoctorModel>> getAllDoctors() async {
    Box<DoctorModel> box = await getBox<DoctorModel>(Boxes.doctor);
    print("TEST :: ${box.values.toList().map((e) => e.key).toList()}");
    return box.values.toList();
    // var res = await _database.query("Doctor");
    // List<DoctorModel> list = res.isNotEmpty ? res.map((c) => DoctorModel.fromJson(c)).toList() : [];
    // return list;
  }

}