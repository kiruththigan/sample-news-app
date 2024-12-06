import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/news_card.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  void initState() {
    Provider.of<NewsProvider>(context, listen: false).fetchBookmarkedNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bookmark',
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: Consumer<NewsProvider>(
            builder: (BuildContext context, NewsProvider value, Widget? child) {
              if (value.bookmarkedArticles!.isEmpty) {
                return const Center(child: Text("No Bookmarks !"));
              } else {
                return ListView.builder(
                  itemCount: value.bookmarkedArticles?.length,
                  itemBuilder: (context, index) {
                    final article = value.bookmarkedArticles?[index];
                    return NewsCard(
                      article: article!,
                      bookmarkedArticles: value.bookmarkedArticles!,
                    );
                  },
                );
              }
            },
          )),
      // bottomNavigationBar: BottomNavBar(),
    );
  }
}
