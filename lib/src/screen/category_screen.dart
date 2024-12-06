
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Category {
  final String image;
  final String label;
  final Color backgroundColor;

  Category({
    required this.image,
    required this.label,
    required this.backgroundColor,
  });
}

class CategoryScreen extends StatelessWidget {
  final List<Category> categories = [
    Category(
      image: 'assets/burger_icon.jpg',
      label: 'All',
      backgroundColor: Colors.blue,
    ),
    Category(
      image: 'assets/burger_icon.jpg',
      label: 'Makanan',
      backgroundColor: Colors.white,
    ),
    Category(
      image: 'assets/drink_icon.jpg',
      label: 'Minuman',
      backgroundColor: Colors.white,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              // Handle category tap
            },
            child: Container(
              decoration: BoxDecoration(
                color: category.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    category.image,
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
