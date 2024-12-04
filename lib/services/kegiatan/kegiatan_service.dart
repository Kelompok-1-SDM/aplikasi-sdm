import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:dio/dio.dart';

class KegiatanService {
  final Dio dio = DioClient.getInstance();

  Future<BaseResponse<List<KegiatanResponse>>> fetchListKegiatanByUser({
    bool? isDone,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'uid_user': '', // Assuming 'uid_user' is mandatory
      };

      if (isDone != null) {
        queryParameters['is_done'] = isDone;
      }
      // Make the GET request
      final response = await dio.get(
        '/api/kegiatan/',
        queryParameters: queryParameters,
      );

      // Use a custom `fromJsonT` function for a list of KegiatanResponse
      final BaseResponse<List<KegiatanResponse>> data =
          BaseResponse<List<KegiatanResponse>>.fromJson(
        response.data,
        (json) => (json as List<dynamic>)
            .map((item) => KegiatanResponse.fromJson(item))
            .toList(),
      );

      // Return the data if successful
      if (response.statusCode == 200 && data.success) {
        return data;
      } else {
        throw Exception(
            "Failed to fetch kegiatan. Status code: ${response.statusCode}");
      }
    } on DioException catch (error) {
      // Handle Dio-specific errors
      return BaseResponse<List<KegiatanResponse>>(
        success: false,
        message: error.response?.data['message'] ?? 'An error occurred',
      );
    } catch (e) {
      // Handle unexpected errors
      return BaseResponse<List<KegiatanResponse>>(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<BaseResponse<KegiatanResponse>> fetchKegiatanById(String uid) async {
    try {
      // Make the GET request
      final response = await dio.get(
        '/api/kegiatan/',
        queryParameters: {'uid': uid},
      );

      // Use a custom `fromJsonT` function for a list of KegiatanResponse
      final BaseResponse<KegiatanResponse> data =
          BaseResponse<KegiatanResponse>.fromJson(
              response.data, (json) => KegiatanResponse.fromJson(json));

      // Return the data if successful
      if (response.statusCode == 200 && data.success) {
        return data;
      } else {
        throw Exception(
            "Failed to fetch kegiatan. Status code: ${response.statusCode}");
      }
    } on DioException catch (error) {
      // Handle Dio-specific errors
      return BaseResponse<KegiatanResponse>(
        success: false,
        message: error.response?.data['message'] ?? 'An error occurred',
      );
    } catch (e) {
      // Handle unexpected errors
      return BaseResponse<KegiatanResponse>(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
