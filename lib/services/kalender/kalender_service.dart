import 'package:aplikasi_manajemen_sdm/services/auth/auth_model.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/kalender/kalender_model.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/services/shared_prefrences.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:dio/dio.dart';

class KalenderService {
  final Dio dio = DioClient.getInstance();

  Future<BaseResponse<KalenderResponse>> kegiatan(String id_kegiatan) async {
    try {
      // Making the POST request
      final response = await dio.get(
        '/api/kegiatan',
        queryParameters: {'uid_user': '', 'status': 'ditugaskan'},
      );

      // Parsing the response
      final BaseResponse<KalenderResponse> data =
          BaseResponse<KalenderResponse>.fromJson(
        response.data,
        (json) => KalenderResponse.fromJson(json),
      );

      // Check if the response is successful
      if (response.statusCode == 200 && data.success) {
        return data;
      } else {
        throw Exception(
            "Failed to log in. Status code: ${response.statusCode}");
      }
    } on DioException catch (error) {
      print("DioException occurred: ${error.message}");
      // Check if there's a response available
      if (error.response != null) {
        return BaseResponse<KalenderResponse>(
          success: false,
          message: error.response?.data['message'] ?? 'Unknown error occurred',
        );
      } else {
        return BaseResponse<KalenderResponse>(
          success: false,
          message:
              'No response from the server. Check your internet connection.',
        );
      }
    } catch (e) {
      print("Unexpected error: $e");
      return BaseResponse<KalenderResponse>(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }
}
