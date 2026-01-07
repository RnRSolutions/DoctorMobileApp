import 'package:chatbot_app/components/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorPatientChat extends StatefulWidget {
  final String patientName;
  final String patientId;

  const DoctorPatientChat({
    Key? key,
    required this.patientName,
    required this.patientId,
  }) : super(key: key);

  @override
  _DoctorPatientChatState createState() => _DoctorPatientChatState();
}

class _DoctorPatientChatState extends State<DoctorPatientChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    // Simulating API call - replace with actual API endpoint
    await Future.delayed(const Duration(seconds: 1));

    // Dummy messages for demonstration
    setState(() {
      _messages = [
        {
          'message': 'Hello Doctor, I have been experiencing some headaches.',
          'isDoctor': false,
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        },
        {
          'message':
              'Hello! Can you describe the type of headache? Is it constant or intermittent?',
          'isDoctor': true,
          'timestamp':
              DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
        },
        {
          'message': 'It comes and goes, usually in the afternoon.',
          'isDoctor': false,
          'timestamp':
              DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
        },
        {
          'message': 'I see. How long have you been experiencing this?',
          'isDoctor': true,
          'timestamp':
              DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        },
        {
          'message': 'About a week now.',
          'isDoctor': false,
          'timestamp':
              DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
        },
      ];
      _isLoading = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add({
        'message': messageText,
        'isDoctor': true,
        'timestamp': DateTime.now(),
      });
      _isSending = true;
    });

    _scrollToBottom();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isSending = false;
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gray50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: gray950, size: 20),
          onPressed: () => Get.back(),
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
              child: Center(
                child: Text(
                  widget.patientName.isNotEmpty
                      ? widget.patientName[0].toUpperCase()
                      : 'P',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.patientName,
                    style: const TextStyle(
                      color: gray950,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Patient',
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
            onPressed: () {
              Get.toNamed('/videoConference');
            },
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
          // Messages List
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(color: blueCustom),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),
          // Input Field
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
            child: SafeArea(
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
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: TextStyle(color: gray400),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              style: const TextStyle(
                                fontSize: 15,
                                color: gray950,
                              ),
                              maxLines: null,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: blueCustom,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      onTap: _isSending ? null : _sendMessage,
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: _isSending
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
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> messageData) {
    final message = messageData['message'];
    final isDoctor = messageData['isDoctor'];
    final timestamp = messageData['timestamp'] as DateTime;

    return Align(
      alignment: isDoctor ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isDoctor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: isDoctor ? blueCustom : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: isDoctor
                    ? const Radius.circular(20)
                    : const Radius.circular(4),
                bottomRight: isDoctor
                    ? const Radius.circular(4)
                    : const Radius.circular(20),
              ),
              border: Border.all(
                color: isDoctor ? Colors.transparent : gray300.withOpacity(0.3),
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
            child: Text(
              message,
              style: TextStyle(
                fontSize: 15,
                color: isDoctor ? Colors.white : gray950,
                height: 1.4,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Text(
              _formatTimestamp(timestamp),
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
}
