import 'package:flutter/material.dart';
import '../models/review.dart';
import '../models/product.dart';

class ReviewsScreen extends StatefulWidget {
  final Product product;
  final Function(Review) onReviewSubmit;

  const ReviewsScreen({
    super.key,
    required this.product,
    required this.onReviewSubmit,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _selectedRating = 5;
  final _commentController = TextEditingController();
  List<Review> reviews = [
    Review(
      id: '1',
      productId: '1',
      userId: 'u1',
      userName: 'John D.',
      rating: 5,
      comment: 'Excellent product! Works perfectly.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      helpful: 45,
      verified: true,
    ),
    Review(
      id: '2',
      productId: '1',
      userId: 'u2',
      userName: 'Sarah M.',
      rating: 4,
      comment: 'Good quality, fast delivery.',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      helpful: 23,
      verified: true,
    ),
  ];

  void _submitReview() {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a comment')));
      return;
    }

    final newReview = Review(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      productId: widget.product.id,
      userId: 'current_user',
      userName: 'You',
      rating: _selectedRating,
      comment: _commentController.text,
      createdAt: DateTime.now(),
      verified: true,
    );

    widget.onReviewSubmit(newReview);
    _commentController.clear();
    setState(() => _selectedRating = 5);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review submitted successfully')),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avgRating = reviews.isEmpty
        ? 0.0
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Reviews & Ratings')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating Summary
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.deepOrange.withOpacity(0.1),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${avgRating.toStringAsFixed(1)}',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            size: 16,
                            color: index < avgRating.toInt()
                                ? Colors.amber[700]
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${reviews.length} reviews',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(5, (index) {
                      final rating = 5 - index;
                      final count = reviews
                          .where((r) => r.rating == rating)
                          .length;
                      return Row(
                        children: [
                          Text(
                            '$rating★',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 80,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: reviews.isEmpty
                                  ? 0
                                  : count / reviews.length,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber[700],
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Write Review
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Share Your Experience',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your Rating',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (index) => GestureDetector(
                        onTap: () =>
                            setState(() => _selectedRating = index + 1),
                        child: Icon(
                          Icons.star,
                          size: 32,
                          color: index < _selectedRating
                              ? Colors.amber[700]
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Share your experience with this product...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitReview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                      ),
                      child: const Text(
                        'Submit Review',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Customer Reviews',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            // Reviews List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
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
                                Row(
                                  children: [
                                    Text(
                                      review.userName,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                    if (review.verified) ...[
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.verified,
                                        size: 14,
                                        color: Colors.green,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (i) => Icon(
                                        Icons.star,
                                        size: 14,
                                        color: i < review.rating
                                            ? Colors.amber[700]
                                            : Colors.grey[300],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${review.createdAt.toString().split(' ')[0]}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          review.comment,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.thumb_up, size: 16),
                              label: Text(
                                'Helpful (${review.helpful})',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
