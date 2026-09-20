import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/home_cubit.dart';
import '../cubits/home_state.dart';
import 'details_screen.dart';

class HomeCarousel extends StatelessWidget {
  const HomeCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);

        if (cubit.carouselLoading && cubit.carouselMovies.isEmpty) {
          return const SizedBox(
            height: 280,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (cubit.carouselError != null && cubit.carouselMovies.isEmpty) {
          return SizedBox(
            height: 280,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(cubit.carouselError!, textAlign: TextAlign.center),
                  TextButton(
                    onPressed: cubit.getCarouselMovies,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }

        return CarouselSlider.builder(
          itemCount: cubit.carouselMovies.length,
          itemBuilder: (context, index, realIndex) {
            final movie = cubit.carouselMovies[index];
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
              child: Stack(
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
                                '${HomeCubit.imageUrl}${movie.posterPath}',
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
                        shadows: [Shadow(color: Color(0xff0296E5), blurRadius: 3)],
                      ),
                    ),
                  ),
                ],
              ),
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
