import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:chatbot_app/patient%20screens/PatientRegisterScreen.dart';
import 'package:chatbot_app/meeting_screens/joinWithCode.dart';
import 'package:chatbot_app/components/constant.dart';

class ChatScreen extends StatefulWidget {
  final String greetingMessage;
  final String relationship;

  ChatScreen({
    Key? key,
    String? greetingMessage,
    String? relationship,
  })  : greetingMessage =
            greetingMessage ?? Get.arguments?['greetingMessage'] ?? '',
        relationship = relationship ?? Get.arguments?['relationship'] ?? '',
        super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final String _chatApiUrl =
      "https://rnproducts.site/greenbless-web/api/ask_question/";
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.greetingMessage.isNotEmpty) {
      _messages.add({
        'message': widget.greetingMessage,
        'isPatient': false,
        'id': 1,
        'isLoading': false,
      });
    }
    _scrollToBottom();
  }

  Future<void> _sendMessageToServer(String message) async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(_chatApiUrl),
        body: jsonEncode({
          'user_id':
              1, // Add user_id here (you might want to make this dynamic)
          'question': message
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final aiMessage =
            data['answer'] ?? "I'm sorry, I didn't understand that.";

        setState(() {
          _messages.add({
            'message': aiMessage,
            'isPatient': false,
            'id': DateTime.now().millisecondsSinceEpoch + 1,
            'isLoading': false,
          });
        });
      } else {
        print("Failed to get response from AI. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending message: $e");
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final newMessageId = DateTime.now().millisecondsSinceEpoch;

    setState(() {
      _messages.add({
        'message': text,
        'isPatient': true,
        'id': newMessageId,
        'isLoading': false,
      });
      _messageController.clear();
    });

    _sendMessageToServer(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: gray100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(1),
            const SizedBox(width: 4),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, double value, child) {
        return Opacity(
          opacity: (value * 2 - index * 0.3).clamp(0.3, 1.0),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: gray400,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  void _startVideoCall() {
    Get.to(() => JoinWithCode());
  }

  Widget _buildMessageBubble(Map<String, dynamic> messageData) {
    final message = messageData['message'];
    final isPatient = messageData['isPatient'];
    final timestamp = DateTime.now();

    return Align(
      alignment: isPatient ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isPatient ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: isPatient ? blueCustom : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: isPatient
                    ? const Radius.circular(20)
                    : const Radius.circular(4),
                bottomRight: isPatient
                    ? const Radius.circular(4)
                    : const Radius.circular(20),
              ),
              border: Border.all(
                color:
                    isPatient ? Colors.transparent : gray300.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildTextWithLink(message, isPatient),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Text(
              '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 11,
                color: gray400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextWithLink(String text, bool isPatient) {
    final RegExp linkRegExp = RegExp(
      r"(https?:\/\/[^\s]+)",
      caseSensitive: false,
    );

    final matches = linkRegExp.allMatches(text);
    if (matches.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          color: isPatient ? Colors.white : gray950,
          fontSize: 15,
          height: 1.4,
        ),
      );
    }

    List<TextSpan> spans = [];
    int currentIndex = 0;

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, match.start),
          style: TextStyle(
            color: isPatient ? Colors.white : gray950,
            fontSize: 15,
            height: 1.4,
          ),
        ));
      }

      final url = text.substring(match.start, match.end);
      spans.add(TextSpan(
        text: url,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            final Uri uri = Uri.parse(url);
            if (await canLaunch(uri.toString())) {
              await launch(uri.toString());
            } else {
              throw 'Could not launch $url';
            }
          },
      ));
      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: TextStyle(
          color: isPatient ? Colors.white : gray950,
          fontSize: 15,
          height: 1.4,
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gray50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: gray950, size: 20),
          onPressed: () => Get.offAll(() => RegisterScreen()),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    blueCustom.withOpacity(0.7),
                    blueCustom,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.medical_services_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "AvaCare Assistant",
                    style: TextStyle(
                      color: gray950,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'AI Healthcare Support',
                    style: TextStyle(
                      color: gray500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_rounded, color: gray950, size: 24),
            onPressed: _startVideoCall,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: gray950, size: 24),
            onPressed: () {
              // TODO: Show more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading && _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 80,
                          color: gray300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start a conversation',
                          style: TextStyle(
                            fontSize: 16,
                            color: gray400,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isLoading) {
                        return _buildTypingIndicator();
                      }
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: gray100,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: gray300, width: 1),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(
                        fontSize: 15,
                        color: gray950,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: gray400),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Material(
                  color: blueCustom,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: _isLoading ? null : _sendMessage,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: _isLoading
                          ? const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  canLaunch(String string) {}

  launch(String string) {}
}
