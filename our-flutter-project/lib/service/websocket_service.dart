import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {

  static final WebSocketService _instance =
  WebSocketService._internal();

  factory WebSocketService() => _instance;

  WebSocketService._internal();

  WebSocketChannel? _channel;

  final StreamController<Map<String, dynamic>> _messageController =
  StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  final StreamController<String> _controller =
  StreamController.broadcast();

  bool _isOpen = false;

  bool get isConnected => _isOpen;

  Future<void> connect(String url) async {

    if (_channel != null) {
      print("WebSocket already connected");
      return;
    }

    _channel = WebSocketChannel.connect(Uri.parse("ws://10.0.2.2:8080/ws"));

    _isOpen = true;

    _channel!.stream.listen(

          (message) {

        print("========== RECEIVE ==========");
        print(message);

        // Stream cũ (String)
        _controller.add(message);

        // Decode JSON
        final data = jsonDecode(message);

        // Stream mới (Map)
        _messageController.add(data);

      },

      onDone: () {

        print("WebSocket disconnected");
        _channel = null;
        _isOpen = false;
      },

      onError: (e) {

        print("WebSocket Error: $e");
        _channel = null;
        _isOpen = false;
      },

    );

  }

  Stream<String> get stream => _controller.stream;

  void send(Map<String, dynamic> json) {

    if (_channel == null || !_isOpen) {
      print("WebSocket chưa kết nối");
      return;
    }

    print("========== SEND ==========");
    print(json);

    _channel!.sink.add(
      jsonEncode(json),
    );

  }

  void disconnect() {
    print("======================");
    print(StackTrace.current);
    print("======================");

    _channel?.sink.close();

    _channel = null;

    print("WebSocket Closed");

  }

}