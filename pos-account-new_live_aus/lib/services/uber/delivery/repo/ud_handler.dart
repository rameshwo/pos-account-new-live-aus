// import 'dart:convert';
// import 'dart:io';

// import 'package:oktoast/oktoast.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/repository/repo_v2.dart';

// import '../model/com/deli_res_error.dart';
// import '../model/delivery/create_deli_req.dart';
// import '../model/delivery/create_deli_res.dart';
// import '../model/delivery/create_quote_req.dart';
// import '../model/delivery/create_quote_res.dart';
// import '../model/delivery/delivery_list.dart';
// import '../model/organization/create_org.dart';
// import '../model/organization/invite_to_org_req.dart';
// import '../model/organization/invite_to_org_res.dart';
// import '../model/delivery/proof_deli_req.dart';
// import '../model/token_res.dart';
// import '../model/delivery/update_deli_req.dart';
// import 'ud_api.dart';
// import 'ud_shared_pref.dart';

// class UberDeliveryHandler {
//   // keys
//   // static String customerId = "794ce7ef-320f-5321-90f8-e370c3d08ebd";
//   // static String clientId = "sdhaVk3ATG7jVqHXvdPvv974lAOhb1B8";
//   // static String clientSecret = "uXDeP5poWfd90tLFcVlk18xKEaSs9qn1wW2KJZE3";
//   // static String grantType = "client_credentials";
//   // static String scope = "eats.deliveries direct.organizations";

//   //handlers

//   static Future<String?> get getToken async => await UberDeliSharedPref.token;

//   static Future<Map<String, String>?> get _header async {
//     final _token = await UberDeliSharedPref.token;
//     final Map<String, String> _head = {
//       "Authorization": "Bearer $_token",
//     };

//     return _head;
//   }

//   static void _showError(String body) {
//     final _error = DeliResError.fromJson(json.decode(body));
//     String _errMessage = _error.message ?? '';

//     if (_error.metadata?.keys.isNotEmpty ?? false) {
//       final _val = _error.metadata?.values.first;
//       if (_val is String) _errMessage = _val;
//     }
//     showToast(_errMessage);
//   }

//   static Future<bool> setToken() async {
//     final _body = {
//       "client_id": clientId,
//       "client_secret": clientSecret,
//       "grant_type": grantType,
//       "scope": scope,
//     };

//     try {
//       final _res = await RepoV2.post(
//         h: {
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//         url: UberDeliveryApi.tokenUrl,
//         body: _body,
//       );

//       if (_res.statusCode == 200) {
//         final _data = UberDeliTokenRes.fromJson(json.decode(_res.body));
//         UberDeliSharedPref.setToken = _data.accessToken;
//         showToast("Success");

//         return true;
//       } else {
//         final _error = UberDeliTokenResError.fromJson(json.decode(_res.body));
//         showToast(_error.errorDescription ?? '');
//       }
//     } on SocketException catch (_) {
//       showToast(LN.noInternetConnection);
//     } on FormatException catch (_) {
//       showToast(LN.tryAgainAfterTime);
//     } catch (e) {
//       // print(e.toString());
//     }

//     return false;
//   }

//   static Future<CreateQuoteRes?> createQuote(
//       {required CreateQuoteReq req}) async {
//     try {
//       final _res = await RepoV2.post(
//           h: await _header,
//           url: UberDeliveryApi.createQuote(customerId),
//           body: json.encode(req.toJson()));

//       if (_res.statusCode == 200) {
//         final _data = CreateQuoteRes.fromJson(json.decode(_res.body));
//         return _data;
//       } else {
//         _showError(_res.body);
//       }
//     } on SocketException catch (_) {
//       showToast(LN.noInternetConnection);
//     } on FormatException catch (_) {
//       showToast(LN.tryAgainAfterTime);
//     } catch (e) {
//       // print(e.toString());
//     }

//     return null;
//   }

//   static Future<CreateDeliveryRes?> createDelivery(
//       {required CreateDeliveryReq req}) async {
//     try {
//       final _res = await RepoV2.post(
//           h: await _header,
//           url: UberDeliveryApi.createDelivery(customerId),
//           body: json.encode(req.toJson()));

//       if (_res.statusCode == 200) {
//         final _data = CreateDeliveryRes.fromJson(json.decode(_res.body));
//         return _data;
//       } else {
//         _showError(_res.body);
//       }
//     } on SocketException catch (_) {
//       showToast(LN.noInternetConnection);
//     } on FormatException catch (_) {
//       showToast(LN.tryAgainAfterTime);
//     } catch (e) {
//       showToast(LN.somethingWentWrong);
//       // print(e.toString());
//     }

//     return null;
//   }

//   static Future<DeliveryListRes?> deliveryList({
//     required String status,
//     int limit = 10,
//     int offset = 1,
//   }) async {
//     try {
//       final _res = await RepoV2.get(
//           h: await _header,
//           url: UberDeliveryApi.listDelivery(customerId,
//               status: status, limit: limit, offset: offset));

//       if (_res.statusCode == 200) {
//         final _data = DeliveryListRes.fromJson(json.decode(_res.body));
//         return _data;
//       } else {
//         _showError(_res.body);
//       }
//     } on SocketException catch (_) {
//       showToast(LN.noInternetConnection);
//     } on FormatException catch (_) {
//       showToast(LN.tryAgainAfterTime);
//     } catch (e) {
//       // print(e.toString());
//     }

