import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/coupon.dart';
import '../data/products_data.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Product> cartItems;
  final Function(double discount, String couponCode) onOrderComplete;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.onOrderComplete,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'cod';
  String _selectedAddress = 'home';
  final _couponController = TextEditingController();
  double _discount = 0;
  String _appliedCouponCode = '';
  bool _isProcessingPayment = false;

  final Map<String, String> _addresses = {
    'home': '123 Main St, City, State 12345',
    'work': '456 Office Plaza, Downtown, State 54321',
    'other': '789 Alternative Address, Town, State 67890',
  };

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  double get _subtotal => widget.cartItems.fold(
    0.0,
    (sum, item) => sum + (item.price * item.quantity),
  );

  double get _shippingCost => _subtotal > 50 ? 0 : 5.99;

  double get _total => _subtotal - _discount + _shippingCost;

  void _applyCoupon() {
    final couponCode = _couponController.text.trim().toUpperCase();
    final couponIndex = coupons.indexWhere((c) => c.code == couponCode);

    if (couponIndex == -1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid coupon code')));
      return;
    }

    final coupon = coupons[couponIndex];

    if (!coupon.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Coupon is ${coupon.isExpired ? "expired" : "no longer available"}',
          ),
        ),
      );
      return;
    }

    if (_subtotal < (coupon.minPurchase ?? 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Minimum purchase of \$${coupon.minPurchase?.toStringAsFixed(2)} required',
          ),
        ),
      );
      return;
    }

    setState(() {
      _discount = coupon.calculateDiscount(_subtotal);
      _appliedCouponCode = coupon.code;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Coupon applied! You saved \$${_discount.toStringAsFixed(2)}',
        ),
      ),
    );
  }

  void _processPayment() {
    if (_selectedAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }

    setState(() => _isProcessingPayment = true);

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isProcessingPayment = false);

      widget.onOrderComplete(_discount, _appliedCouponCode);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), elevation: 0),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Delivery Address Section
                        _buildSectionTitle('Delivery Address'),
                        Card(
                          child: Column(
                            children: _addresses.entries.map((entry) {
                              return RadioListTile<String>(
                                value: entry.key,
                                groupValue: _selectedAddress,
                                onChanged: (value) {
                                  setState(() => _selectedAddress = value!);
                                },
                                title: Text(
                                  entry.key.toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(entry.value),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Order Items Section
                        _buildSectionTitle('Order Items'),
                        Card(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.cartItems.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              final item = widget.cartItems[index];
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.image,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(item.name),
                                subtitle: Text('Qty: ${item.quantity}'),
                                trailing: Text(
                                  '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Apply Coupon Section
                        _buildSectionTitle('Apply Coupon'),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _couponController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter coupon code',
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _applyCoupon,
                                  child: const Text('Apply'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Payment Method Section
                        _buildSectionTitle('Payment Method'),
                        Card(
                          child: Column(
                            children: [
                              RadioListTile<String>(
                                value: 'cod',
                                groupValue: _selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(
                                    () => _selectedPaymentMethod = value!,
                                  );
                                },
                                title: const Text('Cash on Delivery'),
                                secondary: const Icon(Icons.money),
                              ),
                              RadioListTile<String>(
                                value: 'card',
                                groupValue: _selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(
                                    () => _selectedPaymentMethod = value!,
                                  );
                                },
                                title: const Text('Credit/Debit Card'),
                                secondary: const Icon(Icons.credit_card),
                              ),
                              RadioListTile<String>(
                                value: 'mobile',
                                groupValue: _selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(
                                    () => _selectedPaymentMethod = value!,
                                  );
                                },
                                title: const Text('Mobile Banking'),
                                secondary: const Icon(Icons.phone_android),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Price Summary Section
                        _buildSectionTitle('Price Details'),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildPriceRow('Subtotal', _subtotal),
                                _buildPriceRow('Shipping', _shippingCost),
                                if (_discount > 0)
                                  _buildPriceRow(
                                    'Discount',
                                    -_discount,
                                    color: Colors.green,
                                  ),
                                const Divider(height: 24),
                                _buildPriceRow('Total', _total, isTotal: true),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Place Order Button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isProcessingPayment ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isProcessingPayment
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Place Order - \$${_total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isTotal = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
