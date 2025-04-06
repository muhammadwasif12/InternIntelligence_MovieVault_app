import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import 'package:movie_app/models/search_category.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/widgets/movie_tile.dart';
import 'package:movie_app/controllers/main_page_data_controller.dart';
import 'package:movie_app/models/main_page_data.dart';

final selectedMoviePosterUrlProvider = StateProvider<String?>((ref) {
  final movies = ref.watch(mainPageDataControllerProvider).movies;
  return movies?.isNotEmpty == true ? movies![0].posterURL() : null;
});

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final mainPageData = ref.watch(mainPageDataControllerProvider);
    final mainPageDataController = ref.watch(
      mainPageDataControllerProvider.notifier,
    );
    final selectedPosterUrl = ref.watch(selectedMoviePosterUrlProvider);

    final searchController = TextEditingController(
      text: mainPageData.searchText ?? '',
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _BackgroundWidget(selectedPosterUrl, deviceHeight, deviceWidth),
            _ForegroundWidget(
              mainPageData,
              mainPageDataController,
              deviceHeight,
              deviceWidth,
              searchController,
              ref,
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundWidget extends StatelessWidget {
  final String? posterUrl;
  final double height;
  final double width;

  const _BackgroundWidget(this.posterUrl, this.height, this.width);

  @override
  Widget build(BuildContext context) {
    if (posterUrl != null) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(posterUrl!),
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(color: Colors.black.withAlpha(45)),
        ),
      );
    } else {
      return Container(height: height, width: width, color: Colors.black);
    }
  }
}

class _ForegroundWidget extends StatelessWidget {
  final MainPageData mainPageData;
  final MainPageDataController controller;
  final double height;
  final double width;
  final TextEditingController searchController;
  final WidgetRef ref;

  const _ForegroundWidget(
    this.mainPageData,
    this.controller,
    this.height,
    this.width,
    this.searchController,
    this.ref,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
      width: width * 0.90,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _TopBarWidget(
            mainPageData,
            controller,
            height,
            width,
            searchController,
          ),
          Container(
            height: height * 0.83,
            padding: EdgeInsets.symmetric(vertical: height * 0.01),
            child: _MoviesListViewWidget(
              mainPageData,
              controller,
              height,
              width,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBarWidget extends StatelessWidget {
  final MainPageData mainPageData;
  final MainPageDataController controller;
  final double height;
  final double width;
  final TextEditingController searchController;

  const _TopBarWidget(
    this.mainPageData,
    this.controller,
    this.height,
    this.width,
    this.searchController,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.08,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _SearchFieldWidget(height, width, searchController, controller),
          _CategoryDropdownWidget(mainPageData, controller),
        ],
      ),
    );
  }
}

class _SearchFieldWidget extends StatelessWidget {
  final double height;
  final double width;
  final TextEditingController controller;
  final MainPageDataController pageController;

  const _SearchFieldWidget(
    this.height,
    this.width,
    this.controller,
    this.pageController,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.05,
      width: width * 0.50,
      child: TextField(
        controller: controller,
        onSubmitted: pageController.updateTextSearch,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white54,
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Colors.white24),
          hintStyle: const TextStyle(color: Colors.white54),
          filled: false,
          fillColor: Colors.white24,
          hintText: 'Search....',
        ),
      ),
    );
  }
}

class _CategoryDropdownWidget extends StatelessWidget {
  final MainPageData mainPageData;
  final MainPageDataController controller;

  const _CategoryDropdownWidget(this.mainPageData, this.controller);

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: mainPageData.searchCategory,
      dropdownColor: Colors.black38,
      icon: const Icon(Icons.menu, color: Colors.white24),
      underline: Container(height: 1, color: Colors.white24),
      onChanged: (dynamic value) {
        if (value.toString().isNotEmpty) {
          controller.updateSearchCategory(value!);
        }
      },
      items: [
        DropdownMenuItem(
          value: SearchCategory.popular,
          child: Text(
            SearchCategory.popular,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.upcoming,
          child: Text(
            SearchCategory.upcoming,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.topRated,
          child: Text(
            SearchCategory.topRated,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.none,
          child: Text(
            SearchCategory.none,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _MoviesListViewWidget extends ConsumerWidget {
  final MainPageData mainPageData;
  final MainPageDataController controller;
  final double height;
  final double width;

  const _MoviesListViewWidget(
    this.mainPageData,
    this.controller,
    this.height,
    this.width,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Movie> movies = mainPageData.movies!;

    if (movies.isNotEmpty) {
      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            if (notification.metrics.pixels ==
                notification.metrics.maxScrollExtent) {
              controller.getMovies();
            }
          }
          return false;
        },
        child: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.01,
                horizontal: 0,
              ),
              child: GestureDetector(
                onTap: () {
                  ref.read(selectedMoviePosterUrlProvider.notifier).state =
                      movies[index].posterURL();
                },
                child: MovieTile(
                  height: height * 0.20,
                  width: width * 0.85,
                  movie: movies[index],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(backgroundColor: Colors.white),
      );
    }
  }
}
