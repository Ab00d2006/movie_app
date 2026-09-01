import 'movie_model.dart';

class TopRatedMoviesModel {
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  const TopRatedMoviesModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TopRatedMoviesModel.fromJson(Map<String, dynamic> json) {
    return TopRatedMoviesModel(
      page: json['page'] ?? 0,
      results: (json['results'] as List? ?? [])
          .map((movie) => MovieModel.fromJson(
                Map<String, dynamic>.from(movie),
              ))
          .toList(),
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}
