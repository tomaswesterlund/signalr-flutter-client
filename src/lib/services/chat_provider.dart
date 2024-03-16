import 'package:flutter/material.dart';
import 'package:flutter_signalr_test/models/message.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  late HubConnection _chatHub;
  final String myUserId = const Uuid().v4();

  final List<Message> _messages = [];
  List<Message> get messages => _messages;


  Future initializeSignalR() async {
    try {
      const serverUrl = "http://localhost:5066/chathub";
      _chatHub = HubConnectionBuilder().withUrl(serverUrl).build();

      await _chatHub.start();

      _chatHub.on(
        "ReceiveMessage",
        (arguments) {
          var user = arguments![0].toString();
          var text = arguments[1].toString();

          var message = Message(user: user, text: text);

          addMessage(message);
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  void sendMessage(String message) async {
    await _chatHub.invoke("SendMessage", args: [myUserId, message]);
  }

  bool isMe(String userId) {
    return userId == myUserId;
  }
}
