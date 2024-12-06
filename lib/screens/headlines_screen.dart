import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:sample_news_app/db_helper/database_handler.dart';
import 'package:sample_news_app/widgets/common/loading_widget.dart';
import 'package:sample_news_app/widgets/common/news_card.dart';
import 'package:provider/provider.dart';
import '../models/news_article.dart';
import '../providers/news_provider.dart';

class HeadlinesScreen extends StatefulWidget {
  @override
  _HeadlinesScreenState createState() => _HeadlinesScreenState();
}

class _HeadlinesScreenState extends State<HeadlinesScreen> {
  late DatabaseHandler handler;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    // newsProvider.fetchTopNews();
    newsProvider.fetchBookmarkedNews();
    _checkConnectivityAndFetchNews();
  }

  Future<void> _checkConnectivityAndFetchNews() async {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    bool connected = await newsProvider.checkConnectivity();

    setState(() {
      isConnected = connected;
    });

    if (connected) {
      newsProvider.fetchTopNews();
    } else {
      newsProvider.fetchBookmarkedNews();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Top News",
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              onPressed: _checkConnectivityAndFetchNews,
            )
        ],
      ),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: Consumer<NewsProvider>(
            builder: (BuildContext context, NewsProvider value, Widget? child) {
              if (value.articles == null) {
                return const LoadingWidget();
              } else {
                return ListView.builder(
                  itemCount: value.articles?.data.length,
                  itemBuilder: (context, index) {
                    final article = value.articles?.data[index];
                    return NewsCard(
                      article: article!,
                      bookmarkedArticles: value.bookmarkedArticles!,
                    );
                  },
                );
              }
            },
          )),
    );
  }
}
