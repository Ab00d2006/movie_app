import 'movie_model.dart';

class UpcomingMoviesModel {
  final MovieDatesModel dates;
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  const UpcomingMoviesModel({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory UpcomingMoviesModel.fromJson(Map<String, dynamic> json) {
    return UpcomingMoviesModel(
      dates: MovieDatesModel.fromJson(
        Map<String, dynamic>.from(json['dates'] ?? {}),
      ),
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
