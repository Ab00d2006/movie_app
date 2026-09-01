abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeCarouselMovieLoading extends HomeState {}

class HomeCarouselMovieSuccess extends HomeState {}

class HomeCarouselMovieFailure extends HomeState {
  final String error;

  HomeCarouselMovieFailure(this.error);
}
