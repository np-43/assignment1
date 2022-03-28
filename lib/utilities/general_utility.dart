import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'custom_controls/np_alert_dialog.dart';
import 'custom_controls/np_loader_dialog.dart';

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

  getTextStyle({Color? color, Color? bgColor, double fontSize = 15}) {
    return TextStyle(
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

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
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