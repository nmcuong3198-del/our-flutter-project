import 'websocket_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class SignalingService {

  final WebSocketService socket;

  SignalingService(this.socket);

  //----------------------------------
  // REGISTER
  //----------------------------------

  void register(String userId) {

    socket.send({

      "type": "REGISTER",

      "userId": userId,

    });

  }

  //----------------------------------
  // OFFER
  //----------------------------------

  void offer({

    required String from,

    required String to,

    required String sdp,

    required String descriptionType,

  }) {
    debugPrint("SEND OFFER");
    debugPrint("FROM : $from");
    debugPrint("TO   : $to");

    socket.send({

      "type": "OFFER",

      "from": from,

      "to": to,

      "sdp": sdp,

      "descriptionType": descriptionType,
    });

  }

  void answer({

    required String from,

    required String to,

    required String sdp,

    required String descriptionType,

  }) {

    socket.send({

      "type": "ANSWER",

      "from": from,

      "to": to,

      "sdp": sdp,

      "descriptionType": descriptionType,
    });

  }

  //----------------------------------
  // ICE
  //----------------------------------

  void ice({

    required String from,

    required String to,

    required String candidate,

    required String sdpMid,

    required int sdpMLineIndex,

  }) {

    socket.send({

      "type": "CANDIDATE",

      "from": from,

      "to": to,

      "candidate": candidate,

      "sdpMid": sdpMid,

      "sdpMLineIndex": sdpMLineIndex,

    });

  }

  //----------------------------------
  // HANGUP
  //----------------------------------

  void hangup({

    required String from,

    required String to,

  }) {

    socket.send({

      "type": "HANGUP",

      "from": from,

      "to": to,

    });

  }

}