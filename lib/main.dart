import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
import 'screen/cart_screen.dart';
import 'screen/add_item_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder( 
          builder: (BuildContext context) {
            return Container(
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
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); 
                },
              ),
            );
          },
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
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: const Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.blue,
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  height: 5, 
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.shopping_cart),
              title: const Text('Cart'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.post_add_rounded),
              title: const Text('Add Item'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const AddItemScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const HomeScreen(),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.3),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(CupertinoIcons.home, 0),
            _buildNavItem(CupertinoIcons.shopping_cart, 1),
            _buildNavItem(Icons.post_add_rounded, 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (_currentIndex == index) {
            // Do nothing if the selected index is already active
            return;
          }
          if (index == 0) {
            // Stay on Home screen (no routing)
            setState(() {
              _currentIndex = index;
            });
          } else if (index == 1) {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const CartScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const AddItemScreen()),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color.fromARGB(255, 55, 72, 228) : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
