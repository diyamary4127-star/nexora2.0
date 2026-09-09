/// Chat message model for peer-to-peer conversations
class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String recipientId;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.recipientId,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? recipientId,
    String? text,
    DateTime? timestamp,
    bool? isMe,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      recipientId: recipientId ?? this.recipientId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isMe: isMe ?? this.isMe,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'recipientId': recipientId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isMe': isMe,
    };
  }
}
