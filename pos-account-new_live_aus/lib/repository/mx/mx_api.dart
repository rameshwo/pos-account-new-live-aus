// import 'package:flutter/foundation.dart';
// import 'package:pos_account/env.dart';

class MxApi {
  ///[POSApt]
  // static const String posUsername = "POSApt_dev_key";

  static const String posApiKey =
      "live_pak_LdT1anwMS1OFq9dpNv3hXg=="; // "test_pak_y3ahjZVfTBS5nE4vdXgxAw==";

  static const String posSecretKeyA =
      "8ef1f8f3494bd1d5560da784dfd8b035"; // "769d696fbac113d533eacfe9650cb5d8";

  // static const String posOrgId = "p:8839397c-3fb5-4d69-b9fc-52679f8511aa";

  ///[POS_KIOSK]
  /// // static const String kioskUsername ="POSApt_Kiosk_live_key";// "POSApt_Kiosk_dev_key";

  static const String kioskApiKey =
      "live_pak_dQgqsDWDQ6SjSFaiXGYc8Q=="; // "test_pak_WC5GYv76SeSJqWFKCjbbAQ==";

  static const String kioskSecretKeyA = "27c95cc5c7358412f836cbc062f3edf2";
  // "985a37fd587150c557686e7e87ab391f";

  // static const String kioskOrgId ="p:d2f2ae70-6c1c-4ef4-8aba-27d024c86502";// "p:8839397c-3fb5-4d69-b9fc-52679f8511aa";

  // static bool get _isSandbox =>
  //     AppEnviro.enviroment != Enviroment.PROD || kDebugMode;

  static const String pairUrl = "https://sci-pairing-api.integrations.mx51.io";

  static const String pairing = "/v1/progress-pairing";

  static const String unpair = "/v1/unpair";

  static const String pairingInfo = "/v1/pairing-info";

  static const String transaction = "/v1/transactions";

  static String getTransaction(String id) => "/v1/transactions/$id";

  // static String cancelTransaction(String id) => "/v1/transactions/$id/cancel";
}
