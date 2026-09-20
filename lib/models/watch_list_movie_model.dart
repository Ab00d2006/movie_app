import 'movie_details_model.dart';

class WatchListMovieModel {
  final int id;
  final String title;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;
  final String overview;

  const WatchListMovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.overview,
  });

  factory WatchListMovieModel.fromMovieDetails(MovieDetailsModel movie) {
    return WatchListMovieModel(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      releaseDate: movie.releaseDate,
      voteAverage: movie.voteAverage,
      overview: movie.overview,
    );
  }

  factory WatchListMovieModel.fromJson(Map<String, dynamic> json) {
    return WatchListMovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      overview: json['overview'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'overview': overview,
    };
  }

  String get year {
    if (releaseDate.length >= 4) return releaseDate.substring(0, 4);
    return 'N/A';
  }
}
