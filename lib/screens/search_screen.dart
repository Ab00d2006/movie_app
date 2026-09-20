import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/search_cubit/search_cubit.dart';
import '../cubits/search_cubit/search_state.dart';
import '../models/movie_model.dart';
import 'details_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController controller = TextEditingController();
  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  void onChanged(String value) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.read<SearchCubit>().searchMovies(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff242A32),
      appBar: AppBar(
        backgroundColor: const Color(0xff242A32),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: Color(0xff92929D)),
                suffixIcon: const Icon(Icons.search, color: Color(0xff92929D)),
                filled: true,
                fillColor: const Color(0xff3A3F47),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SearchFailure) {
                    return Center(child: Text(state.error, textAlign: TextAlign.center));
                  }
                  if (state is SearchSuccess) {
                    if (state.movies.isEmpty) {
                      return const Center(child: Text('No movies found'));
                    }
                    return ListView.separated(
                      itemCount: state.movies.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) => _SearchMovieTile(movie: state.movies[index]),
                    );
                  }
                  return const Center(
                    child: Text(
                      'Search for a movie',
                      style: TextStyle(color: Color(0xff92929D)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchMovieTile extends StatelessWidget {
  final MovieModel movie;
  const _SearchMovieTile({required this.movie});

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
                  Text(movie.releaseDate.isEmpty ? 'N/A' : movie.releaseDate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
