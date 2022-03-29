import 'package:assignment1/constants/image_constant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../base_classes/base_text.dart';
import '../constants/color_constant.dart';
import 'custom_controls/np_alert_dialog.dart';
import 'custom_controls/np_loader_dialog.dart';
import 'managers/font_enum.dart';
import 'extensions/common_extensions.dart';

class GeneralUtility {

  static GeneralUtility? _instance;
  GeneralUtility._internal() {
    _instance = this;
  }

  static GeneralUtility get shared => _instance ?? GeneralUtility._internal();

}

GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

enum AlertAction { ok, cancel, yes, no }
extension ExtAlertAction on AlertAction {
  String get displayText {
    switch(this) {
      case AlertAction.ok: return "OK";
      case AlertAction.cancel: return "CANCEL";
      case AlertAction.yes: return "YES";
      case AlertAction.no: return "NO";
    }
  }
  TextStyle get textStyle {
    switch(this) {
      case AlertAction.no:
        return GeneralUtility.shared.getTextStyle(color: Colors.red);
      default:
        return GeneralUtility.shared.getTextStyle(color: Colors.blue);
    }
  }
}

extension ExtGeneralUtility1 on GeneralUtility {

  getTextStyle({MyFont myFont = MyFont.rRegular, Color? color, Color? bgColor, double fontSize = 15}) {
    return TextStyle(
      fontFamily: myFont.family,
      fontWeight: myFont.weight,
      color: color,
      backgroundColor: bgColor,
      fontSize: fontSize
    );
  }

  push(BuildContext context, Widget page, {int delay = 1}) {
    Future.delayed(Duration(microseconds: delay), (){
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
    });
  }

  pushAndRemove(BuildContext context, Widget page, {int delay = 1}) {
    Future.delayed(Duration(microseconds: delay), (){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => page), (_) => false);
    });
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Size getScreenSize(BuildContext buildContext) {
    return MediaQuery.of(buildContext).size;
  }

  getNoDataView({String? message}) {
    return Center(
      child:  BaseText(text: message ?? "No data found", color: ColorConst.black, fontSize: 20,),
    );
  }

  Image getAssetImage({String? name, double? height, double? width, BoxFit? fit, String? ext, Color? color}){
    if (height != null || width != null) {
      return Image.asset("assets/images/${name ?? ""}.${ext ?? "png"}", fit: fit ?? BoxFit.none, color: color, height: height, width: width,);
    }
    return Image.asset("assets/images/${name ?? ""}.${ext ?? "png"}", fit: fit ?? BoxFit.fill, color: color,);
  }

  Image getNetworkImage({String? url, double? height, double? width, BoxFit? fit, String? ext, Color? color}){
    if (url?.isSpaceEmpty() ?? false) {
      return getAssetImage(name: ImageConst.icUserDoctorPlaceholder, ext: "png", height: height, width: width, fit: fit, color: color);
    }
    if (height != null || width != null) {
      return Image.network(url ?? "", fit: fit ?? BoxFit.none, color: color, height: height, width: width, errorBuilder: (context,object,_) {
        return getAssetImage(name: ImageConst.icUserDoctorPlaceholder, ext: "png", height: height, width: width, fit: fit, color: color);
      },);
    }
    return Image.network(url ?? "", fit: fit ?? BoxFit.fill, color: color, height: height, width: width, errorBuilder: (context,object,_) {
      return getAssetImage(name: ImageConst.icUserDoctorPlaceholder, ext: "png", height: height, width: width, fit: fit, color: color);
    },);
  }

}

extension ExtGeneralUtility2 on GeneralUtility {

  showProcessing({String? message, bool isFromInitState = true}) {
    if (navKey.currentContext == null) {
      return;
    }
    if (isFromInitState) {
      SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        showDialog(context: navKey.currentContext!, barrierDismissible: false, builder: (BuildContext buildContext) {
          return NPLoaderDialog(message: message);
        });
      });
    } else {
      showDialog(context: navKey.currentContext!, barrierDismissible: false, builder: (BuildContext buildContext) {
        return NPLoaderDialog(message: message);
      });
    }
  }

  hideProcessing({bool isFromInitState = true}) {
    if (navKey.currentContext == null) {
      return;
    }
    if (isFromInitState) {
      SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        Navigator.of(navKey.currentContext!).pop();
      });
    } else {
      Navigator.of(navKey.currentContext!).pop();
    }
  }

  showSnackBar(String message) {
    if (navKey.currentContext == null) {
      return;
    }
    ScaffoldMessenger.of(navKey.currentContext!).removeCurrentSnackBar();
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(navKey.currentContext!).showSnackBar(snackBar);
  }

  showAlert({String? title, String? message, List<AlertAction>? listActions, void Function(AlertAction)? completion}) {
    if (navKey.currentContext == null) {
      return;
    }
    List<AlertAction> actions = listActions ?? [];
    if(actions.isEmpty) {
      actions = [AlertAction.ok];
    }
    Future.delayed(const Duration(microseconds: 1), (){
      showDialog(context: navKey.currentContext!, barrierDismissible: false, builder: (BuildContext buildContext) {
        return NPAlertDialog(title: title, message: message, listActions: actions, completion: (alertAction){
          Navigator.of(buildContext).pop();
          if(completion != null) {
            completion(alertAction);
          }
        });
      });
    });
  }

}