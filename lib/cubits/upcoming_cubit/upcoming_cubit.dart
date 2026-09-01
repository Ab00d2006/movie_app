import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/movie_model.dart';
import '../../models/upcoming_movies_model.dart';
import '../home_cubit.dart';
import 'upcoming_state.dart';

class UpcomingCubit extends Cubit<UpcomingState> {
  UpcomingCubit() : super(UpcomingInitial());

  static UpcomingCubit get(context) {
    return BlocProvider.of<UpcomingCubit>(context);
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

  Future<void> getUpcomingMovies() async {
    emit(UpcomingLoading());

    try {
      final response = await dio.get(
        'https://api.themoviedb.org/3/movie/upcoming',
        queryParameters: {
          'language': 'en-US',
          'page': 1,
        },
      );

      final model = UpcomingMoviesModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      movies
        ..clear()
        ..addAll(model.results);

      emit(UpcomingSuccess());
    } catch (error) {
      emit(UpcomingFailure(tmdbErrorMessage(error)));
    }
  }
}
