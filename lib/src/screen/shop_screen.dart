
import 'package:flutter/material.dart';

// Model untuk mewakili barang yang dijual
class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.name, 
    required this.price, 
    required this.imageUrl
  });
}

class SellerProfilePage extends StatelessWidget {
  // Data profil penjual contoh
  final String sellerName = "Budi Santoso";
  final String profileImageUrl = "https://example.com/profile.jpg";
  
  // Daftar produk penjual
  final List<Product> products = [
    Product(
      name: "Sepatu Olahraga", 
      price: 250000, 
      imageUrl: "https://example.com/sepatu.jpg"
    ),
    Product(
      name: "Jaket Kulit", 
      price: 500000, 
      imageUrl: "https://example.com/jaket.jpg"
    ),
    Product(
      name: "Tas Ransel", 
      price: 175000, 
      imageUrl: "https://example.com/tas.jpg"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Penjual'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Profil
            _buildProfileHeader(),
            
            // Bagian Daftar Produk
            _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          // Foto Profil
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(profileImageUrl),
          ),
          SizedBox(width: 20),
          
          // Nama Penjual
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sellerName, 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'Penjual Aktif', 
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              'Produk Dijual', 
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildProductCard(products[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk
          AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              product.imageUrl, 
              fit: BoxFit.cover,
            ),
          ),
          
          // Informasi Produk
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Rp ${product.price.toStringAsFixed(0)}', 
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SellerProfilePage(),
  ));
}