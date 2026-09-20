abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeCarouselMovieLoading extends HomeState {}
class HomeCarouselMovieSuccess extends HomeState {}
class HomeCarouselMovieFailure extends HomeState {
  final String error;
  HomeCarouselMovieFailure(this.error);
}

class HomeNowPlayingMovieLoading extends HomeState {}
class HomeNowPlayingMovieSuccess extends HomeState {}
class HomeNowPlayingMovieFailure extends HomeState {
  final String error;
  HomeNowPlayingMovieFailure(this.error);
}

class HomeUpcomingMovieLoading extends HomeState {}
class HomeUpcomingMovieSuccess extends HomeState {}
class HomeUpcomingMovieFailure extends HomeState {
  final String error;
  HomeUpcomingMovieFailure(this.error);
}

class HomeTopRatedMovieLoading extends HomeState {}
class HomeTopRatedMovieSuccess extends HomeState {}
class HomeTopRatedMovieFailure extends HomeState {
  final String error;
  HomeTopRatedMovieFailure(this.error);
}

class HomePopularMovieLoading extends HomeState {}
class HomePopularMovieSuccess extends HomeState {}
class HomePopularMovieFailure extends HomeState {
  final String error;
  HomePopularMovieFailure(this.error);
}

class HomeShowMoreChanged extends HomeState {}
