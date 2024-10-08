import 'package:dartz/dartz.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/faqs_model.dart';

import '../services/api_service.dart';

class ViewFaqsRepository {
  final ApiService apiService = ApiService();

  Future<Either<String, FaqsModel>> getFaqs() async {
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.faqsEndPoint,
      );

      if (response.data != null &&
          response.data is Map &&
          response.data.containsKey('data')) {
        final faqs = FaqsModel.fromJson(response.data['data']);
        return Right(faqs);
      } else {
        return const Left(Constants.faqsNotFound);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
