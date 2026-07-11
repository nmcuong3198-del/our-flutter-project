import 'package:flutter/cupertino.dart';

import '../models/device_register_request.dart';
import 'api_service.dart';

class DeviceService {
  DeviceService._();

  static Future<void> registerDevice(
      DeviceRegisterRequest request,
      ) async {

    try {

      final response = await ApiService.post(
        "/device/register",
        request.toJson(),
      );

      if (response.statusCode == 200) {

        debugPrint("Device registered successfully.");

      } else {

        debugPrint(
          "Register device failed: ${response.body}",
        );

      }

    } catch (e) {

      debugPrint(
        "Register device error: $e",
      );

    }

  }
}