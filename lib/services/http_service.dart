import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/models/app_config.dart';

class HttpService {
  final Dio dio = Dio();
  final GetIt getit = GetIt.instance;

  late final String _baseurl;
  late final String _apiKey;

  HttpService() {
    AppConfig appConfig = getit.get<AppConfig>();
    _baseurl = appConfig.BASE_API_URL;
    _apiKey = appConfig.API_KEY;
  }

  Future<Response?> get(String path, {Map<String, dynamic>? query}) async {
    try {
      String url = '$_baseurl$path';
      Map<String, dynamic> query0 = {"api_key": _apiKey, "language": 'en-US'};
      if (query != null) {
        query0.addAll(query);
      }

      return await dio.get(url, queryParameters: query0);
    } on DioException catch (e) {
      print("Unable to perform get request!");
      print("DioError:$e");
    }
    return null;
  }
}
