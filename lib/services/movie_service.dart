import 'package:get_it/get_it.dart';
import 'package:movie_app/services/http_service.dart';
import 'package:movie_app/models/movie.dart';
import 'package:dio/dio.dart';

class MovieService {
  late HttpService _http;
  final GetIt getit = GetIt.instance;
  MovieService() {
    _http = getit.get<HttpService>();
  }

  Future<List<Movie>> getPopularMovies({int? page}) async {
    Response? response = await _http.get(
      "/movie/popular",
      query: {'page': page},
    );
    if (response!.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies =
          data['results'].map<Movie>((movieData) {
            return Movie.fromJson(movieData);
          }).toList();
      return movies;
    } else {
      throw Exception('Couldn\'t load popular movies.');
    }
  }

  Future<List<Movie>> getUpcomingMovies({int? page}) async {
    Response? response = await _http.get(
      '/movie/upcoming',
      query: {'page': page},
    );

    if (response!.statusCode == 200) {
      Map data = response.data;

      List<Movie> movies =
          data['results'].map<Movie>((movieData) {
            return Movie.fromJson(movieData);
          }).toList();
      return movies;
    } else {
      throw Exception('Couldn\'t load upcoming movies.');
    }
  }

  Future<List<Movie>> getTopRatedMovies({int? page}) async {
    Response? response = await _http.get(
      '/movie/top_rated',
      query: {'page': page},
    );

    if (response!.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies =
          data['results'].map<Movie>((movieData) {
            return Movie.fromJson(movieData);
          }).toList();
      return movies;
    } else {
      throw Exception('Couldn\'t load topRated movies.');
    }
  }

  Future<List<Movie>> searchMovies(String searchTerm, {int? page}) async {
    // ✅ Safely construct query map
    final queryParams = {
      'query': searchTerm,
      if (page != null) 'page': page.toString(), // convert page to string
    };

    Response? response = await _http.get('/search/movie', query: queryParams);

    if (response?.statusCode == 200) {
      Map data = response!.data;
      List<Movie> movies =
          data['results'].map<Movie>((moviedata) {
            return Movie.fromJson(moviedata);
          }).toList();
      return movies;
    } else {
      throw Exception('Couldn\'t perform movies search.');
    }
  }
}
