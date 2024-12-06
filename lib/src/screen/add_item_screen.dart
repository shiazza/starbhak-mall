import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'insert_screen.dart';
import 'package:starbhak_mall/services/add_service.dart';
import 'package:intl/intl.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final List<Map<String, dynamic>> items = [];
  final supabase = Supabase.instance.client;
  final SupabaseService _supabaseService = SupabaseService();
  String? userId;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    fetchItems();
  }

  void _getCurrentUser() {
  final currentUser = supabase.auth.currentUser;
  if (currentUser != null) {
    userId = currentUser.id;
  } else {
    userId = null;
    debugPrint('No current user found');
  }
}

  String formatCurrency(double price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  
  Future<void> fetchItems() async {
    if (userId == null) {
      debugPrint('User not logged in');
      return;
    }

    

  try {
    final fetchedItems = await _supabaseService.fetchItems(userId!);
    setState(() {
      items.clear();
      items.addAll(fetchedItems);
    });
  } catch (error) {
    debugPrint('Error fetching items: $error');
  }
}

  
Future<void> deleteItem(int index) async {
  try {
    final id = items[index]['id'];
    await _supabaseService.deleteItem(id);
    setState(() {
      items.removeAt(index);
    });
  } catch (error) {
    debugPrint('Error deleting item: $error');
  }
}

  
  void showDeleteConfirmation(BuildContext context, int index) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: Text(
            "Apakah Anda yakin ingin menghapus ${items[index]['name']}?",
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
                deleteItem(index);
                Navigator.pop(context);
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.red),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                
                if (userId == null) {
                  
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text("Not Logged In"),
                        content: const Text("Please log in first to add items."),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ProductForm(userId: userId!),
                  ),
                ).then((_) => fetchItems()); 
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 20),
                  SizedBox(width: 4),
                  Text('Add Data', style: TextStyle(fontSize: 14, color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item['image'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/placeholder.png', width: 80, height: 80);
                                  },
                                ),

                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'] ?? 'Unknown Item',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    
                                    Text(
                                      formatCurrency(item['price']),
                                      style: const TextStyle(color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                              
                              IconButton(
                                icon: const Icon(CupertinoIcons.delete, color: Colors.red),
                                onPressed: () => showDeleteConfirmation(context, index),
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
    );
  }
}
