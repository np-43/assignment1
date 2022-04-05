import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NPGetXManager {

  static NPGetXManager? _instance;
  NPGetXManager._internal() {
    _instance = this;
  }
  static NPGetXManager get shared => _instance ?? NPGetXManager._internal();

}

extension ExtNPGetXManager1 on NPGetXManager {

  push(dynamic page){
    Get.to(page);
  }

  pushAndRemove(dynamic page){
    Get.offAll(page);
  }

  pop(){
    Get.back();
  }

}

extension ExtGetxString on String {

  RxString get observable {
    return obs;
  }
  
  observer(WidgetCallback builder){
    Obx(builder);
  }

}

extension ExtGetxT<T> on T {

  Rx<T> get observable => Rx<T>(this);

  observer(WidgetCallback builder){
    Obx(builder);
  }

}