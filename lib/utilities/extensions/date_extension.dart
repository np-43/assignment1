import 'package:intl/intl.dart' as dt;

enum DateFormat { ddmmyyyyDash, mmddyyyyDash, ddmmyyyySlash, mmddyyyySlash, ddmmmmyyyyDash, yyyymmddhhmmssDashSpaceColon24Hr }

extension on DateFormat {

  String get value {
    switch(this) {
      case DateFormat.ddmmyyyyDash: return "dd-MM-yyyy";
      case DateFormat.mmddyyyyDash: return "MM-dd-yyyy";
      case DateFormat.ddmmyyyySlash: return "dd/MM/yyyy";
      case DateFormat.mmddyyyySlash: return "MM/dd/yyyy";
      case DateFormat.ddmmmmyyyyDash: return "dd-MMMM-yyyy";
      case DateFormat.yyyymmddhhmmssDashSpaceColon24Hr: return "yyyy-MM-dd HH:mm:ss";
    }
  }

}

extension ExtDateTime on DateTime {

  toFormattedString(DateFormat dateFormat){
    return dt.DateFormat(dateFormat.value).format(this);
  }

  static DateTime? getDateTime({required String? inputString, required DateFormat dateFormat}) {
    if((inputString?.length ?? 0) == 0) {
      return null;
    }
    return dt.DateFormat(dateFormat.value).parse(inputString!);
  }

  static String? changeFormat({required String? inputString, required DateFormat from, required DateFormat to}){
    if((inputString?.length ?? 0) == 0) {
      return null;
    }
    DateTime? dateTime = ExtDateTime.getDateTime(inputString: inputString, dateFormat: from);
    return dateTime?.toFormattedString(to);
  }

}