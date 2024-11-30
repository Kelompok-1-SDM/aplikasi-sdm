import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:dio/dio.dart';

class KegiatanService {
  final Dio dio = DioClient.getInstance();

  Future<BaseResponse<ListKegiatan>> fetchListKegiatanByUser(
      {String type = "", String tanggal = ""}) async {
    try {
      // Making the GET request
      final response = await dio.get(
        '/api/kegiatan/',
        queryParameters: {
          'uid_user': '',
          if (type.isNotEmpty) 'type': type, // Conditionally include 'type'
          if (tanggal.isNotEmpty)
            'tanggal': tanggal // Conditionally include 'tanggal'
        },
      );

      // Parsing the response
      final BaseResponse<ListKegiatan> data =
          BaseResponse<ListKegiatan>.fromJson(
        response.data,
        (json) => ListKegiatan.fromJson(json),
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
        return BaseResponse<ListKegiatan>(
          success: false,
          message: error.response?.data['message'] ?? 'Unknown error occurred',
        );
      } else {
        return BaseResponse<ListKegiatan>(
          success: false,
          message:
              'No response from the server. Check your internet connection.',
        );
      }
    } catch (e) {
      print("Unexpected error: $e");
      return BaseResponse<ListKegiatan>(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  fetchDetailKegiatan(int tugasId) {}
}
