import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_news_app/screens/bookmark_screen.dart';
import 'package:sample_news_app/screens/news_search_screen.dart';
import 'package:sample_news_app/screens/categories_screen.dart';
import 'package:sample_news_app/screens/headlines_screen.dart';
import 'package:sample_news_app/widgets/common/bottom_nav_bar.dart';

import '../providers/selected_index_provider.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final appScreens = [
    HeadlinesScreen(),
    NewsSearchScreen(),
    const CategoriesScreen(),
    BookmarkScreen(),
  ];

  void _onItemTapped(int index) {
    Provider.of<SelectedIndexProvider>(context, listen: false)
        .setSelectedIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndexProvider = Provider.of<SelectedIndexProvider>(context);

    return Scaffold(
      body: appScreens[selectedIndexProvider.selectedIndex!],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndexProvider.selectedIndex!,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
