import 'package:flutter/material.dart';
import 'package:sample_news_app/models/category.dart';
import 'package:sample_news_app/widgets/common/news_card.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import '../widgets/common/loading_widget.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;

  const CategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    Provider.of<NewsProvider>(context, listen: false)
        .fetchCategoryNews(widget.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.name!,
          style: const TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
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
                    if (article?.urlToImage == null) {
                      return const SizedBox.shrink();
                    }
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
