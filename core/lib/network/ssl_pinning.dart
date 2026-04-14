import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class SslPinning {
  static const List<String> _allowedSHAFingerprints = [
    'C6:DB:AE:4D:C2:83:2C:FD:4E:63:FF:88:E9:50:42:6C:62:41:E3:C7:84:26:CF:2D:4D:D1:25:FE:97:EE:B8:C7',
  ];

  static Future<bool> check() async {
    try {
      final result = await HttpCertificatePinning.check(
        serverURL: 'https://api.themoviedb.org',
        headerHttp: {},
        sha: SHA.SHA256,
        allowedSHAFingerprints: _allowedSHAFingerprints,
        timeout: 60,
      );
      return result.contains('CONNECTION_SECURE');
    } catch (_) {
      return false;
    }
  }
}
