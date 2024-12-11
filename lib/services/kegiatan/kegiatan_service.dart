import 'dart:io';

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

  Future<BaseResponse<Agenda>> fetchAgendaById(String uid) async {
    try {
      // Make the GET request
      final response = await dio.get(
        '/api/agenda/',
        queryParameters: {'uid': uid},
      );

      // Use a custom `fromJsonT` function for a list of KegiatanResponse
      final BaseResponse<Agenda> data = BaseResponse<Agenda>.fromJson(
          response.data, (json) => Agenda.fromJson(json));

      // Return the data if successful
      if (response.statusCode == 200 && data.success) {
        return data;
      } else {
        throw Exception(
            "Failed to fetch agenda. Status code: ${response.statusCode}");
      }
    } on DioException catch (error) {
      // Handle Dio-specific errors
      return BaseResponse<Agenda>(
        success: false,
        message: error.response?.data['message'] ?? 'An error occurred',
      );
    } catch (e) {
      // Handle unexpected errors
      return BaseResponse<Agenda>(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<BaseResponse<Agenda>> createAgenda(
      String uidKegiatan,
      String nama,
      String deskripsi,
      DateTime datetime,
      bool isDone,
      List<User>? anggota) async {
    try {
      // Make the GET request
      final response = await dio.post('/api/agenda/', queryParameters: {
        'uid_kegiatan': uidKegiatan
      }, data: {
        'jadwal_agenda': datetime.toIso8601String(),
        'nama_agenda': nama,
        'deskripsi_agenda': deskripsi,
        'is_done': isDone,
        if (anggota != null)
          'list_uid_user_kegiatan':
              anggota.map((it) => it.userToKegiatanId).toList()
      });

      // Use a custom `fromJsonT` function for a list of KegiatanResponse
      final BaseResponse<Agenda> data = BaseResponse<Agenda>.fromJson(
          response.data, (json) => Agenda.fromJson(json));

      // Return the data if successful
      if (response.statusCode == 200 && data.success) {
        return data;
      } else {
        throw Exception(
            "Failed to create agenda. Status code: ${response.statusCode}");
      }
    } on DioException catch (error) {
      // Handle Dio-specific errors
      print(error.response!.data);
      return BaseResponse<Agenda>(
        success: false,
        message: error.response?.data['message'] ?? 'An error occurred',
      );
    } catch (e) {
      // Handle unexpected errors
      return BaseResponse<Agenda>(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<BaseResponse<Agenda>> editAgenda(
      String uid,
      String nama,
      String deskripsi,
      DateTime datetime,
      bool isDone,
      List<User>? anggota) async {
    try {
      // Make the GET request
      final response = await dio.put('/api/agenda/', queryParameters: {
        'uid': uid
      }, data: {
        'jadwal_agenda': datetime.toIso8601String(),
        'nama_agenda': nama,
        'deskripsi_agenda': deskripsi,
        'is_done': isDone,
        if (anggota != null)
          'list_uid_user_kegiatan':
              anggota.map((it) => it.userToKegiatanId).toList()
      });

      // Use a custom `fromJsonT` function for a list of KegiatanResponse
      final BaseResponse<Agenda> data = BaseResponse<Agenda>.fromJson(
          response.data, (json) => Agenda.fromJson(json));

      // Return the data if successful
      if (response.statusCode == 200 && data.success) {
        return data;
      } else {
        throw Exception(
            "Failed to create agenda. Status code: ${response.statusCode}");
      }
    } on DioException catch (error) {
      // Handle Dio-specific errors
      print(error.response!.data);
      return BaseResponse<Agenda>(
        success: false,
        message: error.response?.data['message'] ?? 'An error occurred',
      );
    } catch (e) {
      // Handle unexpected errors
      return BaseResponse<Agenda>(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<BaseResponse<Agenda>> deleteAgenda(String uid) async {
    try {
      // Make the GET request
      final response =
          await dio.delete('/api/agenda/', queryParameters: {'uid': uid});

      // Use a custom `fromJsonT` function for a list of KegiatanResponse
      final BaseResponse<Agenda> data = BaseResponse<Agenda>.fromJson(
          response.data, (json) => Agenda.fromJson(json));

      // Return the data if successful
      if (response.statusCode == 200 && data.success) {
        return data;
      } else {
        throw Exception(
            "Failed to create agenda. Status code: ${response.statusCode}");
      }
    } on DioException catch (error) {
      // Handle Dio-specific errors
      print(error.response!.data);
      return BaseResponse<Agenda>(
        success: false,
        message: error.response?.data['message'] ?? 'An error occurred',
      );
    } catch (e) {
      // Handle unexpected errors
      return BaseResponse<Agenda>(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<BaseResponse<List<User>>> fetchAnggota(String uidKegiatan) async {
    try {
      // Make the GET request
      final response = await dio.get(
        '/api/penugasan/',
        queryParameters: {'uid_kegiatan': uidKegiatan},
      );

      // Use a custom `fromJsonT` function for a list of KegiatanResponse
      final BaseResponse<List<User>> data = BaseResponse<List<User>>.fromJson(
        response.data,
        (json) =>
            (json as List<dynamic>).map((item) => User.fromJson(item)).toList(),
      );

      // Return the data if successful
      if (response.statusCode == 200 && data.success) {
        return data;
      } else {
        throw Exception(
            "Failed to fetch penugasan. Status code: ${response.statusCode}");
      }
    } on DioException catch (error) {
      // Handle Dio-specific errors
      return BaseResponse<List<User>>(
        success: false,
        message: error.response?.data['message'] ?? 'An error occurred',
      );
    } catch (e) {
      // Handle unexpected errors
      return BaseResponse<List<User>>(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<BaseResponse<KegiatanResponse>> deleteAnggotaAgenda(
      String uidAgenda, String uidUserKegiatan) async {
    try {
      // Make the GET request
      final response = await dio.delete(
        '/api/agenda/user',
        queryParameters: {
          'uid': uidAgenda,
          'uid_user_kegiatan': uidUserKegiatan
        },
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
            "Failed to fetch penugasan. Status code: ${response.statusCode}");
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

  Future<BaseResponse<Agenda>> createProgressAgenda(
      String uidAgenda, String deskripsiProgress, List<File>? files) async {
    try {
      // Prepare FormData
      final formData = FormData.fromMap({
        'deskripsi_progress': deskripsiProgress,
        if (files != null)
          'files': files.map((file) {
            final fileExtension = file.path.split('.').last;
            final mimeType = _getMimeType(fileExtension); // Get MIME type
            return MultipartFile.fromFileSync(
              file.path,
              contentType: mimeType, // Add contentType
            );
          }).toList(),
      });

      // Make the POST request
      final response = await dio.post(
        '/api/agenda/progress',
        queryParameters: {'uid_agenda': uidAgenda},
        data: formData,
      );

      // Parse response
      final BaseResponse<Agenda> data = BaseResponse<Agenda>.fromJson(
          response.data, (json) => Agenda.fromJson(json));

      // Return data if successful
      if (response.statusCode == 200 && data.success) {
        return data;
      } else {
        throw Exception(
            "Failed to create progress. Status code: ${response.statusCode}");
      }
    } on DioException catch (error) {
      // Handle Dio-specific errors
      print(error.response?.data);
      return BaseResponse<Agenda>(
        success: false,
        message: error.response?.data['message'] ?? 'An error occurred',
      );
    } catch (e) {
      // Handle unexpected errors
      return BaseResponse<Agenda>(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<BaseResponse<Agenda>> editProgressAgenda(
      String uidProgress, String deskripsiProgress, List<File>? files) async {
    try {
      // Prepare FormData
      final formData = FormData.fromMap({
        'deskripsi_progress': deskripsiProgress,
        if (files != null)
          'files': files.map((file) {
            final fileExtension = file.path.split('.').last;
            final mimeType = _getMimeType(fileExtension); // Get MIME type
            return MultipartFile.fromFileSync(
              file.path,
              contentType: mimeType, // Add contentType
            );
          }).toList(),
      });

      // Make the PUT request
      final response = await dio.put(
        '/api/agenda/progress',
        queryParameters: {'uid': uidProgress},
        data: formData,
      );

      // Parse response
      final BaseResponse<Agenda> data = BaseResponse<Agenda>.fromJson(
          response.data, (json) => Agenda.fromJson(json));

      // Return data if successful
      if (response.statusCode == 200 && data.success) {
        return data;
      } else {
        throw Exception(
            "Failed to edit progress. Status code: ${response.statusCode}");
      }
    } on DioException catch (error) {
      // Handle Dio-specific errors
      print(error.response?.data);
      return BaseResponse<Agenda>(
        success: false,
        message: error.response?.data['message'] ?? 'An error occurred',
      );
    } catch (e) {
      // Handle unexpected errors
      return BaseResponse<Agenda>(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

// Helper function to determine MIME type
  DioMediaType _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return DioMediaType('image', 'jpeg');
      case 'png':
        return DioMediaType('image', 'png');
      case 'gif':
        return DioMediaType('image', 'gif');
      case 'pdf':
        return DioMediaType('application', 'pdf');
      case 'doc':
        return DioMediaType('application',
            'vnd.openxmlformats-officedocument.wordprocessingml.document');
      case 'xls':
        return DioMediaType('application', 'vnd.ms-excel');
      case 'xlsx':
        return DioMediaType('application',
            'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      case 'svg':
        return DioMediaType('image', 'svg+xml');
      default:
        return DioMediaType('application', 'octet-stream'); // Default fallback
    }
  }

  Future<BaseResponse<Progress>> deleteProgressAgenda(
      String uidPorgress) async {
    try {
      // Make the PUT request
      final response = await dio.delete(
        '/api/agenda/progress',
        queryParameters: {'uid': uidPorgress},
      );

      // Parse response
      final BaseResponse<Progress> data = BaseResponse<Progress>.fromJson(
        response.data,
        (json) => Progress.fromJson(json),
      );

      // Return data if successful
      if (response.statusCode == 200 && data.success) {
        return data;
      } else {
        throw Exception(
            "Failed to delete. Status code: ${response.statusCode}");
      }
    } on DioException catch (error) {
      // Handle Dio-specific errors
      print(error.response?.data);
      return BaseResponse<Progress>(
        success: false,
        message: error.response?.data['message'] ?? 'An error occurred',
      );
    } catch (e) {
      // Handle unexpected errors
      return BaseResponse<Progress>(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<BaseResponse<Progress>> deleteProgressAttachmentAgenda(
      String uidPorgress, String uidAttachment) async {
    try {
      // Make the PUT request
      final response = await dio.delete(
        '/api/agenda/progress-attachment',
        queryParameters: {'uid': uidPorgress, 'uid_attachment': uidAttachment},
      );

      // Parse response
      final BaseResponse<Progress> data = BaseResponse<Progress>.fromJson(
        response.data,
        (json) => Progress.fromJson(json),
      );

      // Return data if successful
      if (response.statusCode == 200 && data.success) {
        return data;
      } else {
        throw Exception(
            "Failed to delete. Status code: ${response.statusCode}");
      }
    } on DioException catch (error) {
      // Handle Dio-specific errors
      print(error.response?.data);
      return BaseResponse<Progress>(
        success: false,
        message: error.response?.data['message'] ?? 'An error occurred',
      );
    } catch (e) {
      // Handle unexpected errors
      return BaseResponse<Progress>(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
