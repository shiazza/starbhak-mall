import 'package:supabase_flutter/supabase_flutter.dart';

class SessionService {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  // Stream to listen for session changes
  Stream<User?> get authStateChanges => supabaseClient.auth.onAuthStateChange
      .map((data) => data.session?.user);

  // Method to check if the user is logged in
  Future<bool> isLoggedIn() async {
    final session = supabaseClient.auth.currentSession;
    return session != null;
  }

  // Get current user
  User? getCurrentUser() {
    return supabaseClient.auth.currentUser;
  }

  // Login method
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}