import 'package:either_dart/either.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/state_model.dart';
import 'package:move_app/data/services/api_service.dart';

class StateRepository {
  final ApiService apiService = ApiService();
  Future<Either<String, List<StateModel>>> getStateList(int countryId) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        'countries/$countryId/states',
      );
      if (response.data != null) {
        List<dynamic> statesJson = response.data['data'] as List<dynamic>;
        var states =
            statesJson.map((json) => StateModel.fromJson(json)).toList();
        return Right(states);
      } else {
        return const Left(Constants.statesNotFound);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
