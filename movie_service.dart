import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class MovieService {

  // Fetch movies by category (e.g., popular, top_rated, etc.)
  Future<List<dynamic>> fetchMovies(String category) async {
    final url = "$BASE_URL/movie/$category?api_key=$API_KEY";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'] ?? [];
    } else {
      throw Exception("Failed to load movies");
    }
  }

  // Movie search function
  Future<List<dynamic>> searchMovies(String query) async {
    if (query.isEmpty) return []; // Return empty list if search query is empty
    final url = Uri.parse("https://api.themoviedb.org/3/search/movie?api_key=$API_KEY&query=$query");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception("Failed to search movies");
    }
  }
  // Get movie trailer
  Future<String?> getTrailer(int movieId) async {
    final url = Uri.parse("https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$API_KEY");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> videos = json.decode(response.body)['results'];
      var trailer = videos.firstWhere((video) => video['type'] == "Trailer", orElse: () => null);
      return trailer?['key'];  // Returns the YouTube video ID
    }
    return null;
  }
}
