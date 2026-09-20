import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/watch_list_cubit/watch_list_cubit.dart';
import '../cubits/watch_list_cubit/watch_list_state.dart';
import '../models/watch_list_movie_model.dart';
import 'details_screen.dart';

class WatchListScreen extends StatelessWidget {
  const WatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff242A32),
      appBar: AppBar(
        backgroundColor: const Color(0xff242A32),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Watch list'),
      ),
      body: BlocBuilder<WatchListCubit, WatchListState>(
        builder: (context, state) {
          final cubit = WatchListCubit.get(context);
          if (cubit.movies.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bookmark_border, size: 72, color: Color(0xff92929D)),
                  SizedBox(height: 14),
                  Text('Your watch list is empty'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: cubit.movies.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _WatchListTile(movie: cubit.movies[index]);
            },
          );
        },
      ),
    );
  }
}

class _WatchListTile extends StatelessWidget {
  final WatchListMovieModel movie;
  const _WatchListTile({required this.movie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailsScreen(movieId: movie.id)),
        );
      },
      child: SizedBox(
        height: 145,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: movie.posterPath.isEmpty
                  ? Container(
                      width: 100,
                      color: const Color(0xff3A3F47),
                      child: const Icon(Icons.movie),
                    )
                  : Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      width: 100,
                      height: 145,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star_border, color: Color(0xffFF8700), size: 18),
                      const SizedBox(width: 5),
                      Text(movie.voteAverage.toStringAsFixed(1)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(movie.year),
                ],
              ),
            ),
            IconButton(
              onPressed: () => context.read<WatchListCubit>().removeMovie(movie.id),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
