class SearchResponseModel {
  final int page;
  final List<SearchMovieModel> results;
  final int totalPages;
  final int totalResults;

  const SearchResponseModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      page: json['page'] ?? 0,
      results: (json['results'] as List<dynamic>? ?? [])
          .map((movie) => SearchMovieModel.fromJson(movie))
          .toList(),
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}

class SearchMovieModel {
  final bool adult;
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final String title;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final bool softcore;
  final bool video;
  final double voteAverage;
  final int voteCount;

  const SearchMovieModel({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.title,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.softcore,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory SearchMovieModel.fromJson(Map<String, dynamic> json) {
    return SearchMovieModel(
      adult: json['adult'] ?? false,
      backdropPath: json['backdrop_path'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      softcore: json['softcore'] ?? false,
      video: json['video'] ?? false,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
    );
  }

  String get year {
    if (releaseDate.length >= 4) {
      return releaseDate.substring(0, 4);
    }
    return 'N/A';
  }

  String get firstGenreName {
    if (genreIds.isEmpty) return 'Unknown';

    const genres = <int, String>{
      28: 'Action',
      12: 'Adventure',
      16: 'Animation',
      35: 'Comedy',
      80: 'Crime',
      99: 'Documentary',
      18: 'Drama',
      10751: 'Family',
      14: 'Fantasy',
      36: 'History',
      27: 'Horror',
      10402: 'Music',
      9648: 'Mystery',
      10749: 'Romance',
      878: 'Science Fiction',
      10770: 'TV Movie',
      53: 'Thriller',
      10752: 'War',
      37: 'Western',
    };

    return genres[genreIds.first] ?? 'Unknown';
  }
}
