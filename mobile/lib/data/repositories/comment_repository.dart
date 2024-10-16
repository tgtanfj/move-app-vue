import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/data/models/comment_model.dart';

import 'package:move_app/data/models/comment_model.dart';

import '../../constants/constants.dart';
import '../services/api_service.dart';
import 'auth_repository.dart';

class CommentRepository {
  final ApiService apiService = ApiService();

  Future<Either<String, List<CommentModel>>> getListCommentVideo(int videoId,
      {int limit = 3, int? cursor}) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        'comment/$videoId/comments',
        queryParameters: {
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
        },
      );
      if (response.data != null) {
        List<dynamic> commentJson = response.data['data'] as List<dynamic>;

        var comments =
            commentJson.map((json) => CommentModel.fromJson(json)).toList();
        return Right(comments);
      } else {
        return const Left(Constants.notFound);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<CommentModel>>> getListReplyComment(
      int commentId) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        'comment/$commentId/reply',
      );

      if (response.data != null) {
        List<dynamic> replyJson = response.data['data'] as List<dynamic>;
        var reply =
            replyJson.map((json) => CommentModel.fromJson(json)).toList();
        return Right(reply);
      } else {
        return const Left(Constants.notFound);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Response>> postComment(
      CommentModel commentModel) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.post,
        ApiUrls.commentEndpoint,
        data: commentModel.toJson(),
        options: Options(
          headers: {
            'Accept': '*/*',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 201) {
        return Right(response);
      } else {
        return Left("${response.statusCode}");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData['message'] ?? 'Unknown error occurred';
        return Left(errorMessage);
      }
      return Left(e.toString());
    }
  }

  Future<Either<String, Response>> postCommentReaction(
      CommentModel commentModel) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.post,
        ApiUrls.commentReactionEndPoint,
        data: commentModel.commentReactionToJson(),
        options: Options(
          headers: {
            'Accept': '*/*',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 201) {
        return Right(response);
      } else {
        return Left("${response.statusCode}");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData['message'] ?? 'Unknown error occurred';
        return Left(errorMessage);
      }
      return Left(e.toString());
    }
  }

  Future<Either<String, Response>> patchCommentReaction(
      CommentModel commentModel) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.patch,
        ApiUrls.commentReactionEndPoint,
        data: commentModel.commentReactionToJson(),
        options: Options(
          headers: {
            'Accept': '*/*',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return Left("${response.statusCode}");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData['message'] ?? 'Unknown error occurred';
        return Left(errorMessage);
      }
      return Left(e.toString());
    }
  }

  Future<Either<String, Response>> deleteCommentReaction(int commentId) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.delete,
        "${ApiUrls.commentReactionEndPoint}/$commentId",
        options: Options(
          headers: {
            'Accept': '*/*',
          },
        ),
      );
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return Left("${response.statusCode}");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData['message'] ?? 'Unknown error occurred';
        return Left(errorMessage);
      }
      return Left(e.toString());
    }
  }
}
