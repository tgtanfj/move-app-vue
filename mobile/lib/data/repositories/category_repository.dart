import 'package:dartz/dartz.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/services/api_service.dart';

class CategoryRepository {
  Future<Either<String, List<CategoryModel>>> getListTopCategory() async {
    try {
      final response = await ApiService().request(
        APIRequestMethod.get,
        ApiUrls.homeTopCategoriesEndPoint,
      );
      if (response.data != null) {
        List<dynamic> categoriesJson = response.data['data'] as List<dynamic>;
        var categories =
            categoriesJson.map((json) => CategoryModel.fromJson(json)).toList();
        return Right(categories);
      } else {
        return const Right([]);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
