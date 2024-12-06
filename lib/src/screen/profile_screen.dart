import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabase = Supabase.instance.client;
  
  // User data
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _avatarUrl;
  
  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      // Assuming current logged-in user's ID can be retrieved
      final userId = _supabase.auth.currentUser?.id;
      
      if (userId == null) {
        throw Exception('No authenticated user found');
      }

      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      // Get avatar URL from Supabase storage
      if (response['avatar'] != null) {
        _avatarUrl = _supabase.storage.from('avatar').getPublicUrl(response['avatar']);
      }

      setState(() {
        _userData = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile: $e')),
      );
    }
  }

  Future<void> _uploadAvatar() async {
    // TODO: Implement image picker and upload logic
    // This is a placeholder for avatar upload functionality
    try {
      // 1. Pick an image from gallery/camera
      // 2. Upload to Supabase storage
      // 3. Update user's avatar field in users table
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avatar upload not implemented yet')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading avatar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
              ? const Center(child: Text('No user data found'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: _avatarUrl != null
                                ? NetworkImage(_avatarUrl!)
                                : const AssetImage('assets/default_avatar.png') as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 10.0,
                                  ),
                                ],
                              ),
                              onPressed: _uploadAvatar,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Username
                      Text(
                        _userData?['username'] ?? 'No Username',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      // Email
                      Text(
                        _userData?['email'] ?? 'No Email',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}