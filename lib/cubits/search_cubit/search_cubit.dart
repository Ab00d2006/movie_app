import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/movie_model.dart';
import '../../models/search_movies_model.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of<SearchCubit>(context);

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4',
        'accept': 'application/json',
      },
    ),
  );

  List<MovieModel> movies = [];

  Future<void> searchMovies(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      movies = [];
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final response = await dio.get(
        '/search/movie',
        queryParameters: {
          'query': cleanQuery,
          'include_adult': false,
          'language': 'en-US',
          'page': 1,
        },
      );

      final model = SearchMoviesModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
      movies = model.results;
      emit(SearchSuccess(movies));
    } catch (error) {
      String message = 'Failed to search movies';
      if (error is DioException) {
        final data = error.response?.data;
        if (data is Map && data['status_message'] != null) {
          message = data['status_message'].toString();
        } else if (error.message != null) {
          message = error.message!;
        }
      } else {
        message = error.toString();
      }
      emit(SearchFailure(message));
    }
  }
}
