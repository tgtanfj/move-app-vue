import 'package:either_dart/either.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/country_model.dart';
import 'package:move_app/data/services/api_service.dart';

class CountryRepository {
  final ApiService apiService = ApiService();
  Future<Either<String, List<CountryModel>>> getCountryList() async {
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.getCountryEndPoint,
        queryParameters: {},
      );
      if (response.data != null) {
        List<dynamic> countriesJson = response.data['data'] as List<dynamic>;
        var countries = countriesJson
            .map((json) => CountryModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return Right(countries);
      } else {
        return const Left(Constants.countriesNotFound);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
