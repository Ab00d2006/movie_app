import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/movie_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of<HomeCubit>(context);

  static const String imageUrl = 'https://image.tmdb.org/t/p/w500';

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4',
        'accept': 'application/json',
      },
    ),
  );

  final List<MovieModel> carouselMovies = [];
  final List<MovieModel> nowPlayingMovies = [];
  final List<MovieModel> upcomingMovies = [];
  final List<MovieModel> topRatedMovies = [];
  final List<MovieModel> popularMovies = [];

  bool carouselLoading = false;
  bool nowPlayingLoading = false;
  bool upcomingLoading = false;
  bool topRatedLoading = false;
  bool popularLoading = false;

  String? carouselError;
  String? nowPlayingError;
  String? upcomingError;
  String? topRatedError;
  String? popularError;

  bool isShow = false;

  Future<void> getAllMovies() async {
    await Future.wait([
      getCarouselMovies(),
      getNowPlayingMovies(),
      getUpcomingMovies(),
      getTopRatedMovies(),
      getPopularMovies(),
    ]);
  }

  Future<void> getCarouselMovies() async {
    carouselLoading = true;
    carouselError = null;
    emit(HomeCarouselMovieLoading());

    try {
      final response = await dio.get(
        '/discover/movie',
        queryParameters: {
          'include_adult': false,
          'include_video': false,
          'language': 'en-US',
          'page': 1,
          'sort_by': 'popularity.desc',
        },
      );

      carouselMovies
        ..clear()
        ..addAll(_convertToMovies(response.data['results']));
      emit(HomeCarouselMovieSuccess());
    } catch (error) {
      carouselError = tmdbErrorMessage(error);
      emit(HomeCarouselMovieFailure(carouselError!));
    } finally {
      carouselLoading = false;
    }
  }

  Future<void> getNowPlayingMovies() async {
    nowPlayingLoading = true;
    nowPlayingError = null;
    emit(HomeNowPlayingMovieLoading());

    try {
      final response = await dio.get(
        '/movie/now_playing',
        queryParameters: {'language': 'en-US', 'page': 1},
      );
      nowPlayingMovies
        ..clear()
        ..addAll(_convertToMovies(response.data['results']));
      emit(HomeNowPlayingMovieSuccess());
    } catch (error) {
      nowPlayingError = tmdbErrorMessage(error);
      emit(HomeNowPlayingMovieFailure(nowPlayingError!));
    } finally {
      nowPlayingLoading = false;
    }
  }

  Future<void> getUpcomingMovies() async {
    upcomingLoading = true;
    upcomingError = null;
    emit(HomeUpcomingMovieLoading());

    try {
      final response = await dio.get(
        '/movie/upcoming',
        queryParameters: {'language': 'en-US', 'page': 1},
      );
      upcomingMovies
        ..clear()
        ..addAll(_convertToMovies(response.data['results']));
      emit(HomeUpcomingMovieSuccess());
    } catch (error) {
      upcomingError = tmdbErrorMessage(error);
      emit(HomeUpcomingMovieFailure(upcomingError!));
    } finally {
      upcomingLoading = false;
    }
  }

  Future<void> getTopRatedMovies() async {
    topRatedLoading = true;
    topRatedError = null;
    emit(HomeTopRatedMovieLoading());

    try {
      final response = await dio.get(
        '/movie/top_rated',
        queryParameters: {'language': 'en-US', 'page': 1},
      );
      topRatedMovies
        ..clear()
        ..addAll(_convertToMovies(response.data['results']));
      emit(HomeTopRatedMovieSuccess());
    } catch (error) {
      topRatedError = tmdbErrorMessage(error);
      emit(HomeTopRatedMovieFailure(topRatedError!));
    } finally {
      topRatedLoading = false;
    }
  }

  Future<void> getPopularMovies() async {
    popularLoading = true;
    popularError = null;
    emit(HomePopularMovieLoading());

    try {
      final response = await dio.get(
        '/movie/popular',
        queryParameters: {'language': 'en-US', 'page': 1},
      );
      popularMovies
        ..clear()
        ..addAll(_convertToMovies(response.data['results']));
      emit(HomePopularMovieSuccess());
    } catch (error) {
      popularError = tmdbErrorMessage(error);
      emit(HomePopularMovieFailure(popularError!));
    } finally {
      popularLoading = false;
    }
  }

  List<MovieModel> _convertToMovies(dynamic results) {
    final list = results as List<dynamic>? ?? [];
    return list
        .map((movie) => MovieModel.fromJson(Map<String, dynamic>.from(movie)))
        .toList();
  }

  void toggleShow() {
    isShow = !isShow;
    emit(HomeShowMoreChanged());
  }
}

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
