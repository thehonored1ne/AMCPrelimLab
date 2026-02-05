import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/services/voice_service.dart';
import '../../domain/providers/chat_provider.dart';

class ChatBubble extends ConsumerStatefulWidget {
  final ChatMessage message;
  final Color accentColor;
  final String? personaIconAsset;

  const ChatBubble({
    super.key,
    required this.message,
    required this.accentColor,
    this.personaIconAsset,
  });

  @override
  ConsumerState<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends ConsumerState<ChatBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ImageProvider _getIconProvider(String assetPath) {
    if (assetPath.startsWith('assets/')) {
      return AssetImage(assetPath);
    } else {
      return kIsWeb ? NetworkImage(assetPath) : FileImage(File(assetPath)) as ImageProvider;
    }
  }

  void _showActions(BuildContext context) {
    final notifier = ref.read(chatNotifierProvider.notifier);
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['👍', '❤️', '😂', '😮', '😢', '🔥'].map((emoji) {
                return GestureDetector(
                  onTap: () {
                    notifier.toggleReaction(widget.message.id, emoji);
                    Navigator.pop(context);
                  },
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                );
              }).toList(),
            ),
            const Divider(height: 30),
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text("Reply"),
              onTap: () {
                notifier.setReplyingTo(widget.message);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text("Copy Text"),
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.message.text)).then((_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Text copied to clipboard"),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.isUser;
    final chatState = ref.watch(chatNotifierProvider).value;
    final userIcon = chatState?.userIconAsset;
    
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!isUser) _buildAvatar(false, widget.personaIconAsset),
                    if (!isUser) const SizedBox(width: 8),
                    
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isUser && _isHovered && kIsWeb) 
                          IconButton(
                            icon: const Icon(Icons.more_vert, size: 18),
                            onPressed: () => _showActions(context),
                          ),
                        Column(
                          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            if (widget.message.replyToText != null)
                              Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.all(8),
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border(left: BorderSide(color: widget.accentColor, width: 3)),
                                ),
                                child: Text(
                                  widget.message.replyToText!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                                ),
                              ),
                            
                            // Support for multiple images
                            if (widget.message.imagePaths.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: widget.message.imagePaths.map((path) => Container(
                                    constraints: const BoxConstraints(maxHeight: 150, maxWidth: 150),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: kIsWeb 
                                        ? Image.network(path, fit: BoxFit.cover)
                                        : Image.file(
                                            File(path),
                                            fit: BoxFit.cover,
                                          ),
                                    ),
                                  )).toList(),
                                ),
                              ),

                            GestureDetector(
                              onLongPress: () => _showActions(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                                ),
                                decoration: BoxDecoration(
                                  color: isUser ? widget.accentColor : Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft: Radius.circular(isUser ? 16 : 0),
                                    bottomRight: Radius.circular(isUser ? 0 : 16),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isUser
                                    ? Text(
                                        widget.message.text,
                                        style: const TextStyle(color: Colors.white),
                                      )
                                    : MarkdownBody(
                                        data: widget.message.text,
                                        styleSheet: MarkdownStyleSheet(
                                          p: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                                        ),
                                      ),
                              ),
                            ),
                            if (widget.message.reactions.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Wrap(
                                  spacing: 4,
                                  children: widget.message.reactions.map((r) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(r, style: const TextStyle(fontSize: 12)),
                                  )).toList(),
                                ),
                              ),
                          ],
                        ),
                        if (!isUser && _isHovered && kIsWeb) ...[
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.more_vert, size: 18),
                            onPressed: () => _showActions(context),
                          ),
                        ],
                      ],
                    ),
                    if (isUser) const SizedBox(width: 8),
                    if (isUser) _buildAvatar(true, userIcon),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 4,
                    left: isUser ? 0 : 56, 
                    right: isUser ? 56 : 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(widget.message.timestamp),
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                      ),
                      if (!isUser) ...[
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => ref.read(voiceServiceProvider).speak(widget.message.text),
                          child: Icon(Icons.volume_up, size: 14, color: Colors.grey[500]),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isUser, String? iconAsset) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: isUser ? Colors.grey[300] : widget.accentColor,
      backgroundImage: iconAsset != null ? _getIconProvider(iconAsset) : null,
      child: iconAsset == null 
        ? Icon(isUser ? Icons.person : Icons.android, size: 18, color: Colors.white)
        : null,
    );
  }

  String _formatTime(DateTime timestamp) {
    return "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
  }
}
