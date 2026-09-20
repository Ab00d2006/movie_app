import '../../models/movie_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<MovieModel> movies;

  SearchSuccess(this.movies);
}

class SearchFailure extends SearchState {
  final String error;

  SearchFailure(this.error);
}
