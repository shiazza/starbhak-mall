import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategory = 0;
  
  final List<Map<String, dynamic>> categories = [
    {
      'image': 'assets/burger_icon.jpg',
      'label': 'All',
      'backgroundColor': Colors.blue,
    },
    {
      'image': 'assets/burger_icon.jpg',
      'label': 'Makanan',
      'backgroundColor': Colors.white,
    },
    {
      'image': 'assets/drink_icon.jpg',
      'label': 'Minuman',
      'backgroundColor': Colors.white,
    },
  ];

  List<Map<String, dynamic>> foods = [ 
    {
      'name': 'Burger King Medium',
      'price': '50.000,00',
      'image': 'assets/burger_icon.jpg',
      'category': 'Makanan',
    },
    {
      'name': 'Burger King Medium',
      'price': '50.000,00' ,
      'image': 'assets/burger_icon.jpg',
      'category': 'Makanan',
    },
    {
      'name': 'Teh Botol',
      'price': '4.000,00',
      'image': 'assets/drink_icon.jpg',
      'category': 'Minuman',
    },
  ];

  void addProduct(Map<String, dynamic> newProduct) {
    setState(() {
      foods.add(newProduct);
    });
  }

  List<Map<String, dynamic>> getFilteredFoods() {
    if (selectedCategory == 0) {
      return foods;
    } else {
      String categoryName = categories[selectedCategory]['label'];
      return foods.where((food) => food['category'] == categoryName).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredFoods = getFilteredFoods();
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kategori di tengah
              Container(
                height: 160,
                alignment: Alignment.center,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = index;
                        });
                      },
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 13),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: selectedCategory == index 
                                    ? Colors.blueAccent
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                categories[index]['image'],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              categories[index]['label'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Text "All Food" sekarang akan berada di kiri
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  categories[selectedCategory]['label'] == 'All' 
                      ? 'All Food'
                      : categories[selectedCategory]['label'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredFoods.length,
                  itemBuilder: (context, index) {
                    final food = filteredFoods[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.asset(
                                food['image'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    food['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Rp. ${food['price']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}