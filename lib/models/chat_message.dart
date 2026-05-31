class ChatMessage {
  final String id;
  final String sellerId;
  final String customerId;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool fromSeller;

  ChatMessage({
    required this.id,
    required this.sellerId,
    required this.customerId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.fromSeller,
  });
}
