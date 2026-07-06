class MxPairResponse {
  MxPairData? data;

  MxPairResponse({
    this.data,
  });

  factory MxPairResponse.fromJson(Map<String, dynamic> json) => MxPairResponse(
        data: json["data"] == null ? null : MxPairData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class MxPairData {
  String? pairingId;
  String? keyId;
  String? confirmationCode;
  String? signingSecretPartB;
  String? sciApiBaseUrl;
  String? tid;
  String? pairingNickname;
  String? terminalNickname;

  MxPairData({
    this.pairingId,
    this.keyId,
    this.confirmationCode,
    this.signingSecretPartB,
    this.sciApiBaseUrl,
    this.tid,
    this.pairingNickname,
    this.terminalNickname,
  });

  factory MxPairData.fromJson(Map<String, dynamic> json) => MxPairData(
        pairingId: json["pairing_id"],
        keyId: json["key_id"],
        confirmationCode: json["confirmation_code"],
        signingSecretPartB: json["signing_secret_part_b"],
        sciApiBaseUrl: json["sci_api_base_url"],
        tid: json["tid"],
        pairingNickname: json["pairing_nickname"],
        terminalNickname: json["terminal_nickname"],
      );

  Map<String, dynamic> toJson() => {
        "pairing_id": pairingId,
        "key_id": keyId,
        "confirmation_code": confirmationCode,
        "signing_secret_part_b": signingSecretPartB,
        "sci_api_base_url": sciApiBaseUrl,
        "tid": tid,
        "pairing_nickname": pairingNickname,
        "terminal_nickname": terminalNickname,
      };
}


// {
//     "data": {
//         "pairing_id": "pid_803848c5-d8d3-4c92-9c45-2eeeb064c5ad",
//         "key_id": "kid_c24e5c39-2454-492a-89d3-51697095ef71",
//         "confirmation_code": "3796",
//         "signing_secret_part_b": "558c6da5fac2f056cc049891be2ec44f",
//         "sci_api_base_url": "https://sci-api.geckobank.io",
//         "tid": "30118002",
//         "pairing_nickname": "",
//         "terminal_nickname": "terminal 30118002"
//     }
// }

// {
//   "integrationPlatFormId": "18c179fa-f091-4c93-8267-bd551a39ddbc",
//   "integrationPlatFormName": "MX",
//   "integrationPlatformConnectionCredentials": [
//     {
//       "id": "895d68a0-dd43-4ea6-d7e5-08ddf12332c0",
//       "name": "ter", // nickname // show
//       "customerId": "", //sci_api_base_url //hide
//       "keyOrId": "", //key_id  //hide
//       "secret": "", //secretKeyA+secretKeyB 
//       "serialNumber": "test_pak_y3ahjZVfTBS5nE4vdXgxAw==",
//       "posNameOrId": "Pixel C-ter",
//       "currency": "AUD",
//       "isDefault": false,
//       "posDeviceId": "b1b49b25-55e3-43d4-c638-08ddf120e6e1",
//       "merchantName": null,
//       "merchantType": null
//     }
//   ]
// }