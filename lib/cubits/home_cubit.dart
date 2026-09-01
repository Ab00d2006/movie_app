import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/carousel_movies_model.dart';
import '../models/movie_model.dart';
import 'home_state.dart';

const String tmdbImageUrl = 'https://image.tmdb.org/t/p/w500';

// ضع TMDB Read Access Token الجديد هنا مرة واحدة فقط.
// اكتب التوكن بدون كلمة Bearer.
const String tmdbToken = 'PUT_YOUR_NEW_TMDB_READ_ACCESS_TOKEN_HERE';

String tmdbErrorMessage(Object error) {
  if (error is DioException) {
    final data = error.response?.data;

    if (data is Map && data['status_message'] != null) {
      return data['status_message'].toString();
    }

    return error.message ?? 'Connection failed';
  }

  return error.toString();
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) {
    return BlocProvider.of<HomeCubit>(context);
  }

  final Dio dio = Dio(
    BaseOptions(
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4',
        'accept': 'application/json',
      },
    ),
  );

  final List<MovieModel> carouselMovies = [];

  Future<void> getCarouselMovies() async {
    emit(HomeCarouselMovieLoading());

    try {
      final response = await dio.get(
        'https://api.themoviedb.org/3/discover/movie',
        queryParameters: {
          'include_adult': false,
          'include_video': false,
          'language': 'en-US',
          'page': 1,
          'sort_by': 'popularity.desc',
        },
      );

      final model = CarouselMoviesModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      carouselMovies
        ..clear()
        ..addAll(model.results);

      emit(HomeCarouselMovieSuccess());
    } catch (error) {
      emit(HomeCarouselMovieFailure(tmdbErrorMessage(error)));
    }
  }
}
