import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/shared_prefrences.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:dio/dio.dart';

// class UserService {
//   final Dio dio = DioClient.getInstance();

//   Future<Object?> myInfo() async {
//     late BaseResponse<UserData> data;
//     try {
//       final response = await dio.get(
//         '/api/user',
//         data: {'uid': ''},
//       );
//       data = BaseResponse<UserData>.fromJson(response.data);
//       if (response.statusCode == 200) {
//         await Storage.saveMyInfo(data.data!);
//         return data; // Return the data for success handling
//       }
//     } on DioException catch (error) {
//       if (error.response!.statusCode! > 400) {
//         return data;
//       }
//       return error;
//     }
//     return null;
//   }
// }
