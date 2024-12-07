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
  @override
  void initState() {
    Provider.of<NewsProvider>(context, listen: false).searchNews("");
    super.initState();
  }

  void _pickFromDate(BuildContext context) async {
    final newsProvider = context.read<NewsProvider>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: newsProvider.fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != newsProvider.fromDate) {
      newsProvider.setFromDate(picked);
    }
  }

  void _pickToDate(BuildContext context) async {
    final newsProvider = context.read<NewsProvider>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: newsProvider.toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != newsProvider.toDate) {
      newsProvider.setToDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search News',
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
                  newsProvider.setSearchKey(value);
                },
                onSearch: () {
                  Provider.of<NewsProvider>(context, listen: false).searchNews(
                    newsProvider.searchKey!,
                    from: Provider.of<NewsProvider>(context, listen: false)
                        .fromDate
                        ?.toIso8601String(),
                    to: Provider.of<NewsProvider>(context, listen: false)
                        .toDate
                        ?.toIso8601String(),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickFromDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          Provider.of<NewsProvider>(context, listen: false)
                                      .fromDate ==
                                  null
                              ? 'Select From Date'
                              : Provider.of<NewsProvider>(context,
                                      listen: false)
                                  .fromDate!
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickToDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          Provider.of<NewsProvider>(context, listen: false)
                                      .toDate ==
                                  null
                              ? 'Select To Date'
                              : Provider.of<NewsProvider>(context,
                                      listen: false)
                                  .toDate!
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
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
                ),
              ),
            ],
          )),
      // bottomNavigationBar: BottomNavBar(),
    );
  }
}
