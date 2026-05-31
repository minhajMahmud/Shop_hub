import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  final AppState appState;
  final bool isSellerView;

  const ChatScreen({
    super.key,
    required this.appState,
    this.isSellerView = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String _selectedContactId;
  late String _selectedContactName;
  final TextEditingController _controller = TextEditingController();
  late final VoidCallback _listener;

  final List<Map<String, String>> _sellers = const [
    {'id': 'seller-001', 'name': 'Tech Gear Store'},
    {'id': 'seller-002', 'name': 'Home Living Shop'},
    {'id': 'seller-003', 'name': 'Fashion Hub'},
  ];

  final List<Map<String, String>> _customers = const [
    {'id': 'cust-101', 'name': 'Alice Johnson'},
    {'id': 'cust-102', 'name': 'Michael Chen'},
    {'id': 'cust-103', 'name': 'Sara Lee'},
  ];

  @override
  void initState() {
    super.initState();
    final contacts = widget.isSellerView ? _customers : _sellers;
    _selectedContactId = contacts.first['id']!;
    _selectedContactName = contacts.first['name']!;
    _listener = () => setState(() {});
    widget.appState.addListener(_listener);
  }

  @override
  void dispose() {
    widget.appState.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.appState.currentUser;
    final isSellerView = widget.isSellerView;
    final sellerId = isSellerView
        ? (currentUser?.id ?? 'seller-001')
        : _selectedContactId;
    final customerId = isSellerView
        ? _selectedContactId
        : (currentUser?.id ?? 'customer-guest');
    final List<ChatMessage> messages = widget.appState.getChatMessages(
      sellerId,
      customerId,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(isSellerView ? 'Chat with customers' : 'Chat with sellers'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildContactChips(),
          const Divider(height: 1),
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Text(
                      'Say hi to start the conversation',
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = isSellerView
                          ? msg.fromSeller
                          : !msg.fromSeller;
                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.deepOrange.shade50
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isMe
                                  ? Colors.deepOrange.shade200
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg.senderName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(msg.text),
                              const SizedBox(height: 6),
                              Text(
                                _formatTime(msg.timestamp),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          _buildComposer(sellerId: sellerId, customerId: customerId),
        ],
      ),
    );
  }

  Widget _buildContactChips() {
    final contacts = widget.isSellerView ? _customers : _sellers;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: contacts
            .map(
              (c) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  selected: _selectedContactId == c['id'],
                  label: Text(c['name']!),
                  onSelected: (_) {
                    setState(() {
                      _selectedContactId = c['id']!;
                      _selectedContactName = c['name']!;
                    });
                  },
                  selectedColor: Colors.deepOrange.shade50,
                  labelStyle: TextStyle(
                    color: _selectedContactId == c['id']
                        ? Colors.deepOrange
                        : Colors.black87,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildComposer({
    required String sellerId,
    required String customerId,
  }) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: widget.isSellerView
                      ? 'Reply to customer...'
                      : 'Message seller...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.deepOrange,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () => _sendMessage(sellerId, customerId),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String sellerId, String customerId) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.appState.sendChatMessage(
      sellerId: sellerId,
      customerId: customerId,
      text: text,
      fromSeller: widget.isSellerView,
    );

    _controller.clear();

    // Simple auto-response for demo to show both sides of the chat.
    Future.delayed(const Duration(milliseconds: 500), () {
      final replyText = widget.isSellerView
          ? 'Customer received your message.'
          : 'Seller ${_selectedContactName.split(' ').first} is reviewing your request.';
      widget.appState.sendChatMessage(
        sellerId: sellerId,
        customerId: customerId,
        text: replyText,
        fromSeller: !widget.isSellerView,
        senderName: widget.isSellerView
            ? _selectedContactName
            : _selectedContactName,
        senderId: widget.isSellerView ? _selectedContactId : sellerId,
      );
    });
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}
