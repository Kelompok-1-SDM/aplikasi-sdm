import 'dart:io';

import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/home/home_model.dart';
import 'package:aplikasi_manajemen_sdm/services/shared_prefrences.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:dio/dio.dart';

class UserService {
  final Dio dio = DioClient.getInstance();

  Future<BaseResponse<UserData>> fetchMyinfo() async {
    try {
      // Making the GET request
      final response = await dio.get(
        '/api/user',
        queryParameters: {'uid': ''},
      );

      // Parsing the response
      final BaseResponse<UserData> data = BaseResponse<UserData>.fromJson(
        response.data,
        (json) => UserData.fromJson(json),
      );

      // Check if the response is successful
      if (response.statusCode == 200 && data.success) {
        await Storage.saveMyInfo(data.data!);
        return data;
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

  Future<BaseResponse<Statistik>> fetchStats({int? year}) async {
    try {
      // Making the GET request
      final response = await dio.get(
        '/api/user/statistic',
        queryParameters: {
          'uid': '', // Assuming 'uid' should be included
          if (year != null)
            'year': year, // Only include 'year' if it's not null
        },
      );

      // Parsing the response
      final BaseResponse<Statistik> data = BaseResponse<Statistik>.fromJson(
        response.data,
        (json) => Statistik.fromJson(json),
      );

      // Check if the response is successful
      if (response.statusCode == 200 && data.success) {
        if (data.data!.jumlahKegiatan != null) {
          var sum = data.data!.jumlahKegiatan!
              .map(
                  (it) => it.jumlahKegiatan ?? 0) // Replace null 'count' with 0
              .reduce((a, b) => a + b); // Sum all counts

          double average =
              sum / data.data!.jumlahKegiatan!.length; // Calculate average
          await Storage.setAvg(average);
        }

        return data;
      } else {
        throw Exception(
            "Failed to log in. Status code: ${response.statusCode}");
      }
    } on DioException catch (error) {
      print("DioException occurred: ${error.message}");
      // Check if there's a response available
      if (error.response != null) {
        return BaseResponse<Statistik>(
          success: false,
          message: error.response?.data['message'] ?? 'Unknown error occurred',
        );
      } else {
        return BaseResponse<Statistik>(
          success: false,
          message:
              'No response from the server. Check your internet connection.',
        );
      }
    } catch (e) {
      print("Unexpected error: $e");
      return BaseResponse<Statistik>(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  Future<BaseResponse<UserData>> updatePassword(String password) async {
    try {
      // Making the GET request
      final response = await dio.put('/api/user',
          queryParameters: {'uid': ''}, data: {'password': password});

      // Parsing the response
      final BaseResponse<UserData> data = BaseResponse<UserData>.fromJson(
        response.data,
        (json) => UserData.fromJson(json),
      );

      // Check if the response is successful
      if (response.statusCode == 200 && data.success) {
        await Storage.saveMyInfo(data.data!);
        return data;
      } else {
        throw Exception(
            "Failed to update password. Status code: ${response.statusCode}");
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

  Future<BaseResponse<UserData>> updateProfile(File file) async {
    try {
      final FormData formData = FormData.fromMap(
        {
          'file': await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last,
              contentType: DioMediaType(
                  'image', file.path.split('/').last.split('.').last))
        },
      );

      // Making the GET request
      final response = await dio.put(
        '/api/user',
        queryParameters: {'uid': ''},
        data: formData,
      );

      // Parsing the response
      final BaseResponse<UserData> data = BaseResponse<UserData>.fromJson(
        response.data,
        (json) => UserData.fromJson(json),
      );

      // Check if the response is successful
      if (response.statusCode == 200 && data.success) {
        await Storage.saveMyInfo(data.data!);
        UserData? user = await Storage.getMyInfo();
        print(user!.profileImage);
        return data;
      } else {
        throw Exception(
            "Failed to update profile picture. Status code: ${response.statusCode}");
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
