import 'package:aplikasi_manajemen_sdm/services/auth/auth_model.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/shared_prefrences.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio dio = DioClient.getInstance();

  Future<BaseResponse<LoginResponse>> login(String nip, String password) async {
    try {
      // Making the POST request
      final response = await dio.post(
        '/api/login',
        data: {'nip': nip, 'password': password},
      );

      // Parsing the response
      final BaseResponse<LoginResponse> data =
          BaseResponse<LoginResponse>.fromJson(
        response.data,
        (json) => LoginResponse.fromJson(json),
      );

      // Check if the response is successful
      if (response.statusCode == 200 && data.success) {
        final String? token = data.data?.token;

        if (token != null) {
          // Save the token and its expiry date
          DateTime expiryDate = DateTime.now().add(Duration(days: 7));
          await Storage.saveToken(token, expiryDate);
          await Storage.saveMyInfo(UserData(
              userId: data.data!.userId.toString(),
              nip: data.data!.nip.toString(),
              nama: data.data!.nama.toString(),
              email: data.data!.email.toString(),
              role: data.data!.role.toString(),
              profileImage: data.data!.profileImage.toString(),
              createdAt: data.data!.createdAt.toString(),
              kompetensi: []));
          print("Token saved, valid until: $expiryDate");
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
        return BaseResponse<LoginResponse>(
          success: false,
          message: error.response?.data['message'] ?? 'Unknown error occurred',
        );
      } else {
        return BaseResponse<LoginResponse>(
          success: false,
          message:
              'No response from the server. Check your internet connection.',
        );
      }
    } catch (e) {
      print("Unexpected error: $e");
      return BaseResponse<LoginResponse>(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }
}
