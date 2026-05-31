class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final int? discount;
  final double rating;
  final int reviews;
  final String image;
  final String category;
  final String brand;
  final bool inStock;
  final bool freeShipping;
  final bool flashSale;
  final bool featured;
  final bool bestSeller;
  final int stock;
  final int soldCount;
  final List<String> specifications;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.discount,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.category,
    required this.brand,
    this.inStock = true,
    this.freeShipping = true,
    this.flashSale = false,
    this.featured = false,
    this.bestSeller = false,
    this.stock = 0,
    this.soldCount = 0,
    this.specifications = const [],
    this.quantity = 1,
  });

  // Copy constructor for modifying quantity
  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      originalPrice: originalPrice,
      discount: discount,
      rating: rating,
      reviews: reviews,
      image: image,
      category: category,
      brand: brand,
      inStock: inStock,
      freeShipping: freeShipping,
      flashSale: flashSale,
      featured: featured,
      bestSeller: bestSeller,
      stock: stock,
      soldCount: soldCount,
      specifications: specifications,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => price * quantity;

  double get discountedPrice {
    if (discount != null) {
      return price * (1 - discount! / 100);
    }
    return price;
  }
}
