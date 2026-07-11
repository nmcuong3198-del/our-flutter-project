import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../service/signaling_service.dart';
import '../service/webrtc_service.dart';
import '../service/websocket_service.dart';

class CallController {

  final String currentUser;

  final String remoteUser;

  CallController({

    required this.currentUser,

    required this.remoteUser,

  });

  final WebRTCService webRTC = WebRTCService();

  final WebSocketService socket = WebSocketService();

  late final SignalingService signaling =
  SignalingService(socket);

  StreamSubscription? socketSubscription;

  bool isCaller = false;

  Function(MediaStream stream)? onRemoteStream;

}