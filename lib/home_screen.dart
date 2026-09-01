import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/home_cubit.dart';
import 'cubits/home_state.dart';
import 'cubits/now_playing_cubit/now_playing_cubit.dart';
import 'cubits/now_playing_cubit/now_playing_state.dart';
import 'cubits/popular_cubit/popular_cubit.dart';
import 'cubits/popular_cubit/popular_state.dart';
import 'cubits/top_rated_cubit/top_rated_cubit.dart';
import 'cubits/top_rated_cubit/top_rated_state.dart';
import 'cubits/upcoming_cubit/upcoming_cubit.dart';
import 'cubits/upcoming_cubit/upcoming_state.dart';
import 'models/movie_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeCubit()..getCarouselMovies(),
        ),
        BlocProvider(
          create: (_) => NowPlayingCubit()..getNowPlayingMovies(),
        ),
        BlocProvider(
          create: (_) => UpcomingCubit()..getUpcomingMovies(),
        ),
        BlocProvider(
          create: (_) => TopRatedCubit()..getTopRatedMovies(),
        ),
        BlocProvider(
          create: (_) => PopularCubit()..getPopularMovies(),
        ),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedTab = 0;
  int currentBottomItem = 0;
  bool isShow = false;

  final List<String> tabs = const [
    'Now playing',
    'Upcoming',
    'Top rated',
    'Popular',
  ];

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
              const _CarouselMovies(),
              const SizedBox(height: 25),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    final selected = selectedTab == index;

                    return Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedTab = index;
                            isShow = false;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              tabs[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 45,
                              height: 3,
                              color: selected
                                  ? const Color(0xff0296E5)
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 25),
              _buildSelectedMovies(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentBottomItem,
        onTap: (index) {
          setState(() {
            currentBottomItem = index;
          });
        },
        backgroundColor: const Color(0xff242A32),
        selectedItemColor: const Color(0xff0296E5),
        unselectedItemColor: const Color(0xff67686D),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Watch list',
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedMovies(BuildContext context) {
    if (selectedTab == 1) {
      return BlocBuilder<UpcomingCubit, UpcomingState>(
        builder: (context, state) {
          final cubit = UpcomingCubit.get(context);

          return _MoviesSection(
            movies: cubit.movies,
            loading: state is UpcomingLoading,
            error: state is UpcomingFailure ? state.error : null,
            retry: cubit.getUpcomingMovies,
            isShow: isShow,
            changeShow: _changeShow,
          );
        },
      );
    }

    if (selectedTab == 2) {
      return BlocBuilder<TopRatedCubit, TopRatedState>(
        builder: (context, state) {
          final cubit = TopRatedCubit.get(context);

          return _MoviesSection(
            movies: cubit.movies,
            loading: state is TopRatedLoading,
            error: state is TopRatedFailure ? state.error : null,
            retry: cubit.getTopRatedMovies,
            isShow: isShow,
            changeShow: _changeShow,
          );
        },
      );
    }

    if (selectedTab == 3) {
      return BlocBuilder<PopularCubit, PopularState>(
        builder: (context, state) {
          final cubit = PopularCubit.get(context);

          return _MoviesSection(
            movies: cubit.movies,
            loading: state is PopularLoading,
            error: state is PopularFailure ? state.error : null,
            retry: cubit.getPopularMovies,
            isShow: isShow,
            changeShow: _changeShow,
          );
        },
      );
    }

    return BlocBuilder<NowPlayingCubit, NowPlayingState>(
      builder: (context, state) {
        final cubit = NowPlayingCubit.get(context);

        return _MoviesSection(
          movies: cubit.movies,
          loading: state is NowPlayingLoading,
          error: state is NowPlayingFailure ? state.error : null,
          retry: cubit.getNowPlayingMovies,
          isShow: isShow,
          changeShow: _changeShow,
        );
      },
    );
  }

  void _changeShow() {
    setState(() {
      isShow = !isShow;
    });
  }
}

class _CarouselMovies extends StatelessWidget {
  const _CarouselMovies();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);

        if (state is HomeCarouselMovieLoading) {
          return const SizedBox(
            height: 280,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is HomeCarouselMovieFailure) {
          return _ErrorView(
            height: 280,
            error: state.error,
            retry: cubit.getCarouselMovies,
          );
        }

        if (cubit.carouselMovies.isEmpty) {
          return const SizedBox(
            height: 280,
            child: Center(child: Text('No movies found')),
          );
        }

        return CarouselSlider.builder(
          itemCount: cubit.carouselMovies.length,
          itemBuilder: (context, index, realIndex) {
            final movie = cubit.carouselMovies[index];

            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 24, bottom: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xff3A3F47),
                    borderRadius: BorderRadius.circular(16),
                    image: movie.posterPath.isEmpty
                        ? null
                        : DecorationImage(
                            image: NetworkImage(
                              '$tmdbImageUrl${movie.posterPath}',
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 82,
                      height: 1,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff242A32),
                      shadows: [
                        Shadow(
                          color: Color(0xff0296E5),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          options: CarouselOptions(
            height: 280,
            viewportFraction: 0.55,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
          ),
        );
      },
    );
  }
}

class _MoviesSection extends StatelessWidget {
  final List<MovieModel> movies;
  final bool loading;
  final String? error;
  final VoidCallback retry;
  final bool isShow;
  final VoidCallback changeShow;

  const _MoviesSection({
    required this.movies,
    required this.loading,
    required this.error,
    required this.retry,
    required this.isShow,
    required this.changeShow,
  });

  @override
  Widget build(BuildContext context) {
    if (loading && movies.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null && movies.isEmpty) {
      return _ErrorView(
        height: 250,
        error: error!,
        retry: retry,
      );
    }

    if (movies.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(child: Text('No movies found')),
      );
    }

    final visibleMovies = isShow ? movies : movies.take(6).toList();

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
            return _MoviePosterCard(movie: visibleMovies[index]);
          },
        ),
        if (movies.length > 6)
          TextButton(
            onPressed: changeShow,
            child: Text(isShow ? 'Show less' : 'Show more'),
          ),
      ],
    );
  }
}

class _MoviePosterCard extends StatelessWidget {
  final MovieModel movie;

  const _MoviePosterCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    if (movie.posterPath.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xff3A3F47),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.movie, size: 45),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        '$tmdbImageUrl${movie.posterPath}',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xff3A3F47),
            child: const Icon(Icons.movie, size: 45),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final double height;
  final String error;
  final VoidCallback retry;

  const _ErrorView({
    required this.height,
    required this.error,
    required this.retry,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              error,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            TextButton(
              onPressed: retry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
