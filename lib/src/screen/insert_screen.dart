import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:starbhak_mall/models/items_model.dart';
import 'package:starbhak_mall/services/add_service.dart';
import 'dart:io';

class ProductForm extends StatefulWidget {
  final String userId; 
  const ProductForm({super.key, required this.userId}); // Make userId required

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedCategory = 'Makanan';
  final List<String> _categories = ['Makanan', 'Minuman'];
  File? _selectedImage;
  List<TextEditingController> _typeControllers = [TextEditingController()];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

 Future<void> _saveProduct() async {
   final supabaseService = SupabaseService();

   try {
     // Upload gambar terlebih dahulu jika ada
     String? imageUrl;
     if (_selectedImage != null) {
       imageUrl = await supabaseService.uploadImage(_selectedImage!);
       if (imageUrl == null) {
         throw Exception('Gagal mengupload gambar');
       }
     }

     final types = _typeControllers.map((controller) => controller.text).toList();

     final itemData = {
       'name': _nameController.text,
       'description': _descriptionController.text,
       'price': int.parse(_priceController.text),
       'category': _selectedCategory,
       'creator_id': widget.userId,
       'media': imageUrl, // Gunakan URL gambar yang diupload
       'type': types.join(', '),
       'created_at': DateTime.now().toIso8601String(),
     };

     await supabaseService.insertItem(itemData);

     // Clear the form after successful save
     _nameController.clear();
     _descriptionController.clear();
     _priceController.clear();
     _typeControllers.forEach((controller) => controller.clear());
     setState(() {
       _selectedCategory = _categories.first;
       _selectedImage = null;
     });

     // Show a success message or navigate to a different screen
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
         content: Text('Produk berhasil disimpan'),
       ),
     );
   } catch (error) {
     // Handle error
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text('Terjadi kesalahan: $error'),
       ),
     );
   }
 }



  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('Batal'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Pilih Kategori',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    child: const Text('Selesai'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_categories[index]),
                    onTap: () {
                      setState(() {
                        _selectedCategory = _categories[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTypeField() {
    setState(() {
      _typeControllers.add(TextEditingController());
    });
  }

  void _removeTypeField(int index) {
    setState(() {
      if (_typeControllers.length > 1) {
        _typeControllers.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Produk'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: _selectedImage == null
                      ? Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(Icons.add_a_photo, size: 50),
                        )
                      : Image.file(
                          _selectedImage!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 16),
                const Text('Nama Produk'),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Masukan nama produk',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Deskripsi'),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Masukan deskripsi produk',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Harga'),
                const SizedBox(height: 8),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Masukan harga',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Kategori'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _showCategoryPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(_selectedCategory),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Tipe'),
                const SizedBox(height: 8),
                Column(
                  children: List.generate(_typeControllers.length, (index) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _typeControllers[index],
                            decoration: InputDecoration(
                              hintText: 'Masukan tipe produk',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle),
                          onPressed: () => _removeTypeField(index),
                        ),
                      ],
                    );
                  }),
                ),
                TextButton(
                  onPressed: _addTypeField,
                  child: const Text('Tambah Tipe'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProduct,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on PostgrestFilterBuilder {
  execute() {}
}

