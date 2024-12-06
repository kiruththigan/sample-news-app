import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/news_article.dart';
import '../../providers/news_provider.dart';
import '../../providers/selected_index_provider.dart';

class BookmarkButton extends StatefulWidget {
  final NewsArticle article;
  final List<NewsArticle> bookmarkedArticles;

  const BookmarkButton(
      {super.key, required this.article, required this.bookmarkedArticles});

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.bookmarkedArticles.any((bookmarkedArticle) {
      return bookmarkedArticle.url == widget.article.url;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndexProvider = Provider.of<SelectedIndexProvider>(context);
    final newsProvider = Provider.of<NewsProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.teal,
          ),
          onPressed: () {
            if (isBookmarked) {
              newsProvider.deleteBookmarkedNews(widget.article);
            } else {
              newsProvider.insertBookmarkedNews(widget.article);
            }
            if (selectedIndexProvider.selectedIndex != 3) {
              setState(() {
                isBookmarked = !isBookmarked;
              });
            }
          },
        ),
      ],
    );
  }
}

// bookmark button for details screen
class BookmarkButtonDetailsScreen extends StatefulWidget {
  final NewsArticle article;
  final List<NewsArticle> bookmarkedArticles;

  const BookmarkButtonDetailsScreen(
      {super.key, required this.article, required this.bookmarkedArticles});

  @override
  State<BookmarkButtonDetailsScreen> createState() =>
      _BookmarkButtonDetailsScreenState();
}

class _BookmarkButtonDetailsScreenState
    extends State<BookmarkButtonDetailsScreen> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.bookmarkedArticles.any((bookmarkedArticle) {
      return bookmarkedArticle.url == widget.article.url;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndexProvider = Provider.of<SelectedIndexProvider>(context);
    final newsProvider = Provider.of<NewsProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.teal,
            size: 35,
          ),
          onPressed: () {
            if (isBookmarked) {
              newsProvider.deleteBookmarkedNews(widget.article);
            } else {
              newsProvider.insertBookmarkedNews(widget.article);
            }
            setState(() {
              isBookmarked = !isBookmarked;
            });

            switch (selectedIndexProvider.selectedIndex) {
              case 0:
                newsProvider.fetchTopNews();
                break;
              case 1:
                newsProvider.searchNews(newsProvider.searchKey!);
                break;
              case 2:
                newsProvider.fetchCategoryNews(newsProvider.selectedCategory!);
                break;
              case 3:
                newsProvider.fetchBookmarkedNews();
                break;
              default:
                newsProvider.fetchTopNews();
                break;
            }
          },
        ),
      ],
    );
  }
}
