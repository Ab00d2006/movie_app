import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/movie_model.dart';
import '../../models/popular_movies_model.dart';
import '../home_cubit.dart';
import 'popular_state.dart';

class PopularCubit extends Cubit<PopularState> {
  PopularCubit() : super(PopularInitial());

  static PopularCubit get(context) {
    return BlocProvider.of<PopularCubit>(context);
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

  Future<void> getPopularMovies() async {
    emit(PopularLoading());

    try {
      final response = await dio.get(
        'https://api.themoviedb.org/3/movie/popular',
        queryParameters: {
          'language': 'en-US',
          'page': 1,
        },
      );

      final model = PopularMoviesModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      movies
        ..clear()
        ..addAll(model.results);

      emit(PopularSuccess());
    } catch (error) {
      emit(PopularFailure(tmdbErrorMessage(error)));
    }
  }
}
