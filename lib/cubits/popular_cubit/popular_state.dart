abstract class PopularState {}

class PopularInitial extends PopularState {}

class PopularLoading extends PopularState {}

class PopularSuccess extends PopularState {}

class PopularFailure extends PopularState {
  final String error;

  PopularFailure(this.error);
}
