import 'dart:async'; 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/screen/home_screen.dart';
import 'src/screen/cart_screen.dart';
import 'src/screen/add_item_screen.dart';
import 'src/start/login_screen.dart'; 
import 'core/api/supabase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl, 
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthWrapper(), 
      debugShowCheckedModeBanner: false,
    );
  }
}

// New AuthWrapper to handle authentication state
class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late final StreamSubscription<AuthState> _authSubscription;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    // Check initial authentication state
    _checkAuthStatus();

    // Listen for authentication state changes
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      setState(() {
        _isAuthenticated = data.session != null;
      });
    });
  }

  void _checkAuthStatus() {
    final session = Supabase.instance.client.auth.currentSession;
    setState(() {
      _isAuthenticated = session != null;
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If not authenticated, show login screen
    return _isAuthenticated ? MyHomePage() : LoginScreen();
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
      body: const HomeScreen(), // Only displays HomeScreen
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