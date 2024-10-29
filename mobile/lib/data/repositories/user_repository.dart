import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/constants/constants.dart';

import '../data_sources/local/shared_preferences.dart';
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
        final avatarUrl = response.data['data']['avatar'] as String?;
        if (avatarUrl != null && avatarUrl.isNotEmpty) {
          await SharedPrefer.sharedPrefer.setAvatarUserUrl(avatarUrl);
        }
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
        formData.files.add(
          MapEntry(
            'avatar',
            await MultipartFile.fromFile(
              avatarFile.path,
              filename: avatarFile.path.split('/').last,
              contentType: DioMediaType.parse(Constants.imagePng),
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
        return const Right(Constants.success);
      } else {
        return const Left(Constants.failed);
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response?.data;
          final errorMessage =
              errorData['message'] ?? Constants.unknownErrorOccurred;
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
