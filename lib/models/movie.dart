import 'package:get_it/get_it.dart';
import 'package:movie_app/models/app_config.dart';

class Movie {
  final String? name;
  final String? language;
  final bool? isAdult;
  final String? description;
  final String? posterPath;
  final String? backdropPath;
  final num? rating;
  final String? releaseDate;

  Movie({
    this.name,
    this.language,
    this.isAdult,
    this.description,
    this.posterPath,
    this.backdropPath,
    this.rating,
    this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      name: json['title'],
      language: json['original_language'],
      isAdult: json['adult'],
      description: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      rating: json['vote_average'],
      releaseDate: json['release_date'],
    );
  }

  String posterURL() {
    final AppConfig appConfig = GetIt.instance.get<AppConfig>();
    return '${appConfig.BASE_IMAGE_API_URL}$posterPath';
  }
}
