import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:dio/dio.dart';

class UserService {
  final Dio dio = DioClient.getInstance();

  Future<Object?> myInfo() async {
    try {
      final response = await dio.get(
        '/api/user',
        data: {'uid': ''},
      );
      final BaseResponse<UserData> data = BaseResponse<UserData>.fromJson(
          response.data, (json) => UserData.fromJson(json));
      if (response.statusCode == 200 && data.success) {
        return data; // Return the data for success handling
      } else {
        throw Exception(
            "Failed to log in. Status code: ${response.statusCode}");
      }
    } on DioException catch (error) {
      print("DioException occurred: ${error.message}");
      // Check if there's a response available
      if (error.response != null) {
        return BaseResponse<UserData>(
          success: false,
          message: error.response?.data['message'] ?? 'Unknown error occurred',
        );
      } else {
        return BaseResponse<UserData>(
          success: false,
          message:
              'No response from the server. Check your internet connection.',
        );
      }
    } catch (e) {
      print("Unexpected error: $e");
      return BaseResponse<UserData>(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }
}
