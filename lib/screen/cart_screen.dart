import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Burger King Medium',
      'price': 50000.00,
      'image': 'assets/burger_icon.jpg',
      'quantity': 1,
    },
    {
      'name': 'Teh Botol',
      'price': 4000.00,
      'image': 'assets/drink_icon.jpg',
      'quantity': 2,
    },
    {
      'name': 'Burger King Small',
      'price': 35000.00,
      'image': 'assets/burger_icon.jpg',
      'quantity': 1,
    },
  ];

  void updateQuantity(int index, bool increase) {
    setState(() {
      if (increase) {
        cartItems[index]['quantity']++;
      } else if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      }
    });
  }

  // Custom animated counter widget
  Widget _buildAnimatedCounter(int value) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      child: Text(
        '$value',
        key: ValueKey<int>(value),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAnimatedPrice(double price) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.5),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
      child: Text(
        'Rp ${price.toStringAsFixed(2)}',
        key: ValueKey<double>(price),
        style: const TextStyle(
          color: Colors.black87,
        ),
      ),
    );
  }

  void showDeleteConfirmation(BuildContext context, int index) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: Text(
            "Apakah Anda yakin ingin menghapus ${cartItems[index]['name']} dari keranjang?",
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              isDestructiveAction: true,
              child: const Text("Batal"),
            ),
            CupertinoDialogAction(
              onPressed: () {
                setState(() {
                  cartItems.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  double calculateSubtotal() {
    return cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = calculateSubtotal();
    final ppn = subtotal * 0.11;
    final total = subtotal + ppn;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Cart')),
        leading: Container(
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
            icon: const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.red,
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
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
                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: const Text("Profile Button"),
                      content: const Text("You clicked the profile button!"),
                      actions: [
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(
                              foreground: Paint()..color = Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            item['image'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildAnimatedPrice(item['price'] * item['quantity']),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () => updateQuantity(index, false),
                                          padding: const EdgeInsets.all(4),
                                        ),
                                        SizedBox(
                                          width: 30,
                                          child: Center(
                                            child: _buildAnimatedCounter(item['quantity']),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () => updateQuantity(index, true),
                                          padding: const EdgeInsets.all(4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      CupertinoIcons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => showDeleteConfirmation(context, index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ringkasan Belanja',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('PPN 11%'),
                      _buildAnimatedPrice(ppn),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total belanja'),
                      _buildAnimatedPrice(subtotal),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      _buildAnimatedPrice(total),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle checkout
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}