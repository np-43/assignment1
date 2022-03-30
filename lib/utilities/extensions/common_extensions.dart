import 'dart:convert';

extension ExtString on String {

  bool isSpaceEmpty() {
    return trim().isEmpty;
  }

  int? toInt() {
    return int.tryParse(this);
  }

  double? toDouble() {
    return double.tryParse(this);
  }

}

extension ExtMap on Map {

  String toJSONString() {
    return jsonEncode(this).toString();
  }

}

extension ExtList on List {

  String toJSONString() {
    return jsonEncode(this).toString();
  }

}