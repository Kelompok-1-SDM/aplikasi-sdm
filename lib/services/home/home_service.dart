import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/home/home_model.dart';
import 'package:aplikasi_manajemen_sdm/services/shared_prefrences.dart';
import 'package:dio/dio.dart';

class HomeService {
  final Dio dio = DioClient.getInstance();

  Future<BaseResponse<HomeResponse>> fetchDataHome() async {
    try {
      // Making the GET request
      final response = await dio.get(
        '/api/user/homepage-mobile',
        queryParameters: {'uid': ''},
      );

      // Parsing the response
      final BaseResponse<HomeResponse> data =
          BaseResponse<HomeResponse>.fromJson(
        response.data,
        (json) => HomeResponse.fromJson(json),
      );

      // Check if the response is successful
      if (response.statusCode == 200 && data.success) {
        // Save statistik to shared session
        double average = 0;
        if (data.data?.statistik?.jumlahKegiatan != null) {
          var sum = data.data!.statistik!.jumlahKegiatan!
              .map(
                  (it) => it.jumlahKegiatan ?? 0) // Replace null 'count' with 0
              .reduce((a, b) => a + b); // Sum all counts

          average = sum /
              data.data!.statistik!.jumlahKegiatan!.length; // Calculate average
        }
        await Storage.setAvg(average);
        return data;
      } else {
        throw Exception(
            "Failed to log in. Status code: ${response.statusCode}");
      }
    } on DioException catch (error) {
      print("DioException occurred: ${error.message}");
      // Check if there's a response available
      if (error.response != null) {
        return BaseResponse<HomeResponse>(
          success: false,
          message: error.response?.data['message'] ?? 'Unknown error occurred',
        );
      } else {
        return BaseResponse<HomeResponse>(
          success: false,
          message:
              'No response from the server. Check your internet connection.',
        );
      }
    } catch (e) {
      print("Unexpected error: $e");
      return BaseResponse<HomeResponse>(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }
}
