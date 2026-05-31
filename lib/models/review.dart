class Review {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final int rating;
  final String comment;
  final List<String>? images;
  final DateTime createdAt;
  final int helpful;
  final bool verified;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    this.images,
    required this.createdAt,
    this.helpful = 0,
    this.verified = false,
  });
}
