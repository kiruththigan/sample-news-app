import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:sample_news_app/db_helper/database_handler.dart';
import 'package:sample_news_app/models/category.dart';
import '../models/news_article.dart';
import 'package:http/http.dart' as http;

class NewsProvider with ChangeNotifier {
  DatabaseHandler handler = DatabaseHandler();
  bool _isLoading = false;
  NewsArticleModel? _articles;
  List<NewsArticle>? _bookmarkedArticles;
  Category? _selectedCategory;
  String _searchKey = "";
  DateTime? _fromDate;
  DateTime? _toDate;

  bool? get isLoading => _isLoading;

  NewsArticleModel? get articles => _articles;

  List<NewsArticle>? get bookmarkedArticles => _bookmarkedArticles;

  Category? get selectedCategory => _selectedCategory;

  String? get searchKey => _searchKey;

  DateTime? get fromDate => _fromDate;

  DateTime? get toDate => _toDate;

  final String apiKey = 'dc8a840dd2cf4d8bb8890a5b2674ce57';
  final String apiUrl = 'https://newsapi.org/v2';

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> fetchTopNews() async {
    _articles = null;
    notifyListeners();
    try {
      bool isConnected = await checkConnectivity();

      if (isConnected) {
        final response = await http
            .get(Uri.parse('$apiUrl/top-headlines?country=us&apiKey=$apiKey'));

        if (response.statusCode == 200) {
          _articles = NewsArticleModel.fromJson(json.decode(response.body));
          handler.insertBulkArticles(_articles!.data);
        } else {
          throw Exception('Failed to load news data');
        }
      } else {
        // Fetch bookmarked articles when offline
        final List<NewsArticle> bookmarkedArticles =
            await handler.getBookmarks();
        _articles = NewsArticleModel(status: 'ok', data: bookmarkedArticles);
      }
    } catch (error) {
      final List<NewsArticle> bookmarkedArticles = await handler.getArticles();
      _articles = NewsArticleModel(status: 'ok', data: bookmarkedArticles);
      throw Exception('Error: $error');
    } finally {
      notifyListeners();
    }
  }

  // Future<void> fetchTopNews() async {
  //   _articles = null;
  //   notifyListeners();
  //   try {
  //     final response = await http
  //         .get(Uri.parse('$apiUrl/top-headlines?country=us&apiKey=$apiKey'));
  //
  //     if (response.statusCode == 200) {
  //       _articles = NewsArticleModel.fromJson(json.decode(response.body));
  //     } else {
  //       throw Exception('Failed to load news data');
  //     }
  //   } catch (error) {
  //     throw Exception('Error: $error');
  //   } finally {
  //     notifyListeners();
  //   }
  // }

  Future<void> fetchCategoryNews(Category category) async {
    _articles = null;
    try {
      final response = await http.get(Uri.parse(
          '$apiUrl/top-headlines?country=us&category=${category.name?.toLowerCase()}&apiKey=$apiKey'));

      if (response.statusCode == 200) {
        _articles = NewsArticleModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load news data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    } finally {
      notifyListeners();
    }
  }

  Future<void> searchNews(String searchKey, {String? from, String? to}) async {
    _isLoading = true;
    _articles = null;
    notifyListeners();
    try {
      if (searchKey.isNotEmpty) {
        String url =
            '$apiUrl/everything?q=${searchKey.toLowerCase()}&apiKey=$apiKey&sortBy=publishedAt';

        if (from != null) {
          url += '&from=$from';
        }
        if (to != null) {
          url += '&to=$to';
        }

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          _articles = NewsArticleModel.fromJson(json.decode(response.body));
        } else {
          throw Exception('Failed to load news data');
        }
      }
    } catch (error) {
      throw Exception('Error: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBookmarkedNews() async {
    // _bookmarkedArticles = null;
    try {
      handler = DatabaseHandler();
      final List<NewsArticle> response = await handler.getBookmarks();

      _bookmarkedArticles = response;
    } catch (error) {
      throw Exception('Error: $error');
    } finally {
      notifyListeners();
    }
  }

  Future<void> insertBookmarkedNews(NewsArticle article) async {
    try {
      handler = DatabaseHandler();
      await handler.insertBookmark(article);
    } catch (error) {
      throw Exception('Error: $error');
    } finally {
      fetchBookmarkedNews();
      notifyListeners();
    }
  }

  Future<void> deleteBookmarkedNews(NewsArticle article) async {
    try {
      handler = DatabaseHandler();
      await handler.deleteBookmark(article);
    } catch (error) {
      throw Exception('Error: $error');
    } finally {
      fetchBookmarkedNews();
      notifyListeners();
    }
  }

  Future<void> setSelectedCategory(Category category) async {
    try {
      _selectedCategory = category;
    } catch (error) {
      throw Exception('Error: $error');
    } finally {
      notifyListeners();
    }
  }

  Future<void> setSearchKey(String searchKey) async {
    try {
      _searchKey = searchKey;
    } catch (error) {
      throw Exception('Error: $error');
    } finally {
      notifyListeners();
    }
  }

  Future<void> setFromDate(DateTime fromDate) async {
    try {
      _fromDate = fromDate;
    } catch (error) {
      throw Exception('Error: $error');
    } finally {
      notifyListeners();
    }
  }

  Future<void> setToDate(DateTime toDate) async {
    try {
      _toDate = toDate;
    } catch (error) {
      throw Exception('Error: $error');
    } finally {
      notifyListeners();
    }
  }
}
