class Product {
  final String id;
  final String name;
  final String category;
  final String description;
  final double mrp;
  final double price;
  final int discountPercent;
  final String packContent;
  final String safetyType; // Kids Safe, Night Aerial, Day Sound
  final String productType; // For filtering
  final bool isGreenCracker;
  final bool isGiftBox;
  final bool isCombo;
  final double popularity; // For sorting
  final String imageUrl;
  final String safetyInstructions;
  final int soundRating; // 1-5
  final int lightRating; // 1-5

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.mrp,
    required this.price,
    required this.discountPercent,
    required this.packContent,
    required this.safetyType,
    required this.productType,
    required this.isGreenCracker,
    required this.isGiftBox,
    required this.isCombo,
    required this.popularity,
    required this.imageUrl,
    required this.safetyInstructions,
    required this.soundRating,
    required this.lightRating,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}
