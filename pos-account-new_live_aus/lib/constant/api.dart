part of 'package:pos_account/repository/handler.dart';

class Api {
  /* *************************** API ACCOUNT *************************** */

  // static final String _baseUrlAccount = AppEnviro.baseUrlAccount;

  // account login
  static final String _LOGIN = "${_baseUrlPos}account/login";
  static final String _SENT_OTP_MAIL =
      "${_baseUrlPos}account/sendOtpCodeToEmail2FA";
  static final String _VALIDATE_OTP_MAIL =
      "${_baseUrlPos}account/validateOtpCodeToEmail2FA";
  static final String _VALIDATE_2FA_QR = "${_baseUrlPos}account/validate2faQr";
  static final String _ACTIVATE_STORE = "${_baseUrlPos}account/activateStore";
  static final String _CHANGE_PASS = "${_baseUrlPos}account/changePassword";
  static final String _FORGOT_PASS =
      "${_baseUrlPos}account/sendForgotPasswordChangeLink";
  static final String _DEVICE_ID_SEND_EMAIL =
      "${_baseUrlPos}account/deviceIdentifierSendToEmail";
  static final String _LOGIN_WITH_CODE = "${_baseUrlPos}account/login";
  static final String _GET_ACCESS_TOKEN_WITH_REFRESH_TOKEN =
      "${_baseUrlPos}account/getAccessTokenWithRefreshToken";
  static final String _VALIDATE_LOGIN_PINCODE =
      "${_baseUrlPos}account/validateLoginPinCode";
  static final String _GET_USER_STORES = "${_baseUrlPos}account/getUserStores";
  static final String _GET_USER_STORE_DETAIL =
      "${_baseUrlPos}account/getUserStoreDetail";
  // static final String _GET_DEVICE_DETAIL_BY_ID =
  //     "${_baseUrlPos}device/getDeviceDetailByIdentifier";
  static final String _TAG_FCM_TOKEN =
      "${_baseUrlPos}device/tagFcmTokenToDevice";
  // static final String _CONFIGURE_DEVICE_SEC_LIST =
  //     "${_baseUrlPos}device/configureDeviceSectionList";
  static final String _CONFIGURE_DEVICE =
      "${_baseUrlPos}device/configureDevice";

  //User Permission API
  static final String _GET_ALL_USER_PER =
      "${_baseUrlPos}account/getAllLoggedInUserPermissionMobile";

  //screen lock banners
  static final String _SCREEN_LOCK_BANNER_LIST =
      "${_baseUrlPos}account/getAllLockScreenBannerList";

  //profile
  static final String _ENDIS2FA = "${_baseUrlPos}account/enableDisable2FA";
  static String _GET_USER_B_ID(String id) =>
      "${_baseUrlPos}account/getUserById/$id";

  static final String _ADD_UP_USER = "${_baseUrlPos}account/createUpdateUser";

  // static final String _GET_ALL_USERS = "${_baseUrlPos}account/getAllUsers";

  //generate text
  static final String _GENERATE_PASSWORD =
      "${_baseUrlPos}account/generateRandomPassword";
  static final String _GENERATE_PIN =
      "${_baseUrlPos}account/generateLoginPinCode";

/* *************************** API POS *************************** */

  static final String _baseUrlPos = AppEnvironment.baseUrlPos;

  // static final String _COUNTRY_LIST_4_BASEURL = _baseUrlPos + "common/listCountryWithBaseUrl";
  // static final String _CHECK_API_STATUS = _baseUrlPos + "home/checkapistatus";

  static final String _DEVICE_ID_SEND_EMAIL_COMMON =
      "${_baseUrlPos}common/deviceIdentifierSendToEmail";

  //register user
  static final String _REGISTER_USER = "${_baseUrlPos}onboard/onBoardUser";
  static final String _SEND_OTP_TO_EMAIL_FOR_REGISTER =
      "${_baseUrlPos}onboard/sendOtpCodeToEmailOnBoarding";
  static final String _REGISTER_ADD_SECTION =
      "${_baseUrlPos}onBoard/onBoardAddSectionList";
  static final String _GET_ASSIGN_SERVICE_ADD_SEC =
      "${_baseUrlPos}employee/assignEmployServiceItemsAddSectionList";

  static String _GET_ASSIGNED_SERVICE_ITEMS(String empId) =>
      "${_baseUrlPos}employee/getEmployeeServiceItemAssignDetails/$empId";

  static final String _ASSIGN_SERVICES =
      "${_baseUrlPos}employee/assignEmployServiceItems";

  static final String _ADD_REVIEW = "${_baseUrlPos}pos/makeReview";

  // place order
  // static final String _LIST_ORDER_TYPE = _baseUrlPos + "common/listorderType";
  // static final String _GET_ALL_POS_ORDER_SEC_LIST =
  //     "pos/getAllHospitalityPOSOrderScreenSectionList";
  static final String _PLACE_ORDER_OR_CHECK_OUT =
      "${_baseUrlPos}pos/placeOrderOrCheckOut";
  static final String _GET_DELIVERY_AMOUNT_BY_DIST =
      "${_baseUrlPos}delivery/getDeliveryAmountByDeliveryDistance";

  // retail place order
  // static final String _RETAIL_POS_ORDER =
  //     "pos/getAllRetailPOSOrderScreenSectionList";

  static final String _RETAIL_COMBO_CATS =
      "${_baseUrlPos}pos/getAllPOSOrderScreenComboCategories";
  static final String _RETAIL_INGRE_CATS =
      "${_baseUrlPos}pos/getAllPOSOrderScreenRawLooseCategories";

  // static final String _PROD_DETAIL_BY_BARCODE =
  //     "pos/getProductDetailsByBarCodeNumber";
  // static final String _COMBO_DETAIL_BY_BARCODE =
  //     "pos/getComboDetailsByBarCodeNumber";
  static final String _PRODUCT_DETAIL_BY_VAR_ID =
      "${_baseUrlPos}pos/getProductDetailsByProductVariationId";

  //place order pay section
  // static final String _GET_ALL_CUS_ADD_SEC_LIST =
  //     "customer/getAllCustomerAddSectionList";
  // static final String _POS_ORDER_PAY_SEC_LIST =
  //     "pos/posOrderPaymentSectionList";
  static final String _SEARCH_UNI_CODE =
      "${_baseUrlPos}payment/SearchUniqueCodeByPaymentMethodType";
  static final String _PLACE_ORDER_MAKE_PAYMENT =
      "${_baseUrlPos}payment/makepayment";
  static final String _CANCEL_ORDER_ITEM = "${_baseUrlPos}pos/cancelOrderItems";

  static final String _GET_CUS_DELIVERY_ADDRESS =
      "${_baseUrlPos}delivery/getCustomerDeliveryAddress";

  //orders section
  // static final String _GET_ORDER_DE_SEC_LIST =
  //     "pos/getAllPOSOrderDetailsSectionList";

