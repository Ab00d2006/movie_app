import 'package:flutter/material.dart';

import '../cubits/home_cubit.dart';
import '../models/movie_model.dart';
import 'details_screen.dart';

class MoviePosterCard extends StatelessWidget {
  final MovieModel movie;

  const MoviePosterCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsScreen(movieId: movie.id),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: movie.posterPath.isEmpty
            ? Container(
                color: const Color(0xff3A3F47),
                child: const Icon(Icons.movie, size: 45),
              )
            : Image.network(
                '${HomeCubit.imageUrl}${movie.posterPath}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xff3A3F47),
                    child: const Icon(Icons.movie, size: 45),
                  );
                },
              ),
      ),
    );
  }
}
