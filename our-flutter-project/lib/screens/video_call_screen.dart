import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../service/webrtc_service.dart';
import '../service/signaling_service.dart';
import '../service/websocket_service.dart';
import 'dart:async';

class VideoCallScreen extends StatefulWidget {

  final String remoteUser;
  final String currentUser;

  const VideoCallScreen({
    super.key,
    required this.remoteUser,
    required this.currentUser,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen>{

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();

  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  MediaStream? _localStream;

  final WebRTCService _webRTCService = WebRTCService();

  final WebSocketService _webSocketService = WebSocketService();

  late final SignalingService _signalingService;

  StreamSubscription? _socketSubscription;

  bool _offerSent = false;

  @override
  void initState() {
    super.initState();
    _initialize();

    debugPrint("=================================");
    debugPrint("REGISTER");
    debugPrint("Current User : ${widget.currentUser}");
    debugPrint("=================================");
  }

  Future<void> _initialize() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    await _openCamera();
    await _webRTCService.initializePeerConnection();

    // if (!_webSocketService.isConnected) {
    //   _webSocketService.connect("ws://10.0.2.2:8080/ws");
    //   await Future.delayed(const Duration(milliseconds: 500));
    // }
    await Future.delayed(const Duration(milliseconds: 500));
    _signalingService = SignalingService(_webSocketService);
    // _signalingService.register("userA");
    // _signalingService.register("userB");
    // _signalingService.register(widget.currentUser);
    await Future.delayed(const Duration(milliseconds: 500));
    _socketSubscription =
        _webSocketService.messages.listen((message) async {
      final type = message["type"];

      switch (type) {
        case "OFFER":
          await _handleOffer(message);
          break;

        case "ANSWER":
          await _handleAnswer(message);
          break;

        case "CANDIDATE":

          await _handleCandidate(message);

          break;
      }

    });
    // set url -- if window desktop
    // .connect("ws://localhost:8080/ws");

    // set url -- if điện thoại Android, 192.168.x.x là IP của máy tính đang chạy Spring Boot, cùng wf
    // .connect("ws://192.168.x.x:8080/ws");

    // Đăng ký callback trước
    _webRTCService.onRemoteStream = (stream) {
      setState(() {
        _remoteRenderer.srcObject = stream;
      });
    };

    _webRTCService.onIceCandidate = (candidate) {
      debugPrint("========== LOCAL ICE ==========");

      _signalingService.ice(

        from: widget.currentUser,

        to: widget.remoteUser,

        candidate: candidate.candidate!,

        sdpMid: candidate.sdpMid!,

        sdpMLineIndex: candidate.sdpMLineIndex!,

      );
    };

    // Sau đó mới add stream
    await _webRTCService.addLocalStream(_localStream!);
  }

  Future<void> _startCall() async {

    if (_offerSent) return;

    _offerSent = true;

    debugPrint("========== CREATE OFFER ==========");

    final offer = await _webRTCService.createOffer();

    _signalingService.offer(
      from: widget.currentUser,
      to: widget.remoteUser,
      sdp: offer.sdp!,
      descriptionType: offer.type!,
    );

    debugPrint("Offer Sent");

  }

  Future<void> _openCamera() async {
    try {
      final mediaConstraints = {
        "audio": true,
        "video": {
          "facingMode": "user",
        }
      };

      _localStream =
      await navigator.mediaDevices.getUserMedia(mediaConstraints);

      _localRenderer.srcObject = _localStream;

      setState(() {});
    } catch (e) {
      debugPrint("Open camera failed: $e");
    }
  }

  Future<void> _handleOffer(
      Map<String, dynamic> message,
      ) async {

    debugPrint("========== RECEIVE OFFER ==========");

    await _webRTCService.setRemoteDescription(
      RTCSessionDescription(
        message["sdp"],
        message["descriptionType"],
      ),
    );

    final answer = await _webRTCService.createAnswer();

    _signalingService.answer(
      from: widget.currentUser,
      to: message["from"],
      sdp: answer.sdp!,
      descriptionType: answer.type!,
    );

    debugPrint("Answer Sent");
  }
  Future<void> _handleAnswer(
      Map<String, dynamic> message,
      ) async {

    debugPrint("========== RECEIVE ANSWER ==========");

    await _webRTCService.setRemoteDescription(
      RTCSessionDescription(
        message["sdp"],
        message["descriptionType"],
      ),
    );

    debugPrint("Call Connected");
  }

  Future<void> _handleCandidate(
      Map<String, dynamic> message,
      ) async {

    debugPrint("========== REMOTE ICE ==========");

    final candidate = RTCIceCandidate(

      message["candidate"],

      message["sdpMid"],

      message["sdpMLineIndex"],

    );

    await _webRTCService.addIceCandidate(candidate);

  }

  @override
  void dispose() {
    _socketSubscription?.cancel();

    // Đóng PeerConnection
    _webRTCService.dispose();

    // Dừng Camera và Microphone
    _localStream?.getTracks().forEach((track) {
      track.stop();
    });

    // Giải phóng MediaStream
    _localStream?.dispose();

    // Giải phóng Video Renderer
    _localRenderer.dispose();
    _remoteRenderer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        title: Text(widget.remoteUser),
      ),

      body: Stack(

        children: [

          Container(
            color: Colors.black,
            child: RTCVideoView(
              _remoteRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
          ),

          Positioned(

            top: 20,

            right: 20,

            width: 120,

            height: 180,

            child: RTCVideoView(
              _localRenderer,
              mirror: true,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),

          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  FloatingActionButton(

                    heroTag: "call",

                    backgroundColor: Colors.green,

                    onPressed: _startCall,

                    child: const Icon(Icons.call),

                  ),

                  const SizedBox(width: 30),

                  FloatingActionButton(

                    heroTag: "end",

                    backgroundColor: Colors.red,

                    onPressed: (){

                      Navigator.pop(context);

                    },

                    child: const Icon(Icons.call_end),

                  ),

                ],

              ),
            ),
          ),
        ],

      ),

    );
  }

}