  // static final String _BULK_ORDER_UPDATE = _baseUrlPos + "pos/bulkorderChangeStatus";

  static final String _TRACK_PRINT_STATUS =
      "${_baseUrlPos}pos/trackPrinterPrintingStatus";

// booking
  static final String _GET_TABLE_RESERV_NO =
      "${_baseUrlPos}booking/getBookingNumber";
  static final String _GET_ALL_TAB_RESV =
      "${_baseUrlPos}booking/getAllBookings";
  static final String _ADD_UP_TAB_RESV =
      "${_baseUrlPos}booking/createUpdateBooking";
  static final String _CONFIRM_TAB_RESV =
      "${_baseUrlPos}booking/confirmBooking";
  static final String _CANCEL_BOOKING =
      "${_baseUrlPos}booking/confirmCancelBooking";
  static String _EDIT_TABLE_RE(String id) =>
      "${_baseUrlPos}booking/editBooking/$id";
  static final String _ARRIVE_BOOKING =
      "${_baseUrlPos}booking/updateArrivalStatus";
  //slot
  static final String _GET_TABLE_BOOK_SLOT =
      "${_baseUrlPos}booking/getBookingSlots";

  static final String _GET_ALL_TABLE_LAY_ADD_SEC =
      "${_baseUrlPos}floorplan/getAllFloorPlanAddSectionList";
  static final String _GET_TABLE_STATUS =
      "${_baseUrlPos}floorplan/getFloorPlanTableStatus";
  static final String _UPDATE_TABLE_STATUS =
      "${_baseUrlPos}floorplan/updateTableStatus";
  static final String _GET_TABLE_RESERV_CALENDER =
      "${_baseUrlPos}floorplan/getTableReservationForCalander";
  // static final String _UPDATE_TABLE_STATUS_AVAI =
  //     "${_baseUrlPos}floorplan/updateTableStatusAvilable";
  static final String _SWITCH_TABLE = "${_baseUrlPos}floorplan/switchTable";
  static final String _MERGE_TABLE = "${_baseUrlPos}floorplan/mergeTable";
  static final String _CHECK_TABLE_STATUS =
      "${_baseUrlPos}floorplan/checkTableStatus";

//customer
  static final String _GET_ALL_CUS = "${_baseUrlPos}customer/getAllCustomer";
  // "pos/searchCustomerForLoyaltyDetails";
  static final String _SEARCH_CUS = "${_baseUrlPos}customer/searchCustomer";
  static final String _SEARCH_CUS_FOR_LOYALTY_QR =
      "${_baseUrlPos}pos/searchCustomerForLoyaltyPOSQrScan";
  static final String _SEARCH_CUS_FOR_LOYALTY_CUS_QR =
      "${_baseUrlPos}pos/searchCustomerForLoyaltyCustomerQrScan";

//activate pos device
  // static final String _ACTIVATE_POS_DEVICE =
  //     "${_baseUrlPos}BillingAndSubscription/activatePOSDevice";

//common
  // static final String _LIST_COUNTRY = _baseUrlPos + "common/listCountry";
  // static final String _COUNTRY_CITY_STATE = _baseUrlPos + "common/commonListCountryCityState";

//login screen banner
  static final String _LOGIN_BANNER =
      "${_baseUrlPos}common/getAllMobilePosLoginBannerList";

//punch in/out
  // static final String _GET_EM_PUNCH_DETAIL =
  //     "employee/getEmployeeTodayPunchInPunchOutDetail";
  // static final String _PUNCH_INOUT = _baseUrlPos + "employee/punchInPunchOut";

  //refund

  static final String _MAKE_REFUND = "${_baseUrlPos}payment/makeReFund";

  // recent phone calls
  static final String _ADD_RECENT_CALL = "${_baseUrlPos}pos/addRecentPhoneCall";
  static final String _GET_RECENT_CALLS = "${_baseUrlPos}pos/getAllRecentCalls";

  //EFTPOS Terminal Device Setting
  // static final String _EFT_POS_ADD_SEC =
  //     "posdevicesetting/getAllEFTPosTerminalDeviceSettingsAddSectionList";
  // static final String _ADD_UPP_EFT_POS_SET =
  //     "posdevicesetting/createUpdateEFTPosTerminalDeviceSettings";
  // static final String _GET_ALL_EFT_POS_DEVICES =
  //     "posdevicesetting/getAllEFTPosTerminalDeviceSettings";
  // static String _EDIT_EFT_POS_DEVICE(String id) =>
  //     "POSDeviceSetting/editEFTPosTerminalDeviceSettings/$id";
  // static final String _DELETE_EFT_POS_DEVICE =
  //     "POSDeviceSetting/deleteEFTPosDeviceSettings";

  static final String _POSOrderScreenCategories =
      "${_baseUrlPos}pos/getAllPOSOrderScreenCategories";
  // static final String _POSOrderScreenSectionList =
  //     "pos/getAllHospitalityPOSOrderScreenSectionList";
  static final String _POSOrderScreenComboProducts =
      "${_baseUrlPos}pos/getAllPOSOrderScreenComboProducts";
  static final String _POSOrderScreenRawLooseProducts =
      "${_baseUrlPos}pos/getAllPOSOrderScreenRawLooseProducts";

  // static final String _POS_CHANGE_STATUS =
  //     "datachangeTrack/getDataChangeStatus";

  // kitchen api
  // static final String _KDOrderAddSecList =
  //     "pos/getAllKitchenDisplaySearchSectionList";
  static final String _KDOrders =
      "${_baseUrlPos}pos/getAllKitchenDisplayOrders";
  static final String _KDOrderStatusUpdate =
      "${_baseUrlPos}pos/kitchenDisplayOrderChangeStatus";
  static final String _kDPriorOrder =
      "${_baseUrlPos}pos/kitchenDisplayPrioritizeOrder";
  static final String _kDOrderItemStatus =
      "${_baseUrlPos}pos/kitchenDisplayOrderItemChangeStatus";

  //delivery
  static final String _DELIVERY_CREATE =
      "${_baseUrlPos}delivery/createUberDelivery";
  // static final String _DELIVERY_STATUS_LIST =
  //     "delivery/getAllOrderTrackingStatusList";
  static final String _DELIVERY_ORDER_LIST =
      "${_baseUrlPos}delivery/getAllDeliveryTrackingOrders";
  static String _GET_DELIVERY_DETAIL(String id) =>
      "${_baseUrlPos}delivery/getOrderDeliveryTrackingById/$id";

  //services
  // static final String _SERVICE_DETAIL_ADD_SEC =
  //     "pos/getAllPOSServiceDetailsSectionList";

  //keypad
  static final String _GET_KEYPAD_ADD_SEC =
      "${_baseUrlPos}pos/getKeypadCheckoutAddSectionList";
  static final String _KEYPAD_CHECKOUT =
      "${_baseUrlPos}pos/keypadCheckoutPlaceOrder";
  // static final String _GET_KEYPAD_PRODUCTS =
  //     "pos/getAllVariablePriceProducts";

