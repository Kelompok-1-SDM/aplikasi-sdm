import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:dio/dio.dart';
import 'shared_prefrences.dart';

class BaseResponse<T> {
  final bool success;
  final T? data;
  final String message;

  BaseResponse({required this.success, this.data, required this.message});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return BaseResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'] ?? '',
    );
  }
}


class DioClient {
  static Dio? _dio;

  static Dio getInstance() {
    _dio ??= Dio(
      BaseOptions(
        baseUrl: urlBase,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Add an interceptor to handle authorization
    _dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Attach the token to the request headers
        String? token = await Storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        // Handle 401 unauthorized errors
        if (error.response?.statusCode == 401) {
          final responseData = error.response?.data;

          if (responseData != null) {
            // Parse the response message if available
            try {
              BaseResponse<dynamic> dat = BaseResponse<dynamic>.fromJson(
                responseData,
                (json) =>
                    json, // Pass-through, since we don't expect structured data
              );

              if (dat.message ==
                  "Access Token is expired, please login again") {
                // Clear the token if expired
                await Storage.clearToken();
                print("Token expired, clearing storage.");
              }
            } catch (e) {
              print("Error parsing error response: $e");
            }
          }
        }
        return handler.next(error);
      },
    ));

    return _dio!;
  }
}
