import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starbhak_mall/src/screen/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:starbhak_mall/src/start/register_screen.dart';
import 'package:starbhak_mall/services/session_service.dart';
import 'package:starbhak_mall/main.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SessionService _sessionService = SessionService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isObscured = true;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    // Validate input
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog('Please enter both email and password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Attempt login using SessionService
      final response = await _sessionService.login(
        _emailController.text.trim(), 
        _passwordController.text.trim()
      );

      if (response.user != null) {
        Navigator.pushReplacement(
          context, 
          CupertinoPageRoute(builder: (context) => MyHomePage())
        );
      } else {
        _showErrorDialog('Login gagal. Cek ulang email dan password Anda.');
      }
    } catch (error) {
      _showErrorDialog(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Login Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Starbhak Mall',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // Email TextField
                CupertinoTextField(
                  controller: _emailController,
                  placeholder: 'Email',
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(CupertinoIcons.mail, color: CupertinoColors.systemGrey),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),

                // Password TextField
                CupertinoTextField(
                  controller: _passwordController,
                  placeholder: 'Password',
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(CupertinoIcons.lock, color: CupertinoColors.systemGrey),
                  ),
                  obscureText: _isObscured,
                  suffix: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        _isObscured ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                        color: CupertinoColors.systemGrey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 30),

                // Login Button
                _isLoading
                    ? const CupertinoActivityIndicator()
                    : CupertinoButton.filled(
                        onPressed: _handleLogin,
                        child: const Text('Login'),
                      ),
                const SizedBox(height: 20),

                // Sign Up Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
