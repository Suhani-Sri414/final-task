import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mind_ease_app/controller/chatbot_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();

  static Future<void> clearChatOnLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_messages');
  }
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  final ChatbotController _chatbotController = ChatbotController();
  bool _isLoading = false;
  final String _sessionId = "user123";

  static const Color greenColor = Color(0xFF4CAF50);
  static const Color creamColor = Color(0xFFFDF7E7);
  static const Color greyBubble = Color(0xFFE0E0E0);
  static const Color darkBlue = Color(0xFF1F3A5F);

  @override
  void initState() {
    super.initState();
    _loadSavedMessages();
  }

  Future<void> _loadSavedMessages() async {
   final prefs = await SharedPreferences.getInstance();
   final savedData = prefs.getString('chat_messages');

   if (savedData != null && savedData.isNotEmpty) {
     try {
       final decoded = List<Map<String, String>>.from(json.decode(savedData));
         setState(() {
         _messages.addAll(decoded);
        });
      } catch (e) {
       debugPrint("Failed to decode saved chat data: $e");
       await prefs.remove('chat_messages');
       _addInitialBotMessage();
      }
    } else {
     _addInitialBotMessage();
    }
    _scrollToBottom();
  }
  
  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_messages', json.encode(_messages));
  }

  void _addInitialBotMessage() {
    setState(() {
      _messages.add({
        'sender': 'bot',
        'text':
            'Hey, this is your AI therapist. Here to chat with you and make you feel better.',
      });
    });
    _saveMessages();
  }

  
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  
  Future<void> sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': message});
      _isLoading = true;
    });
    _messageController.clear();

    _scrollToBottom();
    _saveMessages();
try {
  final botResponse = await _chatbotController.getChatbotResponse(message, _sessionId);

  setState(() {
    _messages.add({'sender': 'bot', 'text': botResponse});
    _isLoading = false;
  });

  await _saveMessages(); 
  _scrollToBottom();
} catch (e) {
  setState(() {
    _messages.add({
      'sender': 'bot',
      'text': 'Failed to get response: $e',
    });
    _isLoading = false;
  });
  await _saveMessages(); 
  _scrollToBottom();
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            color: darkBlue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 25),
              child: Text(
                'AI Therapist–Chat Bot',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg['sender'] == 'user';
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      constraints: const BoxConstraints(maxWidth: 300),
                      decoration: BoxDecoration(
                        color: isUser ? greenColor : greyBubble,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg['text'] ?? '',
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(color: greenColor),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Share what's on your mind...",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: greenColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
