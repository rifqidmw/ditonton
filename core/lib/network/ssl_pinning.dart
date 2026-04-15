import 'dart:io';

import 'package:core/constants/api_constants.dart';
import 'package:flutter/services.dart';

class SslPinning {
  static const String _certificatePath = 'assets/certificates/moviedb.pem';

  static late HttpClient client;

  static Future<HttpClient> createPinnedHttpClient() async {
    final certBytes = await rootBundle.load(_certificatePath);

    final sc = SecurityContext(withTrustedRoots: false)
      ..setTrustedCertificatesBytes(certBytes.buffer.asUint8List());

    client = HttpClient(context: sc)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;

    return client;
  }

  static Future<bool> check({HttpClient? httpClient}) async {
    final http = httpClient ?? await createPinnedHttpClient();
    final shouldClose = httpClient == null;
    try {
      final request = await http.headUrl(Uri.parse(ApiConstants.baseUrl));
      final response = await request.close();
      await response.drain<void>();
      if (shouldClose) http.close();
      return true;
    } catch (_) {
      if (shouldClose) http.close();
      return false;
    }
  }
}
