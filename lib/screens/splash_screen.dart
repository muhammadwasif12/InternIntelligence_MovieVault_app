import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movie_app/screens/main_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/models/app_config.dart';
import 'package:movie_app/services/http_service.dart';
import 'package:movie_app/services/movie_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _setup(context).then((value) {
      Timer(Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      });
    });
  }

  Future<void> _setup(BuildContext context) async {
    final getit = GetIt.instance;

    final configFile = await rootBundle.loadString('assets/config/main.json');
    final configData = jsonDecode(configFile);

    getit.registerSingleton<AppConfig>(
      AppConfig(
        BASE_API_URL: configData['BASE_API_URL'],
        BASE_IMAGE_API_URL: configData['BASE_IMAGE_API_URL'],
        API_KEY: configData['API_KEY'],
      ),
    );

    getit.registerSingleton<HttpService>(HttpService());

    getit.registerSingleton<MovieService>(MovieService());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Image.asset(
            "assets/images/logo.png",
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
