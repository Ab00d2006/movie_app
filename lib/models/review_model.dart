class ReviewModel {
  final String author;
  final String content;
  final AuthorDetails authorDetails;

  ReviewModel({
    required this.author,
    required this.content,
    required this.authorDetails,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      author: json['author'] ?? '',
      content: json['content'] ?? '',
      authorDetails: AuthorDetails.fromJson(
        json['author_details'] ?? {},
      ),
    );
  }
}

class AuthorDetails {
  final String name;
  final String username;
  final String avatarPath;
  final double? rating;

  AuthorDetails({
    required this.name,
    required this.username,
    required this.avatarPath,
    required this.rating,
  });

  factory AuthorDetails.fromJson(Map<String, dynamic> json) {
    return AuthorDetails(
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      avatarPath: json['avatar_path'] ?? '',
      rating: json['rating'] == null
          ? null
          : (json['rating'] as num).toDouble(),
    );
  }
}