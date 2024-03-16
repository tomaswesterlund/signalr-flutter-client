import 'package:flutter/material.dart';
import 'package:flutter_signalr_test/pages/chat_page.dart';
import 'package:flutter_signalr_test/services/chat_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var chatProvider = ChatProvider();
  await chatProvider.initializeSignalR();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => chatProvider),
      ],
      child: ChatPage(),
    ),
  );
}