//     return null;
//   }

//   static Future<CreateDeliveryRes?> updateDelivery({
//     required UpdateDeliverytReq req,
//     required String deliveryId,
//   }) async {
//     try {
//       final _res = await RepoV2.post(
//           h: await _header,
//           url: UberDeliveryApi.getOrUpdateDelivery(customerId, deliveryId),
//           body: json.encode(req.toJson()));

//       if (_res.statusCode == 200) {
//         final _data = CreateDeliveryRes.fromJson(json.decode(_res.body));
//         return _data;
//       } else {
//         _showError(_res.body);
//       }
//     } on SocketException catch (_) {
//       showToast(LN.noInternetConnection);
//     } on FormatException catch (_) {
//       showToast(LN.tryAgainAfterTime);
//     } catch (e) {
//       // print(e.toString());
//     }

//     return null;
//   }

//   static Future<CreateDeliveryRes?> getDelivery({
//     required String deliveryId,
//   }) async {
//     try {
//       final _res = await RepoV2.get(
//           h: await _header,
//           url: UberDeliveryApi.getOrUpdateDelivery(customerId, deliveryId));

//       if (_res.statusCode == 200) {
//         final _data = CreateDeliveryRes.fromJson(json.decode(_res.body));
//         return _data;
//       } else {
//         _showError(_res.body);
//       }
//     } on SocketException catch (_) {
//       showToast(LN.noInternetConnection);
//     } on FormatException catch (_) {
//       showToast(LN.tryAgainAfterTime);
//     } catch (e) {
//       // print(e.toString());
//     }

//     return null;
//   }

//   static Future<UpdateDeliverytReq?> cancelDelivery({
//     required String deliveryId,
//   }) async {
//     try {
//       final _res = await RepoV2.post(
//           h: await _header,
//           url: UberDeliveryApi.cancelDelivery(customerId, deliveryId),
//           body: null);

//       if (_res.statusCode == 200) {
//         final _data = UpdateDeliverytReq.fromJson(json.decode(_res.body));
//         return _data;
//       } else {
//         _showError(_res.body);
//       }
//     } on SocketException catch (_) {
//       showToast(LN.noInternetConnection);
//     } on FormatException catch (_) {
//       showToast(LN.tryAgainAfterTime);
//     } catch (e) {
//       // print(e.toString());
//     }

//     return null;
//   }

//   static Future<ProofDeliverytRes?> proofDelivery({
//     required String deliveryId,
//     required ProofDeliverytReq req,
//     String? imagePath,
//   }) async {
//     try {
//       final _res = await RepoV2.postFile(
//           h: await _header,
//           url: UberDeliveryApi.proofDelivery(customerId, deliveryId),
//           body: req.toJson(),
//           fileList: [imagePath]);

//       if (_res.statusCode == 200) {
//         final _data = ProofDeliverytRes.fromJson(json.decode(_res.body));
//         return _data;
//       } else {
//         _showError(_res.body);
//       }
//     } on SocketException catch (_) {
//       showToast(LN.noInternetConnection);
//     } on FormatException catch (_) {
//       showToast(LN.tryAgainAfterTime);
//     } catch (e) {
//       // print(e.toString());
//     }

//     return null;
//   }

//   static Future<CreateOrg?> createOrg({
//     required CreateOrg req,
//   }) async {
//     try {
//       final _res = await RepoV2.post(
//         h: await _header,
//         url: UberDeliveryApi.organization,
//         body: json.encode(req.toJson()),
//       );

//       if (_res.statusCode == 200) {
//         final _data = CreateOrg.fromJson(json.decode(_res.body));
//         return _data;
//       } else {
//         _showError(_res.body);
//       }
//     } on SocketException catch (_) {
//       showToast(LN.noInternetConnection);
//     } on FormatException catch (_) {
//       showToast(LN.tryAgainAfterTime);
//     } catch (e) {
//       // print(e.toString());
//     }

//     return null;
//   }

//   static Future<CreateOrg?> getOrg() async {
//     try {
//       final _res = await RepoV2.get(
//         h: await _header,
//         url: UberDeliveryApi.getOrganization(customerId),
//       );

//       if (_res.statusCode == 200) {
//         final _data = CreateOrg.fromJson(json.decode(_res.body));
//         return _data;
//       } else {
//         _showError(_res.body);
//       }
//     } on SocketException catch (_) {
//       showToast(LN.noInternetConnection);
//     } on FormatException catch (_) {
//       showToast(LN.tryAgainAfterTime);
//     } catch (e) {
//       // print(e.toString());
//     }

//     return null;
//   }

//   static Future<InviteToOrgRes?> inviteToOrg({
//     required InviteToOrg req,
//   }) async {
//     try {
//       final _res = await RepoV2.post(
//         h: await _header,
//         url: UberDeliveryApi.inviteToOrg(customerId),
//         body: json.encode(req.toJson()),
//       );

//       if (_res.statusCode == 200) {
//         final _data = InviteToOrgRes.fromJson(json.decode(_res.body));
//         return _data;
//       } else {
//         _showError(_res.body);
//       }
//     } on SocketException catch (_) {
//       showToast(LN.noInternetConnection);
//     } on FormatException catch (_) {
//       showToast(LN.tryAgainAfterTime);
//     } catch (e) {
//       // print(e.toString());
//     }

//     return null;
//   }
// }
