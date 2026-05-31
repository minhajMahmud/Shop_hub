import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/products_data.dart';
import '../widgets/product_card.dart';
import '../widgets/category_bar.dart';
import '../widgets/hero_banner.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(Product) onAddToCart;
  final Function(String) onToggleWishlist;
  final Set<String> wishlistItems;
  final List<Product> cartItems;

  const HomeScreen({
    super.key,
    required this.onAddToCart,
    required this.onToggleWishlist,
    required this.wishlistItems,
    required this.cartItems,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Product> filteredProducts;
  String selectedCategory = 'all';
  String searchQuery = '';
  String sortBy = 'featured';

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(products);
  }

  void _filterAndSort() {
    filteredProducts = List.from(products);

    // Category filter
    if (selectedCategory != 'all') {
      filteredProducts = filteredProducts
          .where((p) => p.category == selectedCategory)
          .toList();
    }

    // Search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filteredProducts = filteredProducts
          .where(
            (p) =>
                p.name.toLowerCase().contains(query) ||
                p.brand.toLowerCase().contains(query),
          )
          .toList();
    }

    // Sorting
    switch (sortBy) {
      case 'price-low':
        filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price-high':
        filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'popular':
        filteredProducts.sort((a, b) => b.reviews.compareTo(a.reviews));
        break;
      default:
        // Featured sorting
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _filterAndSort();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            elevation: 1,
            title: Text(
              'ShopHub',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Open search
                },
              ),
            ],
          ),
          SliverToBoxAdapter(child: HeroBanner()),
          SliverToBoxAdapter(
            child: CategoryBar(
              categories: categories,
              selectedCategory: selectedCategory,
              onSelectCategory: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Products (${filteredProducts.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  DropdownButton<String>(
                    value: sortBy,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          sortBy = value;
                        });
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'featured',
                        child: Text('Featured'),
                      ),
                      DropdownMenuItem(
                        value: 'price-low',
                        child: Text('Price: Low to High'),
                      ),
                      DropdownMenuItem(
                        value: 'price-high',
                        child: Text('Price: High to Low'),
                      ),
                      DropdownMenuItem(
                        value: 'rating',
                        child: Text('Highest Rated'),
                      ),
                      DropdownMenuItem(
                        value: 'popular',
                        child: Text('Most Popular'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = filteredProducts[index];
                return ProductCard(
                  product: product,
                  isWishlisted: widget.wishlistItems.contains(product.id),
                  onAddToCart: () {
                    widget.onAddToCart(product);
                  },
                  onToggleWishlist: () {
                    widget.onToggleWishlist(product.id);
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          product: product,
                          isInWishlist: widget.wishlistItems.contains(
                            product.id,
                          ),
                          onAddToCart: widget.onAddToCart,
                          onToggleWishlist: widget.onToggleWishlist,
                        ),
                      ),
                    );
                  },
                );
              }, childCount: filteredProducts.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
