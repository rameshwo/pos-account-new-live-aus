part of 'windcave_handler.dart';

class WindcaveApi {
  static bool get _isSandbox =>
      AppEnviro.enviroment != Enviroment.PROD || kDebugMode;

  static const String usernameStatic = "POSApt_REST_Dev";
  static const String keyStatic =
      "587d4c5b63429a691d8ad455ab424fd4d03d5e3e30b2e564a280809b1d61ce55";
  static const String stationStatic = "3828991549";

  static String get _BASE_URL =>
      "https://${_isSandbox ? 'uat' : 'sec'}.windcave.com/hit/pos.aspx";

  //api list

  // static String get _PIN_PAIRING => _BASE_URL + "pairing/cloudpos";
}