  //tab management
  static final String _GET_ALLORDER_TABLS = "${_baseUrlPos}tab/getAllOrderTabs";
  // static final String _GET_ORDER_TAB_SECTION =
  //     "pos/getAllOrderTabSectionList";
  static final String _CREATE_UP_ORDER_TAB =
      "${_baseUrlPos}tab/createUpdateOrderTab";
  static String _EDIT_ORDER_TAB(String id) =>
      "${_baseUrlPos}tab/editOrderTab/$id";
  static final String _COMP_ADD_SEC =
      "${_baseUrlPos}pos/posOrderComplimentaryAddSectionList";
  static final String _CANCEL_ORDER_TAB = "${_baseUrlPos}pos/cancelOrder";

  //promotions
  // static final String _GET_ALL_PROMOTIONS = _baseUrlPos + "promotion/getAllPOSPromotions";

  //signal R
  // static final String _POS_DEVICE_DETAIL_BY_ID =
  //     "device/getPosDeviceDetailByIdentifier";

  // employee shift
  static final String _GET_EMPLOYEE_BY_CODE =
      "${_baseUrlPos}Employee/getEmployeeByLoginPinCode";
  static final String _CHECK_SHIFT_STATUS =
      "${_baseUrlPos}Employee/checkShiftStatus";
  static final String _EMPLOYEE_CHECK_IN =
      "${_baseUrlPos}Employee/employeeCheckIn";
  static final String _EMPLOYEE_CHECK_OUT =
      "${_baseUrlPos}Employee/employeeCheckOut";
  static final String _EMPLOYEE_BREAK_START =
      "${_baseUrlPos}Employee/employeeStartBreak";
  static final String _EMPLOYEE_BREAK_END =
      "${_baseUrlPos}Employee/employeeEndBreak";

// windcave logs
  static final String _WINDCAVE_LOGS =
      "${_baseUrlPos}log/eftPosWindcaveMerchantLogs";

  // static final String _GET_DOCKET_IMAGE =
  //     "${_baseUrlPos}pos/getDocketRasterFormPostData";

  // static final String _GET_DOCKET_BYTE =
  //     "${_baseUrlPos}print/getDocketRasterByteData";

  /* *************************** DATA MENU *************************** */

  // static final String _baseUrlData = AppEnviro.baseUrlData;

  //synce data

  static final String _SYNC_HOS_DATA = "${_baseUrlPos}data/syncAllHPosData";
  static final String _SYNC_RETAIL_DATA = "${_baseUrlPos}data/syncAllRPosData";
  static final String _GET_ALL_PROMOTION =
      "${_baseUrlPos}promotion/getAllPromotions";
  static final String _SYNC_BRANDS = "${_baseUrlPos}data/getAllBrands";
  static final String _SYNC_MERCHANTS = "${_baseUrlPos}data/getAllMerchants";

  static final String _SYNC_POS_ORDER_TYPE =
      "${_baseUrlPos}data/getAllPosOrderTypes";
  static final String _SYNC_ORDERS_ORDER_TYPE =
      "${_baseUrlPos}data/getAllOrdersOrderTypes";

  static final String _SYNC_DOCKET_GRP =
      "${_baseUrlPos}data/getAllDocketGroups";
  static final String _SYNC_ORDER_ITEM_STATUS =
      "${_baseUrlPos}data/getAllOrderItemStatus";
  static final String _SYNC_DISCOUNTS = "${_baseUrlPos}data/getAllDiscounts";
  static final String _SYNC_CUS_GROUP =
      "${_baseUrlPos}data/getAllCustomerGroups";
  static final String _SYNC_NOTES = "${_baseUrlPos}data/getAllOrderNotes";

  static final String _SYNC_STORE_INFO =
      "${_baseUrlPos}data/getStoreInformation";
  // static final String _SYNC_STOCK_DEDUCT_INTO =
  //     "${_baseUrlPos}data/getStockDeductInformation";
  // static final String _SYNC_DELIVERY_INFO =
  //     "${_baseUrlPos}data/getdeliveryInformations";
  static final String _GET_TABLE_LOCATIONS =
      "${_baseUrlPos}data/getTableLocations";
  static final String _GET_ALL_POPULAR_PRODUCTS =
      "${_baseUrlPos}product/getAllPopularProducts";

  static final String _GET_STORE_CHARGE_INFO =
      "${_baseUrlPos}data/getStoreChargeInformation";

  //language
  static final String __GET_ALL_LANG_WIT_TRANS =
      "${_baseUrlPos}data/getAllLanguageWithTranslation";

  static final String _GET_ALL_MENUS = "${_baseUrlPos}data/getAllMenus";

  static final String _MENU_SCHEDULE =
      "${_baseUrlPos}schedule/getAllScheduleMenu";

  /* *************************** API PRODUCT *************************** */

  // static final String _baseUrlProduct = AppEnviro.baseUrlProduct;

  static final String _GET_ALL_HOS_POSORDER_PRODUCTS =
      "${_baseUrlPos}product/getAllHospitalityPOSOrderScreenProducts";

  static final String _RETAIL_POS_ORDER_PRODUCT =
      "${_baseUrlPos}product/getAllRetailPOSOrderScreenProducts";

  static String _SetMenuDetailsById(String id) =>
      "${_baseUrlPos}product/getSetMenuDetailsBySetMenuId/$id";

  static final String _GET_ALL_P_B_P =
      "${_baseUrlPos}product/getAllProductsByProductCategories"; // get all product by product category

  static final String _GET_ALL_PRO_SB_STORE =
      "${_baseUrlPos}product/getAllProductSearchByStore"; //get all product by store

  static final String _GET_RETAIL_POS_COMBO =
      "${_baseUrlPos}product/getAllComboProducts";

  /* *************************** API PRINT *************************** */

  // static final String _baseUrlPrint = AppEnviro.baseUrlPrint;

  static final String _PRINT_RECEIPT = "${_baseUrlPos}print/printReceipt";

  //pos invoice

  static final String _PRINT_EFTPOS_MERCHANT_LOGS =
      "${_baseUrlPos}print/printEftPosMxMerchantLogs"; // "order/printEftPosMerchantLogs";
  //

  static final String _POS_ORDER_SEND_KITCHEN_PRINTER =
      "${_baseUrlPos}print/posOrderSendToKitchenPrinter";
  static final String _POS_ORDER_SEND_KITCHEN =
      "${_baseUrlPos}print/posOrderSendToKitchen";
  // static final String _POS_ORDER_SEND_KITCHEN_DISPLAY =
  //     "${_baseUrlPos}print/posOrderSendToKitchenDisplay";
  static final String _POS_ORDER_PAY_INVOICE =
      "${_baseUrlPos}print/posOrderPaymentInvoicePrint";

  static final String _PRINT_SIG_RECEIPT =
      "${_baseUrlPos}print/PrintSignatureReceipt";

  static final String _CONFIRM_ON_ORDER_SEND_KITCHEN =
      "${_baseUrlPos}print/confirmOrderSendToKitchenPrinter";

