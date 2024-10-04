import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
import 'package:move_app/data/models/object_login_social.dart';
import 'package:move_app/data/services/api_service_additional.dart';
import 'package:move_app/data/services/api_service_additional.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/facebook_request_login.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

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
      rethrow;
    }
  }

  Future<User?> googleLogin() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      final String? firebaseIdToken = await user?.getIdToken(true);

      final String? accessToken = googleAuth?.accessToken;
      final String? idToken = googleAuth?.idToken;
      final String? email = googleUser?.email;
      final String? name = googleUser?.displayName;
      final String? profilePic = googleUser?.photoUrl;

      print('Access Token: $accessToken');
      print('ID Token: $idToken');
      print('Email: $email');
      print('Firebase ID Token: $firebaseIdToken');
      print('Name: $name');
      print('Profile Picture: $profilePic');


      ObjectLoginSocial objectLoginSocial = ObjectLoginSocial(
        email: email,
        idToken: firebaseIdToken,
      );
      await sendIdTokenGoogle(objectLoginSocial);

      return user;
    } catch (e) {
      print('Error during Google login: ${e.toString()}');
      return null;
    }
  }


  Future<void> sendIdTokenGoogle(
      ObjectLoginSocial emailRequestLogin) async {
    try {
      final response = await apiServiceAdditional.request(
        Method.post,
        ApiUrls.loginGoogle,
        data: emailRequestLogin.toJson(),
        options: Options(
          headers: {
            'Accept': '/',
            'Content-Type': 'application/json',
          },
        ),
      );
      print(response.data['data']['accessToken']);
      await SharedPrefer.sharedPrefer
          .setUserToken(response.data['data']['accessToken']);
      await SharedPrefer.sharedPrefer
          .setUserRefreshToken(response.data['data']['refreshToken']);
      return response.data['data']['accessToken'];
    } catch (e) {
      print("send facebookk token==== ${e.toString()}");
      rethrow;
    }
  }

  // Future<UserCredential?> loginWithFacebook() async {
  //   try {
  //     final LoginResult loginResult = await FacebookAuth.instance.login(
  //       permissions: ['email', 'public_profile'],
  //     );
  //
  //     if (loginResult.status == LoginStatus.success) {
  //       final OAuthCredential facebookAuthCredential =
  //           FacebookAuthProvider.credential(
  //               '${loginResult.accessToken?.tokenString}');
  //
  //       print("object $facebookAuthCredential");
  //       final userData = await FacebookAuth.instance.getUserData();
  //       final email = userData['email'];
  //       print(email);
  //       final token = await FirebaseAuth.instance.currentUser?.getIdToken(true);
  //       print(token);
  //       FacebookRequestLogin facebookRequestLogin =
  //       FacebookRequestLogin(email: email, idToken: token);
  //       await sendIdTokenFacebook(facebookRequestLogin);
  //       return FirebaseAuth.instance
  //           .signInWithCredential(facebookAuthCredential);
  //     } else {
  //       throw FirebaseAuthException(
  //         code: 'ERROR_ABORTED_BY_USER',
  //         message: 'Sign in aborted by user',
  //       );
  //     }
  //   } catch (e) {
  //     print("Error in Facebook login: ${e.toString()}");
  //   }
  // }

  Future<UserCredential?> loginWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(
          loginResult.accessToken!.tokenString,
        );

        final userData = await FacebookAuth.instance.getUserData();
        final email = userData['email'];
        final name = userData['name'];
        final profilePic = userData['picture']['data']['url'];

        print('Email: $email');

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

        final token = await userCredential.user?.getIdToken(true);
        print('ID Token: $token');

        ObjectLoginSocial objecSocialLogin = ObjectLoginSocial(email: email, idToken: token);

        await sendIdTokenFacebook(objecSocialLogin);

        return userCredential;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }
    } catch (e) {
      print("Error in Facebook login: ${e.toString()}");
    }
    return null;
  }


  Future<void> sendIdTokenFacebook(
      ObjectLoginSocial objectSocialLogin) async {
    try {
      final response =  await apiServiceAdditional.request(
        Method.post,
        ApiUrls.loginFacebook,
        data: objectSocialLogin.toJson(),
        options: Options(
          headers: {
            'Accept': '/',
            'Content-Type': 'application/json',
          },
        ),
      );
      await SharedPrefer.sharedPrefer
          .setUserToken(response.data['data']['accessToken']);
      await SharedPrefer.sharedPrefer
          .setUserRefreshToken(response.data['data']['refreshToken']);
      return response.data['data']['accessToken'];
    } catch (e) {
      rethrow;
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

      await SharedPrefer.sharedPrefer
          .setUserToken(response.data['data']['accessToken']);
      await SharedPrefer.sharedPrefer
          .setUserRefreshToken(response.data['data']['refreshToken']);
      return response.data['data']['accessToken'];
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
    String refreshToken = SharedPrefer.sharedPrefer.getUserRefreshToken();

    print("Refresh Tokenn-========================${refreshToken}");
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
      print(response.data);
      await SharedPrefer.sharedPrefer.setUserToken('');
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
      await FirebaseAuth.instance.signOut();
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
