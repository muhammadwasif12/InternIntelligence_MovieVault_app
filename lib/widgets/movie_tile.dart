import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';

class MovieTile extends StatelessWidget {
  final double height;
  final double width;
  final Movie movie;

  const MovieTile({
    super.key,
    required this.height,
    required this.width,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _moviePosterWidget(movie.posterURL()),
          SizedBox(width: 8), // Add some spacing between poster and info
          Expanded(
            // This ensures the info widget takes remaining space
            child: _movieInfoWidget(),
          ),
        ],
      ),
    );
  }

  Widget _moviePosterWidget(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: height,
        width: width * 0.35,
        decoration: BoxDecoration(
          color: Colors.grey[800], // Placeholder color
        ),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) =>
                  Center(child: Icon(Icons.broken_image, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _movieInfoWidget() {
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Rating Row
          Row(
            children: [
              Expanded(
                child: Text(
                  movie.name ?? 'No title',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Reduced from 22
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                movie.rating?.toStringAsFixed(1) ?? 'N/A',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18, // Reduced from 22
                ),
              ),
            ],
          ),

          // Metadata
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              '${movie.language?.toUpperCase() ?? 'N/A'} | ${movie.isAdult ?? false ? 'R' : 'PG'} | ${movie.releaseDate ?? 'Unknown'}',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),

          // Description
          Expanded(
            // Takes remaining vertical space
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: SingleChildScrollView(
                // Makes description scrollable
                child: Text(
                  movie.description ?? 'No description available',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
