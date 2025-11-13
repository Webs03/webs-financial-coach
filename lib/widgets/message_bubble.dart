import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) _buildAIAvatar(),
          if (!message.isUser) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!message.isUser)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 4),
                    child: Text(
                      'Webs Financial Coach',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? Colors.blue[700]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                      bottomRight: Radius.circular(message.isUser ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: message.isUser
                      ? Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                      : MarkdownBody(
                    data: _formatAIText(message.text),
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                      strong: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                      em: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.green,
                      ),
                      listBullet: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      blockquote: TextStyle(
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                        backgroundColor: Colors.grey[100],
                      ),
                      blockquotePadding: const EdgeInsets.all(12),
                      blockquoteDecoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
          if (message.isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildAIAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.blue[700],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'W',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String _formatAIText(String text) {
    // Enhance the text with markdown formatting
    String formatted = text;

    // Add emphasis to key points
    formatted = formatted.replaceAll('💡', '**💡**');
    formatted = formatted.replaceAll('🎯', '**🎯**');
    formatted = formatted.replaceAll('💰', '**💰**');
    formatted = formatted.replaceAll('🏆', '**🏆**');
    formatted = formatted.replaceAll('🛡️', '**🛡️**');
    formatted = formatted.replaceAll('💳', '**💳**');
    formatted = formatted.replaceAll('📊', '**📊**');

    // Format percentages and numbers
    formatted = formatted.replaceAllMapped(
        RegExp(r'(\d+\.?\d*)%'),
            (match) => '**${match.group(1)}%**'
    );

    // Format dollar amounts
    formatted = formatted.replaceAllMapped(
        RegExp(r'\$(\d+(?:,\d{3})*(?:\.\d{2})?)'),
            (match) => '**\$${match.group(1)}**'
    );

    // Format numbered lists
    formatted = formatted.replaceAllMapped(
        RegExp(r'(\d+\))'),
            (match) => '\n\n**${match.group(1)}**'
    );

    return formatted;
  }
}