import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signalr_test/services/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
        ),
        body: Consumer<ChatProvider>(
          builder: (context, chatProvider, child) {
            var messages = chatProvider.messages;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      var isMe = chatProvider.isMe(message.user);

                      if (isMe) {
                        return BubbleSpecialThree(
                          text: message.text,
                          color: const Color(0xFF1B97F3),
                          tail: false,
                          isSender: true,
                          textStyle: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        );
                      } else {
                        return  BubbleSpecialThree(
                          text: message.text,
                          color: const Color(0xFFE8E8EE),
                          tail: false,
                          isSender: false,
                        );
                      }
                    },
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          // Using Expanded to ensure the TextFormField takes the available space
                          child: TextFormField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              hintText: 'Enter your message',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                            width:
                                10), // Add some spacing between the text field and the button
                        ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, otherwise false.
                            if (_formKey.currentState!.validate()) {
                              chatProvider.sendMessage(_textEditingController.text);
                              _textEditingController.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue, // Text color
                          ),
                          child: const Text('Send message'),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
