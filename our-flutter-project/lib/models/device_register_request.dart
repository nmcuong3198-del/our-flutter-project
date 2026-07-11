class DeviceRegisterRequest {
  final String? username;
  final String fcmToken;
  final String deviceType;

  DeviceRegisterRequest({
    required this.username,
    required this.fcmToken,
    required this.deviceType,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "fcmToken": fcmToken,
      "deviceType": deviceType,
    };
  }
}