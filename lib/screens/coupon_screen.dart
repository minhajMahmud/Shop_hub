import 'package:flutter/material.dart';
import '../models/coupon.dart';

class CouponScreen extends StatefulWidget {
  final Function(Coupon) onCouponApply;

  const CouponScreen({super.key, required this.onCouponApply});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  final _couponController = TextEditingController();
  Coupon? _appliedCoupon;

  final List<Coupon> availableCoupons = [
    Coupon(
      code: 'SAVE20',
      description: 'Get 20% off on your first purchase',
      discountPercent: 20,
      maxDiscount: 50,
      minPurchase: 50,
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      usageLimit: 100,
      usedCount: 45,
    ),
    Coupon(
      code: 'FLASH50',
      description: 'Flat 50% off on electronics',
      discountPercent: 50,
      maxDiscount: 200,
      expiryDate: DateTime.now().add(const Duration(days: 7)),
      usageLimit: 50,
      usedCount: 48,
    ),
    Coupon(
      code: 'SHIP10',
      description: 'Free shipping on orders above \$100',
      discountPercent: 10,
      expiryDate: DateTime.now().add(const Duration(days: 60)),
      usageLimit: 500,
      usedCount: 200,
    ),
  ];

  void _applyCoupon() {
    final code = _couponController.text.toUpperCase();
    final coupon = availableCoupons.firstWhere(
      (c) => c.code == code,
      orElse: () => Coupon(
        code: '',
        description: '',
        discountPercent: 0,
        expiryDate: DateTime.now(),
        usageLimit: 0,
      ),
    );

    if (coupon.code.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid coupon code')));
      return;
    }

    if (!coupon.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            coupon.isExpired
                ? 'Coupon has expired'
                : 'Coupon usage limit reached',
          ),
        ),
      );
      return;
    }

    setState(() => _appliedCoupon = coupon);
    widget.onCouponApply(coupon);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Coupon "${coupon.code}" applied!')));
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coupons & Offers')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Apply Coupon Section
            Text(
              'Have a Coupon Code?',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    decoration: InputDecoration(
                      hintText: 'Enter coupon code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _applyCoupon,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            if (_appliedCoupon != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Coupon Applied',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                          ),
                          Text(
                            _appliedCoupon!.code,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),
            Text(
              'Available Offers',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...availableCoupons.map((coupon) {
              final isApplied = _appliedCoupon?.code == coupon.code;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: isApplied ? 4 : 1,
                color: isApplied ? Colors.green.withOpacity(0.05) : null,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${coupon.discountPercent}% OFF',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                coupon.code,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          if (isApplied)
                            const Icon(Icons.check_circle, color: Colors.green),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        coupon.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Valid until: ${coupon.expiryDate.toString().split(' ')[0]}',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                          if (!coupon.isValid)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                coupon.isExpired ? 'Expired' : 'Exhausted',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                      if (coupon.minPurchase != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Min. purchase: \$${coupon.minPurchase}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: coupon.usedCount / coupon.usageLimit,
                        minHeight: 4,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          coupon.isExhausted ? Colors.red : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${coupon.usageLimit - coupon.usedCount} uses left',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
