part of 'linkly_handler.dart';

class LinklyApi {
  static bool get _isSandbox => AppEnvironment.environment != Environment.PROD;

  static String get _BASE_URL =>
      _isSandbox ? _SANDBOX_BASE_URL : _PRODUCTION_BASE_URL;

  // base url and production url

  static const String _SANDBOX_BASE_URL =
      "https://auth.sandbox.cloud.pceftpos.com/v1/";
  static const String _PRODUCTION_BASE_URL =
      "https://auth.cloud.pceftpos.com/v1/";

  //api list

  static String get _PIN_PAIRING => "${_BASE_URL}pairing/cloudpos";
}
