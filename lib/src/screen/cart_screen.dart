import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:starbhak_mall/services/cart_service.dart';
import 'package:starbhak_mall/services/session_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _supabase = Supabase.instance.client;
  final SessionService _sessionService = SessionService();
  late CartService _cartService;
  
  List<Map<String, dynamic>> cartItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _cartService = CartService(_supabase);
    _fetchCartItems();
  }

  String formatCurrency(double price) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatter.format(price);
}

  Future<void> _fetchCartItems() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final items = await _cartService.fetchCartItems();
      
      setState(() {
        cartItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        cartItems = [];
        _errorMessage = 'Gagal memuat keranjang: $e';
      });
    }
  }

  void _updateQuantity(int index, bool increase) async {
    try {
      final item = cartItems[index];
      int newQuantity = increase ? item['quantity'] + 1 : item['quantity'] - 1;

      if (newQuantity < 1) {
        _showDeleteConfirmation(context, index);
        return;
      }

      await _cartService.updateCartItemQuantity(
        context, 
        item['cart_id'], 
        newQuantity
      );

      await _fetchCartItems();
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mengubah jumlah: $e';
      });
    }
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
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
              onPressed: () => Navigator.pop(context),
              isDestructiveAction: true,
              child: const Text("Batal"),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                try {
                  await _cartService.removeFromCart(
                    context, 
                    cartItems[index]['cart_id']
                  );
                  
                  await _fetchCartItems();
                  Navigator.pop(context);
                } catch (e) {
                  setState(() {
                    _errorMessage = 'Gagal menghapus item: $e';
                  });
                }
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  double _calculateSubtotal() {
    return cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  void _handleCheckout() async {
    try {
      if (cartItems.isEmpty) {
        setState(() {
          _errorMessage = 'Keranjang Anda kosong';
        });
        return;
      }

      // TODO: Implement full checkout process
      // 1. Validate cart items
      // 2. Create order
      // 3. Process payment
      // 4. Clear cart
      
      // Tampilkan dialog sukses checkout
      _showCheckoutSuccessDialog();
    } catch (e) {
      setState(() {
        _errorMessage = 'Checkout gagal: $e';
      });
    }
  }

  void _showCheckoutSuccessDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Checkout Berhasil"),
          content: const Text("Terima kasih telah melakukan pembelian."),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _fetchCartItems(); // Refresh keranjang
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = _calculateSubtotal();
    final ppn = subtotal * 0.11;
    final total = subtotal + ppn;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Keranjang')),
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
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Column(
        children: [
          // Tampilkan pesan error jika ada
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.red.shade100,
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red.shade800),
                textAlign: TextAlign.center,
              ),
            ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: _isLoading 
                      ? _buildShimmerLoadingList() 
                      : (cartItems.isEmpty
                          ? const Center(
                              child: Text(
                                'Keranjang Anda kosong',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final item = cartItems[index];
                                return _buildCartItemCard(context, item, index);
                              },
                            )
                        ),
                  ),
                  _buildCheckoutSummary(subtotal, ppn, total),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoadingList() {
    return ListView.builder(
      itemCount: 3, // Jumlah item shimmer
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Shimmer untuk gambar
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.white,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shimmer untuk nama item
                      Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      // Shimmer untuk harga
                      Container(
                        width: 100,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      // Shimmer untuk kontrol kuantitas
                      Row(
                        children: [
                          Container(
                            width: 120,
                            height: 40,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartItemCard(BuildContext context, Map<String, dynamic> item, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item['image'],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
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
                Text(
                   formatCurrency(item['price'] * item['quantity']),
                  style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
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
                          onPressed: () => _updateQuantity(index, false),
                          padding: const EdgeInsets.all(4),
                        ),
                        SizedBox(
                          width: 30,
                          child: Center(
                            child: Text(
                              '${item['quantity']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _updateQuantity(index, true),
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
                    onPressed: () => _showDeleteConfirmation(context, index),
                  ),
                ],
              ),
            ],
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSummary(double subtotal, double ppn, double total) {
    return Container(
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
                  Text(formatCurrency(ppn)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total belanja'),
              Text(formatCurrency(subtotal)),
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
              Text(formatCurrency(total)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: cartItems.isEmpty 
                ? null 
                : _handleCheckout,
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
    );
  }
}
