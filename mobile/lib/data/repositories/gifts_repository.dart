import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
import 'package:move_app/data/models/gift_model.dart';
import 'package:move_app/data/services/api_service.dart';

class GiftsRepository {
  Future<Either<String, List<GiftModel>?>> getGifts() async {
    try {
      final response = await ApiService().request(
        APIRequestMethod.get,
        ApiUrls.giftListPackageEndPoint,
      );
      if (response.data != null) {
        List<dynamic> giftsJson = response.data['data'] as List<dynamic>;
        var gifts = giftsJson.map((json) => GiftModel.fromJson(json)).toList();
        return Right(gifts);
      } else {
        return const Right([]);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> sendGift({
    required int giftId,
    required int videoId,
    required String content,
  }) async {
    String accessToken = SharedPrefer.sharedPrefer.getUserToken();
    final data = {
      'giftPackageId': giftId,
      'videoId': 67,
      'content': content,
    };
    try {
      final response = await ApiService().request(
        APIRequestMethod.post,
        ApiUrls.donationEndPoint,
        data: data,
        options: Options(
          headers: {
            'Accept': '/',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        return const Right(true);
      }
      return const Left("Cannot send gift");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
