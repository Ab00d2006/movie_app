import '../../models/watch_list_movie_model.dart';

abstract class WatchListState {}

class WatchListInitial extends WatchListState {}

class WatchListLoaded extends WatchListState {
  final List<WatchListMovieModel> movies;

  WatchListLoaded(this.movies);
}

class WatchListChanged extends WatchListState {
  final List<WatchListMovieModel> movies;

  WatchListChanged(this.movies);
}
