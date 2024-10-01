import 'package:either_dart/either.dart';
import 'package:move_app/constants/constants.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

class UserRepository {
  Future<Either<String, UserModel>> getUserProfile() async {
    try {
      final response = await ApiService().request(
        APIRequestMethod.get,
        'user/profile',
        queryParameters: {},
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
}