  static final String _REFUND_INVOICE_PRINT =
      "${_baseUrlPos}print/posOrderRefundInvoicePrint";

  static final String _GET_INVOICE_PRINTER =
      "${_baseUrlPos}print/getPosInvoicePrinterDetails";
  static final String _GET_PRINT_DOCKET_SETUP =
      "${_baseUrlPos}data/getPrintDocketSetup";

  /* *************************** ORDER MENU *************************** */

  // static final String _baseUrlOrder = AppEnviro.baseUrlOrder;

  static final String _GET_CUS_ORDERS =
      "${_baseUrlPos}order/getAllCustomerOrders";
  // static String _GET_PAY_INVOICE_DETAIL(String orderId) =>
  //     "${_baseUrlPos}order/posOrderPaymentInvoiceDetails/$orderId";
  static final String _POS_IN_SEND_EMAIL =
      "${_baseUrlPos}email/paymentInvoiceSendEmail";

  static final String _EFTPOS_MERCHANT_LOGS =
      "${_baseUrlPos}log/eftPosMxMerchantInvoiceLogs";
  // auto print send to kitchen from online order
  static final String _POS_ONLINE_ORDER_SEND_KITCHEN =
      "${_baseUrlPos}order/getAllAutoSendToKitchenOrders";
  static final String _GET_ORDER_PRINT_STATUS =
      "${_baseUrlPos}order/getAllOrderKitchenPrintStatus";

  static final String _BULK_ORDER_SEND_KIT =
      "${_baseUrlPos}order/bulkOrderSendToKitchen";

  static final String _GET_ALL_ORDERS = "${_baseUrlPos}order/getAllOrders";
  static final String _ORDER_CHANGE_STATUS =
      "${_baseUrlPos}order/orderChangeStatus";
  static String _GET_OR_DETAILS(String id) =>
      "${_baseUrlPos}order/getOrderDetailsByOrderId/$id";
  static String _GET_OR_TRAN_DETAILS(String id) =>
      "${_baseUrlPos}order/getOrderTransactionDetail/$id";

  static final String _BULK_ACCEPT_ORDER =
      "${_baseUrlPos}order/bulkAcceptOrder";
  static final String _CHANGE_PAY_METHOD =
      "${_baseUrlPos}order/changePaymentMethod";

  static final String _REVOKE_ORDER = "${_baseUrlPos}order/revokeOrder";

  // sms send
  static String _GET_SMS_CUS_DETAILS(String id) =>
      "${_baseUrlPos}order/getSendSMSCustomerDetails/$id";
  static final String _SEND_ORDER_READY_SMS =
      "${_baseUrlPos}order/sendOrderReadySms";

  static String _GET_ORDER_ITEM_FLOOR(String id) =>
      "${_baseUrlPos}order/getOrderItemKitchenStatus/$id";

  static String _GET_ORDER_DETAIL_4_REFUND(String id) =>
      "${_baseUrlPos}order/getOrderDetailsByOrderIdForRefund/$id";

  static final String _GET_ALL_SERVICES = "${_baseUrlPos}order/getAllServices";

/* *************************** API MENU *************************** */

  static final String _baseUrlMenu = AppEnvironment.baseUrlMenu;

  //language
  static final String _CHANGE_LANG = "${_baseUrlMenu}store/changeLanguage";

  static String _GET_EMP_B_ID(String id) =>
      "${_baseUrlMenu}employee/editEmployee/$id";

  //user management

  static final String _GET_EMP_ADD_SEC =
      "${_baseUrlMenu}employee/getAllEmployeeAddSectionList";
  static final String _GET_ALL_EMPLOYEES =
      "${_baseUrlMenu}employee/getAllEmployeeList";
  static final String _ADD_UP_EMP =
      "${_baseUrlMenu}employee/createupdateEmployee";
  static final String _GET_COMM_ADD_SEC =
      "${_baseUrlMenu}employee/employeeServiceCommissionAddSectionList";
  static String _GET_COMM_DETAILS(String empId) =>
      "${_baseUrlMenu}employee/getEmployeeServiceCommissionDetails/$empId";
  static final String _ADD_UP_COMM_DETAILS =
      "${_baseUrlMenu}employee/createUpdateEmployServiceCommission";

  // sync
  static final String _SYNC_SEC_LIST = "${_baseUrlMenu}sync/syncSectionList";
  static final String _SYNC_PROD_FOOCTOOC =
      "${_baseUrlMenu}sync/syncProductFromOneChannelToOtherChannel";

  //category type
  static final String _GET_ALL_CAT_TYPE =
      "${_baseUrlMenu}settings/getAllCategoryType";
  static final String _GET_ALL_DIS_TYPE =
      "${_baseUrlMenu}settings/getAllDiscounts";
  static final String _ADD_UP_CAT_TYPE =
      "${_baseUrlMenu}settings/createUpdateCategoryType";
  static final String _ADD_UP_DIS =
      "${_baseUrlMenu}settings/createUpdateDiscount";
  // static String _EDIT_CAT_TYPE(String id) =>  _baseUrlPos + "settings/editCategoryType/$id";
  static final String _DELETE_CAT_TYPE =
      "${_baseUrlMenu}settings/deleteCategoryType";

  //product category
  static final String _ADD_UPDATE_PRODUCT_CAT =
      "${_baseUrlMenu}settings/createUpdateProductCategories";
  static final String _GET_PRODUCT_CATS =
      "${_baseUrlMenu}settings/getAllProductCategories";
  static final String _GET_PRODUCT_CATS_ADD_SEC_LIST =
      "${_baseUrlMenu}settings/getAllProductCategoriesAddSectionList";
  static final String _DELETE_PRODUCT_CATS =
      "${_baseUrlMenu}settings/deleteProductCategories";
  static String _EDIT_PROD_CATS(String id) =>
      "${_baseUrlMenu}settings/editProductCategories/$id";
  static final String _GET_ALL_PROD_PARENT_CATS =
      "${_baseUrlMenu}product/getAllProductParentCategories";
  static final String _GET_ALL_PROD_BY_PROD_CAT =
      "${_baseUrlMenu}product/getAllProductsByProductCategory";
  static final String _SORT_PROD_BY_CATS =
      "${_baseUrlMenu}inventory/getSortProductByCategory";
  static final String _UPDATE_SORT_PROD_BY_CATS =
      "${_baseUrlMenu}inventory/sortProductByCategory";
  static final String _UPLOAD_URL_S3 = "${_baseUrlMenu}upload/getS3UploadUrl";

  //product sub category
  static final String _ADD_UPDATE_SUB_CAT =
      "${_baseUrlMenu}settings/createUpdateProductSubCategories";
  static final String _GET_SUB_CAT =
      "${_baseUrlMenu}settings/getAllProductSubCategories";
  static final String _GET_SUB_CAT_ADD_SEC =
      "${_baseUrlMenu}settings/getAllProductSubCategoriesAddSectionList";
  static final String _DELETE_SUB_CAT =
      "${_baseUrlMenu}settings/deleteProductSubCategories";
  static String _EDIT_SUB_CAT(String id) =>
      "${_baseUrlMenu}settings/editProductSubCategories/$id";

