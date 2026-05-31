import 'package:flutter/material.dart';
import 'models/user.dart';
import 'models/order.dart';
import 'models/product.dart';
import 'models/address.dart';
import 'models/payment.dart';
import 'models/seller_product.dart';
import 'models/seller_stats.dart';
import 'models/chat_message.dart';
import 'data/products_data.dart';

class AppState extends ChangeNotifier {
  // Authentication
  User? _currentUser;
  bool _isLoggedIn = false;

  // Shopping
  List<Product> _cartItems = [];
  Set<String> _wishlistItems = {};
  List<Order> _userOrders = [];
  List<Address> _userAddresses = [];
  List<Payment> _paymentHistory = [];

  // Seller Management
  List<SellerProduct> _sellerProducts = [];
  SellerStats? _sellerStats;
  List<SellerPayout> _sellerPayouts = [];

  // Chat
  final Map<String, List<ChatMessage>> _chatThreads = {};

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  List<Product> get cartItems => _cartItems;
  Set<String> get wishlistItems => _wishlistItems;
  List<Order> get userOrders => _userOrders;
  List<Address> get userAddresses => _userAddresses;
  List<Payment> get paymentHistory => _paymentHistory;
  List<SellerProduct> get sellerProducts => _sellerProducts;
  SellerStats? get sellerStats => _sellerStats;
  List<SellerPayout> get sellerPayouts => _sellerPayouts;
  List<ChatMessage> getChatMessages(String sellerId, String customerId) {
    final threadKey = _threadKey(sellerId, customerId);
    return _chatThreads[threadKey] ?? [];
  }

  // Auth Methods
  void login(User user) {
    _currentUser = user;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _cartItems = [];
    _wishlistItems = {};
    notifyListeners();
  }

  void updateProfile(String name, String phone, String address) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        phone: phone,
        address: address,
      );
      notifyListeners();
    }
  }

  // Cart Methods
  void addToCart(Product product) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.id == product.id,
    );
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += 1;
    } else {
      product.quantity = 1;
      _cartItems.add(product);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final item = _cartItems.firstWhere((item) => item.id == productId);
    item.quantity = quantity;
    notifyListeners();
  }

  void clearCart() {
    _cartItems = [];
    notifyListeners();
  }

  // Wishlist Methods
  void toggleWishlist(String productId) {
    if (_wishlistItems.contains(productId)) {
      _wishlistItems.remove(productId);
    } else {
      _wishlistItems.add(productId);
    }
    notifyListeners();
  }

  // Order Methods
  void createOrder(
    List<Product> items,
    double discountAmount,
    String couponCode,
  ) {
    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUser?.id ?? '',
      items: items
          .map(
            (p) => OrderItem(
              productId: p.id,
              productName: p.name,
              price: p.price,
              quantity: p.quantity,
              image: p.image,
            ),
          )
          .toList(),
      totalPrice: items.fold(0.0, (sum, p) => sum + (p.price * p.quantity)),
      discount: discountAmount,
      couponCode: couponCode.isEmpty ? null : couponCode,
      createdAt: DateTime.now(),
      status: OrderStatus.pending,
    );
    _userOrders.add(order);
    clearCart();
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final orderIndex = _userOrders.indexWhere((o) => o.id == orderId);
    if (orderIndex >= 0) {
      _userOrders[orderIndex] = _userOrders[orderIndex].copyWith(
        status: status,
      );
      notifyListeners();
    }
  }

  // Address Methods
  void addAddress(Address address) {
    _userAddresses.add(address);
    notifyListeners();
  }

  void updateAddress(String addressId, Address address) {
    final index = _userAddresses.indexWhere((a) => a.id == addressId);
    if (index >= 0) {
      _userAddresses[index] = address;
      notifyListeners();
    }
  }

  void deleteAddress(String addressId) {
    _userAddresses.removeWhere((a) => a.id == addressId);
    notifyListeners();
  }

  void setDefaultAddress(String addressId) {
    for (var addr in _userAddresses) {
      addr = addr.copyWith(isDefault: addr.id == addressId);
    }
    notifyListeners();
  }

  // Payment Methods
  void addPayment(Payment payment) {
    _paymentHistory.add(payment);
    notifyListeners();
  }

  // Seller Methods
  void addSellerProduct(SellerProduct product) {
    _sellerProducts.add(product);
    notifyListeners();
  }

  void updateSellerProduct(String productId, SellerProduct product) {
    final index = _sellerProducts.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      _sellerProducts[index] = product;
      notifyListeners();
    }
  }

  void deleteSellerProduct(String productId) {
    _sellerProducts.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  void approveSellerProduct(String productId) {
    final index = _sellerProducts.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      _sellerProducts[index] = _sellerProducts[index].copyWith(
        approvalStatus: ApprovalStatus.approved,
        approvedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void rejectSellerProduct(String productId, String reason) {
    final index = _sellerProducts.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      _sellerProducts[index] = _sellerProducts[index].copyWith(
        approvalStatus: ApprovalStatus.rejected,
        rejectionReason: reason,
      );
      notifyListeners();
    }
  }

  void updateSellerStats(SellerStats stats) {
    _sellerStats = stats;
    notifyListeners();
  }

  void addSellerPayout(SellerPayout payout) {
    _sellerPayouts.add(payout);
    notifyListeners();
  }

  // Chat Methods
  void sendChatMessage({
    required String sellerId,
    required String customerId,
    required String text,
    required bool fromSeller,
    String? senderName,
    String? senderId,
  }) {
    if (_currentUser == null && senderName == null) return;

    final threadKey = _threadKey(sellerId, customerId);
    final message = ChatMessage(
      id: 'msg-${DateTime.now().microsecondsSinceEpoch}',
      sellerId: sellerId,
      customerId: customerId,
      senderId:
          senderId ?? _currentUser?.id ?? (fromSeller ? sellerId : customerId),
      senderName: senderName ?? _currentUser?.name ?? 'You',
      text: text,
      timestamp: DateTime.now(),
      fromSeller: fromSeller,
    );

    _chatThreads.putIfAbsent(threadKey, () => []);
    _chatThreads[threadKey]!.add(message);
    notifyListeners();
  }

  String _threadKey(String sellerId, String customerId) =>
      'thread_${sellerId}_$customerId';

  // Get products by category
  List<Product> getProductsByCategory(String categoryId) {
    if (categoryId == 'all') {
      return products;
    }
    return products.where((p) => p.category == categoryId).toList();
  }

  // Search products
  List<Product> searchProducts(String query) {
    return products
        .where(
          (p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.brand.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
