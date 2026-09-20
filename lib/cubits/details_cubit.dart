import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cast_model.dart';
import '../models/movie_details_model.dart';
import '../models/review_model.dart';
import 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit() : super(DetailsInitial());

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4',
        'accept': 'application/json',
      },
    ),
  );

  Future<void> getAllDetails(int movieId) async {
    emit(DetailsLoading());

    try {
      final responses = await Future.wait([
        dio.get('/movie/$movieId', queryParameters: {'language': 'en-US'}),
        dio.get('/movie/$movieId/reviews', queryParameters: {'language': 'en-US', 'page': 1}),
        dio.get('/movie/$movieId/credits', queryParameters: {'language': 'en-US'}),
      ]);

      final movie = MovieDetailsModel.fromJson(
        Map<String, dynamic>.from(responses[0].data),
      );

      final reviewData = Map<String, dynamic>.from(responses[1].data);
      final reviews = (reviewData['results'] as List<dynamic>? ?? [])
          .map((item) => ReviewModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      final creditsData = Map<String, dynamic>.from(responses[2].data);
      final cast = (creditsData['cast'] as List<dynamic>? ?? [])
          .map((item) => CastModel.fromJson(Map<String, dynamic>.from(item)))
          .take(10)
          .toList();

      emit(DetailsSuccess(movie: movie, reviews: reviews, cast: cast));
    } catch (error) {
      emit(DetailsFailure(_errorMessage(error)));
    }
  }

  String _errorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['status_message'] != null) {
        return data['status_message'].toString();
      }
      return error.message ?? 'Connection failed';
    }
    return error.toString();
  }
}
