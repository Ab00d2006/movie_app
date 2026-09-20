import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/movie_details_model.dart';
import '../../models/watch_list_movie_model.dart';
import 'watch_list_state.dart';

class _WatchListStorage {
  static final List<String> _savedMovies = <String>[];

  static Future<_WatchListStorage> getInstance() async => _WatchListStorage();

  List<String> getStringList(String key) => List<String>.from(_savedMovies);

  Future<bool> setStringList(String key, List<String> value) async {
    _savedMovies
      ..clear()
      ..addAll(value);
    return true;
  }
}

class WatchListCubit extends Cubit<WatchListState> {
  WatchListCubit() : super(WatchListInitial());

  static WatchListCubit get(context) =>
      BlocProvider.of<WatchListCubit>(context);

  static const String _watchListKey = 'watch_list_movies';

  final List<WatchListMovieModel> movies = [];

  Future<void> loadWatchList() async {
    final preferences = await _WatchListStorage.getInstance();
    final savedMovies = preferences.getStringList(_watchListKey);

    movies.clear();

    for (final movieString in savedMovies) {
      final movieJson = jsonDecode(movieString) as Map<String, dynamic>;
      movies.add(WatchListMovieModel.fromJson(movieJson));
    }

    emit(WatchListLoaded(List.from(movies)));
  }

  bool isMovieSaved(int movieId) {
    return movies.any((movie) => movie.id == movieId);
  }

  Future<void> toggleMovie(MovieDetailsModel movie) async {
    if (isMovieSaved(movie.id)) {
      movies.removeWhere((item) => item.id == movie.id);
    } else {
      movies.add(WatchListMovieModel.fromMovieDetails(movie));
    }

    await _saveWatchList();
    emit(WatchListChanged(List.from(movies)));
  }

  Future<void> removeMovie(int movieId) async {
    movies.removeWhere((movie) => movie.id == movieId);

    await _saveWatchList();
    emit(WatchListChanged(List.from(movies)));
  }

  Future<void> _saveWatchList() async {
    final preferences = await _WatchListStorage.getInstance();

    final savedMovies = movies
        .map((movie) => jsonEncode(movie.toJson()))
        .toList();

    await preferences.setStringList(_watchListKey, savedMovies);
  }
}
