import '../../utilities/extensions/common_extensions.dart';
import '../../utilities/general_utility.dart';
import 'package:dio/dio.dart';

enum HttpMethod { get, post, put, delete }
extension on HttpMethod {
  String get value {
    switch(this) {
      case HttpMethod.get: return "GET";
      case HttpMethod.post: return "POST";
      case HttpMethod.put: return "PUT";
      case HttpMethod.delete: return "DELETE";
    }
  }
}

enum API { getDoctors }
extension on API {

  String getURL(dynamic data) {
    switch(this) {
      case API.getDoctors: return "contacts";
    }
  }

  HttpMethod get method {
    switch(this) {
      default:
        return HttpMethod.get;
    }
  }

  Map<String, dynamic>? get headers {
    switch(this) {
      default: return null;
    }
  }

  dynamic getData(dynamic data) {
    switch(this) {
      default: return null;
    }
  }

  Map<String, dynamic>? getQueryParameter(dynamic data) {
    switch(this) {
      default: return null;
    }
  }

}

typedef APIResponseBlock = void Function(bool status, String message, dynamic response);

class APIManager {

  static APIManager? _instance;
  APIManager._internal() {
    _instance = this;
    _initDio();
  }

  static APIManager get shared => _instance ?? APIManager._internal();

  final Dio _dio = Dio();

  _initDio() {
    BaseOptions baseOptions = BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        baseUrl: "https://5efdb0b9dd373900160b35e2.mockapi.io/"
    );
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (option, handler){
        _printRequest(option);
        handler.next(option);
      }
    ));
    _dio.options = baseOptions;
  }

  performCall({required API api, dynamic data, required APIResponseBlock completion}) {
    _performRequest(api: api, data: data, completion: completion);
  }

}

extension on APIManager {

  _performRequest({required API api, dynamic data, required APIResponseBlock completion}) {
    GeneralUtility.shared.checkConnectivity().then((value) {
      if (value) {
        _dio.request(
            api.getURL(data),
            data: api.getData(data),
            queryParameters: api.getQueryParameter(data),
            options: Options(method: api.method.value, headers: api.headers)
        ).then((value) {
          print(value.data.toString());
          _handleAPIResponse(api, value, completion);
        }).catchError((error) {
          print("\nError: ${error.toString()}\n");
          if(error is DioError) {
            completion(false, error.message.toString(), null);
          } else {
            completion(false, error.toString(), null);
          }
        });
      } else {
        GeneralUtility.shared.showSnackBar("No internet connection.");
        completion(false, "No internet connection.", null);
      }
    });
  }

}

extension on APIManager {

  _handleAPIResponse(API api, Response<dynamic> value, APIResponseBlock completion) {
    // Need to check status, for this project checking data type.
    if (value.data is List<dynamic>) {
      completion(true, "", value.data);
    } else {
      completion(false, value.data.toString(), null);
    }
  }

}

extension on APIManager {

  _printRequest(RequestOptions option) {
    String headers = "";
    _dio.options.headers.forEach((key, value) {
      headers = headers + "-H \"$key: $value\" \\\n";
    });
    option.headers.forEach((key, value) {
      headers = headers + "-H \"$key: $value\"\\\n";
    });
    String data = "";
    Map<String, dynamic>? map = option.data as Map<String, dynamic>?;
    if ((map?.length?? 0) > 0) {
      String json = map!.toJSONString().replaceAll("\"", "\\\"");
      data = "-d \"$json\" \\\n";
    }
    print("\n********************************* cURL Request ***********************************\n"
        "curl -v \\\n"
        "-X ${option.method.toUpperCase()} \\\n"
        "$headers"
        "$data"
        "\"${option.uri.toString()}\""
        "\n**********************************************************************************\n");
  }

}