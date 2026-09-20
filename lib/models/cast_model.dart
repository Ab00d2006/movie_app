class CastModel {
  final int id;
  final String name;
  final String character;
  final String profilePath;

  CastModel({
    required this.id,
    required this.name,
    required this.character,
    required this.profilePath,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: json['profile_path'] ?? '',
    );
  }
}