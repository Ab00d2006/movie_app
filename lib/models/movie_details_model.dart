class MovieDetailsModel {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final int runtime;
  final double voteAverage;
  final List<GenreModel> genres;

  const MovieDetailsModel({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.runtime,
    required this.voteAverage,
    required this.genres,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      runtime: json['runtime'] ?? 0,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      genres: (json['genres'] as List<dynamic>? ?? [])
          .map((genre) => GenreModel.fromJson(genre))
          .toList(),
    );
  }

  String get year {
    if (releaseDate.length >= 4) {
      return releaseDate.substring(0, 4);
    }
    return 'N/A';
  }

  String get genresText {
    if (genres.isEmpty) return 'Unknown';
    return genres.map((genre) => genre.name).join(', ');
  }
}

class GenreModel {
  final int id;
  final String name;

  const GenreModel({required this.id, required this.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
