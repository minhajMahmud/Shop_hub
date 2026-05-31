import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../app_state.dart';
import 'chat_screen.dart';

class SellerDashboardScreen extends StatefulWidget {
  final AppState appState;

  const SellerDashboardScreen({required this.appState, super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  int _selectedTab = 0;

  // Mock seller products
  final List<Product> _sellerProducts = [];

  // Mock seller orders
  final List<Order> _sellerOrders = [
    Order(
      id: 'ORD-101',
      userId: 'user-001',
      items: [],
      totalPrice: 599.99,
      discount: 0,
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      address: '123 Main St, New York, NY 10001',
    ),
    Order(
      id: 'ORD-102',
      userId: 'user-002',
      items: [],
      totalPrice: 299.99,
      discount: 0,
      status: OrderStatus.confirmed,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      address: '456 Oak Ave, Los Angeles, CA 90001',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      ChatScreen(appState: widget.appState, isSellerView: true),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards with Gradient Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange, Colors.deepOrange.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Store Analytics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatCard(
                      title: 'Products',
                      value: '${_sellerProducts.length}',
                      icon: Icons.inventory_2,
                      color: Colors.blue,
                    ),
                    _StatCard(
                      title: 'Orders',
                      value: '${_sellerOrders.length}',
                      icon: Icons.shopping_bag,
                      color: Colors.green,
                    ),
                    _StatCard(
                      title: 'Revenue',
                      value: '\$${_calculateRevenue()}',
                      icon: Icons.monetization_on,
                      color: Colors.amber,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Enhanced Tabs
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildTab('Orders', Icons.receipt_long, 0),
                _buildTab('Products', Icons.inventory_2, 1),
                _buildTab('Analytics', Icons.analytics, 2),
              ],
            ),
          ),

          // Content
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _buildOrdersTab(),
                _buildProductsTab(),
                _buildAnalyticsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedTab == 1
          ? FloatingActionButton.extended(
              onPressed: _addProduct,
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
              backgroundColor: Colors.deepOrange,
            )
          : null,
    );
  }

  Widget _buildTab(String label, IconData icon, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.deepOrange : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.deepOrange : Colors.grey,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.deepOrange : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateRevenue() {
    return _sellerOrders
        .where(
          (o) =>
              o.status == OrderStatus.delivered ||
              o.status == OrderStatus.shipped,
        )
        .fold(0.0, (sum, order) => sum + order.totalPrice);
  }

  Widget _buildOrdersTab() {
    if (_sellerOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No orders yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sellerOrders.length,
      itemBuilder: (context, index) {
        final order = _sellerOrders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => _showOrderDetails(order),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: _getStatusColor(order.status),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order ${order.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatDate(order.createdAt)} • \$${order.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status.toString().split('.').last.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductsTab() {
    if (_sellerProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('No products added'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _addProduct,
              child: const Text('Add First Product'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _sellerProducts.length,
      itemBuilder: (context, index) {
        final product = _sellerProducts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(product.name),
            subtitle: Text(
              '\$${product.price.toStringAsFixed(2)} • Stock: ${product.stock}',
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _editProduct(product);
                } else if (value == 'delete') {
                  _deleteProduct(product.id);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsTab() {
    final totalRevenue = _calculateRevenue();
    final pendingOrders = _sellerOrders
        .where((o) => o.status == OrderStatus.pending)
        .length;
    final completedOrders = _sellerOrders
        .where((o) => o.status == OrderStatus.delivered)
        .length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Sales Overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _AnalyticsCard(
          title: 'Total Revenue',
          value: '\$${totalRevenue.toStringAsFixed(2)}',
          icon: Icons.attach_money,
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _AnalyticsCard(
          title: 'Pending Orders',
          value: '$pendingOrders',
          icon: Icons.pending_actions,
          color: Colors.orange,
        ),
        const SizedBox(height: 12),
        _AnalyticsCard(
          title: 'Completed Orders',
          value: '$completedOrders',
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        const SizedBox(height: 24),
        const Text(
          'Best Selling Products',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'No sales data yet',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.returned:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Order ${order.id}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Customer: ${order.userId}'),
            Text('Amount: \$${order.totalPrice.toStringAsFixed(2)}'),
            Text('Status: ${order.status.toString().split('.').last}'),
            const SizedBox(height: 16),
            Text('Shipping Address:\n${order.address}'),
            const SizedBox(height: 24),
            Row(
              children: [
                if (order.status == OrderStatus.pending)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Confirm order logic
                        Navigator.pop(context);
                      },
                      child: const Text('Confirm Order'),
                    ),
                  ),
                if (order.status == OrderStatus.confirmed) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Ship order logic
                        Navigator.pop(context);
                      },
                      child: const Text('Mark as Shipped'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addProduct() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add product feature coming soon')),
    );
  }

  void _editProduct(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit product feature coming soon')),
    );
  }

  void _deleteProduct(String productId) {
    setState(() {
      _sellerProducts.removeWhere((p) => p.id == productId);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Product deleted')));
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _AnalyticsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.8), color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
