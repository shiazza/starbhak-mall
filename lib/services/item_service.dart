// item_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class ItemService {
  final SupabaseClient _supabase;

  ItemService(this._supabase);

  Future<List<Map<String, dynamic>>> fetchItems() async {
    try {
      // Fetch all items from Supabase
      final response = await _supabase
          .from('items')
          .select('*')
          .order('created_at', ascending: false);

      return response.map((item) => {
        'id': item['id'],
        'name': item['name'],
        'price': item['price'],
        'image': item['media'] != null
            ? _supabase.storage.from('items').getPublicUrl(item['media'])
            : 'assets/placeholder.png', // Fallback image
        'category': item['category'],
        'description': item['description'],
      }).toList();
    } catch (e) {
      print('Error fetching items: $e');
      throw Exception('Failed to load items');
    }
  }
}
