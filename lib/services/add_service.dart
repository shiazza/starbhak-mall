import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  
  Future<String?> uploadImage(File imageFile) async {
    try {
      
      final user = _supabase.auth.currentUser;
      
      
      if (user == null) {
        print('User belum login');
        return null;
      }

      
      final String fileName = '${user.id}/${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      
      
      final response = await _supabase.storage
          .from('items')
          .upload(
            fileName, 
            imageFile,
            fileOptions: FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      
      return fileName;
    } on StorageException catch (e) {
      print('Storage Upload Error: ${e.message}');
      print('Status Code: ${e.statusCode}');
      return null;
    } catch (e) {
      print('General Upload Error: $e');
      return null;
    }
  }

  
  String getImageUrl(String? fileName) {
    if (fileName == null || fileName.isEmpty) {
      return 'assets/placeholder.png';
    }
    return _supabase.storage.from('items').getPublicUrl(fileName);
  }

  
  Future<bool> insertItem(Map<String, dynamic> itemData) async {
    
    final user = _supabase.auth.currentUser;
    
    
    if (user == null) {
      print('User harus login untuk menambah item');
      return false;
    }

    try {
      final response = await _supabase
          .from('items')
          .insert({
            ...itemData,
            'creator_id': user.id, 
          });
      return true;
    } on PostgrestException catch (e) {
      print('Insert Error: ${e.toString()}');
      return false;
    } catch (e) {
      print('General Insert Error: $e');
      return false;
    }
  }

  
  Future<List<Map<String, dynamic>>> fetchItems(String userId) async {
    try {
      final response = await _supabase
          .from('items')
          .select()
          .eq('creator_id', userId)
          .order('created_at', ascending: false);

      return response.map((item) => {
        'id': item['id'],
        'name': item['name'],
        'price': item['price'],
        'image': getImageUrl(item['media']),
        'category': item['category'],
        'description': item['description'],
      }).toList();
    } on PostgrestException catch (e) {
      print('Fetch Error: ${e.toString()}');
      return [];
    } catch (e) {
      print('General Fetch Error: $e');
      return [];
    }
  }

  
  Future<bool> deleteItem(String itemId) async {
    
    final user = _supabase.auth.currentUser;
    
    
    if (user == null) {
      print('User harus login untuk menghapus item');
      return false;
    }

    try {
      
      await _supabase
          .from('items')
          .delete()
          .eq('id', itemId)
          .eq('creator_id', user.id);

      return true;
    } on PostgrestException catch (e) {
      print('Delete Error: ${e.toString()}');
      return false;
    } catch (e) {
      print('General Delete Error: $e');
      return false;
    }
  }

  
  Future<bool> updateItem(String itemId, Map<String, dynamic> updateData) async {
    
    final user = _supabase.auth.currentUser;
    
    
    if (user == null) {
      print('User harus login untuk mengupdate item');
      return false;
    }

    try {
      await _supabase
          .from('items')
          .update(updateData)
          .eq('id', itemId)
          .eq('creator_id', user.id);
      return true;
    } on PostgrestException catch (e) {
      print('Update Error: ${e.toString()}');
      return false;
    } catch (e) {
      print('General Update Error: $e');
      return false;
    }
  }

  
  Future<bool> deleteImageFromStorage(String? fileName) async {
    if (fileName == null || fileName.isEmpty) {
      return false;
    }

    try {
      await _supabase.storage
          .from('items')
          .remove([fileName]);
      return true;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }
}


class ExampleUsage {
  final SupabaseService _supabaseService = SupabaseService();

  
  Future<void> createItem(File imageFile) async {
    
    final String? fileName = await _supabaseService.uploadImage(imageFile);
    
    if (fileName != null) {
      
      final bool success = await _supabaseService.insertItem({
        'name': 'Nama Item',
        'price': 100000,
        'media': fileName, 
        'category': 'Kategori',
        'description': 'Deskripsi item',
      });
    }
  }
  }
