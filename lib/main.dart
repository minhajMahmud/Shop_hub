import 'package:flutter/material.dart';
import 'app_state.dart';
import 'models/user.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/admin_panel_screen.dart';
import 'screens/seller_dashboard_screen.dart';
import 'screens/customer_dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopHub - E-Commerce',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late AppState appState;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    appState = AppState();
  }

  void handleLogin(User user) {
    setState(() {
      appState.login(user);
      isLoggedIn = true;
    });
  }

  void handleLogout() {
    setState(() {
      appState.logout();
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return MainApp(appState: appState, onLogout: handleLogout);
    }
    return LoginScreen(onLoginSuccess: handleLogin);
  }
}

class MainApp extends StatefulWidget {
  final AppState appState;
  final VoidCallback onLogout;

  const MainApp({required this.appState, required this.onLogout, super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Route to role-specific dashboard
    final user = widget.appState.currentUser;
    if (user != null) {
      if (user.role == UserRole.admin) {
        return AdminDashboardScreen(appState: widget.appState);
      } else if (user.role == UserRole.seller) {
        return SellerDashboardScreen(appState: widget.appState);
      } else if (user.role == UserRole.customer) {
        return CustomerDashboardScreen(
          appState: widget.appState,
          onLogout: widget.onLogout,
        );
      }
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(
            onAddToCart: (product) {
              setState(() {
                widget.appState.addToCart(product);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${product.name} added to cart')),
              );
            },
            onToggleWishlist: (productId) {
              setState(() {
                widget.appState.toggleWishlist(productId);
              });
            },
            wishlistItems: widget.appState.wishlistItems,
            cartItems: widget.appState.cartItems,
          ),
          CartScreen(
            cartItems: widget.appState.cartItems,
            onRemoveFromCart: (productId) {
              setState(() {
                widget.appState.removeFromCart(productId);
              });
            },
            onUpdateQuantity: (productId, quantity) {
              setState(() {
                widget.appState.updateQuantity(productId, quantity);
              });
            },
            onOrderComplete: (discount, couponCode) {
              setState(() {
                widget.appState.createOrder(
                  widget.appState.cartItems,
                  discount,
                  couponCode,
                );
              });
            },
          ),
          WishlistScreen(
            wishlistItems: widget.appState.wishlistItems,
            onToggleWishlist: (productId) {
              setState(() {
                widget.appState.toggleWishlist(productId);
              });
            },
            onAddToCart: (product) {
              setState(() {
                widget.appState.addToCart(product);
              });
            },
          ),
          if (widget.appState.currentUser != null)
            ProfileScreen(
              user: widget.appState.currentUser!,
              onProfileUpdate: (updatedUser) {
                setState(() {
                  widget.appState.updateProfile(
                    updatedUser.name,
                    updatedUser.phone,
                    updatedUser.address ?? '',
                  );
                });
              },
              onLogout: widget.onLogout,
              appState: widget.appState,
            )
          else
            const Scaffold(body: Center(child: Text('Please login first'))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        elevation: 10,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Shop'),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('${widget.appState.cartItems.length}'),
              isLabelVisible: widget.appState.cartItems.isNotEmpty,
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('${widget.appState.wishlistItems.length}'),
              isLabelVisible: widget.appState.wishlistItems.isNotEmpty,
              child: const Icon(Icons.favorite),
            ),
            label: 'Wishlist',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
