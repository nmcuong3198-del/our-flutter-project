class SignalMessage {

  final String type;

  final String? from;

  final String? to;

  final String? sdp;

  final String? candidate;

  final String? sdpMid;

  final int? sdpMLineIndex;

  SignalMessage({

    required this.type,

    this.from,

    this.to,

    this.sdp,

    this.candidate,

    this.sdpMid,

    this.sdpMLineIndex,

  });

  Map<String,dynamic> toJson(){

    return{

      "type":type,

      "from":from,

      "to":to,

      "sdp":sdp,

      "candidate":candidate,

      "sdpMid":sdpMid,

      "sdpMLineIndex":sdpMLineIndex

    };

  }

}