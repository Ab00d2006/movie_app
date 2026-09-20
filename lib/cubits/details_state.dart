import '../models/cast_model.dart';
import '../models/movie_details_model.dart';
import '../models/review_model.dart';

abstract class DetailsState {}

class DetailsInitial extends DetailsState {}
class DetailsLoading extends DetailsState {}

class DetailsSuccess extends DetailsState {
  final MovieDetailsModel movie;
  final List<ReviewModel> reviews;
  final List<CastModel> cast;

  DetailsSuccess({
    required this.movie,
    required this.reviews,
    required this.cast,
  });
}

class DetailsFailure extends DetailsState {
  final String error;
  DetailsFailure(this.error);
}
