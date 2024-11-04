import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/data/repositories/user_repository.dart';

import '../data_sources/local/shared_preferences.dart';
import '../models/login_request_social.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/api_service_additional.dart';

class AuthRepository {
  final ApiService apiService = ApiService();

  final ApiServiceAdditional apiServiceAdditional = ApiServiceAdditional();

  Future<Response> signUpWithEmail(UserModel userModel, String otp) async {
    try {
      final data = {
        "email": userModel.email,
        "password": userModel.password,
        "referralCode": userModel.referralCode,
        "otp": otp
      };
      final signUpResponse = await apiService.request(
        APIRequestMethod.post,
        ApiUrls.signUpEndpoint,
        data: data,
        options: Options(
          headers: {
            'Accept': '*/*',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (signUpResponse.statusCode == 201) {
        await loginWithEmailPassword(userModel);
      }

      return signUpResponse;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response?.data;
          final errorMessage = errorData['message'] ?? 'Unknown error occurred';
          throw SignUpException(errorMessage);
        } else {
          throw SignUpException("${e.message}");
        }
      }
      rethrow;
    }
  }

  Future<Response> sendVerificationCode(String email) async {
    try {
      final data = {"email": email};
      return await apiService.request(
        APIRequestMethod.post,
        ApiUrls.sendVerificationCodeEndpoint,
        data: data,
        options: Options(
          headers: {
            'Accept': '*/*',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response?.data;
          final errorMessage = errorData['message'] ?? 'Unknown error occurred';
          throw SignUpException(errorMessage);
        } else {
          throw SignUpException("${e.message}");
        }
      }
      rethrow;
    }
  }

  Future<Either<String, User?>> googleLogin() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      final String? firebaseIdToken = await user?.getIdToken(true);
      final String? email = googleUser?.email;
      LoginRequestSocial loginRequestGoogle = LoginRequestSocial(
        email: email,
        idToken: firebaseIdToken,
      );
      await sendIdTokenGoogle(loginRequestGoogle);
      await UserRepository().getUserProfile();
      return Right(user);
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
      rethrow;
    }
  }

  Future<void> sendIdTokenGoogle(LoginRequestSocial loginRequestGoogle) async {
    try {
      final response = await apiServiceAdditional.request(
        Method.post,
        ApiUrls.loginGoogle,
        data: loginRequestGoogle.toJson(),
        options: Options(
          headers: {
            'Accept': '/',
            'Content-Type': 'application/json',
          },
        ),
      );
      String accessToken = response.data['data']['accessToken'];

      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      int? userId = decodedToken['userId'] ?? decodedToken['sub'];
      await SharedPrefer.sharedPrefer.setUserId(userId ?? 0);

      await SharedPrefer.sharedPrefer.setUserToken(accessToken);
      await SharedPrefer.sharedPrefer
          .setUserRefreshToken(response.data['data']['refreshToken']);
      return response.data['data']['accessToken'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Either<String, UserCredential?>> loginWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );
      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(
          loginResult.accessToken?.tokenString ?? "",
        );
        final userData = await FacebookAuth.instance.getUserData();
        final email = userData['email'];
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        final token = await userCredential.user?.getIdToken(true);
        LoginRequestSocial loginRequestFacebook =
            LoginRequestSocial(email: email, idToken: token);
        await sendIdTokenFacebook(loginRequestFacebook);
        await UserRepository().getUserProfile();
        return Right(userCredential);
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
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
      rethrow;
    }
  }

  Future<void> sendIdTokenFacebook(
      LoginRequestSocial loginRequestFacebook) async {
    try {
      final response = await apiServiceAdditional.request(
        Method.post,
        ApiUrls.loginFacebook,
        data: loginRequestFacebook.toJson(),
        options: Options(
          headers: {
            'Accept': '/',
            'Content-Type': 'application/json',
          },
        ),
      );
      String accessToken = response.data['data']['accessToken'];

      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      int? userId = decodedToken['userId'] ?? decodedToken['sub'];
      await SharedPrefer.sharedPrefer.setUserId(userId ?? 0);

      await SharedPrefer.sharedPrefer.setUserToken(accessToken);
      await SharedPrefer.sharedPrefer
          .setUserRefreshToken(response.data['data']['refreshToken']);
      return response.data['data']['accessToken'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Either<String, String?>> loginWithEmailPassword(
      UserModel userModel) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.post,
        ApiUrls.endPointLogin,
        data: userModel.toJson(),
        options: Options(
          headers: {
            'Accept': '/',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        String accessToken = response.data['data']['accessToken'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
        int? userId = decodedToken['userId'] ?? decodedToken['sub'];
        await SharedPrefer.sharedPrefer.setUserId(userId ?? 0);

        await UserRepository().getUserProfile();
        await SharedPrefer.sharedPrefer.setUserToken(accessToken);
        await SharedPrefer.sharedPrefer
            .setUserRefreshToken(response.data['data']['refreshToken']);
        return Right(response.data['data']['accessToken']);
      } else {
        return const Left("Login Error");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
          final errorData = e.response?.data;
          final errorMessage = errorData["message"] ?? 'Unknown error occurred';
          return Left(errorMessage);
        }
      return Left(e.toString());
    }
  }

  Future<void> logOut() async {
    String refreshToken = SharedPrefer.sharedPrefer.getUserRefreshToken();
    try {
      final response = await apiServiceAdditional.request(
        Method.get,
        ApiUrls.endPointLogout,
        options: Options(
          headers: {
            'Accept': '/',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        await SharedPrefer.sharedPrefer.setUnreadNotificationCount(0);
        await SharedPrefer.sharedPrefer.setUserId(0);
        await SharedPrefer.sharedPrefer.setUserToken('');
        await SharedPrefer.sharedPrefer.setUserRefreshToken('');
        await SharedPrefer.sharedPrefer.setAvatarUserUrl('');
        await SharedPrefer.sharedPrefer.setUsername('');
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        await FacebookAuth.instance.logOut();
        await FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response?.data;
          final errorMessage = errorData['message'] ?? 'Unknown error occurred';
          throw errorMessage;
        } else {
          throw Exception('No response from the server');
        }
      } else {
        rethrow;
      }
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