  //product brands
  static final String _GET_PRODUCT_BRANDS =
      "${_baseUrlMenu}settings/getAllBrands";
  static final String _ADD_UPDATE_PRODUCT_BRAND =
      "${_baseUrlMenu}settings/createUpdateBrands";
  static final String _DELETE_PRODUCT_BRAND =
      "${_baseUrlMenu}settings/deleteBrands";
  static String _EDIT_BRAND(String id) =>
      "${_baseUrlMenu}settings/editBrand/$id";

  //setting
  static final String _GET_ALL_SETTING =
      "${_baseUrlMenu}settings/getAllSettings";

  //all tables location
  static final String _GET_ALL_TABLE_LOCATION =
      "${_baseUrlMenu}settings/getAllTableLocations";
  static final String _ADD_UPDATE_TABLE_LOCATION =
      "${_baseUrlMenu}settings/createUpdateTableLocations";
  static final String _DELETE_TABLE_LOCATION =
      "${_baseUrlMenu}settings/deleteTableLocations";

  //all tables
  static final String _GET_ALL_TABLES = "${_baseUrlMenu}settings/getAllTables";
  static final String _ADD_UPDATE_TABLES =
      "${_baseUrlMenu}settings/createUpdateTables";
  static final String _GET_ALL_TABLE_ADD_SEC_LIST =
      "${_baseUrlMenu}settings/getAllTablesAddSectionList";
  static final String _DELETE_TABLES = "${_baseUrlMenu}settings/deleteTables";
  static String _EDIT_TABLE(String id) =>
      "${_baseUrlMenu}settings/editTable/$id";
  static final String _GENERATE_QR =
      "${_baseUrlMenu}settings/generateQRForTable";
  static final String _GET_TABLE_QR = "${_baseUrlMenu}settings/getTableQRImage";

  //order types
  static final String _GET_ALL_ORDER_TYPE_ADD_SEC =
      "${_baseUrlMenu}settings/getAllOrderTypeAddSectionList";
  static final String _GET_ALL_ORDER_TYPES =
      "${_baseUrlMenu}settings/getAllOrderTypes";
  static final String _ADD_UP_ORDER_TYPES =
      "${_baseUrlMenu}settings/createUpdateOrderTypes";
  static String _EDIT_ORDER_TYPES(String id) =>
      "${_baseUrlMenu}settings/editOrderType/$id";
  static final String _DELETE_ORDER_TYPES =
      "${_baseUrlMenu}settings/deleteOrderType";

  //tax inclusive exclusive
  static final String _GET_TAX_ADD_SEC =
      "${_baseUrlMenu}settings/getAllTaxAddSectionList";
  static final String _GET_ALL_TAX_IE = "${_baseUrlMenu}settings/getAllTaxes";
  static final String _ADD_UP_TAX_IE =
      "${_baseUrlMenu}settings/createUpdateTax";
  static String _EDIT_TAX_IE(String id) =>
      "${_baseUrlMenu}settings/editTax/$id";
  static final String _DELETE_TAX_IE = "${_baseUrlMenu}settings/deleteTax";

  // Docket Group
  static final String _GET_ALL_DOCKET_GROUP =
      "${_baseUrlMenu}settings/getAllDocketGroup";
  static final String _ADD_UP_DOCKET_GROUP =
      "${_baseUrlMenu}settings/createUpdateDocketGroup";
  static String _EDIT_DOCKET_GROUP(String id) =>
      "${_baseUrlMenu}settings/editDocketGroup/$id";
  static String _GET_PRODUCT_TAG_DOCKET(String id) =>
      "${_baseUrlMenu}settings/getProductTaggedToDocketGroup/$id";
  static final String _TAG_PROD_TO_DOCKET =
      "${_baseUrlMenu}settings/tagProductToDocketGroup";

// Order Status Setting
  static final String _GET_ALL_ORDER_STATUS =
      "${_baseUrlMenu}settings/getAllOrderStatus";
  static final String _UPDATE_ORDER_STATUS =
      "${_baseUrlMenu}settings/updateOrderStatus";

  // pos printer setting
  static final String _GET_ALL_ASSIGNED_PRODUCT =
      "${_baseUrlMenu}Posdevicesetting/getAllPrinterProductVariations";
  static final String _GET_ALL_PRINTER =
      "${_baseUrlMenu}PosdeviceSetting/getAllStorePrinters";
  // static final String _GET_ALL_PRINTER_SETTINGS =
  //     "POSDeviceSetting/getAllPOSDeviceGeneralSettings";
  static final String _ADD_UP_PRINTER_SET =
      "${_baseUrlMenu}POSDeviceSetting/createUpdatePOSprinterSetUp";
  static final String _GET_PRINTER_DETAIL =
      "${_baseUrlMenu}POSDeviceSetting/getPrinterSetUpDetails";
  static final String _GET_PRINTER_ADD_SEC =
      "${_baseUrlMenu}POSDeviceSetting/getAllPOSPrinterSetUpSectionList";
  static final String _POS_PRINTER_ADD_SEC =
      "${_baseUrlMenu}POSDeviceSetting/getAllPosPrinterAddSectionList";
  // static final String _OPEN_CASH_REGISTER =
  //     "${_baseUrlMenu}POSDeviceSetting/openCashRegister";

  //pos printer department
  static final String _GET_ALL_DEPART =
      "${_baseUrlMenu}POSDeviceSetting/getAllDepartment";
  static final String _CREATE_UP_DEPART =
      "${_baseUrlMenu}POSDeviceSetting/createUpdateDepartment";
  // static String _EDIT_DEPART(String id) =>  _baseUrlPos + "POSDeviceSetting/editDepartment/$id";
  static final String _DELETE_DEPART =
      "${_baseUrlMenu}POSDeviceSetting/deleteDepartment";

  //pos printer location by department
  // static final String _GET_ALL_POS_LOC_BY_DEPART_LIST =
  //     "settings/getAllPOSPrinterLocationAddSectionList";
  static final String _GET_ALL_POS_PRINTER =
      "${_baseUrlMenu}POSDeviceSetting/getAllPOSPrinters";
  static final String _CREATE_UP_POS_PRINTER =
      "${_baseUrlMenu}POSDeviceSetting/createUpdatePOSPrinter";
  static String _EDIT_POS_PRINTER(String id) =>
      "${_baseUrlMenu}POSDeviceSetting/editPOSPrinter/$id";
  static final String _DELETE_POS_PRINTER =
      "${_baseUrlMenu}POSDeviceSetting/deletePOSPrinter";

