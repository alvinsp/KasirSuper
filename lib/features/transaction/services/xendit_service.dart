import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kasirsuper/app/config.dart';
import 'package:kasirsuper/core/core.dart';

class XenditService {
  XenditService._();

  static Dio get dio {
    return Dio()
      ..interceptors.addAll([
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      ])
      ..options = BaseOptions(
        baseUrl: 'https://api.xendit.co',
        headers: {
          'api-version': '2022-07-31',
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${AppConfig.xenditKey}:'))}'
        },
      );
  }

  static Future<(String qrId, String qrString)> createQR({
    required String referenceId,
    required num amount,
  }) async {
    try {
      final response = await dio.post('/qr_codes', data: {
        "reference_id": referenceId,
        "type": "DYNAMIC",
        "currency": "IDR",
        "amount": amount
      });

      return ('${response.data['id']}', '${response.data['qr_string']}');
    } catch (e, stack) {
      CrashlyticsHelper.capture(e, stack);
      throw ErrorDescription(e.toString());
    }
  }

  static Future<TypeEnum> cekQR(String qrId) async {
    try {
      final response = await dio.get('/qr_codes/$qrId/payments');

      final results = List.from(response.data['data']);

      final status = results.map((e) => e['status'] == 'COMPLETED').isNotEmpty;

      if (status) {
        return TypeEnum.paid;
      } else {
        return TypeEnum.unpaid;
      }
    } catch (e, stack) {
      CrashlyticsHelper.capture(e, stack);
      throw ErrorDescription(e.toString());
    }
  }
}
