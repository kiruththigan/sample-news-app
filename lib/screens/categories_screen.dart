import 'package:flutter/material.dart';
import '../models/category.dart';
import '../widgets/categories/category_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});


  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  static List<Category> getCategories() {
    return [
      Category(
          name: "Business",
          url:
              "https://images.business.com/app/uploads/2011/06/12131215/Leadership-Skills.png"),
      Category(
          name: "Entertainment",
          url:
              "https://imgeng.jagran.com/images/2022/nov/Cirkus1669599578227.jpg"),
      Category(
          name: "General",
          url:
              "https://chessdailynews.com/wp-content/uploads/2015/03/general_news1.jpg"),
      Category(
          name: "Health",
          url:
              "https://media.licdn.com/dms/image/v2/D4D12AQF-UNBK1Cd76A/article-cover_image-shrink_720_1280/article-cover_image-shrink_720_1280/0/1692008950713?e=2147483647&v=beta&t=np9IYeph2hO3qky7DCqB0sM5KvXP3HWTBT5bknBBlnY"),
      Category(
          name: "Science",
          url:
              "https://cdn.ourcrowd.com/wp-content/uploads/2024/04/Life_Sciences_Learn-Article_1-652x369.png"),
      Category(
          name: "Sports",
          url:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4hgUVtTgO4EIPRIxBcxGMlgSStAQEJv0l3g&s"),
      Category(
          name: "Technology",
          url:
              "https://insidesmallbusiness.com.au/wp-content/uploads/2021/04/bigstock-Technology-And-Biometric-Conce-213062104.jpg"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var categories = getCategories();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 3 / 2,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(category: category);
          },
        ),
      ),
    );
  }
}
