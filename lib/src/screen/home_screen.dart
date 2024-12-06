import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:starbhak_mall/services/cart_service.dart';
import 'package:starbhak_mall/services/item_service.dart';
import 'package:shimmer/shimmer.dart';
import 'profile_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supabase = Supabase.instance.client;
  late final CartService _cartService;
  late final ItemService _itemService;

  int selectedCategory = 0;
  bool _isLoading = true;

  List<Map<String, dynamic>> categories = [
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

  List<Map<String, dynamic>> stuffs = [];

  @override
  void initState() {
    super.initState();
    _cartService = CartService(_supabase);
    _itemService = ItemService(_supabase);
    _fetchItems();
  }

    
  String _formatPrice(dynamic price) {
    if (price == null) return 'Rp 0';
    final formatter = NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp ', 
      decimalDigits: 0
    );
    return formatter.format(num.tryParse(price.toString()) ?? 0);
  }

  Future<void> _fetchItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final items = await _itemService.fetchItems();
      setState(() {
        stuffs = items;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching items: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load items: $e')),
      );
    }
  }

  List<Map<String, dynamic>> getFilteredstuffs() {
    if (selectedCategory == 0) {
      return stuffs;
    } else {
      String categoryName = categories[selectedCategory]['label'];
      return stuffs.where((stuff) => 
        stuff['category'].toString().toLowerCase() == 
        categoryName.toLowerCase()
      ).toList();
    }
  }

  
  Widget _buildCategoryShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 100,
            margin: const EdgeInsets.only(right: 13),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 10,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  
  Widget _buildItemShimmer() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 4, 
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Container(
                  width: double.infinity,
                  height: 170,
                  color: Colors.white,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                        Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 60,
                              height: 16,
                              color: Colors.white,
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredstuffs = getFilteredstuffs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                CupertinoIcons.person,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const ProfileScreen())
                );
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchItems,
        child: _isLoading
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: _buildCategoryShimmer(),
                      ),
                      const SizedBox(height: 24),
                      
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 100,
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      Expanded(
                        child: _buildItemShimmer(),
                      ),
                    ],
                  ),
                ),
              )
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Container(
                        height: 200,
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
                                      width: 80,
                                      height: 80,
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
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: double.infinity,
                                            height: 80,
                                            color: Colors.grey[200],
                                            child: const Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
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
                      
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "All items",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      Expanded(
                        child: filteredstuffs.isEmpty
                            ? Center(
                                child: Text(
                                  'No items found',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.65,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: filteredstuffs.length,
                                itemBuilder: (context, index) {
                                  final stuff = filteredstuffs[index];
                                  return Card(
                                    color: Colors.white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            stuff['image'] ?? 'assets/placeholder.png',
                                            width: double.infinity,
                                            height: 170,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                width: double.infinity,
                                                height: 240,
                                                color: Colors.grey[200],
                                                child: const Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
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
                                                  stuff['name'] ?? 'Unnamed Item',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      _formatPrice(stuff['price']),
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _cartService.addToCart(context, stuff['id'].toString());
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        child: const Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                          size: 15,
                                                        ),
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
      )
    );
  }
}