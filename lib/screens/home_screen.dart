import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/home_cubit.dart';
import '../cubits/home_state.dart';
import '../models/movie_model.dart';
import 'home_carousel.dart';
import 'movie_poster_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onSearchTap;

  const HomeScreen({super.key, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..getAllMovies(),
      child: HomeView(onSearchTap: onSearchTap),
    );
  }
}

class HomeView extends StatefulWidget {
  final VoidCallback? onSearchTap;

  const HomeView({super.key, this.onSearchTap});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedTab = 0;

  final List<String> tabs = const [
    'Now playing',
    'Upcoming',
    'Top rated',
    'Popular',
  ];

  List<MovieModel> selectedMovies(HomeCubit cubit) {
    if (selectedTab == 1) return cubit.upcomingMovies;
    if (selectedTab == 2) return cubit.topRatedMovies;
    if (selectedTab == 3) return cubit.popularMovies;
    return cubit.nowPlayingMovies;
  }

  bool selectedMoviesLoading(HomeCubit cubit) {
    if (selectedTab == 1) return cubit.upcomingLoading;
    if (selectedTab == 2) return cubit.topRatedLoading;
    if (selectedTab == 3) return cubit.popularLoading;
    return cubit.nowPlayingLoading;
  }

  String? selectedMoviesError(HomeCubit cubit) {
    if (selectedTab == 1) return cubit.upcomingError;
    if (selectedTab == 2) return cubit.topRatedError;
    if (selectedTab == 3) return cubit.popularError;
    return cubit.nowPlayingError;
  }

  void retrySelectedMovies(HomeCubit cubit) {
    if (selectedTab == 1) {
      cubit.getUpcomingMovies();
    } else if (selectedTab == 2) {
      cubit.getTopRatedMovies();
    } else if (selectedTab == 3) {
      cubit.getPopularMovies();
    } else {
      cubit.getNowPlayingMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff242A32),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What do you want to watch?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 22),
              TextField(
                readOnly: true,
                onTap: widget.onSearchTap,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Color(0xff92929D)),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Color(0xff92929D),
                    size: 30,
                  ),
                  filled: true,
                  fillColor: const Color(0xff3A3F47),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const HomeCarousel(),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(tabs.length, (index) {
                  return InkWell(
                    onTap: () => setState(() => selectedTab = index),
                    child: Column(
                      children: [
                        Text(
                          tabs[index],
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 45,
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
              const SizedBox(height: 25),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final cubit = HomeCubit.get(context);
                  final movies = selectedMovies(cubit);
                  final isLoading = selectedMoviesLoading(cubit);
                  final error = selectedMoviesError(cubit);

                  if (isLoading && movies.isEmpty) {
                    return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (error != null && movies.isEmpty) {
                    return SizedBox(
                      height: 250,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(error, textAlign: TextAlign.center),
                            TextButton(
                              onPressed: () => retrySelectedMovies(cubit),
                              child: const Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final visibleMovies = cubit.isShow ? movies : movies.take(6).toList();

                  return Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: visibleMovies.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 18,
                          childAspectRatio: 0.66,
                        ),
                        itemBuilder: (context, index) {
                          return MoviePosterCard(movie: visibleMovies[index]);
                        },
                      ),
                      if (movies.length > 6)
                        TextButton(
                          onPressed: cubit.toggleShow,
                          child: Text(cubit.isShow ? 'Show less' : 'Show more'),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
