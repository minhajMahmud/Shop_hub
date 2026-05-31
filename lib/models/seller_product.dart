enum ApprovalStatus { pending, approved, rejected }

class SellerProduct {
  final String id;
  final String sellerId;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int stock;
  final ApprovalStatus approvalStatus;
  final DateTime createdAt;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final bool isActive;
  final int soldCount;

  SellerProduct({
    required this.id,
    required this.sellerId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.stock,
    this.approvalStatus = ApprovalStatus.pending,
    required this.createdAt,
    this.approvedAt,
    this.rejectionReason,
    this.isActive = true,
    this.soldCount = 0,
  });

  SellerProduct copyWith({
    double? price,
    int? stock,
    ApprovalStatus? approvalStatus,
    DateTime? approvedAt,
    String? rejectionReason,
    bool? isActive,
    int? soldCount,
  }) {
    return SellerProduct(
      id: id,
      sellerId: sellerId,
      productId: productId,
      productName: productName,
      productImage: productImage,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      createdAt: createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      isActive: isActive ?? this.isActive,
      soldCount: soldCount ?? this.soldCount,
    );
  }
}
