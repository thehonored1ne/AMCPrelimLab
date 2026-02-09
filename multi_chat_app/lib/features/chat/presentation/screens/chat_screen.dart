import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/providers/chat_provider.dart';
import '../../data/services/export_service.dart';
import '../../data/services/voice_service.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/persona_drawer.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  
  bool _isListening = false;
  bool _isTtsEnabled = false;
  bool _showScrollToBottom = false;
  bool _showEmojiPicker = false;

  final List<String> _emojis = [
    '😀', '😃', '😄', '😁', '😅', '😂', '🤣', '😊', '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘', '😗', '😙', '😚', '😋',
    '😛', '😝', '😜', '🤪', '🤨', '🧐', '🤓', '😎', '🤩', '🥳', '😏', '😒', '😞', '😔', '😟', '😕', '🙁', '☹️', '😣', '😖',
    '😫', '😩', '🥺', '😢', '😭', '😤', '😠', '😡', '🤬', '🤯', '😳', '🥵', '🥶', '😱', '😨', '😰', '😥', '😓', '🤗', '🤔',
    '🤭', '🤫', '🤥', '😶', '😐', '😑', '😬', '🙄', '😯', '😦', '😧', '😮', '😲', '🥱', '😴', '🤤', '😪', '😵', '🤐', '🥴',
    '🤢', '🤮', '🤧', '🥵', '🥶', '😷', '🤒', '🤕', '🤑', '🤠', '😈', '👿', '👹', '👺', '🤡', '👻', '💀', '☠️', '👽', '👾',
    '🤖', '💩', '😺', '😸', '😹', '😻', '😼', '😽', '🙀', '😿', '😾', '🙈', '🙉', '🙊', '💋', '💌', '💘', '💝', '💖', '💗',
    '💓', '💞', '💕', '💟', '❣️', '💔', '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '🤎', '💯', '💢', '💥', '💫', '💦',
    '💨', '🕳️', '💣', '💬', '👁️‍🗨️', '🗨️', '🗯️', '💭', '💤', '👋', '🤚', '🖐️', '✋', '🖖', '👌', '🤏', '✌️', '🤞', '🤟', '🤘',
    '🤙', '👈', '👉', '👆', '🖕', '👇', '☝️', '👍', '👎', '✊', '👊', '🤛', '🤜', '👏', '🙌', '👐', '🤲', '🤝', '🙏', '✍️',
    '💅', '🤳', '💪', '🦾', '🦵', '🦿', '🦶', '👣', '👂', '🦻', '👃', '🧠', '🦷', '🦴', '👀', '👁️', '👅', '👄', '👶', '🧒'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final isAtBottom = _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200;
      if (isAtBottom && _showScrollToBottom) {
        setState(() => _showScrollToBottom = false);
      } else if (!isAtBottom && !_showScrollToBottom) {
        setState(() => _showScrollToBottom = true);
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  ImageProvider _getIconProvider(String assetPath) {
    if (assetPath.startsWith('assets/')) {
      return AssetImage(assetPath);
    } else {
      return kIsWeb ? NetworkImage(assetPath) : FileImage(File(assetPath)) as ImageProvider;
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() => _selectedImages.addAll(images));
    }
  }

  void _sendCurrentMessage(ChatNotifier notifier) {
    if (_controller.text.trim().isNotEmpty || _selectedImages.isNotEmpty) {
      notifier.sendMessage(
        _controller.text.trim(),
        images: _selectedImages,
      );
      _controller.clear();
      setState(() {
        _selectedImages = [];
        _showEmojiPicker = false;
      });
    }
  }

  Future<void> _toggleListening() async {
    final voiceService = ref.read(voiceServiceProvider);
    if (_isListening) {
      await voiceService.stopListening();
      setState(() => _isListening = false);
    } else {
      final available = await voiceService.initSpeech(
        onListeningStateChanged: (isListening) {
          setState(() => _isListening = isListening);
        },
      );
      if (available) {
        await voiceService.startListening(
          onResult: (text) {
            setState(() {
              _controller.text = text;
            });
          },
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Speech recognition not available")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatNotifierProvider);

    return chatAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (chatState) {
        final notifier = ref.read(chatNotifierProvider.notifier);
        
        ref.listen(chatNotifierProvider, (previous, next) {
          final previousValue = previous?.value;
          final nextValue = next.value;

          if (nextValue != null) {
            if (previousValue != null && previousValue.activePersona.id != nextValue.activePersona.id) {
              _controller.clear();
              setState(() => _selectedImages = []);
              ref.read(voiceServiceProvider).stopTts();
            }

            if (previousValue?.messages.length != nextValue.messages.length) {
              _scrollToBottom();
              
              if (_isTtsEnabled && nextValue.messages.isNotEmpty) {
                final lastMsg = nextValue.messages.last;
                if (!lastMsg.isUser && lastMsg.id != 'thinking-id' && !lastMsg.text.contains('thinking...')) {
                  ref.read(voiceServiceProvider).speak(lastMsg.text);
                }
              }
            }
          }
        });

        return Scaffold(
          appBar: _buildAppBar(context, chatState, notifier),
          drawer: const PersonaDrawer(),
          body: Container(
            color: chatState.activePersona.themeColor.withValues(alpha: 0.05),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: chatState.messages.isEmpty 
                        ? _buildEmptyState(chatAsync.value!)
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: chatState.messages.length,
                            itemBuilder: (context, index) {
                              return ChatBubble(
                                message: chatState.messages[index],
                                accentColor: chatState.activePersona.themeColor,
                                personaIconAsset: chatState.activePersona.iconAsset,
                              );
                            },
                          ),
                    ),
                    _buildInputArea(context, chatState, notifier, chatState.activePersona.themeColor),
                    if (_showEmojiPicker) _buildEmojiPicker(chatState.activePersona.themeColor),
                  ],
                ),
                if (_showScrollToBottom)
                  Positioned(
                    bottom: 110,
                    right: 16,
                    child: FloatingActionButton.small(
                      onPressed: _scrollToBottom,
                      backgroundColor: chatState.activePersona.themeColor,
                      child: const Icon(Icons.arrow_downward, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(ChatState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.3,
              child: Image(
                image: _getIconProvider(state.activePersona.iconAsset),
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                "Say something to start a conversation with ${state.activePersona.name}...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ChatState state, ChatNotifier notifier) {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: state.activePersona.themeColor,
            radius: 18,
            backgroundImage: _getIconProvider(state.activePersona.iconAsset),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.activePersona.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                state.activePersona.tone,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(state.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
          onPressed: () => notifier.toggleTheme(),
          tooltip: "Toggle Theme",
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.translate),
          tooltip: "Select Language",
          initialValue: state.language,
          onSelected: (String language) {
            notifier.setLanguage(language);
          },
          itemBuilder: (BuildContext context) => <String>[
            'English',
            'Spanish',
            'French',
            'German',
            'Tagalog',
          ].map((String lang) {
            return PopupMenuItem<String>(
              value: lang,
              child: Text(lang),
            );
          }).toList(),
        ),
        IconButton(
          icon: Icon(_isTtsEnabled ? Icons.volume_up : Icons.volume_off),
          onPressed: () => setState(() => _isTtsEnabled = !_isTtsEnabled),
          tooltip: "Toggle Auto-TTS",
        ),
        IconButton(
          icon: const Icon(Icons.share),
          tooltip: "Share Chat",
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            try {
              final exportService = ExportService();
              await exportService.exportAndShareChat(
                state.activePersona,
                state.messages
              );
            } catch (e) {
              messenger.showSnackBar(SnackBar(content: Text("Export failed: $e")));
            }
          },
        ),
      ],
    );
  }

  Widget _buildEmojiPicker(Color accentColor) {
    return Container(
      height: 250,
      color: Theme.of(context).cardColor,
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemCount: _emojis.length,
        itemBuilder: (context, index) {
          return IconButton(
            onPressed: () {
              final text = _controller.text;
              final selection = _controller.selection;
              final newText = text.replaceRange(selection.start, selection.end, _emojis[index]);
              _controller.value = TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(offset: selection.start + _emojis[index].length),
              );
            },
            icon: Text(_emojis[index], style: const TextStyle(fontSize: 24)),
          );
        },
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, ChatState state, ChatNotifier notifier, Color accentColor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -2),
              blurRadius: 5,
            ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.replyingTo != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border(left: BorderSide(color: accentColor, width: 4)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.replyingTo!.isUser ? "You" : state.activePersona.name,
                          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          state.replyingTo!.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => notifier.setReplyingTo(null),
                  ),
                ],
              ),
            ),

          if (_selectedImages.isNotEmpty)
            Container(
              height: 90,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  final img = _selectedImages[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: kIsWeb 
                            ? Image.network(img.path, height: 80, width: 80, fit: BoxFit.cover)
                            : Image.file(File(img.path), height: 80, width: 80, fit: BoxFit.cover),
                        ),
                        Positioned(
                          right: -5,
                          top: -5,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedImages.removeAt(index)),
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close, size: 12, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: Icon(_showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions, color: accentColor),
                onPressed: () {
                  setState(() => _showEmojiPicker = !_showEmojiPicker);
                  if (_showEmojiPicker) {
                    FocusScope.of(context).unfocus();
                  } else {
                    FocusScope.of(context).requestFocus();
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.image, color: accentColor),
                onPressed: _pickImages,
              ),
              IconButton(
                icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: _isListening ? Colors.red : accentColor),
                onPressed: _toggleListening,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendCurrentMessage(notifier),
                  onTap: () {
                    if (_showEmojiPicker) {
                      setState(() => _showEmojiPicker = false);
                    }
                  },
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: _isListening ? 'Listening...' : 'Ask anything...',
                    hintStyle: TextStyle(color: isDark ? Colors.white60 : Colors.black45),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey[850] : Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  maxLines: 5,
                  minLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton.small(
                onPressed: () => _sendCurrentMessage(notifier),
                backgroundColor: accentColor,
                elevation: 0,
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
