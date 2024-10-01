import 'package:either_dart/either.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/country_model.dart';
import 'package:move_app/data/services/api_service.dart';

class CountryRepository {
  Future<Either<String, List<Country>>> getCountryList() async {
    try {
      final response = await ApiService().request(
        APIRequestMethod.get,
        'countries',
        queryParameters: {},
      );
      if (response.data != null) {
        List<dynamic> countriesJson = response.data['data'] as List<dynamic>;
        var countries = countriesJson
            .map((json) => Country.fromJson(json as Map<String, dynamic>))
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
