import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {

  RTCPeerConnection? peerConnection;

  MediaStream? localStream;

  Function(MediaStream stream)? onRemoteStream;

  Function(RTCIceCandidate candidate)? onIceCandidate;

  final Map<String, dynamic> configuration = {
    "iceServers": [
      {
        "urls": [
          "stun:stun.l.google.com:19302",
        ]
      }
    ]
  };

  Future<void> initializePeerConnection() async {

    peerConnection = await createPeerConnection(configuration);

    //----------------------------------------
    // ICE Candidate
    //----------------------------------------

    peerConnection!.onIceCandidate = (candidate) {

      debugPrint("LOCAL ICE GENERATED");

      onIceCandidate?.call(candidate);

    };

    //----------------------------------------
    // Remote Track
    //----------------------------------------

    peerConnection!.onTrack = (event) {

      debugPrint("REMOTE TRACK");

      if (event.streams.isNotEmpty) {

        onRemoteStream?.call(event.streams.first);

      }

    };

    //----------------------------------------
    // Connection State (Debug)
    //----------------------------------------

    peerConnection!.onConnectionState = (state) {

      debugPrint("Connection State : $state");

    };

    //----------------------------------------
    // ICE Connection State (Debug)
    //----------------------------------------

    peerConnection!.onIceConnectionState = (state) {

      debugPrint("ICE State : $state");

    };

  }

  Future<void> addLocalStream(MediaStream stream) async {

    localStream = stream;

    for (final track in stream.getTracks()) {

      await peerConnection!.addTrack(track, stream);

    }

  }

  Future<RTCSessionDescription> createOffer() async {

    final offer = await peerConnection!.createOffer();

    await peerConnection!.setLocalDescription(offer);

    return offer;

  }

  Future<RTCSessionDescription> createAnswer() async {

    final answer = await peerConnection!.createAnswer();

    await peerConnection!.setLocalDescription(answer);

    return answer;

  }

  Future<void> setRemoteDescription(
      RTCSessionDescription description,
      ) async {

    await peerConnection!.setRemoteDescription(description);

  }

  Future<void> addIceCandidate(
      RTCIceCandidate candidate,
      ) async {

    await peerConnection!.addCandidate(candidate);

  }

  void dispose() {

    peerConnection?.close();

    peerConnection = null;

  }

}