import 'movie_model.dart';

class SearchMoviesModel {
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  const SearchMoviesModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory SearchMoviesModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> resultsJson = json['results'] ?? [];

    return SearchMoviesModel(
      page: json['page'] ?? 1,
      results: resultsJson
          .map((movie) => MovieModel.fromJson(movie as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}