  // quick notes
  static final String _GET_ALL_NOTES =
      "${_baseUrlMenu}settings/getAllOrderNotes";
  static final String _CREATE_UP_NOTES =
      "${_baseUrlMenu}settings/createUpdateOrderNote";
  // static String _EDIT_NOTES(String id) =>
  //     _baseUrlMenu + "settings/editOrderNote/$id";
  static final String _DELETE_NOTES = "${_baseUrlMenu}settings/deleteOrderNote";

  //POS Devices Settings

  static final String _POS_DEVICE_ADD_SEC =
      "${_baseUrlMenu}POSDeviceSetting/getAllPOSDevicesAddSectionList";
  static final String _GET_ALL_POS_DEVICES =
      "${_baseUrlMenu}POSDeviceSetting/getAllPOSDevices";
  static final String _ADD_UP_POS_DEVICE =
      "${_baseUrlMenu}POSDeviceSetting/createUpdatePosDevices";
  static String _EDIT_POS_DEVICE(String id) =>
      "${_baseUrlMenu}POSDeviceSetting/editPosDevice/$id";
  static final String _UPDATE_DEVICE_4_POS =
      "${_baseUrlMenu}POSDeviceSetting/updateDeviceForPOS";
  static final String _GENERATE_QR_FOR_POS =
      "${_baseUrlMenu}POSDeviceSetting/generateQRForPosDevice";
  // static final String _DELETE_POS_DEVICE = _baseUrlMenu + "POSDeviceSetting/deletePosDevice";

  // printer product
  static final String _GET_PRINTER_PROD_DETAILS =
      "${_baseUrlMenu}posdevicesetting/getPrinterProductPrintSetUpDetails";
  static final String _ADD_UP_PRINTER_PRODUCT =
      "${_baseUrlMenu}posdevicesetting/createUpdatePrinterProducts";

  //bar code settings
  static final String _BAR_CODE_ADD_SEC =
      "${_baseUrlMenu}settings/getAllBarCodeTypeAddSectionList";
  static final String _GET_BAR_CODE_TYPE =
      "${_baseUrlMenu}settings/getAllBarCodeType";
  // static String _EDIT_BAR_CODE_TYPE(String id) =>
  //     "settings/editBarCodeType/$id";
  static final String _UPDATE_BAR_CODE_TYPE =
      "${_baseUrlMenu}settings/createUpdateBarCodeType";

  //store
  static final String _GET_ALL_STORE_LIST =
      "${_baseUrlMenu}store/getAllStoresAddSectionList";
  static final String _ADD_UP_STORE = "${_baseUrlMenu}store/createUpdateStore";
  static String _EDIT_STORE(String id) => "${_baseUrlMenu}store/editStore/$id";
  // store new apis
  static String _GET_STORE_GENERAL(String id) =>
      "${_baseUrlMenu}store/getGeneralInformation/$id";
  static String _GET_STORE_OPENING_HOUR(String id) =>
      "${_baseUrlMenu}store/getOpeningHours/$id";
  static String _GET_STORE_DELIVERY_DIS(String id) =>
      "${_baseUrlMenu}store/getDeliveryDistance/$id";
  static String _GET_STORE_SURCHARGE(String id) =>
      "${_baseUrlMenu}store/getSurchargeSettings/$id";
  static String _GET_STORE_COLORS(String id) =>
      "${_baseUrlMenu}store/getOnlineThemeColor/$id";
  static String _GET_STORE_OTHERS(String id) =>
      "${_baseUrlMenu}store/getOtherSettings/$id";
  static final String _UP_STORE_GENERAL =
      "${_baseUrlMenu}store/updateGeneralInformation";
  static final String _UP_STORE_OPEN_HOUR =
      "${_baseUrlMenu}store/updateOpeningHours";
  static final String _UP_STORE_DELI_DIS =
      "${_baseUrlMenu}store/updateDeliveryDistance";
  static final String _UP_STORE_SURCHARGE =
      "${_baseUrlMenu}store/updateSurchargeSettings";
  static final String _UP_STORE_COLORS =
      "${_baseUrlMenu}store/updateOnlineThemeColor";
  static final String _RESET_STORE_COLORS =
      "${_baseUrlMenu}store/resetStoreColor";
  static final String _UP_STORE_OTHERS =
      "${_baseUrlMenu}store/updateOtherSettings";

  // set menu
  static final String _GET_ALL_SET_MENU_ADD_SEC =
      "${_baseUrlMenu}inventory/getAllSetmenuAddSection";

  static final String _DELETE_SET_MENU =
      "${_baseUrlMenu}inventory/deleteSetMenu";
  static String _EDIT_SET_MENU(String id) =>
      "${_baseUrlMenu}inventory/editSetMenu/$id";
  static final String _ADD_UP_SET_MENU =
      "${_baseUrlMenu}inventory/createUpdateSetMenu";
  static final String _GET_ALL_SET_MENU =
      "${_baseUrlMenu}inventory/getAllSetMenu";

  // product
  static final String _ADD_UP_PRODUCTS =
      "${_baseUrlMenu}inventory/createupdateProducts";
  static final String _DELETE_PRODUCTS =
      "${_baseUrlMenu}inventory/deleteProduct";
  static final String _DEACTIVE_PRODUCTS =
      "${_baseUrlMenu}inventory/deactivateProduct";
  static final String _GET_ALL_PRODUCTS =
      "${_baseUrlMenu}inventory/getAllProducts"; // get all product by product category
  static final String _GET_ALL_PROD_ADD_SEC =
      "${_baseUrlMenu}inventory/getAllProductAddSectionList"; //get all product add section
  static String _EDIT_PRODUCTS(String id) =>
      "${_baseUrlMenu}inventory/editProduct/$id";

  static String _EDIT_PROD_PRICE(String id) =>
      "${_baseUrlMenu}inventory/editProductPrice/$id";
  static final String _UPDATE_PROD_PRICE =
      "${_baseUrlMenu}inventory/updateProductPrice";
  static final String _DELETE_PROD_VARIENT =
      "${_baseUrlMenu}inventory/deleteProductVariation";

  //product view
  static String _GET_PROD_FILTER_OPTION(String id) =>
      "${_baseUrlMenu}inventory/getProductFilterTypeOptionByProductId/$id";

  // featured products
  static final String _GET_ALL_FEAT_PROD =
      "${_baseUrlMenu}settings/getAllFeaturedProducts"; // get all featured products
  static final String _ADD_UP_FEAT_PROD =
      "${_baseUrlMenu}settings/createUpdateFeaturedProducts";
  // static String _EDIT_FEAT_PROD(String id) =>
  //     "settings/editFeaturedProducts/$id";
  static final String _DELETE_FEAT_PROD =
      "${_baseUrlMenu}settings/deleteFeaturedProducts";

  //table location

  static final String _ADD_UP_TABLE_LAY =
      "${_baseUrlMenu}settings/createUpdateTableLayout";
  static String _EDIT_TABLE_LAY(String id) =>
      "${_baseUrlMenu}settings/editTableLayout/$id";
  static final String _GET_ALL_TABLE_LAYOUT =
      "${_baseUrlMenu}settings/getAllTableLayout";
  static String _GET_TABLE_LAYOUT(String id) =>
      "${_baseUrlMenu}settings/getTableLayoutByLocationId/$id";

