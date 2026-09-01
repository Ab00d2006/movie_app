abstract class UpcomingState {}

class UpcomingInitial extends UpcomingState {}

class UpcomingLoading extends UpcomingState {}

class UpcomingSuccess extends UpcomingState {}

class UpcomingFailure extends UpcomingState {
  final String error;

  UpcomingFailure(this.error);
}
