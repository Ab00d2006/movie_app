abstract class TopRatedState {}

class TopRatedInitial extends TopRatedState {}

class TopRatedLoading extends TopRatedState {}

class TopRatedSuccess extends TopRatedState {}

class TopRatedFailure extends TopRatedState {
  final String error;

  TopRatedFailure(this.error);
}
