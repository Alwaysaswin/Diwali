import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://crackers-2-qw2e.onrender.com/api';

  static Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      }
      throw Exception('Failed to load categories');
    } catch (e) {
      throw Exception('API error: $e');
    }
  }

  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => _ProductApiMapper.fromApiJson(json)).toList();
      }
      throw Exception('Failed to load products');
    } catch (e) {
      throw Exception('API error: $e');
    }
  }

  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      throw Exception('Failed to create order');
    } catch (e) {
      throw Exception('API error: $e');
    }
  }
}

class Category {
  final String id;
  final String name;
  final String icon;
  final int displayOrder;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.displayOrder,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      displayOrder: json['displayOrder'] ?? 0,
    );
  }
}

class _ProductApiMapper {
  static Product fromApiJson(Map<String, dynamic> json) {
    final mrp = (json['mrp'] ?? 0).toDouble();
    final price = (json['price'] ?? 0).toDouble();
    final discountPercent = json['discountPercent'] ?? 
        ((mrp > 0) ? ((mrp - price) / mrp * 100).round() : 0);

    String safetyType = 'Kids Safe';
    if (json['soundRating'] != null && json['soundRating'] >= 4) {
      safetyType = json['type'] == 'aerial' || json['type'] == 'rocket' 
          ? 'Night Aerial' 
          : 'Day Sound';
    }

    return Product(
      id: json['sku']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'General',
      description: json['description'] ?? json['safetyTips'] ?? '',
      mrp: mrp,
      price: price,
      discountPercent: discountPercent.toInt(),
      packContent: json['packDetails'] ?? json['packContent'] ?? '',
      safetyType: safetyType,
      productType: json['type'] ?? '',
      isGreenCracker: json['isGreenCracker'] ?? false,
      isGiftBox: json['category']?.toString().toLowerCase().contains('gift') ?? false,
      isCombo: json['category']?.toString().toLowerCase().contains('combo') ?? false,
      popularity: json['isPopular'] == true ? 5.0 : 3.0,
      imageUrl: json['imageUrl'] ?? '',
      safetyInstructions: json['safetyTips'] ?? 'Use with adult supervision. Follow safety guidelines.',
      soundRating: json['soundRating'] ?? 1,
      lightRating: json['lightRating'] ?? 1,
    );
  }
}
