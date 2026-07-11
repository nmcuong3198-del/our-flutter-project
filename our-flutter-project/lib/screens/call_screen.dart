import 'package:flutter/material.dart';
import '../service/signaling_service.dart';
import '../service/websocket_service.dart';

import '../core/theme.dart';
import 'video_call_screen.dart';
import 'dart:async';


class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {

  final TextEditingController _userController =
  TextEditingController();

  final WebSocketService _webSocketService =
  WebSocketService();

  late SignalingService _signalingService;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  String? currentUser;

  List<String> onlineUsers = [];

  bool connected = false;

  @override
  void dispose() {
    _subscription?.cancel();
    _userController.dispose();
    super.dispose();
  }

  Future<void> _login() async {

    final user = _userController.text.trim();

    if (user.isEmpty) {
      return;
    }

    currentUser = user;

    // if (!_webSocketService.isConnected) {
    //
    //   _webSocketService.connect(
    //     "ws://10.0.2.2:8080/ws",
    //   );
    //
    //   Future.delayed(const Duration(milliseconds: 800), () {
    //     _signalingService.register(currentUser!);
    //   });
    // }

    _webSocketService.connect(
      "ws://10.0.2.2:8080/ws",
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      _signalingService.register(currentUser!);
    });

    _signalingService =
        SignalingService(_webSocketService);

    // Listen
    _subscription ??=
        _webSocketService.messages.listen((message) {

          debugPrint("========== RECEIVE ==========");
          debugPrint(message.toString());

          if (message["type"] == "ONLINE_USERS") {

            final users = List<String>.from(message["users"]);

            setState(() {
              onlineUsers = users
                  .where((e) => e != currentUser)
                  .toList();
            });

          }

        });

    // register
    _signalingService.register(currentUser!);

    setState(() {
      connected = true;
    });

  }

  @override
  Widget build(BuildContext context) {

    if (!connected) {

      return Scaffold(

        appBar: AppBar(
          title: const Text("Nhập userId để videocall"),
        ),

        backgroundColor: AppColors.background,

        body: Padding(

          padding: const EdgeInsets.all(20),

          child: Column(

            children: [

              TextField(

                controller: _userController,

                decoration: const InputDecoration(

                  labelText: "User ID",

                  border: OutlineInputBorder(),

                ),

              ),

              const SizedBox(height: 20),

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: _login,

                  child: const Text("Login"),

                ),

              ),

            ],

          ),

        ),

      );

    }

    return Scaffold(

      appBar: AppBar(

        title: Text(

          "Online (${currentUser!})",

        ),

      ),

      backgroundColor: AppColors.background,

      body: onlineUsers.isEmpty

          ? const Center(

        child: Text(

          "Chưa có ai online",

          style: TextStyle(fontSize: 18),

        ),

      )

          : ListView.builder(

        itemCount: onlineUsers.length,

        itemBuilder: (_, index) {

          final user = onlineUsers[index];

          return Card(

            margin: const EdgeInsets.symmetric(

              horizontal: 16,

              vertical: 8,

            ),

            child: ListTile(

              leading: const CircleAvatar(

                backgroundColor: Colors.green,

                child: Icon(

                  Icons.person,

                  color: Colors.white,

                ),

              ),

              title: Text(user),

              subtitle: const Text("Đang online"),

              trailing: ElevatedButton.icon(

                icon: const Icon(Icons.call),

                label: const Text("Call"),

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) => VideoCallScreen(

                        currentUser: currentUser!,

                        remoteUser: user,

                      ),

                    ),

                  );

                },

              ),

            ),

          );

        },

      ),

    );

  }

}