import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/movie_model.dart';
import '../../models/top_rated_movies_model.dart';
import '../home_cubit.dart';
import 'top_rated_state.dart';

class TopRatedCubit extends Cubit<TopRatedState> {
  TopRatedCubit() : super(TopRatedInitial());

  static TopRatedCubit get(context) {
    return BlocProvider.of<TopRatedCubit>(context);
  }

  final Dio dio = Dio(
    BaseOptions(
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4',
        'accept': 'application/json',
      },
    ),
  );

  final List<MovieModel> movies = [];

  Future<void> getTopRatedMovies() async {
    emit(TopRatedLoading());

    try {
      final response = await dio.get(
        'https://api.themoviedb.org/3/movie/top_rated',
        queryParameters: {
          'language': 'en-US',
          'page': 1,
        },
      );

      final model = TopRatedMoviesModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      movies
        ..clear()
        ..addAll(model.results);

      emit(TopRatedSuccess());
    } catch (error) {
      emit(TopRatedFailure(tmdbErrorMessage(error)));
    }
  }
}
