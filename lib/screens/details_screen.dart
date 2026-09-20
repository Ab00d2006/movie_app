import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/details_cubit.dart';
import '../cubits/details_state.dart';
import '../cubits/watch_list_cubit/watch_list_cubit.dart';
import '../cubits/watch_list_cubit/watch_list_state.dart';
import '../models/cast_model.dart';
import '../models/movie_details_model.dart';
import '../models/review_model.dart';

class DetailsScreen extends StatelessWidget {
  final int movieId;

  const DetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailsCubit()..getAllDetails(movieId),
      child: const DetailsView(),
    );
  }
}

class DetailsView extends StatefulWidget {
  const DetailsView({super.key});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  int selectedTab = 0;
  final tabs = const ['About Movie', 'Reviews', 'Cast'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff242A32),
      appBar: AppBar(
        backgroundColor: const Color(0xff242A32),
        elevation: 0,
        centerTitle: true,
        title: const Text('Detail'),
      ),
      body: BlocBuilder<DetailsCubit, DetailsState>(
        builder: (context, state) {
          if (state is DetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DetailsFailure) {
            return Center(child: Text(state.error, textAlign: TextAlign.center));
          }
          if (state is DetailsSuccess) {
            return _content(context, state.movie, state.reviews, state.cast);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _content(
    BuildContext context,
    MovieDetailsModel movie,
    List<ReviewModel> reviews,
    List<CastModel> cast,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: 220,
                width: double.infinity,
                child: movie.backdropPath.isEmpty
                    ? Container(color: const Color(0xff3A3F47))
                    : Image.network(
                        'https://image.tmdb.org/t/p/w780${movie.backdropPath}',
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                left: 24,
                bottom: -65,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: movie.posterPath.isEmpty
                      ? Container(
                          width: 100,
                          height: 145,
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
              ),
              Positioned(
                right: 20,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xaa252836),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_border, color: Color(0xffFF8700), size: 18),
                      const SizedBox(width: 4),
                      Text(movie.voteAverage.toStringAsFixed(1)),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: BlocBuilder<WatchListCubit, WatchListState>(
                  builder: (context, state) {
                    final saved = context.read<WatchListCubit>().isMovieSaved(movie.id);
                    return IconButton(
                      style: IconButton.styleFrom(backgroundColor: const Color(0xaa242A32)),
                      onPressed: () => context.read<WatchListCubit>().toggleMovie(movie),
                      icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.only(left: 140, right: 20),
            child: Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 38),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _info(Icons.calendar_today_outlined, movie.year),
                _divider(),
                _info(Icons.access_time, '${movie.runtime} Minutes'),
                _divider(),
                _info(Icons.local_movies_outlined, movie.genres.isEmpty ? 'Unknown' : movie.genres.first.name),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(tabs.length, (index) {
                return InkWell(
                  onTap: () => setState(() => selectedTab = index),
                  child: Column(
                    children: [
                      Text(tabs[index], style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      Container(
                        width: 55,
                        height: 3,
                        color: selectedTab == index
                            ? const Color(0xff3A3F47)
                            : Colors.transparent,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: selectedTab == 0
                ? Text(
                    movie.overview.isEmpty ? 'No overview available.' : movie.overview,
                    style: const TextStyle(height: 1.6),
                  )
                : selectedTab == 1
                    ? _reviews(reviews)
                    : _cast(cast),
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xff92929D)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xff92929D), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 16,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: const Color(0xff92929D),
    );
  }

  Widget _reviews(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return const Center(child: Text('No reviews yet'));
    return Column(
      children: reviews.take(10).map((review) {
        final avatar = review.authorDetails.avatarPath;
        final avatarUrl = avatar.startsWith('http')
            ? avatar.substring(1)
            : avatar.isEmpty
                ? ''
                : 'https://image.tmdb.org/t/p/w185$avatar';
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xff3A3F47),
                backgroundImage: avatarUrl.isEmpty ? null : NetworkImage(avatarUrl),
                child: avatarUrl.isEmpty ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.author, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 7),
                    Text(review.content, maxLines: 8, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _cast(List<CastModel> cast) {
    if (cast.isEmpty) return const Center(child: Text('No cast data'));
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cast.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 22,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final actor = cast[index];
        return Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: actor.profilePath.isEmpty
                    ? Container(
                        color: const Color(0xff3A3F47),
                        child: const Center(child: Icon(Icons.person, size: 50)),
                      )
                    : Image.network(
                        'https://image.tmdb.org/t/p/w185${actor.profilePath}',
                        width: 110,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(actor.name, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        );
      },
    );
  }
}
