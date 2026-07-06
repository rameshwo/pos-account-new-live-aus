enum Enviroment { UAT, PROD }

abstract class AppEnviro {
  static late String baseUrlPos;
  static late String baseUrlMenu;
  static late String adminUrl;
  static late String socketUrl;

  static late String title;
  static late Enviroment _enviroment;
  static Enviroment get enviroment => _enviroment;

  /// eftpos url
  static late String eftposPay;

  static Future<void> setupEnv(Enviroment env) async {
    _enviroment = env;
    switch (env) {
      case Enviroment.UAT:
        {
          baseUrlPos = _BaseUrl._BASE_URL_UAT_POS;
          baseUrlMenu = _BaseUrl._BASE_URL_UAT_MENU;
          // eftposPay = _BaseUrl._EFTPOS_DEV;
          socketUrl = _BaseUrl._SOCKET_URL_UAT;
          adminUrl = _BaseUrl._ADMIN_URL_UAT;
          title = 'Pos user testing';
          break;
        }
      case Enviroment.PROD:
        {
          baseUrlPos = _BaseUrl._BASE_URL_LIVE_POS;
          baseUrlMenu = _BaseUrl._BASE_URL_LIVE_MENU;
          // eftposPay = _BaseUrl._EFTPOS_PROD;
          socketUrl = _BaseUrl._SOCKET_URL_PROD;
          adminUrl = _BaseUrl._ADMIN_URL_LIVE;
          title = 'Pos production';
          break;
        }
    }
  }
}

class _BaseUrl {
  // base Url

  // UAT
  static const String _BASE_URL_UAT_POS = "https://uathposapi.posapt.au/api/";
  static const String _BASE_URL_UAT_MENU = "https://uatadminapi.posapt.au/api/";
  static const String _ADMIN_URL_UAT = "https://uatapp.posapt.au/";

  // LIVE
  static const String _BASE_URL_LIVE_POS =
      "https://hposapi.posapt.au/api/"; // "https://posapi.posapt.com/api/";
  static const String _BASE_URL_LIVE_MENU =
      "https://adminapi.posapt.au/api/"; // "https://adminapi.posapt.com/api/";
  static const String _ADMIN_URL_LIVE = "https://app.posapt.au/";

  // static const String _EFTPOS_DEV = "https://merchant.posapt.au/";
  // // "https://developmx51.posapt.au/";

  // static const String _EFTPOS_PROD = "https://merchant.posapt.au/";

// SOCKET
  static const String _SOCKET_URL_UAT = "https://uathubapi.posapt.au/poshub";
  static const String _SOCKET_URL_PROD = "https://hubapi.posapt.au/poshub";

  // MX Base Url
  //  static const String _MX_TEST_BASE_URL = "https://posapi.posapt.com/api/";
  // static const String _MX_LIVE_BASE_URL = "https://adminapi.posapt.com/api/";
}
