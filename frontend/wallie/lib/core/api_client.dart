import 'package:dio/dio.dart';
import 'package:wallie/core/constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio dio;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {"Content-Type": "application/json"},
      ),
    );

    // Add Interceptors for logging and error handling
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("Sending request to ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("Received response: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print("Error: ${e.message}");
          return handler.reject(e);
        },
      ),
    );
  }

  Future<Response> getRequest(String path) async {
    return await dio.get(path);
  }

  Future<Response> postRequest(String path, dynamic data) async {
    return await dio.post(path, data: data);
  }
}
