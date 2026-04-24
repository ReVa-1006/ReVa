import 'package:flutter/material.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> with TickerProviderStateMixin {
  static const _darkGreen = Color(0xFF1B5E20);
  static const _green = Color(0xFF2E6B2E);
  static const _lightGreen = Color(0xFF4CAF50);
  static const _bgColor = Color(0xFFF0F5F0);

  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _isTyping = false;

  final List<Map<String, dynamic>> _messages = [
    {
      'isBot': true,
      'text': 'Hello! 🌿 I\'m ReVa AI, your eco-friendly recycling assistant.\n\nI can help you with:\n• Identifying recyclable materials\n• Finding nearby recycling points\n• Earning more ReVa points\n• Eco-friendly tips & tricks\n\nHow can I help you today?',
    },
  ];

  final List<String> _quickReplies = [
    '♻️ How do I earn points?',
    '🌍 Find recycling centers',
    '📦 What can I recycle?',
    '💡 Eco tips',
  ];

  final Map<String, String> _botResponses = {
    'point': 'You earn ReVa points by:\n• Selling recyclable materials 🏷️\n• Completing deliveries ✅\n• Referring friends 👥\n• Participating in community challenges 🌿\n\nPoints can be redeemed for eco-friendly products in our store!',
    'recycl': 'Common recyclable materials include:\n• ♻️ Plastic bottles & containers\n• 📰 Paper & cardboard\n• 🥫 Aluminum & metal cans\n• 🍶 Glass bottles & jars\n• 📱 Electronics (e-waste)\n• 👕 Fabric & denim\n\nNot sure? Upload a photo and I\'ll identify it for you!',
    'center': 'I can help you find the nearest recycling centers in your area! 📍\n\nFor now, check the Map tab in the app to see all registered recycling points near you. New centers are added weekly!',
    'tip': 'Here are some great eco tips! 🌱\n\n1. Use reusable bags instead of plastic\n2. Compost organic waste at home\n3. Fix and repair items instead of replacing\n4. Choose products with minimal packaging\n5. Donate unwanted items instead of trashing them\n\nEvery small action counts! 💚',
    'sell': 'To sell recyclable materials:\n1. Go to the Materials section\n2. Upload photos of your materials\n3. Set your price or points value\n4. Wait for admin approval\n5. A driver will collect from your location! 🚛',
    'buy': 'To buy recycled materials:\n1. Browse the Materials marketplace\n2. Filter by category or price\n3. Add items to your cart\n4. Complete payment (cash or points)\n5. Track your delivery in real time! 📦',
  };

  String _getBotReply(String input) {
    final lower = input.toLowerCase();
    for (final key in _botResponses.keys) {
      if (lower.contains(key)) return _botResponses[key]!;
    }
    return 'Thanks for your message! 🌿\n\nI\'m here to help with all things recycling. You can ask me about:\n• Earning points\n• Selling or buying materials\n• Finding recycling centers\n• Eco-friendly tips\n\nWhat would you like to know?';
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'isBot': false, 'text': text.trim()});
      _isTyping = true;
    });
    _inputCtrl.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({'isBot': true, 'text': _getBotReply(text)});
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (_, i) {
                  if (_isTyping && i == _messages.length) return _buildTypingIndicator();
                  return _buildMessage(_messages[i]);
                },
              ),
            ),
            _buildQuickReplies(),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_darkGreen, _green, _lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ReVa AI Assistant', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                Row(children: [
                  Container(width: 7, height: 7,
                      decoration: const BoxDecoration(color: Color(0xFFA5D6A7), shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text('Online · Eco Expert', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11)),
                ]),
              ],
            ),
          ),
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    final isBot = msg['isBot'] as bool;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isBot) ...[
            Container(
              width: 32, height: 32,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [_darkGreen, _lightGreen]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isBot ? Colors.white : _green,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isBot ? 4 : 18),
                  bottomRight: Radius.circular(isBot ? 18 : 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isBot ? Colors.black : _green).withValues(alpha: 0.08),
                    blurRadius: 8, offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                msg['text'] as String,
                style: TextStyle(
                  fontSize: 14,
                  color: isBot ? const Color(0xFF333333) : Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (!isBot) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32, height: 32,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [_darkGreen, _lightGreen]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4), bottomRight: Radius.circular(18),
              ),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
            ),
            child: _TypingDots(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReplies() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _quickReplies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          return GestureDetector(
            onTap: () => _sendMessage(_quickReplies[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFC8E6C9)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
              ),
              child: Text(_quickReplies[i],
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _green)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      color: _bgColor,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
              ),
              child: TextField(
                controller: _inputCtrl,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: _sendMessage,
                decoration: InputDecoration(
                  hintText: 'Ask about recycling...',
                  hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFAAAAAA)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  prefixIcon: const Icon(Icons.eco_outlined, color: _lightGreen, size: 20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _sendMessage(_inputCtrl.text),
            child: Container(
              width: 50, height: 50,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [_darkGreen, _lightGreen], begin: Alignment.topLeft, end: Alignment.bottomRight),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Color(0x44388E3C), blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

// Animated typing dots widget
class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) =>
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
          ..repeat(reverse: true));
    _anims = _controllers.asMap().entries.map((e) {
      Future.delayed(Duration(milliseconds: e.key * 150), () {
        if (mounted) e.value.repeat(reverse: true);
      });
      return Tween<double>(begin: 0, end: -6).animate(CurvedAnimation(parent: e.value, curve: Curves.easeInOut));
    }).toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) => AnimatedBuilder(
        animation: _anims[i],
        builder: (_, __) => Transform.translate(
          offset: Offset(0, _anims[i].value),
          child: Container(
            width: 8, height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
          ),
        ),
      )),
    );
  }
}
