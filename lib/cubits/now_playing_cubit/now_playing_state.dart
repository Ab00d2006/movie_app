abstract class NowPlayingState {}

class NowPlayingInitial extends NowPlayingState {}

class NowPlayingLoading extends NowPlayingState {}

class NowPlayingSuccess extends NowPlayingState {}

class NowPlayingFailure extends NowPlayingState {
  final String error;

  NowPlayingFailure(this.error);
}
