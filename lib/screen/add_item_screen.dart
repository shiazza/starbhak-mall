import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'insert_screen.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final List<Map<String, dynamic>> items = [
    {
      'name': 'Burger King Medium',
      'price': 50000.00,
      'image': 'assets/burger_icon.jpg',
    },
    {
      'name': 'Teh Botol',
      'price': 4000.00,
      'image': 'assets/drink_icon.jpg',
    },
    {
      'name': 'Burger King Small',
      'price': 35000.00,
      'image': 'assets/burger_icon.jpg',
    },
  ];

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
                setState(() {
                  items.removeAt(index);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const ProductForm()),
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 20),
                  SizedBox(width: 4),
                  Text(
                    'Add Data',
                    style: TextStyle(fontSize: 14, color: Colors.white, ),
                  ),
                ],
              ),
            ),
          ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
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
                          child: Image.asset(
                            item['image'],
                            width: 80,
                            height: 80,
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
                              Text(
                                'Rp ${item['price'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.delete,
                            color: Colors.red,
                          ),
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