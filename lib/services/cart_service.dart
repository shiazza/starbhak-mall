import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class CartService {
  final SupabaseClient _supabase;
  static const String _cartBucket = 'cart';

  CartService(this._supabase);

  Future<void> addToCart(
    BuildContext context, 
    String itemId, 
    {bool showNotification = true}
  ) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        _showSnackBar(context, 'Login terlebih dahulu untuk mengecek');
        return;
      }

      final existingCartItemResponse = await _supabase
          .from(_cartBucket)
          .select('*')
          .eq('user_id', userId)
          .eq('item_id', itemId)
          .limit(1)
          .maybeSingle();

      if (existingCartItemResponse != null) {
        await updateCartItemQuantity(
          context, 
          existingCartItemResponse['id'], 
          existingCartItemResponse['qty'] + 1,
          showNotification: showNotification
        );
      } else {
        await _insertCartItem(
          context, 
          userId, 
          itemId, 
          showNotification: showNotification
        );
      }
    } catch (e) {
      _handleCartError(context, e, 'Gagal menambahkan ke keranjang', showNotification);
    }
  }

  Future<void> _insertCartItem(
    BuildContext context, 
    String userId, 
    String itemId, 
    {bool showNotification = true}
  ) async {
    try {
      await _supabase.from(_cartBucket).insert({
        'user_id': userId,
        'item_id': itemId,
        'qty': 1,
      });
      
      if (showNotification) {
        _showSnackBar(context, 'Item ditambahkan ke keranjang');
      }
    } catch (e) {
      _handleCartError(
        context, 
        e, 
        'Gagal menambahkan item ke keranjang', 
        showNotification
      );
    }
  }

  Future<void> updateCartItemQuantity(
    BuildContext context, 
    String cartItemId, 
    int newQuantity,
    {bool showNotification = false}
  ) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        if (showNotification) {
          _showSnackBar(context, 'Login terlebih dahulu');
        }
        return;
      }

      if (newQuantity <= 0) {
        await removeFromCart(
          context, 
          cartItemId, 
          showNotification: showNotification
        );
        return;
      }

      await _updateCartItemQuantity(
        context, 
        cartItemId, 
        newQuantity, 
        showNotification: showNotification
      );
    } catch (e) {
      _handleCartError(
        context, 
        e, 
        'Gagal memperbarui item keranjang', 
        showNotification
      );
    }
  }

  Future<void> _updateCartItemQuantity(
    BuildContext context, 
    String cartItemId, 
    int newQuantity,
    {bool showNotification = false}
  ) async {
    try {
      await _supabase
          .from(_cartBucket)
          .update({'qty': newQuantity})
          .eq('id', cartItemId);
      
      if (showNotification) {
        _showSnackBar(context, 'Keranjang diperbarui');
      }
    } catch (e) {
      _handleCartError(
        context, 
        e, 
        'Gagal memperbarui keranjang', 
        showNotification
      );
    }
  }

  Future<void> removeFromCart(
    BuildContext context, 
    String cartItemId,
    {bool showNotification = false}
  ) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        if (showNotification) {
          _showSnackBar(context, 'Login terlebih dahulu');
        }
        return;
      }

      await _supabase
          .from(_cartBucket)
          .delete()
          .eq('id', cartItemId)
          .eq('user_id', userId);

      if (showNotification) {
        _showSnackBar(context, 'Item dihapus dari keranjang');
      }
    } catch (e) {
      _handleCartError(
        context, 
        e, 
        'Gagal menghapus item dari keranjang', 
        showNotification
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchCartItems() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Pengguna tidak terautentikasi');
      }

      final response = await _supabase
          .from(_cartBucket)
          .select('*, items(id, name, price, media)')
          .eq('user_id', userId);

      return _transformCartItems(response);
    } catch (e) {
      print('Kesalahan mengambil item keranjang: $e');
      rethrow;
    }
  }

  List<Map<String, dynamic>> _transformCartItems(List<dynamic> response) {
    return response.map((cartItem) {
      final item = cartItem['items'] as Map<String, dynamic>;
      return {
        'cart_id': cartItem['id'],
        'item_id': item['id'],
        'name': item['name'],
        'price': item['price'],
        'quantity': cartItem['qty'],
        'image': _supabase.storage.from('items').getPublicUrl(item['media']),
        'total_price': (item['price'] * cartItem['qty']).toDouble(),
      };
    }).toList();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleCartError(
    BuildContext context, 
    dynamic e, 
    String defaultMessage, 
    bool showNotification
  ) {
    print('Kesalahan Keranjang: $e');
    if (showNotification) {
      _showSnackBar(context, defaultMessage);
    }
  }
}
