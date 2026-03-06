import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/services/api_services.dart';

import 'package:pilem/screens/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiServices _apiServices = ApiServices();
  List<Movie> _AllMovies = [];
  List<Movie> _TrendingMovies = [];
  List<Movie> _PopularMovies = [];
  // List<Movie> _FavoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final List<Map<String,dynamic>> allMoviesData = await _apiServices.getAllMovies();
    final List<Map<String,dynamic>> trendingMoviesData = await _apiServices.getTrendingMovies();
    final List<Map<String,dynamic>> popularMoviesData = await _apiServices.getTrendingMovies();

    setState(() {
      _AllMovies = allMoviesData.map((e) => Movie.fromJson(e)).toList();
      _TrendingMovies = trendingMoviesData.map((e) => Movie.fromJson(e)).toList();
      _PopularMovies = popularMoviesData.map((e) => Movie.fromJson(e)).toList();
    });

    void _toggleFavorite(Movie movie) {
  // setState(() {
  //   if (_FavoriteMovies.contains(movie)) {
  //     _FavoriteMovies.remove(movie);
  //   } else {
  //     _FavoriteMovies.add(movie);
  //   }
  // });
}

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pilem")
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // agar horizontal kiri kanan
          children: [
            _buildMovieList('All Movies', _AllMovies),
            _buildMovieList('Trending Movies', _TrendingMovies),
            _buildMovieList('Popular Movies', _PopularMovies),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieList(String title, List<Movie> movies){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              final Movie movie = movies[index];
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(movie: movie),
                    // isFavorite: _FavoriteMovies.contains(movies),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.network('https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      height: 150,
                      width: 100,
                      fit: BoxFit.cover
                      ),
                      const SizedBox(height: 5),
                      Text(movie.title.length > 14 ?'${movie.title.substring(0, 10)}...' : movie.title,
                      style: const TextStyle(fontWeight:FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
   }
}