import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/constants/constants.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService apiService = ApiService();

  Future<Either<String, UserModel>> getUserProfile() async {
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.getUserProfileEndPoint,
      );
      if (response.data != null) {
        final user = UserModel.fromJson(response.data['data']);
        return Right(user);
      } else {
        return const Left(Constants.userNotFound);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> editUserProfile(
      UserModel? user, File? avatarFile) async {
    try {
      FormData formData = FormData.fromMap(user?.editUserToJson() ?? {});

      if (avatarFile != null) {
        final fileExtension = avatarFile.path.split('.').last.toLowerCase();
        String mimeType;

        switch (fileExtension) {
          case 'jpg':
          case 'jpeg':
            mimeType = 'image/jpeg';
            break;
          case 'png':
            mimeType = 'image/png';
            break;
          case 'gif':
            mimeType = 'image/gif';
            break;
          default:
            mimeType = 'application/octet-stream';
            break;
        }

        formData.files.add(
          MapEntry(
            'avatar',
            await MultipartFile.fromFile(
              avatarFile.path,
              filename: avatarFile.path.split('/').last,
              contentType: MediaType.parse(mimeType),
            ),
          ),
        );
      }

      final response = await apiService.request(
        APIRequestMethod.patch,
        ApiUrls.editUserProfileEndPoint,
        data: formData,
        options: Options(
          headers: {
            'Accept': '*/*',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      if (response.statusCode == 200) {
        return const Right('Success');
      } else {
        return const Left('Failed');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response?.data;
          final errorMessage = errorData['message'] ?? 'Unknown error occurred';
          return Left(errorMessage);
        } else {
          return Left(e.message.toString());
        }
      }

      return Left(e.toString());
    }
  }

  Future<Either<String, File?>> pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return Right(File(pickedImage.path));
    } else {
      return const Left(Constants.noImageIsPicked);
    }
  }
}

class SignUpException implements Exception {
  final String message;

  SignUpException(this.message);

  @override
  String toString() {
    return message;
  }
}
