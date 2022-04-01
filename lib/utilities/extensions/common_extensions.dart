import 'dart:convert';
import 'dart:typed_data';

import 'dart:ui';

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

  static String? getBase64(Uint8List? data) {
    if(data != null) {
      return base64Encode(data);
    }
    return null;
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