  //sms and email setting
  static final String _GET_ALL_SMS_SETTING =
      "${_baseUrlMenu}settings/getAllSMSSettings";
  static final String _CREATE_UP_SMS_SET =
      "${_baseUrlMenu}settings/createUpdateSMSSettings";
  static final String _GET_EMAIL_SETTING =
      "${_baseUrlMenu}settings/getAllEmailSMTPSettings";
  static final String _CREATE_UP_EMAIL_SET =
      "${_baseUrlMenu}settings/createUpdateEmailSMTPSettings";

  // payment method
  static final String _GET_ALL_PAY_METHOD =
      "${_baseUrlMenu}settings/getAllPaymentMethod";
  static final String _ADD_UP_PAY_METHOD =
      "${_baseUrlMenu}settings/createUpdatePaymentMethod";

//billing and subscription
  static final String _GET_BILL_SUBS_PLAN =
      "${_baseUrlMenu}BillingAndSubscription/getBillingAndSubscriptionPlanList";
  static final String _GET_ALL_SUBS_ADD_SEC =
      "${_baseUrlMenu}BillingAndSubscription/getAllSubscriptionAndBillingAddSectionList";
  static final String _CREATE_SUBS_BILL =
      "${_baseUrlMenu}BillingAndSubscription/createSubscriptionAndBilling";

  //change billing and subscription plan
  static final String _GET_SUBS_AND_BILLING =
      "${_baseUrlMenu}BillingAndSubscription/getAllSubscriptionAndBilling";
  static final String _CHANGE_SUBS_PLAN =
      "${_baseUrlMenu}BillingAndSubscription/changeSubscriptionAndBillingPlan";

  //sales history report
  static final String _HISTORY_REPORT =
      "${_baseUrlMenu}report/salesHistoryReport";
  static final String _GET_REPORT_ADD_SEC =
      "${_baseUrlMenu}report/getAllSalesHistoryReportSectionList";

  //integration
  static final String _GET_AC_INTEG_SEC =
      "${_baseUrlMenu}IntegrationPlatform/getAllIntegrationPlatformSectionList";
  static String _GET_AC_PLAT_CON_B_PLAT_ID(String id) =>
      "${_baseUrlMenu}IntegrationPlatform/getIntegrationPlatformConnectionByPlatformId/$id";
  static String _GET_AC_CHART_AC_INTE(String id) =>
      "${_baseUrlMenu}IntegrationPlatform/getAccountingChartofAccountIntegrationByPlatformId/$id";
  static final String _ADD_UP_PLAT_INTEG_CONN =
      "${_baseUrlMenu}IntegrationPlatform/createUpdateIntegrationPlatformConnection";
  static final String _ADD_UP_CHART_OF_AC_MAP =
      "${_baseUrlMenu}IntegrationPlatform/createUpdateAccountingIntegrationChartofAccountMappings";
  static String _GET_ACC_CONTACT_SETTING(String id) =>
      "${_baseUrlMenu}IntegrationPlatform/getAccountingContactSettingsByPlatformId/$id";
  static final String _CREATE_UP_ACC_CONTACT_SETTING =
      "${_baseUrlMenu}IntegrationPlatform/createUpdateAccountingContactSettings";
  static final String _DELETE_INTEGRATION_PLAT =
      "${_baseUrlMenu}IntegrationPlatform/deleteIntegrationPlatformConnection";

  //Short term cash flow
  static final String _APPLY_STC_LUCA_PAY =
      "${_baseUrlMenu}ShortTermCashFlow/applySTCFLucaPay";

//End of the day cash in out
  static final String _ALL_CASH_INOUT =
      "${_baseUrlMenu}eod/getAllCashInCashOut";
  static final String _ADD_UP_CASH_IN_OUT =
      "${_baseUrlMenu}eod/createUpdateCashInCashOut";
  static String _EDIT_CASH_INOUT(String id) =>
      "${_baseUrlMenu}eod/editCashInCashOut/$id";

//End of the day finalize eod
  static final String _ALL_EOD_FINAL =
      "${_baseUrlMenu}eod/getAllEODFinalizeByDate";
  static final String _ALL_EOD_SEC_LIST =
      "${_baseUrlMenu}eod/getAllEODSectionList";
  static final String _FINALIZE_EOD = "${_baseUrlMenu}eod/FinalizeEODByDate";
  static final String _PRINT_EOD = "${_baseUrlMenu}eod/printEOD";

// add new organization
  static final String _BOARD_STORE = "${_baseUrlMenu}onboard/onBoardStore";
  static final String _BOARD_ADD_SEC =
      "${_baseUrlMenu}onBoard/onBoardAddSectionList";

  //dashboard
  // static final String _POS_DASHBOARD =
  //     "${_baseUrlMenu}dashboard/getAllPOSMobileDashBoardData";
  static String _GET_ALL_CHANNEL_FILTER_SEC_LIST(String id) =>
      "${_baseUrlMenu}dashboard/getAllChannelFilterSectionList/$id";
  static final String _CONNECT_CHANNEL =
      "${_baseUrlMenu}dashboard/connectChannel";
  // separate api
  static final String _DASH_RECOMM_PRODS =
      "${_baseUrlMenu}dashboard/getRecommendedProducts";
  static final String _DASH_SALES_BY_PAY_METHOD =
      "${_baseUrlMenu}dashboard/getSalesByPaymentMethod";
  static final String _DASH_AVAI_CHANNELS =
      "${_baseUrlMenu}dashboard/getAvailableChannels";
  static final String _DASH_SALES_BY_CHANNEL =
      "${_baseUrlMenu}dashboard/getSalesByChannelWithMonths";
  static final String _DASH_SALES_BY_CATS =
      "${_baseUrlMenu}dashboard/getSalesByCategory";
  static final String _DASH_STATS_TODAYS =
      "${_baseUrlMenu}dashboard/getDashboardStatisticsToday";
  static final String _DASH_EMPLOYEE_SALES =
      "${_baseUrlMenu}dashboard/getEmployeeSales";

//gift card

  static final String _GIFT_CARD_ADD_SEC =
      "${_baseUrlMenu}GiftCard/getAllEGiftCardsSendSectionList";
  static final String _ADD_UP_GIFTS = "${_baseUrlMenu}GiftCard/sendEGiftCard";
  static final String _GIFT_DETAILS_WITH_REEDEM_SUMM =
      "${_baseUrlMenu}GiftCard/giftCardDetailsWithReedemSummary";
  static final String _DEACT_GIFT_CARD =
      "${_baseUrlMenu}GiftCard/deactiveGiftCard";
  static final String _GIFT_SEARCH_SEC =
      "${_baseUrlMenu}GiftCard/getAllGiftCardsSearchSectionList";
  static final String _GET_ALL_GIFTS =
      "${_baseUrlMenu}GiftCard/getAllGiftCards";
  static final String _GIFT_BALANCE_CHECK =
      "${_baseUrlMenu}GiftCard/checkGiftCardBalance";

