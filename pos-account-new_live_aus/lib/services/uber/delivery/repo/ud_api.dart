// class UberDeliveryApi {
//   // base url
//   static const String baseurl = "https://api.uber.com/v1/";

//   // get token using curl
//   static const String tokenUrl = "https://auth.uber.com/oauth/v2/token";

//   // uber direct api
//   static String createQuote(String cusId) =>
//       baseurl + "customers/$cusId/delivery_quotes";

//   static String createDelivery(String cusId) =>
//       baseurl + "customers/$cusId/deliveries";

//   static String listDelivery(
//     String cusId, {
//     required String status,
//     int limit = 10,
//     int offset = 1,
//   }) =>
//       baseurl +
//       "customers/$cusId/deliveries?filter=$status&limit=$limit&offset=$offset";

//   static String getOrUpdateDelivery(String cusId, String deliveryId) =>
//       baseurl + "customers/$cusId/deliveries/$deliveryId";

//   static String cancelDelivery(String cusId, String deliveryId) =>
//       baseurl + "customers/$cusId/deliveries/$deliveryId/cancel";

//   static String proofDelivery(String cusId, String deliveryId) =>
//       baseurl + "customers/$cusId/deliveries/$deliveryId/proof-of-delivery";

//   // uber organization api
//   static const String organization = baseurl + "direct/organizations";
//   static String getOrganization(String cusId) =>
//       baseurl + "direct/organizations/$cusId";
//   static String inviteToOrg(String cusId) =>
//       baseurl + "direct/organizations/$cusId/memberships/invite";
// }
