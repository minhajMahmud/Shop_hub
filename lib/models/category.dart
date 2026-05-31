class Category {
  final String id;
  final String name;
  final String? icon;
  final String? image;
  final List<String>? subCategories;
  final bool isActive;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    this.icon,
    this.image,
    this.subCategories,
    this.isActive = true,
    required this.createdAt,
  });

  Category copyWith({
    String? name,
    String? icon,
    String? image,
    List<String>? subCategories,
    bool? isActive,
  }) {
    return Category(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      subCategories: subCategories ?? this.subCategories,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }
}
