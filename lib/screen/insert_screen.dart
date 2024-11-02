import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({Key? key}) : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedCategory = 'Makanan';
  final List<String> _categories = ['Makanan', 'Minuman'];

  void _showCategoryPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        color: CupertinoColors.systemBackground,
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Batal'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Pilih Kategori',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  CupertinoButton(
                    child: const Text('Selesai'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                backgroundColor: CupertinoColors.systemBackground,
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedCategory = _categories[index];
                  });
                },
                children: _categories.map((category) => Text(category)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.red,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
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
                          child: const Text("OK"),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Nama Produk',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Masukan nama produk',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Harga',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukan harga',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _showCategoryPicker,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Text(
                    _selectedCategory,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Image',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Choose file',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}