  //gift card image
  static final String _GIFT_CARD_IMAGE_ADD_SEC =
      "${_baseUrlMenu}GiftCard/getAllEGiftCardAddSectionList";

  static final String _GIFT_CARD_IMAGE_CREATE =
      "${_baseUrlMenu}GiftCard/createUpdateEGiftCard";

  static final String _GIFT_CARD_IMAGE_EDIT =
      "${_baseUrlMenu}GiftCard/editEGiftCard";
  static final String _GIFT_CARD_IMAGE_GET_ALL =
      "${_baseUrlMenu}GiftCard/getAllEGiftCards";

  static final String _GIFT_CARD_TEMPLATE_GROUP =
      "${_baseUrlMenu}GiftCard/getAllGiftCardTemplateGroups";

  static final String _GIFT_CARD_TEMPLATE_GROUP_CREATE =
      "${_baseUrlMenu}GiftCard/createUpdateGiftCardTemplateGroup";

  static final String _GIFT_CARD_TEMPLATE_GROUP_EDIT =
      "${_baseUrlMenu}GiftCard/editGiftCardTemplateGroup";

  //Barcode Generate
  static final String _BAR_CODE_SEC_LIST =
      "${_baseUrlMenu}inventory/getAllGenerateBarCodeSectionList";
  static final String _GENERATE_BARCODE =
      "${_baseUrlMenu}inventory/generateBarCode";
  static final String _PRINT_BARCODE = "${_baseUrlMenu}inventory/printBarCode";

  //product
  static final String _GEN_BAR_CODE_ADD_SEC =
      "${_baseUrlMenu}inventory/getAllProductSearchSectionList";

  static final String _GET_RAW_INGRE_ADD_SEC =
      "${_baseUrlMenu}inventory/getAllRawLooseIngredientAddSectionList";
  static final String _GET_RAW_INGRE_HISTORY =
      "${_baseUrlMenu}inventory/getAllRawLooseIngredientStockHistories";
  static final String _ADD_UP_RAW_INGRE =
      '${_baseUrlMenu}inventory/createUpdateRawLooseIngredient';
  static final String _ADD_UP_RAW_INGRE_HISTORY =
      '${_baseUrlMenu}inventory/createUpdateRawLooseIngredientStockHistory';
  static String _EDIT_RAW_INGRE(String id) =>
      '${_baseUrlMenu}inventory/editRawLooseIngredient/$id';
  static final String _GET_ALL_RAW_INGRE =
      '${_baseUrlMenu}inventory/getAllRawLooseIngredients';

  static final String _GET_BARCODE_PRINT =
      "${_baseUrlMenu}inventory/getGenerateBarCodePrintData";
  static final String _GEN_BARCODE_PRINT_BULK =
      "${_baseUrlMenu}inventory/getGenerateBarCodePrintDataBulk";

  //modifier
  static final String _GET_ALL_PROD_WITH_VARS =
      "${_baseUrlMenu}product/getAllProductWithVariations";
  static final String _GET_ALL_TAG_MODI_ADD_SEC =
      "${_baseUrlMenu}inventory/getAllTagModifierAddSectionList";
  static final String _CREATE_PROD_VAR_MODI =
      "${_baseUrlMenu}inventory/createProductVariationModifier";
  static final String _GET_PROD_VAR_MODI_GROUP =
      "${_baseUrlMenu}inventory/getAllProductVariationModifierGroups";
  static final String _CREATE_UP_PROD_VAR_MODI =
      "${_baseUrlMenu}inventory/createUpdateProductVariationModifier";

  //combo

  static final String _GET_COMBO_BARCODE_PRINT =
      "${_baseUrlMenu}inventory/getGenerateComboBarCodePrintData"; //{Id: "C4B0D1A7-B6D5-452E-ACBC-08DCBC25BF47", Name: "Combo Set 2"}
  static final String _GEN_BARCODE_COMBO_PRINT_BULK =
      "${_baseUrlMenu}inventory/getGenerateComboBarCodePrintDataBulk"; //[{above}]

  // combo packs
  static final String _GET_ALL_COMBOPACK =
      "${_baseUrlMenu}promotion/getAllDeals";

  static final String _GET_COMBO_ADD_SEC =
      "${_baseUrlMenu}promotion/getAllDealAddSectionList";
  static final String _CREATE_UP_COMBO =
      "${_baseUrlMenu}promotion/createUpdateDeals";
  static String _EDIT_COMBO_PACK(String id) =>
      "${_baseUrlMenu}promotion/editDeals/$id";
  //editProductPrice
  static final String _DELETE_COMBO_PACK =
      "${_baseUrlMenu}promotion/deleteDeal";

  //kitchen configuration
  static final String _GET_POS_DEVICE_SETUP_DETAIL =
      "${_baseUrlMenu}posdevicesetting/getPosDeviceProductPrintSetUpDetails";
  static final String _CREATE_UP_POS_DEVICE_PRODUCT =
      "${_baseUrlMenu}posdevicesetting/createUpdatePosDeviceProducts";

  //notification
  static final String _NOTIFICATION_TYPE =
      "${_baseUrlMenu}settings/getAllNotificationType";
  static final String _ADD_UP_NOTIFy_TYPE =
      "${_baseUrlMenu}settings/createUpdateNotificationType";
  static final String _GET_ALL_NEW_NOTI =
      "${_baseUrlMenu}Notification/getAllNewNotification";
  static final String _UPDATE_ORD_NOTI =
      "${_baseUrlMenu}Notification/updateNewNotification";
  static final String _GET_ALL_NOTIFICATION =
      "${_baseUrlMenu}Notification/getAllNotification";
  static final String _MARK_ALL_NOTIFY_SEEN =
      "${_baseUrlMenu}Notification/markAllNotificaitonAsSeen";

  //customer
  static String _EDIT_CUS(String id) =>
      "${_baseUrlMenu}customer/editCustomer/$id";
  static final String _ADD_UP_CUS =
      "${_baseUrlMenu}customer/createUpdateCustomer";

  static final String _GET_ALL_V_B_P =
      "${_baseUrlMenu}product/getAllProductVariationsByProductCategory";

  static final String _GET_RETAIL_POS_PRODUCTS =
      "${_baseUrlMenu}product/getAllProductVariations";

  static final String _GET_USER_ADD_SEC =
      "${_baseUrlMenu}account/getAllUserAddSectionList";

  static final String _UPDATE_USER = "${_baseUrlMenu}account/updateUser";
  //payment MX
  // static final String _GET_MX_MERCHANT_CRED =
  //     _baseUrlMenu + "IntegrationPlatform/getMxMerchantCredential";
  // static final String _UPDATE_MX_MERCHANT_CRED =
  //     _baseUrlMenu + "IntegrationPlatform/updateMxMerchantCredential";
}
