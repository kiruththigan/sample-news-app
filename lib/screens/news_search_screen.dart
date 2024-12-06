import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sample_news_app/widgets/common/search_input.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/news_card.dart';

class NewsSearchScreen extends StatefulWidget {
  const NewsSearchScreen({super.key});

  @override
  State<NewsSearchScreen> createState() => _NewsSearchScreenState();
}

class _NewsSearchScreenState extends State<NewsSearchScreen> {
  String searchKey = "";

  @override
  void initState() {
    Provider.of<NewsProvider>(context, listen: false).searchNews(searchKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All News',
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              SearchInput(
                onChanged: (value) {
                  setState(() {
                    newsProvider.setSearchKey(value);
                    searchKey = value;
                  });
                },
                onSearch: () {
                  Provider.of<NewsProvider>(context, listen: false)
                      .searchNews(searchKey);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Consumer<NewsProvider>(
                  builder: (BuildContext context, NewsProvider value,
                      Widget? child) {
                    if (value.isLoading!) {
                      return LoadingWidget();
                    } else if (value.articles == null) {
                      return Center(child: const Text("News not found !"));
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
                ),
              ),
            ],
          )),
      // bottomNavigationBar: BottomNavBar(),
    );
  }
}
