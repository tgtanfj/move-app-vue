import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:move_app/constants/api_urls.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService apiService = ApiService();
  Future<Response> signUpWithEmail(UserModel userModel, String otp) async {
    try {
      final data = {
        "email": userModel.email,
        "password": userModel.password,
        "referralCode": userModel.referralCode,
        "otp": otp
      };

      return await ApiService().request(
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

      return await ApiService().request(
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
      rethrow;    }
  }
  Future<User?> googleLogin() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final User? user = (await _auth.signInWithCredential(credential)).user;
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential?> loginWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );
      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(
          '${loginResult.accessToken?.tokenString}',
        );
        return FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> loginWithEmailPassword(UserModel userModel) async {
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
        return response.data['token'];
      } else {
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response?.data;
          final errorMessage = errorData['message'] ?? 'Unknown error occurred';
          throw errorMessage;
        } else {
          throw Exception();
        }
      }
      rethrow;
    }
  }

  Future<void> logOut() async {
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        'auth/logout',
        options: Options(
          headers: {
            'Accept': '/',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Logout successful');
      } else {
        print('Failed to logout: ${response.statusMessage}');
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

