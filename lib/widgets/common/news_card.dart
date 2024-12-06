import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sample_news_app/widgets/common/BookmarkButton.dart';

import '../../db_helper/database_handler.dart';
import '../../models/news_article.dart';
import '../../screens/news_details_screen.dart';

class NewsCard extends StatefulWidget {
  final NewsArticle article;
  final List<NewsArticle> bookmarkedArticles;

  const NewsCard(
      {super.key, required this.article, required this.bookmarkedArticles});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();

    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailsScreen(article: widget.article),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
            clipBehavior: Clip.hardEdge,
            child: CachedNetworkImage(
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              imageUrl: widget.article.urlToImage ?? "",
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Container(
                height: 200,
                color: Colors.grey,
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.article.title ?? 'No Title',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.article.description ?? 'No Description',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          BookmarkButton(
              article: widget.article,
              bookmarkedArticles: widget.bookmarkedArticles),
          const Divider(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
