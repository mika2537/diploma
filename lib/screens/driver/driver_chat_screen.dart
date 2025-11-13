// lib/screens/driver/driver_chat_screen.dart
// Simple chat UI (placeholder). Replace send/receive with websocket or firebase.

import 'package:flutter/material.dart';

class DriverChatScreen extends StatefulWidget {
  final String chatId;
  final String title;
  const DriverChatScreen({Key? key, required this.chatId, required this.title}) : super(key: key);

  @override
  State<DriverChatScreen> createState() => _DriverChatScreenState();
}

class _DriverChatScreenState extends State<DriverChatScreen> {
  final _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {'me': false, 'text': 'Сайн байна уу! би таныг очиход бэлэн байна.'},
    {'me': true, 'text': 'Сайн байна, хэдэн минутд очих вэ?'},
  ];

  void _send() {
    final txt = _controller.text.trim();
    if (txt.isEmpty) return;
    setState(() {
      messages.add({'me': true, 'text': txt});
      _controller.clear();
      // NOTE: Simulate reply
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => messages.add({'me': false, 'text': 'Баярлалаа!'}));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (ctx, i) {
                  final m = messages[i];
                  final align = m['me'] ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                  final color = m['me'] ? Theme.of(context).colorScheme.primary : Colors.grey.shade200;
                  final textColor = m['me'] ? Theme.of(context).colorScheme.onPrimary : Colors.black87;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: align,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(m['text'], style: TextStyle(color: textColor)),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            // Input
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Мессеж бичнэ үү', border: OutlineInputBorder(), isDense: true))),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: _send, child: const Icon(Icons.send)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}