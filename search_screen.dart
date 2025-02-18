import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../constants.dart';
import 'movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final MovieService movieService;
  const SearchScreen({Key? key, required this.movieService}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _movies = [];
  bool _isLoading = false;
  String _errorMessage = "";

  void _searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        _movies = [];
        _errorMessage = "";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final results = await widget.movieService.searchMovies(query);
      setState(() {
        _movies = results;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = "Error: ${error.toString()}";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search movies...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.black),
          onChanged: _searchMovies,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _searchMovies("");
              },
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : _movies.isEmpty
          ? Center(child: Text("No results found"))
          : ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index];
          return ListTile(
            leading: movie['poster_path'] != null
                ? Image.network("${IMAGE_BASE_URL}${movie['poster_path']}", width: 50, fit: BoxFit.cover)
                : Icon(Icons.movie),
            title: Text(movie['title'] ?? "Unknown title"),
            subtitle: Text(movie['release_date'] ?? "Release date unknown"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)),
              );
            },
          );
        },
      ),
    );
  }
}
