import 'dart:convert';

import 'lang_data.dart';

LangModel appStringsFromJson(String str) =>
    LangModel.fromJson(json.decode(str));

String appStringsToJson(LangModel data) => json.encode(data.toJson());

LangModel get DEFAULT_LANG_ENG => LangModel.fromJson(
    ALL_LANG_TEXT.entries.firstWhere((e) => e.key == "en").value);

LangModel getLang(String lang) => LangModel.fromJson(
    ALL_LANG_TEXT.entries.firstWhere((e) => e.key == lang).value);

class LangModel {
  String? ln;
  String headerTitle;
  String arrangeTable;
  String tableLocation;
  String chooseTable;
  String clearTables;
  String add;
  String update;
  String tables;
  String enable2faAuth;
  String s2faAuthTitle1;
  String s2faAuthTitle2;
  String s2faAuthTitle3;
  String enter6digit;
  String validate;
  String cancel;
  String sendOtp;
  String google2faVer;
  String emailVer;
  String phoneVer;
  String back;
  String enterEmail;
  String otpSentEmail;
  String comingSoon;
  String welcomeBack;
  String loginAc;
  String email;
  String password;
  String rememberMe;
  String forgotPassword;
  String logIn;
  String orders;
  String searchCatMenu;
  String orderType;
  String addCustomer;
  String customerType;
  String name;
  String phoneNumber;
  String receiveMarMat;
  String addCus;
  String searchCus;
  String eligibleAmount;
  String edit;
  String cusName;
  String paidAmount;
  String tipAmount;
  String totalPayAmt;
  String payAmt;
  String payNow;
  String searchNum;
  String sendDetails;
  String phone;
  String recieverDetails;
  String code;
  String discountAmt;
  String giftAmt;
  String payment;
  String discount;
  String publicHolidaySc;
  String creditCardSc;
  String items;
  String qty;
  String price;
  String payReceipt;
  String sendInvoiceDe;
  String from;
  String to;
  String cc;
  String subject;
  String yourMessage;
  String emailNotEmpty;
  String send;
  String printOrder;
  String department;
  String printer;
  String unContrct;
  String print;
  String downloadCmpt;
  String doYouWantOpenRcpt;
  String open;
  String orderBy;
  String table;
  String cashier;
  String dateTime;
  String tax;
  String taxInvoice;
  String abn;
  String description;
  String sentTKtchn;
  String placeOrder;
  String subtotal;
  String taxIncInTotal;
  String total;
  String tableNumber;
  String chooseStaffs;
  String cashInOut;
  String cash;
  String pleaseEtrVal;
  String yourNoteHere;
  String cashIn;
  String cashOut;
  String payHistory;
  String endOfTheDay;
  String paymentDetails;
  String cashCounterAmount;
  String status;
  String receivableFromDoor;
  String totalCounted;
  String difference;
  String cashOutIn;
  String finalizeNow;
  String cashCountedAmt;
  String eftpos;
  String giftCardSales;
  String giftCardRedem;
  String float;
  String receivableFromUber;
  String grossSales;
  String gst;
  String viods;
  String refunds;
  String rounding;
  String training;
  String netSales;
  String noOfTransaction;
  String noOfItemSold;
  String noOfVoids;
  String noOfTraining;
  String accumulatedSales;
  String accumulatedNoOfItems;
  String dateNTime;
  String finalReport;
  String eodDeclaration;
  String download;
  String printReceipt;
  String emailReceipt;
  String date;
  String recieptNo;
  String salesAmount;
  String paymentMethod;
  String bank;
  String storeAndEndDate;
  String receiptNo;
  String productName;
  String history;
  String pastDays;
  String searchNow;
  String historyReport;
  String added;
  String setMenu;
  String quantity;
  String addToCart;
  String categories;
  String frequentlySellingProducts;
  String chooseOrderType;
  String plzChooseOrderType;
  String emptyAdons;
  String save;
  String productLists;
  String products;
  String delete;
  String variations;
  String defaultText;
  String calories;
  String stock;
  String minStockAlert;
  String maxStockAlert;
  String recentlyAddedProducts;
  String addNewProducts;
  String updateProduct;
  String recentlyAddedProduct;
  String featuredProduct;
  String createSetMenu;
  String productDescription;
  String category;
  String chooseCategory;
  String brand;
  String chooseBrand;
  String taxIncExcl;
  String chooseTaxType;
  String productCode;
  String addProductImage;
  String alreadyListedOnAdons;
  String mainProdCantListed;
  String addProduct;
  String searchSetMenu;
  String setMenuSmall;
  String noImage;
  String ourSetMenu;
  String addDescription;
  String noProducts;
  String allSetMenu;
  String updateSetMenu;
  String nameOfSetMenu;
  String taxType;
  String addSetMenuImage;
  String creatNewLayout;
  String roundTable;
  String tableBooking;
  String changePassword;
  String oldPassword;
  String newPassword;
  String confirmNewPassword;
  String addNewBrand;
  String active;
  String inActive;
  String addNewCategory;
  String categoriesSmall;
  String isPosOrderType;
  String isOnlineOrderType;
  String saveNAddAnother;
  String addNewOrderType;
  String orderTypes;
  String defaultImages;
  String searchMenuImages;
  String confirm;
  String addNewTable;
  String tableLocEmpty;
  String chooseTableLoc;
  String addImage;
  String tableNumbers;
  String addNewLoc;
  String tableLocations;
  String addTax;
  String taxTypes;
  String generalSettings;
  String tableNo;
  String chooseTableNo;
  String addNewDepartment;
  String addPrinterLocation;
  String chooseDepartment;
  String printerLocations;
  String posPrinterSettings;
  String printerLocation;
  String distanceType;
  String distanceFrom;
  String distanceTo;
  String amount;
  String storeName;
  String abnNum;
  String storeImage;
  String url;
  String language;
  String holidaySurPercent;
  String invalidNumber;
  String franchise;
  String template;
  String businessType;
  String storeType;
  String country;
  String city;
  String address;
  String latitude;
  String longitude;
  String timezone;
  String pickUpHours;
  String deliveryHours;
  String day;
  String openTime;
  String closeTime;
  String isClosed;
  String maxClaimAmt;
  String maxClaimPoints;
  String amtFrom;
  String amtTo;
  String points;
  String general;
  String loyalty;
  String deliveryDistance;
  String openingHours;
  String storeSettings;
  String settings;
  String tableLayout;
  String whereYouCanSync;
  String syncFrom;
  String syncTo;
  String syncNow;
  String viewOrder;
  String moveOrder;
  String acceptOrder;
  String rejectOrder;
  String orderNumber;
  String orderDate;
  String tableName;
  String orderChannel;
  String totalAmount;
  String addToBasket;
  String selectVarience;
  String selectSize;
  String selectAdons;
  String logout;
  String sureToLogout;
  String logOut;
  String splashScreen;
  String error;
  String unsupportedImage;
  String fieldMustNotBeEmpty;
  String wantToDelete;
  String of;
  String passwordNotEmpty;
  String passwordMustContain;
  String passwordMustAtleast;
  String passwordDoesNtMatch;
  String invalidEmail;
  String regular;
  String taxTypeIsEmpty;
  String adult;
  String child;
  String adultCapacity;
  String childCapacity;
  String sort;
  String isActive;
  String brandName;
  String invalidSortNumber;
  String categoryName;
  String taxName;
  String value;
  String action;
  String port;
  String ipAddress;
  String someFieldIsEmpty;
  String syncFromIsNotSelected;
  String syncToIsNotSelected;
  String noInternetConnection;
  String invalidResponseFormat;
  String categoriesAreDeleted;
  String brandsAreDeleted;
  String tablesAreDeleted;
  String somethingWentWrong;
  String orderTypesAreDeleted;
  String taxAreDeleted;
  String setmenuAreDeleted;
  String productsAreDeleted;
  String featProdAreDeleted;
  String departmentsAreDeleted;
  String posLocationsAreDeleted;
  String emailIsSent;
  String success;
  String tip;
  String share;
  String menu;
  String productsTab;
  String sync;
  String paymentWith;
  String time;
  String notes;
  String totalAmountTaken;
  String payAmount;
  String booking;
  String noOfCus;
  String dateTimeFrom;
  String dateTimeTo;
  String bookNow;
  String cusList;
  String search;
  String chooseDate;
  String channel;
  String areYouSureCancel;
  String areYouSureOk;
  String yes;
  String no;
  String reserveNo;
  String cusUserU;
  String na;
  String orderDetailU;
  String orderNo;
  String orderTypeU;
  String orderStatus;
  String deliveryAdd;
  String amountDetails;
  String subTotal;
  String taxAmount;
  String productWPriceD;
  String setmenuWPD;
  String transStatus;
  String holiSurgeAmt;
  String ccSurgeAmt;
  String noDataFound;
  String cancelOrder;
  String aystcOrder;
  String pay;
  String notifiSet;
  String taxTypeU;
  String dateFormat;
  String productOutOfStock;
  String sortNo;
  String posOrderType;
  String onlineOrderType;
  String allergens;
  String loading;
  String payMethodSetting;
  String key;
  String secretKey;
  String genQr;
  String viewQr;
  String tableQr;
  String billAndSubs;
  String addNewCard;
  String nameOnCard;
  String enterNameCard;
  String emailAddress;
  String enterTheEmail;
  String poweredByStripe;
  String agreeTermsOnBilling;
  String saveAndUse;
  String biilingAddress;
  String state;
  String street;
  String postalCode;
  String npOfPos;
  String expiryDate;
  String expiryDateCard;
  String cvv;
  String securityCode;
  String cardNum;
  String cardNumSub;
  String perMonLoc;
  String includes;
  String integratePosapt;
  String buyNow;
  String trialExpired;
  String choosePlanThatFits;
  String userManagement;
  String addUser;
  String userType;
  String fullname;
  String fullName;
  String zipcode;
  String sessionExpired;
  String personalInfo;
  String passAndSec;
  String lastUpOn;
  String en2FaAccReadyText;
  String enable2Fa;
  String editProfile;
  String pushNoti;
  String profileAccReadyText;
  String deviceNotActive;
  String activePos;
  String enterActiveKey;
  String activeKey;
  String activatingKey;
  String activateNow;
  String choosePlan;
  String chooseUrPlan;
  String changePlan;
  String wishToChangePlan;
  String perMemMon;
  String mySubs;
  String visa;
  String cardType;
  String addNewCart;
  String registeredCards;
  String allUsers;
  String users;
  String searchUser;
  String deviceNameLoc;
  String notification;
  String integration;
  String integrationSubText;
  String getStarted;
  String clientId;
  String enterClientId;
  String clientSecret;
  String enClientSec;
  String connect;
  String chartAcMap;
  String contactSetting;
  String productMacros;
  String sortOrder;
  String deviceActivated;
  String profile;
  String billsNSubs;
  String allOrders;
  String newOrders;
  String newBooking;
  String productDeactivated;
  String activate;
  String deactivate;
  String wannaDeactivate;
  String printKitchen;
  String eod;
  String shortTCashFlow;
  String payBillsInstall;
  String applyNow;
  String bookAppoint;
  String fastTrack;
  String saveTime;
  String takePressOff;
  String betterSupBuy;
  String partnerWith;
  String lucaDes;
  String thankYou;
  String formSent;
  String goBackFromLuca;
  String fillDetailsLuca;
  String contactPerson;
  String contactNum;
  String busEmailAdd;
  String accSoft;
  String clearForm;
  String submit;
  String refresh;
  String available;
  String printerNotFound;
  String printerIsConnected;
  String printerNotConnected;
  String acceptTerms;
  String storeChannel;
  String chooseChannel;
  String catTypeDeleted;
  String catType;
  String chooseCatType;
  String sn;
  String supplier;
  String chooseSupplier;
  String productVarients;
  String productStatus;
  String unitPrice;
  String searchProduct;
  String updatePrice;
  String varientDeleted;
  String sureToDelete;
  String varient;
  String posPrinter;
  String setMenuKit;
  String printInvoice;
  String paperSize;
  String orPrintAuto;
  String autoInvoicePrint;
  String view;
  String setMenuStatus;
  String printing;
  String generalSetSubtitle;
  String posDeviceSet;
  String posDeviceSetSubtitle;
  String storeSetSubtitle;
  String notifySetSubtitle;
  String payMethodSetSubtitle;
  String userManageSetSubtitle;
  String changeAll;
  String noItemsSelected;
  String removeFromCart;
  String payInvoice;
  String noOrdersPlaced;
  String newOrder;
  String noBookFound;
  String invalidOtp;
  String clear;
  String sendEmail;
  String copyClipboard;
  String holidayChargeAmt;
  String creditSurchargeAmt;
  String subsNow;
  String noItemFound;
  String noProductAdded;
  String startEndDate;
  String noHistoryReport;
  String selectTable;
  String taxInvoiceInfoEmpty;
  String dashboard;
  String printRecptKit;
  String server;
  String customer;
  String setMenuItems;
  String creditCardSurcharge;
  String posPrinterSetup;
  String pos;
  String pleaseTryAgain;
  String incomingCall;
  String userRole;
  String posDevice;
  String deviceName;
  String planSubscribed;
  String posDevices;
  String twoFaUp;
  String noSetMenuFound;
  String pleaseSePlan;
  String useThisDevice;
  String isOpen;
  String exit;
  String sureToExit;
  String discountHigher;
  String included;
  String sendToKit;
  String updateOrder;
  String copiedToClip;
  String storeUrl;
  String webUrl;
  String deliAmt;
  String remainAmt;
  String addPhoto;
  String takeCamera;
  String takeGallery;
  String invalidDisChar;
  String invalidAmt;
  String amtExtsive;
  String payableAmt;
  String picDeliDate;
  String refundOrder;
  String sureToRefund;
  String resetYourPass;
  String resetPassSubtitle;
  String resetMyPass;
  String selectNumItemsVariants;
  String productVariants;
  String addons;
  String redeemCode;
  String the2FaAuthEmailTitle;
  String type;
  String totalCashIn;
  String totalCashOut;
  String loyaltyPoint;
  String eligibleLoyalPoint;
  String enableLoyal;
  String tableBookResv;
  String noCashInOut;
  String recentAddProds;
  String createSetMenuCom;
  String prodVariants;
  String variant;
  String updateSetMenuCom;
  String setMenuCombo;
  String selectItemsSetMenu;
  String notifications;
  String selectNumOfItems;
  String refundPay;
  String fieldEmpty;
  String canceled;
  String termOfService;
  String dontHaveAcc;
  String signup;
  String registerNow;
  String sendVeriTitle;
  String resendOtp;
  String veriCode;
  String register;
  String refund;
  String deliverOrder;
  String orderDeli;
  String sureToOrderDeli;
  String orderStatusNotChoosen;
  String removePhoto;
  String per;
  String device;
  String devices;
  String addNewOrg;
  String addUrOrg;
  String businessName;
  String businessPhone;
  String businessEmail;
  String choosePlatform;
  String calculateEod;
  String chooseSubCat;
  String subCategory;
  String subCatsDeleted;
  String subCatName;
  String addNewSubCat;
  String subCats;
  String sendEmailAndFinalize;
  String payWithEodRecon;
  String finalize;
  String finalizeEod;
  String otpCodeExpired5Min;
  String plAuthToCont;
  String screenTime;
  String enableAppLock;
  String langModelContinue;
  String processOrder;
  String tableNotSelected;
  String eodOnDate;
  String findEodReport;
  String chooseOrderStatus;
  String storeChangedSuccess;
  String todaySale;
  String salesSummary;
  String salesCat;
  String salesReportByMon;
  String payReport;
  String salesByChannel;
  String recommProducts;
  String totalSales;
  String totalOrders;
  String totalRefund;
  String totalCus;
  String upgradePlanFromFreeTrial;
  String upgradeNow;
  String payMethod;
  String sales;
  String product;
  String noStoreSelected;
  String tryAgainAfterTime;
  String pointOfSale;
  String onlineOrSys;
  String posOnlineOrderSys;
  String onlineOrder;
  String sureToUpTableBook;
  String sureToBookTable;
  String sureToDiscardChanges;
  String invoiceNo;
  String barcodeType;
  String chooseBarCode;
  String show;
  String entries;
  String searchProdCat;
  String variationNotAvai;
  String newGiftCard;
  String giftCardList;
  String giftCard;
  String giftCardNo;
  String amtOnGift;
  String senderDetails;
  String message;
  String yourMsgHere;
  String receiverDetails;
  String senderName;
  String receiverName;
  String purDate;
  String chooseGift;
  String retailStore;
  String noGiftFound;
  String redeemHistory;
  String redeemBy;
  String redeemAmt;
  String redeemDate;
  String noRecord;
  String barCodeType;
  String payAmtHigherGift;
  String thankPur;
  String voucherRedeemCode;
  String giftRedeemCode;
  String chooseGiftCard;
  String monthlySubs;
  String commission;
  String priceChargedSales;
  String barcodeTypes;
  String searching;
  String pleaseChooseGift;
  String dear;
  String thanksForChoosing;
  String emailText1;
  String emailText2;
  String bestRegards;
  String refundAmt;
  String barcodeGen;
  String generate;
  String printBarcode;
  String generateBarcode;
  String invalidBarcodeImg;
  String numOfBarcode;
  String uploadImage;
  String searchPrinter;
  String slug;
  String filterTypes;
  String icon;
  String identifier;
  String selectAll;
  String customDesc;
  String labelName;
  String enableRetailScreen;
  String promOfferDiscountPercent;
  String discountPercent;
  String promOfferThres;
  String promImage;
  String commissionBasedSubsPlan;
  String numOfPosLocation;
  String monthlySubsPlan;
  String areUSureUWantToChangePayMethTo;
  String changePayMethod;
  String sendDeviceId;
  String emailSuccess;
  String seeNotifications;
  String recentNotifications;
  String markRead;
  String deviceIsActivated;
  String amountReturned;
  String amountPaid;
  String insufficientAmount;
  String sureRefund;
  String receipt;
  String ccChargeMayApply;
  String discountMayApply;
  String eftposMerPay;
  String eftposMerPayPro;
  String merPay;
  String merPayPro;
  String serialNo;
  String eftposTerDev;
  String eftposMer;
  String chooseEftpos;
  String eftposMerPro;
  String eftposDevDeleted;
  String chooseEftposTerDev;
  String sureToDeleteAllItems;
  String canNotRevertBack;
  String noProductAvai;
  String noBarcodeAvai;
  String acceptAll;
  String pair;
  String posName;
  String paymentProvider;
  String enablePrice;
  String priceRange;
  String todaySaleSum;
  String chooseMerchantPro;
  String giftCardImg;
  String noImgFound;
  String createNew;
  String removeImg;
  String giftCards;
  String plzSelectGiftCard;
  String printNotAvai;
  String displayName;
  String paymentReceipt;
  String totalQty;
  String refundQty;
  String invalidCardSurchargePer;
  String printRefundReceipt;
  String refundInvoice;
  String refundReceipt;
  String refundAmount;
  String refundAmtDetail;
  String refundProdPrice;
  String refundComboPrice;
  String ccNumEmpty;
  String invalidCcLen;
  String invalidCc;
  String expiryYear;
  String yourCardNum;
  String expiryMonth;
  String changePrice;
  String ok;
  String hospitalityPricing;
  String retailPricing;
  String slelectItemNumRefund;
  String updateBeforePay;
  String completePrevPayToNextPay;
  String sureUpdateOrder;
  String disCantApplied;
  String modifier;
  String trackNumber;
  String searchFtProduct;
  String alreadyExists;
  String layout;
  String rotateTable;
  String resizeTable;
  String createLayoutFor;
  String create;
  String selected;
  String floorPlan;
  String noFloorSetup;
  String reservationList;
  String tapMoveTableSpace;
  String makeFree;
  String placeNewOrder;
  String reseravtionType;
  String reservedIn;
  String tableAvailable;
  String viewLayout;
  String createLayout;
  String hours;
  String hour;
  String minutes;
  String minute;
  String reserve;
  String occupy;
  String tableOccupation;
  String wannaOccupyTable;
  String makeTableFree;
  String wannaTableFree;
  String checkout;
  String printMerchant;
  String purchaseReceipt;
  String salesTax;
  String purchaseTax;
  String comments;
  String channelType;
  String staySignedIn;
  String noProductFound;
  String willAutoLogoutDevices;
  String confirmLogoutDeviceCheckSignin;
  String eodCasPay;
  String calculatedCash;
  String templateCategory;
  String otherSettings;
  String updateOrderChannel;
  String tableQrOrderChannel;
  String showReserveTable;
  String showFooter;
  String showPaymentPickup;
  String showPaymentDine;
  String showPaymentDelivery;
  String livePaymentMode;
  String barcode;
  String showTable;
  String enableUnderMaintain;
  String isRetailScreen;
  String enableOrderGiftForm;
  String enableCopyrightFooter;
  String enableFooter;
  String enableGuestCheckout;
  String hospitalityOnline;
  String retailOnline;
  String businessTypeCategory;
  String spiceChoices;
  String addCartSuccess;
  String printRefundInvoice;
  String printEftposSign;
  String otherDetails;
  String deliveryCannotForPast;
  String deliveryTime;
  String spice;
  String printMerchantCopy;
  String printCustomerCopy;
  String viewEftposLogs;
  String printEftposLog;
  String updatedSuccessfully;
  String cusSearch;
  String orderHistory;
  String selectCusOrderHistory;
  String number;
  String anonymous;
  String scanBluetoothDevices;
  String errorScanningPrinter;
  String devicesFound;
  String searchingDevice;
  String noDeviceFound;
  String isBluetoothDevice;
  String enableBluetoothSetting;
  String stockCount;
  String connectionFailed;
  String businessTypeCat;
  String refundableAmt;
  String printEftSign;
  String printCusCopy;
  String viewEftLogs;
  String printEftLogs;
  String eftLogs;
  String deliveryCantMadePast;
  String allItemRefund;
  String enCopyFootDes;
  String adultCap;
  String enDocGroupSpliter;
  String docGroup;
  String chooseDocGroup;
  String cusCopy;
  String orderPrintCopy;
  String revoke;
  String servedBy;
  String payProcessBy;
  String orderProcessBy;
  String cancelSendKitchen;
  String reservCantEndBefStartDate;
  String noRcptFound;
  String updateSuccess;
  String invoicePrintCusCopy;
  String viewReserve;
  String orderCopy;
  String chooseHalfHalf;
  String halfItem;
  String calSet;
  String autoEnable;
  String autoEnHoliSur;
  String weekendSur;
  String autoEnWeekSur;
  String autoEnCreSur;
  String mailServer;
  String allProducts;
  String emailSetting;
  String smsSetting;

  String fromNum;
  String enTls;
  String enSsi;
  String sendSms;
  String printerType;
  String choosePrintType;

  String enAutoSendKit;
  String enPayPair;
  String enAutoSendKitDisplay;
  String totalLoyaltyAmt;
  String redeemLoyalty;
  String balPoint;

  String amtSpent;
  String rewardCusAmtSpent;
  String eveTimeCusSpnt;
  String cusEarn;
  String eodReport;
  String eodReportNotFound;
  String zReport;
  String salesSum;
  String discounts;
  String giftSales;
  String crCardSur;
  String deliCharge;
  String totalTax;
  String totalUnitSales;
  String salesChannel;
  String unit;
  String totalNetSales;
  String salesByCat;
  String salesByCatType;
  String payMethods;
  String totalPayment;
  String variance;
  String printEod;
  String preparedDate;
  String orderedDate;
  String eftDevicePair;
  String dualDisSet;
  String searchComboProduct;
  String searchNewIngre;
  String select;
  String disAmtHigher;
  String sellingPrice;
  String disPrice;
  String newSellingPrice;

  String addProductMessage;
  String outOfStock;
  String usbNotFound;
  String printerNotSetup;
  String npQrFound;
  String posDeviceQr;
  String occasion;
  String kitDocket;
  String item;
  String createHalfHalfItem;
  String createUniHalf;
  String selectItemUpdate;
  String addItem;
  String up1StHalf;
  String addHalfSucc;
  String upHalfSucc;
  String promtOffDis;
  String comProd;
  String rawIngre;
  String enterName;
  String enterMsg;
  String point;
  String printEodSum;
  String inStock;
  String orderStatusChangeSucc;
  String up2NdHalf;
  String choose2NdHalf;
  String connected;
  String disconnected;
  String notConnected;
  String ourChannels;
  String empName;
  String empCode;
  String empEmail;
  String empPhone;
  String currentDateTime;
  String workingHours;
  String punchOut;
  String punchIn;
  String punching;
  String toConDevLocAcc;
  String openLocSet;
  String noThanks;
  String downloading;
  String downloaded;
  String downloadFailed;
  String permissionDenied;
  String chooseTerminal;
  String emergencyContact;
  String deviceNotConnected;
  String initiatePayment;
  String successfullyConnected;
  String failedToOpenPort;
  String modifiers;
  String punchInOut;
  String unexpectedError;
  String salesSummaryCap;
  String platformError;
  String continueTransaction;
  String incompleteTransactionRecovery;
  String retry;
  String dismiss;
  String createReservation;
  String recentIncomingCall;
  String line;
  String failedToPrint;
  String decline;
  String accept;
  String openingCashDrawer;
  String failedToConnect;
  String purchaseCap;
  String refundCap;
  String retryCap;
  String blueScanError;
  String blueConnectDenied;
  String blueScanDenied;
  String zReportCap;
  String paymentMethods;
  String half;
  String noOfCustomers;
  String removeIngredients;
  String halfNHalf;
  String failedToGetUsb;
  String box;
  String addBox;
  String tapBoxToAdd;
  String dimensionCm;
  String weightGram;
  String length;
  String height;
  String depth;
  String chooseItems;
  String deliveryDriverPickup;
  String pickupCannotPast;
  String pickupTimeAtLeast10;
  String pickupTimeCannotAfter;
  String pickupTimeCannotMade;
  String deliveryCustomer;
  String failedToGetUsbDevices;
  String createDelivery;
  String delivery;
  String details;
  String pickUpTime;
  String viewDetails;
  String courierDetails;
  String vehicleType;
  String recipient;
  String deliveryNotes;
  String itemDetails;
  String itemName;
  String size;
  String dimension;
  String weight;
  String assignedStaffs;
  String mustBeUpright;
  String deliveryStatus;
  String totalPrice;
  String close;
  String completeDelivery;
  String trackDelivery;
  String noDeliveryOrderFound;
  String giveUsRating;
  String shareDetails;
  String enterEmpCode;
  String startUnscheduledShift;
  String startShift;
  String scheduledBreaks;
  String startingAt;
  String noScheduledShifts;
  String shiftTime;
  String early;
  String late;
  String onUnscheduledShift;
  String onBreak;
  String iWillBeBack;
  String doYouWantConfirmEarlier;
  String doYouWantConfirmEndShift;
  String earlyEndShift;
  String endShift;
  String endBreak;
  String pleaseSelectBreak;
  String addNote;
  String noBreaksAvailable;
  String startBreak;
  String unscheduled;
  String scheduled;
  String unpaid;
  String paid;
  String selectBreaks;
  String breakTaken;
  String endShiftWarning;
  String takeBreak;
  String showGiftCard;
  String yourGiftCardBalance;
  String checkBalance;
  String giftCardTemplate;
  String checkGiftCardAmount;
  String giftCardEnquiry;
  String giftCardTemplateGroup;
  String allServices;
  String getDeviceInfo;
  String emergencyEmail;
  String emergencyPhone;
  String emergencyContactPerson;
  String emergencyContactName;
  String reportingEmployees;
  String hourlyRate;
  String annualSalary;
  String gender;
  String preferredName;
  String employeeCode;
  String employeeInformation;
  String editEmployee;
  String jobTitle;
  String others;
  String female;
  String male;
  String splitByItems;
  String splitAmount;
  String fullAmount;
  String yourOrderReady;
  String checkGiftCard;
  String hi;
  String services;
  String locationPermissionDenied;
  String pleaseTurnOnLocation;
  String enableLocationService;
  String customerSignature;
  String serviceChannel;
  String serviceStatus;
  String serviceDate;
  String serviceNo;
  String serviceType;
  String serviceNumber;
  String totalServices;
  String printService;
  String viewService;
  String newServices;
  String goToKitchen;
  String minPurchaseQty;
  String recommendedServices;
  String merchantCopyWithSignature;
  String merchantCopy;
  String customerCopy;
  String receiptType;
  String duplicateReceipt;
  String lastTransactionReceipt;
  String receiptPrinting;
  String channelsPrice;
  String runningStock;
  String invalidInput;
  String home;
  String chooseServiceStatus;
  String extra;

  // String failedToLoginWithCode;
  // String loginWithEmail;
  // String loginWCode;
  // String enter4DCode;
  // String enUnitPrice;
  // String orderRefresh10;
  // String eligibleAmt;
  // String transAbort;
  // String transIncom;

  LangModel(
      {this.ln,
      required this.headerTitle,
      required this.arrangeTable,
      required this.tableLocation,
      required this.chooseTable,
      required this.clearTables,
      required this.add,
      required this.update,
      required this.tables,
      required this.enable2faAuth,
      required this.s2faAuthTitle1,
      required this.s2faAuthTitle2,
      required this.s2faAuthTitle3,
      required this.enter6digit,
      required this.validate,
      required this.cancel,
      required this.sendOtp,
      required this.google2faVer,
      required this.emailVer,
      required this.phoneVer,
      required this.punchInOut,
      required this.back,
      required this.enterEmail,
      required this.otpSentEmail,
      required this.comingSoon,
      required this.welcomeBack,
      required this.loginAc,
      required this.email,
      required this.password,
      required this.rememberMe,
      required this.forgotPassword,
      required this.logIn,
      required this.orders,
      required this.searchCatMenu,
      required this.orderType,
      required this.addCustomer,
      required this.customerType,
      required this.name,
      required this.phoneNumber,
      required this.receiveMarMat,
      required this.addCus,
      required this.searchCus,
      required this.eligibleAmount,
      required this.edit,
      required this.cusName,
      required this.paidAmount,
      required this.tipAmount,
      required this.totalPayAmt,
      required this.payAmt,
      required this.payNow,
      required this.home,
      required this.searchNum,
      required this.sendDetails,
      required this.phone,
      required this.recieverDetails,
      required this.code,
      required this.discountAmt,
      required this.giftAmt,
      required this.payment,
      required this.discount,
      required this.publicHolidaySc,
      required this.creditCardSc,
      required this.items,
      required this.qty,
      required this.price,
      required this.payReceipt,
      required this.sendInvoiceDe,
      required this.from,
      required this.to,
      required this.cc,
      required this.subject,
      required this.yourMessage,
      required this.emailNotEmpty,
      required this.send,
      required this.printOrder,
      required this.department,
      required this.printer,
      required this.unContrct,
      required this.print,
      required this.downloadCmpt,
      required this.doYouWantOpenRcpt,
      required this.open,
      required this.orderBy,
      required this.table,
      required this.cashier,
      required this.dateTime,
      required this.tax,
      required this.taxInvoice,
      required this.abn,
      required this.description,
      required this.sentTKtchn,
      required this.placeOrder,
      required this.subtotal,
      required this.taxIncInTotal,
      required this.total,
      required this.tableNumber,
      required this.chooseStaffs,
      required this.cashInOut,
      required this.cash,
      required this.pleaseEtrVal,
      required this.yourNoteHere,
      required this.cashIn,
      required this.cashOut,
      required this.payHistory,
      required this.endOfTheDay,
      required this.paymentDetails,
      required this.cashCounterAmount,
      required this.status,
      required this.receivableFromDoor,
      required this.totalCounted,
      required this.difference,
      required this.cashOutIn,
      required this.finalizeNow,
      required this.cashCountedAmt,
      required this.eftpos,
      required this.giftCardSales,
      required this.giftCardRedem,
      required this.float,
      required this.receivableFromUber,
      required this.grossSales,
      required this.gst,
      required this.viods,
      required this.refunds,
      required this.rounding,
      required this.training,
      required this.netSales,
      required this.noOfTransaction,
      required this.noOfItemSold,
      required this.noOfVoids,
      required this.extra,
      required this.noOfTraining,
      required this.accumulatedSales,
      required this.accumulatedNoOfItems,
      required this.dateNTime,
      required this.finalReport,
      required this.eodDeclaration,
      required this.download,
      required this.printReceipt,
      required this.emailReceipt,
      required this.date,
      required this.recieptNo,
      required this.salesAmount,
      required this.paymentMethod,
      required this.bank,
      required this.storeAndEndDate,
      required this.receiptNo,
      required this.productName,
      required this.history,
      required this.pastDays,
      required this.searchNow,
      required this.historyReport,
      required this.added,
      required this.setMenu,
      required this.quantity,
      required this.addToCart,
      required this.categories,
      required this.frequentlySellingProducts,
      required this.chooseOrderType,
      required this.plzChooseOrderType,
      required this.emptyAdons,
      required this.save,
      required this.productLists,
      required this.products,
      required this.delete,
      required this.variations,
      required this.defaultText,
      required this.calories,
      required this.stock,
      required this.minStockAlert,
      required this.maxStockAlert,
      required this.recentlyAddedProducts,
      required this.addNewProducts,
      required this.updateProduct,
      required this.failedToPrint,
      required this.recentlyAddedProduct,
      required this.featuredProduct,
      required this.createSetMenu,
      required this.productDescription,
      required this.category,
      required this.chooseCategory,
      required this.brand,
      required this.chooseBrand,
      required this.taxIncExcl,
      required this.chooseTaxType,
      required this.productCode,
      required this.addProductImage,
      required this.alreadyListedOnAdons,
      required this.mainProdCantListed,
      required this.addProduct,
      required this.searchSetMenu,
      required this.setMenuSmall,
      required this.noImage,
      required this.ourSetMenu,
      required this.addDescription,
      required this.noProducts,
      required this.allSetMenu,
      required this.updateSetMenu,
      required this.nameOfSetMenu,
      required this.taxType,
      required this.addSetMenuImage,
      required this.creatNewLayout,
      required this.roundTable,
      required this.tableBooking,
      required this.changePassword,
      required this.oldPassword,
      required this.newPassword,
      required this.confirmNewPassword,
      required this.addNewBrand,
      required this.active,
      required this.inActive,
      required this.addNewCategory,
      required this.categoriesSmall,
      required this.isPosOrderType,
      required this.isOnlineOrderType,
      required this.saveNAddAnother,
      required this.addNewOrderType,
      required this.orderTypes,
      required this.defaultImages,
      required this.searchMenuImages,
      required this.confirm,
      required this.addNewTable,
      required this.tableLocEmpty,
      required this.chooseTableLoc,
      required this.addImage,
      required this.tableNumbers,
      required this.addNewLoc,
      required this.tableLocations,
      required this.addTax,
      required this.taxTypes,
      required this.generalSettings,
      required this.tableNo,
      required this.chooseTableNo,
      required this.addNewDepartment,
      required this.addPrinterLocation,
      required this.chooseDepartment,
      required this.printerLocations,
      required this.posPrinterSettings,
      required this.printerLocation,
      required this.distanceType,
      required this.distanceFrom,
      required this.distanceTo,
      required this.amount,
      required this.storeName,
      required this.abnNum,
      required this.storeImage,
      required this.url,
      required this.language,
      required this.holidaySurPercent,
      required this.invalidNumber,
      required this.franchise,
      required this.template,
      required this.businessType,
      required this.storeType,
      required this.country,
      required this.city,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.timezone,
      required this.pickUpHours,
      required this.deliveryHours,
      required this.day,
      required this.openTime,
      required this.closeTime,
      required this.isClosed,
      required this.maxClaimAmt,
      required this.maxClaimPoints,
      required this.amtFrom,
      required this.amtTo,
      required this.points,
      required this.general,
      required this.loyalty,
      required this.deliveryDistance,
      required this.openingHours,
      required this.storeSettings,
      required this.settings,
      required this.tableLayout,
      required this.whereYouCanSync,
      required this.syncFrom,
      required this.syncTo,
      required this.syncNow,
      required this.viewOrder,
      required this.moveOrder,
      required this.acceptOrder,
      required this.rejectOrder,
      required this.orderNumber,
      required this.orderDate,
      required this.tableName,
      required this.orderChannel,
      required this.totalAmount,
      required this.addToBasket,
      required this.selectVarience,
      required this.selectSize,
      required this.selectAdons,
      required this.logout,
      required this.sureToLogout,
      required this.logOut,
      required this.splashScreen,
      required this.error,
      required this.unsupportedImage,
      required this.fieldMustNotBeEmpty,
      required this.wantToDelete,
      required this.of,
      required this.passwordNotEmpty,
      required this.passwordMustContain,
      required this.passwordMustAtleast,
      required this.passwordDoesNtMatch,
      required this.invalidEmail,
      required this.regular,
      required this.taxTypeIsEmpty,
      required this.adult,
      required this.modifiers,
      required this.chooseServiceStatus,
      required this.child,
      required this.adultCapacity,
      required this.childCapacity,
      required this.sort,
      required this.isActive,
      required this.brandName,
      required this.invalidSortNumber,
      required this.categoryName,
      required this.taxName,
      required this.value,
      required this.action,
      required this.port,
      required this.ipAddress,
      required this.someFieldIsEmpty,
      required this.syncFromIsNotSelected,
      required this.syncToIsNotSelected,
      required this.noInternetConnection,
      required this.invalidResponseFormat,
      required this.categoriesAreDeleted,
      required this.brandsAreDeleted,
      required this.tablesAreDeleted,
      required this.somethingWentWrong,
      required this.orderTypesAreDeleted,
      required this.taxAreDeleted,
      required this.setmenuAreDeleted,
      required this.productsAreDeleted,
      required this.featProdAreDeleted,
      required this.departmentsAreDeleted,
      required this.posLocationsAreDeleted,
      required this.emailIsSent,
      required this.success,
      required this.tip,
      required this.share,
      required this.menu,
      required this.productsTab,
      required this.sync,
      required this.paymentWith,
      required this.time,
      required this.notes,
      required this.totalAmountTaken,
      required this.payAmount,
      required this.booking,
      required this.noOfCus,
      required this.dateTimeFrom,
      required this.dateTimeTo,
      required this.bookNow,
      required this.cusList,
      required this.search,
      required this.chooseDate,
      required this.channel,
      required this.areYouSureCancel,
      required this.areYouSureOk,
      required this.yes,
      required this.no,
      required this.reserveNo,
      required this.cusUserU,
      required this.na,
      required this.orderDetailU,
      required this.orderNo,
      required this.orderTypeU,
      required this.orderStatus,
      required this.deliveryAdd,
      required this.amountDetails,
      required this.subTotal,
      required this.taxAmount,
      required this.productWPriceD,
      required this.setmenuWPD,
      required this.transStatus,
      required this.holiSurgeAmt,
      required this.ccSurgeAmt,
      required this.noDataFound,
      required this.cancelOrder,
      required this.aystcOrder,
      required this.pay,
      required this.notifiSet,
      required this.taxTypeU,
      required this.dateFormat,
      required this.productOutOfStock,
      required this.sortNo,
      required this.posOrderType,
      required this.onlineOrderType,
      required this.allergens,
      required this.loading,
      required this.payMethodSetting,
      required this.key,
      required this.secretKey,
      required this.genQr,
      required this.viewQr,
      required this.tableQr,
      required this.billAndSubs,
      required this.addNewCard,
      required this.nameOnCard,
      required this.enterNameCard,
      required this.emailAddress,
      required this.enterTheEmail,
      required this.poweredByStripe,
      required this.agreeTermsOnBilling,
      required this.saveAndUse,
      required this.biilingAddress,
      required this.state,
      required this.street,
      required this.postalCode,
      required this.npOfPos,
      required this.expiryDate,
      required this.expiryDateCard,
      required this.cvv,
      required this.securityCode,
      required this.cardNum,
      required this.cardNumSub,
      required this.perMonLoc,
      required this.includes,
      required this.integratePosapt,
      required this.buyNow,
      required this.trialExpired,
      required this.choosePlanThatFits,
      required this.userManagement,
      required this.addUser,
      required this.userType,
      required this.fullname,
      required this.fullName,
      required this.zipcode,
      required this.sessionExpired,
      required this.personalInfo,
      required this.passAndSec,
      required this.lastUpOn,
      required this.en2FaAccReadyText,
      required this.enable2Fa,
      required this.editProfile,
      required this.pushNoti,
      required this.profileAccReadyText,
      required this.deviceNotActive,
      required this.activePos,
      required this.enterActiveKey,
      required this.activeKey,
      required this.activatingKey,
      required this.activateNow,
      required this.choosePlan,
      required this.chooseUrPlan,
      required this.changePlan,
      required this.wishToChangePlan,
      required this.perMemMon,
      required this.mySubs,
      required this.visa,
      required this.cardType,
      required this.addNewCart,
      required this.registeredCards,
      required this.allUsers,
      required this.users,
      required this.searchUser,
      required this.deviceNameLoc,
      required this.notification,
      required this.integration,
      required this.integrationSubText,
      required this.getStarted,
      required this.clientId,
      required this.enterClientId,
      required this.clientSecret,
      required this.enClientSec,
      required this.connect,
      required this.chartAcMap,
      required this.contactSetting,
      required this.productMacros,
      required this.sortOrder,
      required this.deviceActivated,
      required this.profile,
      required this.billsNSubs,
      required this.allOrders,
      required this.newOrders,
      required this.newBooking,
      required this.productDeactivated,
      required this.activate,
      required this.deactivate,
      required this.wannaDeactivate,
      required this.printKitchen,
      required this.eod,
      required this.shortTCashFlow,
      required this.payBillsInstall,
      required this.applyNow,
      required this.bookAppoint,
      required this.fastTrack,
      required this.saveTime,
      required this.takePressOff,
      required this.betterSupBuy,
      required this.partnerWith,
      required this.lucaDes,
      required this.thankYou,
      required this.formSent,
      required this.goBackFromLuca,
      required this.fillDetailsLuca,
      required this.contactPerson,
      required this.contactNum,
      required this.busEmailAdd,
      required this.accSoft,
      required this.clearForm,
      required this.submit,
      required this.refresh,
      required this.available,
      required this.printerNotFound,
      required this.printerIsConnected,
      required this.printerNotConnected,
      required this.acceptTerms,
      required this.storeChannel,
      required this.chooseChannel,
      required this.catTypeDeleted,
      required this.catType,
      required this.chooseCatType,
      required this.sn,
      required this.supplier,
      required this.chooseSupplier,
      required this.productVarients,
      required this.productStatus,
      required this.unitPrice,
      required this.searchProduct,
      required this.updatePrice,
      required this.varientDeleted,
      required this.sureToDelete,
      required this.varient,
      required this.posPrinter,
      required this.setMenuKit,
      required this.printInvoice,
      required this.paperSize,
      required this.orPrintAuto,
      required this.autoInvoicePrint,
      required this.view,
      required this.setMenuStatus,
      required this.printing,
      required this.generalSetSubtitle,
      required this.posDeviceSet,
      required this.posDeviceSetSubtitle,
      required this.storeSetSubtitle,
      required this.notifySetSubtitle,
      required this.payMethodSetSubtitle,
      required this.userManageSetSubtitle,
      required this.changeAll,
      required this.noItemsSelected,
      required this.removeFromCart,
      required this.payInvoice,
      required this.noOrdersPlaced,
      required this.newOrder,
      required this.noBookFound,
      required this.invalidOtp,
      required this.clear,
      required this.sendEmail,
      required this.copyClipboard,
      required this.holidayChargeAmt,
      required this.creditSurchargeAmt,
      required this.subsNow,
      required this.noItemFound,
      required this.noProductAdded,
      required this.startEndDate,
      required this.noHistoryReport,
      required this.selectTable,
      required this.taxInvoiceInfoEmpty,
      required this.dashboard,
      required this.printRecptKit,
      required this.server,
      required this.customer,
      required this.setMenuItems,
      required this.creditCardSurcharge,
      required this.posPrinterSetup,
      required this.pos,
      required this.pleaseTryAgain,
      required this.userRole,
      required this.posDevice,
      required this.deviceName,
      required this.planSubscribed,
      required this.posDevices,
      required this.twoFaUp,
      required this.noSetMenuFound,
      required this.pleaseSePlan,
      required this.useThisDevice,
      required this.isOpen,
      required this.exit,
      required this.sureToExit,
      required this.discountHigher,
      required this.included,
      required this.sendToKit,
      required this.updateOrder,
      required this.copiedToClip,
      required this.storeUrl,
      required this.webUrl,
      required this.deliAmt,
      required this.remainAmt,
      required this.addPhoto,
      required this.takeCamera,
      required this.takeGallery,
      required this.invalidDisChar,
      required this.invalidAmt,
      required this.amtExtsive,
      required this.payableAmt,
      required this.picDeliDate,
      required this.refundOrder,
      required this.sureToRefund,
      required this.resetYourPass,
      required this.resetPassSubtitle,
      required this.resetMyPass,
      required this.selectNumItemsVariants,
      required this.productVariants,
      required this.addons,
      required this.redeemCode,
      required this.the2FaAuthEmailTitle,
      required this.type,
      required this.totalCashIn,
      required this.totalCashOut,
      required this.loyaltyPoint,
      required this.eligibleLoyalPoint,
      required this.enableLoyal,
      required this.tableBookResv,
      required this.noCashInOut,
      required this.recentAddProds,
      required this.createSetMenuCom,
      required this.prodVariants,
      required this.variant,
      required this.updateSetMenuCom,
      required this.setMenuCombo,
      required this.selectItemsSetMenu,
      required this.notifications,
      required this.selectNumOfItems,
      required this.refundPay,
      required this.fieldEmpty,
      required this.canceled,
      required this.termOfService,
      required this.dontHaveAcc,
      required this.signup,
      required this.registerNow,
      required this.sendVeriTitle,
      required this.resendOtp,
      required this.veriCode,
      required this.register,
      required this.refund,
      required this.deliverOrder,
      required this.orderDeli,
      required this.sureToOrderDeli,
      required this.orderStatusNotChoosen,
      required this.removePhoto,
      required this.per,
      required this.device,
      required this.devices,
      required this.addNewOrg,
      required this.addUrOrg,
      required this.businessName,
      required this.businessPhone,
      required this.businessEmail,
      required this.choosePlatform,
      required this.calculateEod,
      required this.chooseSubCat,
      required this.subCategory,
      required this.subCatsDeleted,
      required this.subCatName,
      required this.addNewSubCat,
      required this.subCats,
      required this.sendEmailAndFinalize,
      required this.payWithEodRecon,
      required this.finalize,
      required this.finalizeEod,
      required this.otpCodeExpired5Min,
      required this.plAuthToCont,
      required this.screenTime,
      required this.enableAppLock,
      required this.langModelContinue,
      required this.processOrder,
      required this.tableNotSelected,
      required this.eodOnDate,
      required this.findEodReport,
      required this.chooseOrderStatus,
      required this.storeChangedSuccess,
      required this.todaySale,
      required this.salesSummary,
      required this.salesCat,
      required this.salesReportByMon,
      required this.payReport,
      required this.salesByChannel,
      required this.recommProducts,
      required this.totalSales,
      required this.totalOrders,
      required this.totalRefund,
      required this.totalCus,
      required this.upgradePlanFromFreeTrial,
      required this.upgradeNow,
      required this.payMethod,
      required this.sales,
      required this.product,
      required this.noStoreSelected,
      required this.tryAgainAfterTime,
      required this.pointOfSale,
      required this.onlineOrSys,
      required this.posOnlineOrderSys,
      required this.onlineOrder,
      required this.sureToUpTableBook,
      required this.sureToBookTable,
      required this.sureToDiscardChanges,
      required this.invoiceNo,
      required this.barcodeType,
      required this.chooseBarCode,
      required this.show,
      required this.entries,
      required this.searchProdCat,
      required this.variationNotAvai,
      required this.newGiftCard,
      required this.giftCardList,
      required this.giftCard,
      required this.giftCardNo,
      required this.amtOnGift,
      required this.senderDetails,
      required this.message,
      required this.yourMsgHere,
      required this.receiverDetails,
      required this.senderName,
      required this.receiverName,
      required this.purDate,
      required this.chooseGift,
      required this.retailStore,
      required this.noGiftFound,
      required this.redeemHistory,
      required this.redeemBy,
      required this.redeemAmt,
      required this.redeemDate,
      required this.noRecord,
      required this.barCodeType,
      required this.payAmtHigherGift,
      required this.thankPur,
      required this.voucherRedeemCode,
      required this.giftRedeemCode,
      required this.chooseGiftCard,
      required this.monthlySubs,
      required this.commission,
      required this.priceChargedSales,
      required this.barcodeTypes,
      required this.searching,
      required this.pleaseChooseGift,
      required this.dear,
      required this.thanksForChoosing,
      required this.emailText1,
      required this.emailText2,
      required this.bestRegards,
      required this.refundAmt,
      required this.barcodeGen,
      required this.generate,
      required this.printBarcode,
      required this.generateBarcode,
      required this.invalidBarcodeImg,
      required this.numOfBarcode,
      required this.uploadImage,
      required this.searchPrinter,
      required this.slug,
      required this.filterTypes,
      required this.icon,
      required this.identifier,
      required this.selectAll,
      required this.customDesc,
      required this.labelName,
      required this.enableRetailScreen,
      required this.promOfferDiscountPercent,
      required this.discountPercent,
      required this.promOfferThres,
      required this.promImage,
      required this.commissionBasedSubsPlan,
      required this.numOfPosLocation,
      required this.monthlySubsPlan,
      required this.areUSureUWantToChangePayMethTo,
      required this.changePayMethod,
      required this.sendDeviceId,
      required this.emailSuccess,
      required this.seeNotifications,
      required this.recentNotifications,
      required this.markRead,
      required this.deviceIsActivated,
      required this.amountReturned,
      required this.amountPaid,
      required this.emergencyContact,
      required this.insufficientAmount,
      required this.sureRefund,
      required this.receipt,
      required this.ccChargeMayApply,
      required this.discountMayApply,
      required this.eftposMerPay,
      required this.eftposMerPayPro,
      required this.merPay,
      required this.merPayPro,
      required this.serialNo,
      required this.eftposTerDev,
      required this.eftposMer,
      required this.chooseEftpos,
      required this.eftposMerPro,
      required this.eftposDevDeleted,
      required this.chooseEftposTerDev,
      required this.sureToDeleteAllItems,
      required this.canNotRevertBack,
      required this.noProductAvai,
      required this.noBarcodeAvai,
      required this.acceptAll,
      required this.pair,
      required this.posName,
      required this.paymentProvider,
      required this.enablePrice,
      required this.priceRange,
      required this.todaySaleSum,
      required this.chooseMerchantPro,
      required this.giftCardImg,
      required this.noImgFound,
      required this.createNew,
      required this.removeImg,
      required this.giftCards,
      required this.plzSelectGiftCard,
      required this.printNotAvai,
      required this.displayName,
      required this.paymentReceipt,
      required this.totalQty,
      required this.refundQty,
      required this.invalidCardSurchargePer,
      required this.printRefundReceipt,
      required this.refundInvoice,
      required this.refundReceipt,
      required this.refundAmount,
      required this.refundAmtDetail,
      required this.refundProdPrice,
      required this.refundComboPrice,
      required this.ccNumEmpty,
      required this.invalidCcLen,
      required this.invalidCc,
      required this.expiryYear,
      required this.yourCardNum,
      required this.expiryMonth,
      required this.changePrice,
      required this.ok,
      required this.hospitalityPricing,
      required this.retailPricing,
      required this.slelectItemNumRefund,
      required this.updateBeforePay,
      required this.completePrevPayToNextPay,
      required this.sureUpdateOrder,
      required this.disCantApplied,
      required this.modifier,
      required this.trackNumber,
      required this.searchFtProduct,
      required this.alreadyExists,
      required this.layout,
      required this.rotateTable,
      required this.resizeTable,
      required this.createLayoutFor,
      required this.create,
      required this.selected,
      required this.floorPlan,
      required this.noFloorSetup,
      required this.reservationList,
      required this.tapMoveTableSpace,
      required this.makeFree,
      required this.placeNewOrder,
      required this.reseravtionType,
      required this.reservedIn,
      required this.tableAvailable,
      required this.viewLayout,
      required this.createLayout,
      required this.hours,
      required this.hour,
      required this.minutes,
      required this.minute,
      required this.reserve,
      required this.occupy,
      required this.tableOccupation,
      required this.wannaOccupyTable,
      required this.makeTableFree,
      required this.wannaTableFree,
      required this.checkout,
      required this.printMerchant,
      required this.purchaseReceipt,
      required this.salesTax,
      required this.purchaseTax,
      required this.comments,
      required this.channelType,
      required this.staySignedIn,
      required this.noProductFound,
      required this.willAutoLogoutDevices,
      required this.confirmLogoutDeviceCheckSignin,
      required this.eodCasPay,
      required this.calculatedCash,
      required this.templateCategory,
      required this.otherSettings,
      required this.updateOrderChannel,
      required this.tableQrOrderChannel,
      required this.showReserveTable,
      required this.showFooter,
      required this.showPaymentPickup,
      required this.showPaymentDine,
      required this.showPaymentDelivery,
      required this.livePaymentMode,
      required this.barcode,
      required this.showTable,
      required this.enableUnderMaintain,
      required this.isRetailScreen,
      required this.enableOrderGiftForm,
      required this.enableCopyrightFooter,
      required this.enableFooter,
      required this.enableGuestCheckout,
      required this.hospitalityOnline,
      required this.retailOnline,
      required this.businessTypeCategory,
      required this.spiceChoices,
      required this.addCartSuccess,
      required this.printRefundInvoice,
      required this.printEftposSign,
      required this.otherDetails,
      required this.deliveryCannotForPast,
      required this.deliveryTime,
      required this.spice,
      required this.printMerchantCopy,
      required this.printCustomerCopy,
      required this.viewEftposLogs,
      required this.printEftposLog,
      required this.updatedSuccessfully,
      required this.cusSearch,
      required this.orderHistory,
      required this.selectCusOrderHistory,
      required this.number,
      required this.anonymous,
      required this.scanBluetoothDevices,
      required this.errorScanningPrinter,
      required this.devicesFound,
      required this.searchingDevice,
      required this.noDeviceFound,
      required this.isBluetoothDevice,
      required this.enableBluetoothSetting,
      required this.stockCount,
      required this.connectionFailed,
      required this.businessTypeCat,
      required this.refundableAmt,
      required this.printEftSign,
      required this.printCusCopy,
      required this.viewEftLogs,
      required this.printEftLogs,
      required this.eftLogs,
      required this.deliveryCantMadePast,
      required this.allItemRefund,
      required this.enCopyFootDes,
      required this.adultCap,
      required this.enDocGroupSpliter,
      required this.docGroup,
      required this.chooseDocGroup,
      required this.cusCopy,
      required this.orderPrintCopy,
      required this.revoke,
      required this.servedBy,
      required this.payProcessBy,
      required this.orderProcessBy,
      required this.cancelSendKitchen,
      required this.reservCantEndBefStartDate,
      required this.noRcptFound,
      required this.updateSuccess,
      required this.invoicePrintCusCopy,
      required this.viewReserve,
      required this.orderCopy,
      required this.chooseHalfHalf,
      required this.halfItem,
      required this.calSet,
      required this.autoEnable,
      required this.autoEnHoliSur,
      required this.weekendSur,
      required this.autoEnWeekSur,
      required this.autoEnCreSur,
      required this.mailServer,
      required this.allProducts,
      required this.emailSetting,
      required this.smsSetting,
      required this.fromNum,
      required this.enTls,
      required this.enSsi,
      required this.sendSms,
      required this.printerType,
      required this.choosePrintType,
      required this.enAutoSendKit,
      required this.enPayPair,
      required this.enAutoSendKitDisplay,
      required this.totalLoyaltyAmt,
      required this.redeemLoyalty,
      required this.balPoint,
      required this.amtSpent,
      required this.rewardCusAmtSpent,
      required this.eveTimeCusSpnt,
      required this.cusEarn,
      required this.eodReport,
      required this.eodReportNotFound,
      required this.zReport,
      required this.salesSum,
      required this.discounts,
      required this.giftSales,
      required this.crCardSur,
      required this.deliCharge,
      required this.totalTax,
      required this.totalUnitSales,
      required this.salesChannel,
      required this.unit,
      required this.totalNetSales,
      required this.salesByCat,
      required this.salesByCatType,
      required this.payMethods,
      required this.totalPayment,
      required this.variance,
      required this.printEod,
      required this.preparedDate,
      required this.orderedDate,
      required this.eftDevicePair,
      required this.dualDisSet,
      required this.searchComboProduct,
      required this.searchNewIngre,
      required this.select,
      required this.disAmtHigher,
      required this.sellingPrice,
      required this.disPrice,
      required this.newSellingPrice,
      required this.addProductMessage,
      required this.outOfStock,
      required this.usbNotFound,
      required this.printerNotSetup,
      required this.npQrFound,
      required this.posDeviceQr,
      required this.occasion,
      required this.kitDocket,
      required this.item,
      required this.createHalfHalfItem,
      required this.createUniHalf,
      required this.selectItemUpdate,
      required this.addItem,
      required this.up1StHalf,
      required this.addHalfSucc,
      required this.upHalfSucc,
      required this.promtOffDis,
      required this.comProd,
      required this.rawIngre,
      required this.enterName,
      required this.assignedStaffs,
      required this.enterMsg,
      required this.point,
      required this.printEodSum,
      required this.inStock,
      required this.orderStatusChangeSucc,
      required this.up2NdHalf,
      required this.choose2NdHalf,
      required this.connected,
      required this.disconnected,
      required this.notConnected,
      required this.ourChannels,
      required this.empName,
      required this.empCode,
      required this.empEmail,
      required this.empPhone,
      required this.currentDateTime,
      required this.workingHours,
      required this.incomingCall,
      required this.punchOut,
      required this.punchIn,
      required this.punching,
      required this.toConDevLocAcc,
      required this.openLocSet,
      required this.noThanks,
      required this.downloading,
      required this.downloaded,
      required this.downloadFailed,
      required this.permissionDenied,
      required this.chooseTerminal,
      required this.deviceNotConnected,
      required this.initiatePayment,
      required this.successfullyConnected,
      required this.failedToOpenPort,
      required this.unexpectedError,
      required this.salesSummaryCap,
      required this.platformError,
      required this.continueTransaction,
      required this.incompleteTransactionRecovery,
      required this.retry,
      required this.dismiss,
      required this.createReservation,
      required this.recentIncomingCall,
      required this.line,
      required this.decline,
      required this.accept,
      required this.openingCashDrawer,
      required this.failedToConnect,
      required this.purchaseCap,
      required this.refundCap,
      required this.retryCap,
      required this.blueScanError,
      required this.blueConnectDenied,
      required this.blueScanDenied,
      required this.zReportCap,
      required this.paymentMethods,
      required this.half,
      required this.noOfCustomers,
      required this.removeIngredients,
      required this.halfNHalf,
      required this.failedToGetUsb,
      required this.box,
      required this.addBox,
      required this.tapBoxToAdd,
      required this.dimensionCm,
      required this.weightGram,
      required this.length,
      required this.height,
      required this.depth,
      required this.chooseItems,
      required this.deliveryDriverPickup,
      required this.pickupCannotPast,
      required this.pickupTimeAtLeast10,
      required this.pickupTimeCannotAfter,
      required this.pickupTimeCannotMade,
      required this.deliveryCustomer,
      required this.failedToGetUsbDevices,
      required this.createDelivery,
      required this.delivery,
      required this.details,
      required this.pickUpTime,
      required this.viewDetails,
      required this.courierDetails,
      required this.vehicleType,
      required this.recipient,
      required this.deliveryNotes,
      required this.itemDetails,
      required this.itemName,
      required this.size,
      required this.dimension,
      required this.weight,
      required this.mustBeUpright,
      required this.deliveryStatus,
      required this.totalPrice,
      required this.close,
      required this.completeDelivery,
      required this.trackDelivery,
      required this.noDeliveryOrderFound,
      required this.giveUsRating,
      required this.shareDetails,
      required this.enterEmpCode,
      required this.startUnscheduledShift,
      required this.startShift,
      required this.scheduledBreaks,
      required this.startingAt,
      required this.noScheduledShifts,
      required this.shiftTime,
      required this.early,
      required this.late,
      required this.onUnscheduledShift,
      required this.onBreak,
      required this.iWillBeBack,
      required this.doYouWantConfirmEarlier,
      required this.doYouWantConfirmEndShift,
      required this.earlyEndShift,
      required this.endShift,
      required this.endBreak,
      required this.pleaseSelectBreak,
      required this.addNote,
      required this.noBreaksAvailable,
      required this.startBreak,
      required this.unscheduled,
      required this.scheduled,
      required this.unpaid,
      required this.paid,
      required this.selectBreaks,
      required this.breakTaken,
      required this.endShiftWarning,
      required this.takeBreak,
      required this.showGiftCard,
      required this.yourGiftCardBalance,
      required this.checkBalance,
      required this.giftCardTemplate,
      required this.checkGiftCardAmount,
      required this.giftCardEnquiry,
      required this.giftCardTemplateGroup,
      required this.allServices,
      required this.getDeviceInfo,
      required this.emergencyEmail,
      required this.emergencyPhone,
      required this.emergencyContactPerson,
      required this.emergencyContactName,
      required this.reportingEmployees,
      required this.hourlyRate,
      required this.annualSalary,
      required this.gender,
      required this.preferredName,
      required this.employeeCode,
      required this.employeeInformation,
      required this.editEmployee,
      required this.jobTitle,
      required this.others,
      required this.female,
      required this.male,
      required this.splitByItems,
      required this.splitAmount,
      required this.fullAmount,
      required this.yourOrderReady,
      required this.checkGiftCard,
      required this.hi,
      required this.services,
      required this.locationPermissionDenied,
      required this.pleaseTurnOnLocation,
      required this.enableLocationService,
      required this.customerSignature,
      required this.serviceChannel,
      required this.serviceStatus,
      required this.serviceDate,
      required this.serviceNo,
      required this.serviceType,
      required this.serviceNumber,
      required this.totalServices,
      required this.printService,
      required this.viewService,
      required this.newServices,
      required this.goToKitchen,
      required this.minPurchaseQty,
      required this.recommendedServices,
      required this.merchantCopyWithSignature,
      required this.merchantCopy,
      required this.customerCopy,
      required this.receiptType,
      required this.duplicateReceipt,
      required this.lastTransactionReceipt,
      required this.receiptPrinting,
      required this.channelsPrice,
      required this.runningStock,
      required this.invalidInput
      // required this.failedToLoginWithCode,
      // required this.loginWithEmail,
      // required this.loginWCode,
      // required this.enter4DCode,
      // required this.enUnitPrice,
      // required this.orderRefresh10,
      // required this.eligibleAmt,
      // required this.transAbort,
      // required this.transIncom,
      });

  factory LangModel.fromJson(Map<String, dynamic> json) {
    return LangModel(
      ln: (json['ln_1'] == null || (json['ln_1'] as String).isEmpty)
          ? EN_LANG_TEXT['ln_1']
          : json['ln_1'],
      headerTitle: (json['header_title'] == null ||
              (json['header_title'] as String).isEmpty)
          ? EN_LANG_TEXT['header_title']
          : json['header_title'],
      arrangeTable: (json['arrange_table'] == null ||
              (json['arrange_table'] as String).isEmpty)
          ? EN_LANG_TEXT['arrange_table']
          : json['arrange_table'],
      tableLocation: (json['table_location'] == null ||
              (json['table_location'] as String).isEmpty)
          ? EN_LANG_TEXT['table_location']
          : json['table_location'],
      chooseTable: (json['choose_table'] == null ||
              (json['choose_table'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_table']
          : json['choose_table'],
      clearTables: (json['clear_tables'] == null ||
              (json['clear_tables'] as String).isEmpty)
          ? EN_LANG_TEXT['clear_tables']
          : json['clear_tables'],
      add: (json['add'] == null || (json['add'] as String).isEmpty)
          ? EN_LANG_TEXT['add']
          : json['add'],
      update: (json['update'] == null || (json['update'] as String).isEmpty)
          ? EN_LANG_TEXT['update']
          : json['update'],
      tables: (json['tables'] == null || (json['tables'] as String).isEmpty)
          ? EN_LANG_TEXT['tables']
          : json['tables'],
      enable2faAuth: (json['enable_2fa_auth'] == null ||
              (json['enable_2fa_auth'] as String).isEmpty)
          ? EN_LANG_TEXT['enable_2fa_auth']
          : json['enable_2fa_auth'],
      s2faAuthTitle1: (json['2fa_auth_title_1'] == null ||
              (json['2fa_auth_title_1'] as String).isEmpty)
          ? EN_LANG_TEXT['2fa_auth_title_1']
          : json['2fa_auth_title_1'],
      s2faAuthTitle2: (json['2fa_auth_title_2'] == null ||
              (json['2fa_auth_title_2'] as String).isEmpty)
          ? EN_LANG_TEXT['2fa_auth_title_2']
          : json['2fa_auth_title_2'],
      s2faAuthTitle3: (json['2fa_auth_title_3'] == null ||
              (json['2fa_auth_title_3'] as String).isEmpty)
          ? EN_LANG_TEXT['2fa_auth_title_3']
          : json['2fa_auth_title_3'],
      enter6digit: (json['enter_6digit'] == null ||
              (json['enter_6digit'] as String).isEmpty)
          ? EN_LANG_TEXT['enter_6digit']
          : json['enter_6digit'],
      validate:
          (json['validate'] == null || (json['validate'] as String).isEmpty)
              ? EN_LANG_TEXT['validate']
              : json['validate'],
      cancel: (json['cancel'] == null || (json['cancel'] as String).isEmpty)
          ? EN_LANG_TEXT['cancel']
          : json['cancel'],
      sendOtp:
          (json['send_otp'] == null || (json['send_otp'] as String).isEmpty)
              ? EN_LANG_TEXT['send_otp']
              : json['send_otp'],
      google2faVer: (json['google_2fa_ver'] == null ||
              (json['google_2fa_ver'] as String).isEmpty)
          ? EN_LANG_TEXT['google_2fa_ver']
          : json['google_2fa_ver'],
      emailVer:
          (json['email_ver'] == null || (json['email_ver'] as String).isEmpty)
              ? EN_LANG_TEXT['email_ver']
              : json['email_ver'],
      phoneVer:
          (json['phone_ver'] == null || (json['phone_ver'] as String).isEmpty)
              ? EN_LANG_TEXT['phone_ver']
              : json['phone_ver'],
      back: (json['back'] == null || (json['back'] as String).isEmpty)
          ? EN_LANG_TEXT['back']
          : json['back'],
      enterEmail: (json['enter_email'] == null ||
              (json['enter_email'] as String).isEmpty)
          ? EN_LANG_TEXT['enter_email']
          : json['enter_email'],
      otpSentEmail: (json['otp_sent_email'] == null ||
              (json['otp_sent_email'] as String).isEmpty)
          ? EN_LANG_TEXT['otp_sent_email']
          : json['otp_sent_email'],
      comingSoon: (json['coming_soon'] == null ||
              (json['coming_soon'] as String).isEmpty)
          ? EN_LANG_TEXT['coming_soon']
          : json['coming_soon'],
      welcomeBack: (json['welcome_back'] == null ||
              (json['welcome_back'] as String).isEmpty)
          ? EN_LANG_TEXT['welcome_back']
          : json['welcome_back'],
      loginAc:
          (json['login_ac'] == null || (json['login_ac'] as String).isEmpty)
              ? EN_LANG_TEXT['login_ac']
              : json['login_ac'],
      email: (json['email'] == null || (json['email'] as String).isEmpty)
          ? EN_LANG_TEXT['email']
          : json['email'],
      password:
          (json['password'] == null || (json['password'] as String).isEmpty)
              ? EN_LANG_TEXT['password']
              : json['password'],
      rememberMe: (json['remember_me'] == null ||
              (json['remember_me'] as String).isEmpty)
          ? EN_LANG_TEXT['remember_me']
          : json['remember_me'],
      forgotPassword: (json['forgot_password'] == null ||
              (json['forgot_password'] as String).isEmpty)
          ? EN_LANG_TEXT['forgot_password']
          : json['forgot_password'],
      logIn: (json['log_in'] == null || (json['log_in'] as String).isEmpty)
          ? EN_LANG_TEXT['log_in']
          : json['log_in'],
      orders: (json['orders'] == null || (json['orders'] as String).isEmpty)
          ? EN_LANG_TEXT['orders']
          : json['orders'],
      searchCatMenu: (json['search_cat_menu'] == null ||
              (json['search_cat_menu'] as String).isEmpty)
          ? EN_LANG_TEXT['search_cat_menu']
          : json['search_cat_menu'],
      orderType:
          (json['order_type'] == null || (json['order_type'] as String).isEmpty)
              ? EN_LANG_TEXT['order_type']
              : json['order_type'],
      addCustomer: (json['add_customer'] == null ||
              (json['add_customer'] as String).isEmpty)
          ? EN_LANG_TEXT['add_customer']
          : json['add_customer'],
      customerType: (json['customer_type'] == null ||
              (json['customer_type'] as String).isEmpty)
          ? EN_LANG_TEXT['customer_type']
          : json['customer_type'],
      name: (json['name'] == null || (json['name'] as String).isEmpty)
          ? EN_LANG_TEXT['name']
          : json['name'],
      phoneNumber: (json['phone_number'] == null ||
              (json['phone_number'] as String).isEmpty)
          ? EN_LANG_TEXT['phone_number']
          : json['phone_number'],
      receiveMarMat: (json['receive_mar_mat'] == null ||
              (json['receive_mar_mat'] as String).isEmpty)
          ? EN_LANG_TEXT['receive_mar_mat']
          : json['receive_mar_mat'],
      addCus: (json['add_cus'] == null || (json['add_cus'] as String).isEmpty)
          ? EN_LANG_TEXT['add_cus']
          : json['add_cus'],
      searchCus:
          (json['search_cus'] == null || (json['search_cus'] as String).isEmpty)
              ? EN_LANG_TEXT['search_cus']
              : json['search_cus'],
      eligibleAmount: (json['eligible_amount'] == null ||
              (json['eligible_amount'] as String).isEmpty)
          ? EN_LANG_TEXT['eligible_amount']
          : json['eligible_amount'],
      edit: (json['edit'] == null || (json['edit'] as String).isEmpty)
          ? EN_LANG_TEXT['edit']
          : json['edit'],
      cusName:
          (json['cus_name'] == null || (json['cus_name'] as String).isEmpty)
              ? EN_LANG_TEXT['cus_name']
              : json['cus_name'],
      paidAmount: (json['paid_amount'] == null ||
              (json['paid_amount'] as String).isEmpty)
          ? EN_LANG_TEXT['paid_amount']
          : json['paid_amount'],
      tipAmount:
          (json['tip_amount'] == null || (json['tip_amount'] as String).isEmpty)
              ? EN_LANG_TEXT['tip_amount']
              : json['tip_amount'],
      totalPayAmt: (json['total_pay_amt'] == null ||
              (json['total_pay_amt'] as String).isEmpty)
          ? EN_LANG_TEXT['total_pay_amt']
          : json['total_pay_amt'],
      payAmt: (json['pay_amt'] == null || (json['pay_amt'] as String).isEmpty)
          ? EN_LANG_TEXT['pay_amt']
          : json['pay_amt'],
      payNow: (json['pay_now'] == null || (json['pay_now'] as String).isEmpty)
          ? EN_LANG_TEXT['pay_now']
          : json['pay_now'],
      searchNum:
          (json['search_num'] == null || (json['search_num'] as String).isEmpty)
              ? EN_LANG_TEXT['search_num']
              : json['search_num'],
      sendDetails: (json['send_details'] == null ||
              (json['send_details'] as String).isEmpty)
          ? EN_LANG_TEXT['send_details']
          : json['send_details'],
      phone: (json['phone'] == null || (json['phone'] as String).isEmpty)
          ? EN_LANG_TEXT['phone']
          : json['phone'],
      recieverDetails: (json['reciever_details'] == null ||
              (json['reciever_details'] as String).isEmpty)
          ? EN_LANG_TEXT['reciever_details']
          : json['reciever_details'],
      code: (json['code'] == null || (json['code'] as String).isEmpty)
          ? EN_LANG_TEXT['code']
          : json['code'],
      discountAmt: (json['discount_amt'] == null ||
              (json['discount_amt'] as String).isEmpty)
          ? EN_LANG_TEXT['discount_amt']
          : json['discount_amt'],
      giftAmt:
          (json['gift_amt'] == null || (json['gift_amt'] as String).isEmpty)
              ? EN_LANG_TEXT['gift_amt']
              : json['gift_amt'],
      payment: (json['payment'] == null || (json['payment'] as String).isEmpty)
          ? EN_LANG_TEXT['payment']
          : json['payment'],
      discount:
          (json['discount'] == null || (json['discount'] as String).isEmpty)
              ? EN_LANG_TEXT['discount']
              : json['discount'],
      publicHolidaySc: (json['public_holiday_sc'] == null ||
              (json['public_holiday_sc'] as String).isEmpty)
          ? EN_LANG_TEXT['public_holiday_sc']
          : json['public_holiday_sc'],
      creditCardSc: (json['credit_card_sc'] == null ||
              (json['credit_card_sc'] as String).isEmpty)
          ? EN_LANG_TEXT['credit_card_sc']
          : json['credit_card_sc'],
      items: (json['items'] == null || (json['items'] as String).isEmpty)
          ? EN_LANG_TEXT['items']
          : json['items'],
      qty: (json['qty'] == null || (json['qty'] as String).isEmpty)
          ? EN_LANG_TEXT['qty']
          : json['qty'],
      price: (json['price'] == null || (json['price'] as String).isEmpty)
          ? EN_LANG_TEXT['price']
          : json['price'],
      payReceipt: (json['pay_receipt'] == null ||
              (json['pay_receipt'] as String).isEmpty)
          ? EN_LANG_TEXT['pay_receipt']
          : json['pay_receipt'],
      sendInvoiceDe: (json['send_invoice_de'] == null ||
              (json['send_invoice_de'] as String).isEmpty)
          ? EN_LANG_TEXT['send_invoice_de']
          : json['send_invoice_de'],
      from: (json['from'] == null || (json['from'] as String).isEmpty)
          ? EN_LANG_TEXT['from']
          : json['from'],
      to: (json['to'] == null || (json['to'] as String).isEmpty)
          ? EN_LANG_TEXT['to']
          : json['to'],
      cc: (json['cc'] == null || (json['cc'] as String).isEmpty)
          ? EN_LANG_TEXT['cc']
          : json['cc'],
      subject: (json['subject'] == null || (json['subject'] as String).isEmpty)
          ? EN_LANG_TEXT['subject']
          : json['subject'],
      yourMessage: (json['your_message'] == null ||
              (json['your_message'] as String).isEmpty)
          ? EN_LANG_TEXT['your_message']
          : json['your_message'],
      emailNotEmpty: (json['email_not_empty'] == null ||
              (json['email_not_empty'] as String).isEmpty)
          ? EN_LANG_TEXT['email_not_empty']
          : json['email_not_empty'],
      send: (json['send'] == null || (json['send'] as String).isEmpty)
          ? EN_LANG_TEXT['send']
          : json['send'],
      printOrder: (json['print_order'] == null ||
              (json['print_order'] as String).isEmpty)
          ? EN_LANG_TEXT['print_order']
          : json['print_order'],
      department:
          (json['department'] == null || (json['department'] as String).isEmpty)
              ? EN_LANG_TEXT['department']
              : json['department'],
      printer: (json['printer'] == null || (json['printer'] as String).isEmpty)
          ? EN_LANG_TEXT['printer']
          : json['printer'],
      unContrct:
          (json['un_contrct'] == null || (json['un_contrct'] as String).isEmpty)
              ? EN_LANG_TEXT['un_contrct']
              : json['un_contrct'],
      print: (json['print'] == null || (json['print'] as String).isEmpty)
          ? EN_LANG_TEXT['print']
          : json['print'],
      downloadCmpt: (json['download_cmpt'] == null ||
              (json['download_cmpt'] as String).isEmpty)
          ? EN_LANG_TEXT['download_cmpt']
          : json['download_cmpt'],
      doYouWantOpenRcpt: (json['do_you_want_open_rcpt'] == null ||
              (json['do_you_want_open_rcpt'] as String).isEmpty)
          ? EN_LANG_TEXT['do_you_want_open_rcpt']
          : json['do_you_want_open_rcpt'],
      open: (json['open'] == null || (json['open'] as String).isEmpty)
          ? EN_LANG_TEXT['open']
          : json['open'],
      orderBy:
          (json['order_by'] == null || (json['order_by'] as String).isEmpty)
              ? EN_LANG_TEXT['order_by']
              : json['order_by'],
      table: (json['table'] == null || (json['table'] as String).isEmpty)
          ? EN_LANG_TEXT['table']
          : json['table'],
      cashier: (json['cashier'] == null || (json['cashier'] as String).isEmpty)
          ? EN_LANG_TEXT['cashier']
          : json['cashier'],
      dateTime:
          (json['date_time'] == null || (json['date_time'] as String).isEmpty)
              ? EN_LANG_TEXT['date_time']
              : json['date_time'],
      tax: (json['tax'] == null || (json['tax'] as String).isEmpty)
          ? EN_LANG_TEXT['tax']
          : json['tax'],
      taxInvoice: (json['tax_invoice'] == null ||
              (json['tax_invoice'] as String).isEmpty)
          ? EN_LANG_TEXT['tax_invoice']
          : json['tax_invoice'],
      abn: (json['abn'] == null || (json['abn'] as String).isEmpty)
          ? EN_LANG_TEXT['abn']
          : json['abn'],
      description: (json['description'] == null ||
              (json['description'] as String).isEmpty)
          ? EN_LANG_TEXT['description']
          : json['description'],
      sentTKtchn: (json['sent_t_ktchn'] == null ||
              (json['sent_t_ktchn'] as String).isEmpty)
          ? EN_LANG_TEXT['sent_t_ktchn']
          : json['sent_t_ktchn'],
      placeOrder: (json['place_order'] == null ||
              (json['place_order'] as String).isEmpty)
          ? EN_LANG_TEXT['place_order']
          : json['place_order'],
      subtotal:
          (json['subtotal'] == null || (json['subtotal'] as String).isEmpty)
              ? EN_LANG_TEXT['subtotal']
              : json['subtotal'],
      taxIncInTotal: (json['tax_inc_in_total'] == null ||
              (json['tax_inc_in_total'] as String).isEmpty)
          ? EN_LANG_TEXT['tax_inc_in_total']
          : json['tax_inc_in_total'],
      total: (json['total'] == null || (json['total'] as String).isEmpty)
          ? EN_LANG_TEXT['total']
          : json['total'],
      tableNumber: (json['table_number'] == null ||
              (json['table_number'] as String).isEmpty)
          ? EN_LANG_TEXT['table_number']
          : json['table_number'],
      chooseStaffs: (json['choose_staffs'] == null ||
              (json['choose_staffs'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_staffs']
          : json['choose_staffs'],
      cashInOut: (json['cash_in_out'] == null ||
              (json['cash_in_out'] as String).isEmpty)
          ? EN_LANG_TEXT['cash_in_out']
          : json['cash_in_out'],
      cash: (json['cash'] == null || (json['cash'] as String).isEmpty)
          ? EN_LANG_TEXT['cash']
          : json['cash'],
      pleaseEtrVal: (json['please_etr_val'] == null ||
              (json['please_etr_val'] as String).isEmpty)
          ? EN_LANG_TEXT['please_etr_val']
          : json['please_etr_val'],
      yourNoteHere: (json['your_note_here'] == null ||
              (json['your_note_here'] as String).isEmpty)
          ? EN_LANG_TEXT['your_note_here']
          : json['your_note_here'],
      cashIn: (json['cash_in'] == null || (json['cash_in'] as String).isEmpty)
          ? EN_LANG_TEXT['cash_in']
          : json['cash_in'],
      cashOut:
          (json['cash_out'] == null || (json['cash_out'] as String).isEmpty)
              ? EN_LANG_TEXT['cash_out']
              : json['cash_out'],
      payHistory: (json['pay_history'] == null ||
              (json['pay_history'] as String).isEmpty)
          ? EN_LANG_TEXT['pay_history']
          : json['pay_history'],
      endOfTheDay: (json['end_of_the_day'] == null ||
              (json['end_of_the_day'] as String).isEmpty)
          ? EN_LANG_TEXT['end_of_the_day']
          : json['end_of_the_day'],
      paymentDetails: (json['payment_details'] == null ||
              (json['payment_details'] as String).isEmpty)
          ? EN_LANG_TEXT['payment_details']
          : json['payment_details'],
      cashCounterAmount: (json['cash_counter_amount'] == null ||
              (json['cash_counter_amount'] as String).isEmpty)
          ? EN_LANG_TEXT['cash_counter_amount']
          : json['cash_counter_amount'],
      status: (json['status'] == null || (json['status'] as String).isEmpty)
          ? EN_LANG_TEXT['status']
          : json['status'],
      receivableFromDoor: (json['receivable_from_door'] == null ||
              (json['receivable_from_door'] as String).isEmpty)
          ? EN_LANG_TEXT['receivable_from_door']
          : json['receivable_from_door'],
      totalCounted: (json['total_counted'] == null ||
              (json['total_counted'] as String).isEmpty)
          ? EN_LANG_TEXT['total_counted']
          : json['total_counted'],
      difference:
          (json['difference'] == null || (json['difference'] as String).isEmpty)
              ? EN_LANG_TEXT['difference']
              : json['difference'],
      cashOutIn: (json['cash_out_in'] == null ||
              (json['cash_out_in'] as String).isEmpty)
          ? EN_LANG_TEXT['cash_out_in']
          : json['cash_out_in'],
      finalizeNow: (json['finalize_now'] == null ||
              (json['finalize_now'] as String).isEmpty)
          ? EN_LANG_TEXT['finalize_now']
          : json['finalize_now'],
      cashCountedAmt: (json['cash_counted_amt'] == null ||
              (json['cash_counted_amt'] as String).isEmpty)
          ? EN_LANG_TEXT['cash_counted_amt']
          : json['cash_counted_amt'],
      eftpos: (json['eftpos'] == null || (json['eftpos'] as String).isEmpty)
          ? EN_LANG_TEXT['eftpos']
          : json['eftpos'],
      giftCardSales: (json['gift_card_sales'] == null ||
              (json['gift_card_sales'] as String).isEmpty)
          ? EN_LANG_TEXT['gift_card_sales']
          : json['gift_card_sales'],
      giftCardRedem: (json['gift_card_redem'] == null ||
              (json['gift_card_redem'] as String).isEmpty)
          ? EN_LANG_TEXT['gift_card_redem']
          : json['gift_card_redem'],
      float: (json['float'] == null || (json['float'] as String).isEmpty)
          ? EN_LANG_TEXT['float']
          : json['float'],
      receivableFromUber: (json['receivable_from_uber'] == null ||
              (json['receivable_from_uber'] as String).isEmpty)
          ? EN_LANG_TEXT['receivable_from_uber']
          : json['receivable_from_uber'],
      grossSales: (json['gross_sales'] == null ||
              (json['gross_sales'] as String).isEmpty)
          ? EN_LANG_TEXT['gross_sales']
          : json['gross_sales'],
      gst: (json['gst'] == null || (json['gst'] as String).isEmpty)
          ? EN_LANG_TEXT['gst']
          : json['gst'],
      viods: (json['viods'] == null || (json['viods'] as String).isEmpty)
          ? EN_LANG_TEXT['viods']
          : json['viods'],
      refunds: (json['refunds'] == null || (json['refunds'] as String).isEmpty)
          ? EN_LANG_TEXT['refunds']
          : json['refunds'],
      rounding:
          (json['rounding'] == null || (json['rounding'] as String).isEmpty)
              ? EN_LANG_TEXT['rounding']
              : json['rounding'],
      training:
          (json['training'] == null || (json['training'] as String).isEmpty)
              ? EN_LANG_TEXT['training']
              : json['training'],
      netSales:
          (json['net_sales'] == null || (json['net_sales'] as String).isEmpty)
              ? EN_LANG_TEXT['net_sales']
              : json['net_sales'],
      noOfTransaction: (json['no_of_transaction'] == null ||
              (json['no_of_transaction'] as String).isEmpty)
          ? EN_LANG_TEXT['no_of_transaction']
          : json['no_of_transaction'],
      noOfItemSold: (json['no_of_item_sold'] == null ||
              (json['no_of_item_sold'] as String).isEmpty)
          ? EN_LANG_TEXT['no_of_item_sold']
          : json['no_of_item_sold'],
      noOfVoids: (json['no_of_voids'] == null ||
              (json['no_of_voids'] as String).isEmpty)
          ? EN_LANG_TEXT['no_of_voids']
          : json['no_of_voids'],
      noOfTraining: (json['no_of_training'] == null ||
              (json['no_of_training'] as String).isEmpty)
          ? EN_LANG_TEXT['no_of_training']
          : json['no_of_training'],
      accumulatedSales: (json['accumulated_sales'] == null ||
              (json['accumulated_sales'] as String).isEmpty)
          ? EN_LANG_TEXT['accumulated_sales']
          : json['accumulated_sales'],
      accumulatedNoOfItems: (json['accumulated_no_of_items'] == null ||
              (json['accumulated_no_of_items'] as String).isEmpty)
          ? EN_LANG_TEXT['accumulated_no_of_items']
          : json['accumulated_no_of_items'],
      dateNTime: (json['date_n_time'] == null ||
              (json['date_n_time'] as String).isEmpty)
          ? EN_LANG_TEXT['date_n_time']
          : json['date_n_time'],
      finalReport: (json['final_report'] == null ||
              (json['final_report'] as String).isEmpty)
          ? EN_LANG_TEXT['final_report']
          : json['final_report'],
      eodDeclaration: (json['eod_declaration'] == null ||
              (json['eod_declaration'] as String).isEmpty)
          ? EN_LANG_TEXT['eod_declaration']
          : json['eod_declaration'],
      download:
          (json['download'] == null || (json['download'] as String).isEmpty)
              ? EN_LANG_TEXT['download']
              : json['download'],
      printReceipt: (json['print_receipt'] == null ||
              (json['print_receipt'] as String).isEmpty)
          ? EN_LANG_TEXT['print_receipt']
          : json['print_receipt'],
      emailReceipt: (json['email_receipt'] == null ||
              (json['email_receipt'] as String).isEmpty)
          ? EN_LANG_TEXT['email_receipt']
          : json['email_receipt'],
      date: (json['date'] == null || (json['date'] as String).isEmpty)
          ? EN_LANG_TEXT['date']
          : json['date'],
      recieptNo:
          (json['reciept_no'] == null || (json['reciept_no'] as String).isEmpty)
              ? EN_LANG_TEXT['reciept_no']
              : json['reciept_no'],
      salesAmount: (json['sales_amount'] == null ||
              (json['sales_amount'] as String).isEmpty)
          ? EN_LANG_TEXT['sales_amount']
          : json['sales_amount'],
      paymentMethod: (json['payment_method'] == null ||
              (json['payment_method'] as String).isEmpty)
          ? EN_LANG_TEXT['payment_method']
          : json['payment_method'],
      bank: (json['bank'] == null || (json['bank'] as String).isEmpty)
          ? EN_LANG_TEXT['bank']
          : json['bank'],
      storeAndEndDate: (json['store_and_end_date'] == null ||
              (json['store_and_end_date'] as String).isEmpty)
          ? EN_LANG_TEXT['store_and_end_date']
          : json['store_and_end_date'],
      receiptNo:
          (json['receipt_no'] == null || (json['receipt_no'] as String).isEmpty)
              ? EN_LANG_TEXT['receipt_no']
              : json['receipt_no'],
      productName: (json['product_name'] == null ||
              (json['product_name'] as String).isEmpty)
          ? EN_LANG_TEXT['product_name']
          : json['product_name'],
      history: (json['history'] == null || (json['history'] as String).isEmpty)
          ? EN_LANG_TEXT['history']
          : json['history'],
      pastDays:
          (json['past_days'] == null || (json['past_days'] as String).isEmpty)
              ? EN_LANG_TEXT['past_days']
              : json['past_days'],
      searchNow:
          (json['search_now'] == null || (json['search_now'] as String).isEmpty)
              ? EN_LANG_TEXT['search_now']
              : json['search_now'],
      historyReport: (json['history_report'] == null ||
              (json['history_report'] as String).isEmpty)
          ? EN_LANG_TEXT['history_report']
          : json['history_report'],
      added: (json['added'] == null || (json['added'] as String).isEmpty)
          ? EN_LANG_TEXT['added']
          : json['added'],
      setMenu:
          (json['set_menu'] == null || (json['set_menu'] as String).isEmpty)
              ? EN_LANG_TEXT['set_menu']
              : json['set_menu'],
      quantity:
          (json['quantity'] == null || (json['quantity'] as String).isEmpty)
              ? EN_LANG_TEXT['quantity']
              : json['quantity'],
      addToCart: (json['add_to_cart'] == null ||
              (json['add_to_cart'] as String).isEmpty)
          ? EN_LANG_TEXT['add_to_cart']
          : json['add_to_cart'],
      categories:
          (json['categories'] == null || (json['categories'] as String).isEmpty)
              ? EN_LANG_TEXT['categories']
              : json['categories'],
      frequentlySellingProducts: (json['frequently_selling_products'] == null ||
              (json['frequently_selling_products'] as String).isEmpty)
          ? EN_LANG_TEXT['frequently_selling_products']
          : json['frequently_selling_products'],
      chooseOrderType: (json['choose_order_type'] == null ||
              (json['choose_order_type'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_order_type']
          : json['choose_order_type'],
      plzChooseOrderType: (json['plz_choose_order_type'] == null ||
              (json['plz_choose_order_type'] as String).isEmpty)
          ? EN_LANG_TEXT['plz_choose_order_type']
          : json['plz_choose_order_type'],
      emptyAdons: (json['empty_adons'] == null ||
              (json['empty_adons'] as String).isEmpty)
          ? EN_LANG_TEXT['empty_adons']
          : json['empty_adons'],
      save: (json['save'] == null || (json['save'] as String).isEmpty)
          ? EN_LANG_TEXT['save']
          : json['save'],
      productLists: (json['product_lists'] == null ||
              (json['product_lists'] as String).isEmpty)
          ? EN_LANG_TEXT['product_lists']
          : json['product_lists'],
      products:
          (json['products'] == null || (json['products'] as String).isEmpty)
              ? EN_LANG_TEXT['products']
              : json['products'],
      delete: (json['delete'] == null || (json['delete'] as String).isEmpty)
          ? EN_LANG_TEXT['delete']
          : json['delete'],
      variations:
          (json['variations'] == null || (json['variations'] as String).isEmpty)
              ? EN_LANG_TEXT['variations']
              : json['variations'],
      defaultText: (json['default_text'] == null ||
              (json['default_text'] as String).isEmpty)
          ? EN_LANG_TEXT['default_text']
          : json['default_text'],
      calories:
          (json['calories'] == null || (json['calories'] as String).isEmpty)
              ? EN_LANG_TEXT['calories']
              : json['calories'],
      stock: (json['stock'] == null || (json['stock'] as String).isEmpty)
          ? EN_LANG_TEXT['stock']
          : json['stock'],
      minStockAlert: (json['min_stock_alert'] == null ||
              (json['min_stock_alert'] as String).isEmpty)
          ? EN_LANG_TEXT['min_stock_alert']
          : json['min_stock_alert'],
      maxStockAlert: (json['max_stock_alert'] == null ||
              (json['max_stock_alert'] as String).isEmpty)
          ? EN_LANG_TEXT['max_stock_alert']
          : json['max_stock_alert'],
      recentlyAddedProducts: (json['recently_added_products'] == null ||
              (json['recently_added_products'] as String).isEmpty)
          ? EN_LANG_TEXT['recently_added_products']
          : json['recently_added_products'],
      addNewProducts: (json['add_new_products'] == null ||
              (json['add_new_products'] as String).isEmpty)
          ? EN_LANG_TEXT['add_new_products']
          : json['add_new_products'],
      updateProduct: (json['update_product'] == null ||
              (json['update_product'] as String).isEmpty)
          ? EN_LANG_TEXT['update_product']
          : json['update_product'],
      recentlyAddedProduct: (json['recently_added_product'] == null ||
              (json['recently_added_product'] as String).isEmpty)
          ? EN_LANG_TEXT['recently_added_product']
          : json['recently_added_product'],
      featuredProduct: (json['featured_product'] == null ||
              (json['featured_product'] as String).isEmpty)
          ? EN_LANG_TEXT['featured_product']
          : json['featured_product'],
      createSetMenu: (json['create_set_menu'] == null ||
              (json['create_set_menu'] as String).isEmpty)
          ? EN_LANG_TEXT['create_set_menu']
          : json['create_set_menu'],
      productDescription: (json['product_description'] == null ||
              (json['product_description'] as String).isEmpty)
          ? EN_LANG_TEXT['product_description']
          : json['product_description'],
      category:
          (json['category'] == null || (json['category'] as String).isEmpty)
              ? EN_LANG_TEXT['category']
              : json['category'],
      chooseCategory: (json['choose_category'] == null ||
              (json['choose_category'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_category']
          : json['choose_category'],
      brand: (json['brand'] == null || (json['brand'] as String).isEmpty)
          ? EN_LANG_TEXT['brand']
          : json['brand'],
      chooseBrand: (json['choose_brand'] == null ||
              (json['choose_brand'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_brand']
          : json['choose_brand'],
      taxIncExcl: (json['tax_inc_excl'] == null ||
              (json['tax_inc_excl'] as String).isEmpty)
          ? EN_LANG_TEXT['tax_inc_excl']
          : json['tax_inc_excl'],
      chooseTaxType: (json['choose_tax_type'] == null ||
              (json['choose_tax_type'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_tax_type']
          : json['choose_tax_type'],
      productCode: (json['product_code'] == null ||
              (json['product_code'] as String).isEmpty)
          ? EN_LANG_TEXT['product_code']
          : json['product_code'],
      addProductImage: (json['add_product_image'] == null ||
              (json['add_product_image'] as String).isEmpty)
          ? EN_LANG_TEXT['add_product_image']
          : json['add_product_image'],
      alreadyListedOnAdons: (json['already_listed_on_adons'] == null ||
              (json['already_listed_on_adons'] as String).isEmpty)
          ? EN_LANG_TEXT['already_listed_on_adons']
          : json['already_listed_on_adons'],
      mainProdCantListed: (json['main_prod_cant_listed'] == null ||
              (json['main_prod_cant_listed'] as String).isEmpty)
          ? EN_LANG_TEXT['main_prod_cant_listed']
          : json['main_prod_cant_listed'],
      addProduct: (json['add_product'] == null ||
              (json['add_product'] as String).isEmpty)
          ? EN_LANG_TEXT['add_product']
          : json['add_product'],
      searchSetMenu: (json['search_set_menu'] == null ||
              (json['search_set_menu'] as String).isEmpty)
          ? EN_LANG_TEXT['search_set_menu']
          : json['search_set_menu'],
      setMenuSmall: (json['set_menu_small'] == null ||
              (json['set_menu_small'] as String).isEmpty)
          ? EN_LANG_TEXT['set_menu_small']
          : json['set_menu_small'],
      noImage:
          (json['no_image'] == null || (json['no_image'] as String).isEmpty)
              ? EN_LANG_TEXT['no_image']
              : json['no_image'],
      ourSetMenu: (json['our_set_menu'] == null ||
              (json['our_set_menu'] as String).isEmpty)
          ? EN_LANG_TEXT['our_set_menu']
          : json['our_set_menu'],
      addDescription: (json['add_description'] == null ||
              (json['add_description'] as String).isEmpty)
          ? EN_LANG_TEXT['add_description']
          : json['add_description'],
      noProducts: (json['no_products'] == null ||
              (json['no_products'] as String).isEmpty)
          ? EN_LANG_TEXT['no_products']
          : json['no_products'],
      allSetMenu: (json['all_set_menu'] == null ||
              (json['all_set_menu'] as String).isEmpty)
          ? EN_LANG_TEXT['all_set_menu']
          : json['all_set_menu'],
      updateSetMenu: (json['update_set_menu'] == null ||
              (json['update_set_menu'] as String).isEmpty)
          ? EN_LANG_TEXT['update_set_menu']
          : json['update_set_menu'],
      nameOfSetMenu: (json['name_of_set_menu'] == null ||
              (json['name_of_set_menu'] as String).isEmpty)
          ? EN_LANG_TEXT['name_of_set_menu']
          : json['name_of_set_menu'],
      taxType:
          (json['tax_type'] == null || (json['tax_type'] as String).isEmpty)
              ? EN_LANG_TEXT['tax_type']
              : json['tax_type'],
      addSetMenuImage: (json['add_set_menu_image'] == null ||
              (json['add_set_menu_image'] as String).isEmpty)
          ? EN_LANG_TEXT['add_set_menu_image']
          : json['add_set_menu_image'],
      creatNewLayout: (json['creat_new_layout'] == null ||
              (json['creat_new_layout'] as String).isEmpty)
          ? EN_LANG_TEXT['creat_new_layout']
          : json['creat_new_layout'],
      roundTable: (json['round_table'] == null ||
              (json['round_table'] as String).isEmpty)
          ? EN_LANG_TEXT['round_table']
          : json['round_table'],
      tableBooking: (json['table_booking'] == null ||
              (json['table_booking'] as String).isEmpty)
          ? EN_LANG_TEXT['table_booking']
          : json['table_booking'],
      changePassword: (json['change_password'] == null ||
              (json['change_password'] as String).isEmpty)
          ? EN_LANG_TEXT['change_password']
          : json['change_password'],
      oldPassword: (json['old_password'] == null ||
              (json['old_password'] as String).isEmpty)
          ? EN_LANG_TEXT['old_password']
          : json['old_password'],
      newPassword: (json['new_password'] == null ||
              (json['new_password'] as String).isEmpty)
          ? EN_LANG_TEXT['new_password']
          : json['new_password'],
      confirmNewPassword: (json['confirm_new_password'] == null ||
              (json['confirm_new_password'] as String).isEmpty)
          ? EN_LANG_TEXT['confirm_new_password']
          : json['confirm_new_password'],
      addNewBrand: (json['add_new_brand'] == null ||
              (json['add_new_brand'] as String).isEmpty)
          ? EN_LANG_TEXT['add_new_brand']
          : json['add_new_brand'],
      active: (json['active'] == null || (json['active'] as String).isEmpty)
          ? EN_LANG_TEXT['active']
          : json['active'],
      inActive:
          (json['in_active'] == null || (json['in_active'] as String).isEmpty)
              ? EN_LANG_TEXT['in_active']
              : json['in_active'],
      addNewCategory: (json['add_new_category'] == null ||
              (json['add_new_category'] as String).isEmpty)
          ? EN_LANG_TEXT['add_new_category']
          : json['add_new_category'],
      categoriesSmall: (json['categories_small'] == null ||
              (json['categories_small'] as String).isEmpty)
          ? EN_LANG_TEXT['categories_small']
          : json['categories_small'],
      isPosOrderType: (json['is_pos_order_type'] == null ||
              (json['is_pos_order_type'] as String).isEmpty)
          ? EN_LANG_TEXT['is_pos_order_type']
          : json['is_pos_order_type'],
      isOnlineOrderType: (json['is_online_order_type'] == null ||
              (json['is_online_order_type'] as String).isEmpty)
          ? EN_LANG_TEXT['is_online_order_type']
          : json['is_online_order_type'],
      saveNAddAnother: (json['save_n_add_another'] == null ||
              (json['save_n_add_another'] as String).isEmpty)
          ? EN_LANG_TEXT['save_n_add_another']
          : json['save_n_add_another'],
      addNewOrderType: (json['add_new_order_type'] == null ||
              (json['add_new_order_type'] as String).isEmpty)
          ? EN_LANG_TEXT['add_new_order_type']
          : json['add_new_order_type'],
      orderTypes: (json['order_types'] == null ||
              (json['order_types'] as String).isEmpty)
          ? EN_LANG_TEXT['order_types']
          : json['order_types'],
      defaultImages: (json['default_images'] == null ||
              (json['default_images'] as String).isEmpty)
          ? EN_LANG_TEXT['default_images']
          : json['default_images'],
      searchMenuImages: (json['search_menu_images'] == null ||
              (json['search_menu_images'] as String).isEmpty)
          ? EN_LANG_TEXT['search_menu_images']
          : json['search_menu_images'],
      confirm: (json['confirm'] == null || (json['confirm'] as String).isEmpty)
          ? EN_LANG_TEXT['confirm']
          : json['confirm'],
      addNewTable: (json['add_new_table'] == null ||
              (json['add_new_table'] as String).isEmpty)
          ? EN_LANG_TEXT['add_new_table']
          : json['add_new_table'],
      tableLocEmpty: (json['table_loc_empty'] == null ||
              (json['table_loc_empty'] as String).isEmpty)
          ? EN_LANG_TEXT['table_loc_empty']
          : json['table_loc_empty'],
      chooseTableLoc: (json['choose_table_loc'] == null ||
              (json['choose_table_loc'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_table_loc']
          : json['choose_table_loc'],
      addImage:
          (json['add_image'] == null || (json['add_image'] as String).isEmpty)
              ? EN_LANG_TEXT['add_image']
              : json['add_image'],
      tableNumbers: (json['table_numbers'] == null ||
              (json['table_numbers'] as String).isEmpty)
          ? EN_LANG_TEXT['table_numbers']
          : json['table_numbers'],
      addNewLoc: (json['add_new_loc'] == null ||
              (json['add_new_loc'] as String).isEmpty)
          ? EN_LANG_TEXT['add_new_loc']
          : json['add_new_loc'],
      tableLocations: (json['table_locations'] == null ||
              (json['table_locations'] as String).isEmpty)
          ? EN_LANG_TEXT['table_locations']
          : json['table_locations'],
      addTax: (json['add_tax'] == null || (json['add_tax'] as String).isEmpty)
          ? EN_LANG_TEXT['add_tax']
          : json['add_tax'],
      taxTypes:
          (json['tax_types'] == null || (json['tax_types'] as String).isEmpty)
              ? EN_LANG_TEXT['tax_types']
              : json['tax_types'],
      generalSettings: (json['general_settings'] == null ||
              (json['general_settings'] as String).isEmpty)
          ? EN_LANG_TEXT['general_settings']
          : json['general_settings'],
      tableNo:
          (json['table_no'] == null || (json['table_no'] as String).isEmpty)
              ? EN_LANG_TEXT['table_no']
              : json['table_no'],
      chooseTableNo: (json['choose_table_no'] == null ||
              (json['choose_table_no'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_table_no']
          : json['choose_table_no'],
      addNewDepartment: (json['add_new_department'] == null ||
              (json['add_new_department'] as String).isEmpty)
          ? EN_LANG_TEXT['add_new_department']
          : json['add_new_department'],
      addPrinterLocation: (json['add_printer_location'] == null ||
              (json['add_printer_location'] as String).isEmpty)
          ? EN_LANG_TEXT['add_printer_location']
          : json['add_printer_location'],
      chooseDepartment: (json['choose_department'] == null ||
              (json['choose_department'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_department']
          : json['choose_department'],
      printerLocations: (json['printer_locations'] == null ||
              (json['printer_locations'] as String).isEmpty)
          ? EN_LANG_TEXT['printer_locations']
          : json['printer_locations'],
      posPrinterSettings: (json['pos_printer_settings'] == null ||
              (json['pos_printer_settings'] as String).isEmpty)
          ? EN_LANG_TEXT['pos_printer_settings']
          : json['pos_printer_settings'],
      printerLocation: (json['printer_location'] == null ||
              (json['printer_location'] as String).isEmpty)
          ? EN_LANG_TEXT['printer_location']
          : json['printer_location'],
      distanceType: (json['distance_type'] == null ||
              (json['distance_type'] as String).isEmpty)
          ? EN_LANG_TEXT['distance_type']
          : json['distance_type'],
      distanceFrom: (json['distance_from'] == null ||
              (json['distance_from'] as String).isEmpty)
          ? EN_LANG_TEXT['distance_from']
          : json['distance_from'],
      distanceTo: (json['distance_to'] == null ||
              (json['distance_to'] as String).isEmpty)
          ? EN_LANG_TEXT['distance_to']
          : json['distance_to'],
      amount: (json['amount'] == null || (json['amount'] as String).isEmpty)
          ? EN_LANG_TEXT['amount']
          : json['amount'],
      storeName:
          (json['store_name'] == null || (json['store_name'] as String).isEmpty)
              ? EN_LANG_TEXT['store_name']
              : json['store_name'],
      abnNum: (json['abn_num'] == null || (json['abn_num'] as String).isEmpty)
          ? EN_LANG_TEXT['abn_num']
          : json['abn_num'],
      storeImage: (json['store_image'] == null ||
              (json['store_image'] as String).isEmpty)
          ? EN_LANG_TEXT['store_image']
          : json['store_image'],
      url: (json['url'] == null || (json['url'] as String).isEmpty)
          ? EN_LANG_TEXT['url']
          : json['url'],
      language:
          (json['language'] == null || (json['language'] as String).isEmpty)
              ? EN_LANG_TEXT['language']
              : json['language'],
      holidaySurPercent: (json['holiday_sur_percent'] == null ||
              (json['holiday_sur_percent'] as String).isEmpty)
          ? EN_LANG_TEXT['holiday_sur_percent']
          : json['holiday_sur_percent'],
      invalidNumber: (json['invalid_number'] == null ||
              (json['invalid_number'] as String).isEmpty)
          ? EN_LANG_TEXT['invalid_number']
          : json['invalid_number'],
      franchise:
          (json['franchise'] == null || (json['franchise'] as String).isEmpty)
              ? EN_LANG_TEXT['franchise']
              : json['franchise'],
      template:
          (json['template'] == null || (json['template'] as String).isEmpty)
              ? EN_LANG_TEXT['template']
              : json['template'],
      businessType: (json['business_type'] == null ||
              (json['business_type'] as String).isEmpty)
          ? EN_LANG_TEXT['business_type']
          : json['business_type'],
      storeType:
          (json['store_type'] == null || (json['store_type'] as String).isEmpty)
              ? EN_LANG_TEXT['store_type']
              : json['store_type'],
      country: (json['country'] == null || (json['country'] as String).isEmpty)
          ? EN_LANG_TEXT['country']
          : json['country'],
      city: (json['city'] == null || (json['city'] as String).isEmpty)
          ? EN_LANG_TEXT['city']
          : json['city'],
      address: (json['address'] == null || (json['address'] as String).isEmpty)
          ? EN_LANG_TEXT['address']
          : json['address'],
      latitude:
          (json['latitude'] == null || (json['latitude'] as String).isEmpty)
              ? EN_LANG_TEXT['latitude']
              : json['latitude'],
      longitude:
          (json['longitude'] == null || (json['longitude'] as String).isEmpty)
              ? EN_LANG_TEXT['longitude']
              : json['longitude'],
      timezone:
          (json['timezone'] == null || (json['timezone'] as String).isEmpty)
              ? EN_LANG_TEXT['timezone']
              : json['timezone'],
      pickUpHours: (json['pick_up_hours'] == null ||
              (json['pick_up_hours'] as String).isEmpty)
          ? EN_LANG_TEXT['pick_up_hours']
          : json['pick_up_hours'],
      deliveryHours: (json['delivery_hours'] == null ||
              (json['delivery_hours'] as String).isEmpty)
          ? EN_LANG_TEXT['delivery_hours']
          : json['delivery_hours'],
      day: (json['day'] == null || (json['day'] as String).isEmpty)
          ? EN_LANG_TEXT['day']
          : json['day'],
      openTime:
          (json['open_time'] == null || (json['open_time'] as String).isEmpty)
              ? EN_LANG_TEXT['open_time']
              : json['open_time'],
      closeTime:
          (json['close_time'] == null || (json['close_time'] as String).isEmpty)
              ? EN_LANG_TEXT['close_time']
              : json['close_time'],
      isClosed:
          (json['is_closed'] == null || (json['is_closed'] as String).isEmpty)
              ? EN_LANG_TEXT['is_closed']
              : json['is_closed'],
      maxClaimAmt: (json['max_claim_amt'] == null ||
              (json['max_claim_amt'] as String).isEmpty)
          ? EN_LANG_TEXT['max_claim_amt']
          : json['max_claim_amt'],
      maxClaimPoints: (json['max_claim_points'] == null ||
              (json['max_claim_points'] as String).isEmpty)
          ? EN_LANG_TEXT['max_claim_points']
          : json['max_claim_points'],
      amtFrom:
          (json['amt_from'] == null || (json['amt_from'] as String).isEmpty)
              ? EN_LANG_TEXT['amt_from']
              : json['amt_from'],
      amtTo: (json['amt_to'] == null || (json['amt_to'] as String).isEmpty)
          ? EN_LANG_TEXT['amt_to']
          : json['amt_to'],
      points: (json['points'] == null || (json['points'] as String).isEmpty)
          ? EN_LANG_TEXT['points']
          : json['points'],
      general: (json['general'] == null || (json['general'] as String).isEmpty)
          ? EN_LANG_TEXT['general']
          : json['general'],
      loyalty: (json['loyalty'] == null || (json['loyalty'] as String).isEmpty)
          ? EN_LANG_TEXT['loyalty']
          : json['loyalty'],
      deliveryDistance: (json['delivery_distance'] == null ||
              (json['delivery_distance'] as String).isEmpty)
          ? EN_LANG_TEXT['delivery_distance']
          : json['delivery_distance'],
      openingHours: (json['opening_hours'] == null ||
              (json['opening_hours'] as String).isEmpty)
          ? EN_LANG_TEXT['opening_hours']
          : json['opening_hours'],
      storeSettings: (json['store_settings'] == null ||
              (json['store_settings'] as String).isEmpty)
          ? EN_LANG_TEXT['store_settings']
          : json['store_settings'],
      settings:
          (json['settings'] == null || (json['settings'] as String).isEmpty)
              ? EN_LANG_TEXT['settings']
              : json['settings'],
      tableLayout: (json['table_layout'] == null ||
              (json['table_layout'] as String).isEmpty)
          ? EN_LANG_TEXT['table_layout']
          : json['table_layout'],
      whereYouCanSync: (json['where_you_can_sync'] == null ||
              (json['where_you_can_sync'] as String).isEmpty)
          ? EN_LANG_TEXT['where_you_can_sync']
          : json['where_you_can_sync'],
      syncFrom:
          (json['sync_from'] == null || (json['sync_from'] as String).isEmpty)
              ? EN_LANG_TEXT['sync_from']
              : json['sync_from'],
      syncTo: (json['sync_to'] == null || (json['sync_to'] as String).isEmpty)
          ? EN_LANG_TEXT['sync_to']
          : json['sync_to'],
      syncNow:
          (json['sync_now'] == null || (json['sync_now'] as String).isEmpty)
              ? EN_LANG_TEXT['sync_now']
              : json['sync_now'],
      viewOrder:
          (json['view_order'] == null || (json['view_order'] as String).isEmpty)
              ? EN_LANG_TEXT['view_order']
              : json['view_order'],
      moveOrder:
          (json['move_order'] == null || (json['move_order'] as String).isEmpty)
              ? EN_LANG_TEXT['move_order']
              : json['move_order'],
      acceptOrder: (json['accept_order'] == null ||
              (json['accept_order'] as String).isEmpty)
          ? EN_LANG_TEXT['accept_order']
          : json['accept_order'],
      rejectOrder: (json['reject_order'] == null ||
              (json['reject_order'] as String).isEmpty)
          ? EN_LANG_TEXT['reject_order']
          : json['reject_order'],
      orderNumber: (json['order_number'] == null ||
              (json['order_number'] as String).isEmpty)
          ? EN_LANG_TEXT['order_number']
          : json['order_number'],
      orderDate:
          (json['order_date'] == null || (json['order_date'] as String).isEmpty)
              ? EN_LANG_TEXT['order_date']
              : json['order_date'],
      tableName:
          (json['table_name'] == null || (json['table_name'] as String).isEmpty)
              ? EN_LANG_TEXT['table_name']
              : json['table_name'],
      orderChannel: (json['order_channel'] == null ||
              (json['order_channel'] as String).isEmpty)
          ? EN_LANG_TEXT['order_channel']
          : json['order_channel'],
      totalAmount: (json['total_amount'] == null ||
              (json['total_amount'] as String).isEmpty)
          ? EN_LANG_TEXT['total_amount']
          : json['total_amount'],
      addToBasket: (json['add_to_basket'] == null ||
              (json['add_to_basket'] as String).isEmpty)
          ? EN_LANG_TEXT['add_to_basket']
          : json['add_to_basket'],
      selectVarience: (json['select_varience'] == null ||
              (json['select_varience'] as String).isEmpty)
          ? EN_LANG_TEXT['select_varience']
          : json['select_varience'],
      selectSize: (json['select_size'] == null ||
              (json['select_size'] as String).isEmpty)
          ? EN_LANG_TEXT['select_size']
          : json['select_size'],
      selectAdons: (json['select_adons'] == null ||
              (json['select_adons'] as String).isEmpty)
          ? EN_LANG_TEXT['select_adons']
          : json['select_adons'],
      logout: (json['logout'] == null || (json['logout'] as String).isEmpty)
          ? EN_LANG_TEXT['logout']
          : json['logout'],
      sureToLogout: (json['sure_to_logout'] == null ||
              (json['sure_to_logout'] as String).isEmpty)
          ? EN_LANG_TEXT['sure_to_logout']
          : json['sure_to_logout'],
      logOut: (json['log_out'] == null || (json['log_out'] as String).isEmpty)
          ? EN_LANG_TEXT['log_out']
          : json['log_out'],
      splashScreen: (json['splash_screen'] == null ||
              (json['splash_screen'] as String).isEmpty)
          ? EN_LANG_TEXT['splash_screen']
          : json['splash_screen'],
      error: (json['error'] == null || (json['error'] as String).isEmpty)
          ? EN_LANG_TEXT['error']
          : json['error'],
      unsupportedImage: (json['unsupported_image'] == null ||
              (json['unsupported_image'] as String).isEmpty)
          ? EN_LANG_TEXT['unsupported_image']
          : json['unsupported_image'],
      fieldMustNotBeEmpty: (json['field_must_not_be_empty'] == null ||
              (json['field_must_not_be_empty'] as String).isEmpty)
          ? EN_LANG_TEXT['field_must_not_be_empty']
          : json['field_must_not_be_empty'],
      wantToDelete: (json['want_to_delete'] == null ||
              (json['want_to_delete'] as String).isEmpty)
          ? EN_LANG_TEXT['want_to_delete']
          : json['want_to_delete'],
      of: (json['of'] == null || (json['of'] as String).isEmpty)
          ? EN_LANG_TEXT['of']
          : json['of'],
      passwordNotEmpty: (json['password_not_empty'] == null ||
              (json['password_not_empty'] as String).isEmpty)
          ? EN_LANG_TEXT['password_not_empty']
          : json['password_not_empty'],
      passwordMustContain: (json['password_must_contain'] == null ||
              (json['password_must_contain'] as String).isEmpty)
          ? EN_LANG_TEXT['password_must_contain']
          : json['password_must_contain'],
      passwordMustAtleast: (json['password_must_atleast'] == null ||
              (json['password_must_atleast'] as String).isEmpty)
          ? EN_LANG_TEXT['password_must_atleast']
          : json['password_must_atleast'],
      passwordDoesNtMatch: (json['password_does_nt_match'] == null ||
              (json['password_does_nt_match'] as String).isEmpty)
          ? EN_LANG_TEXT['password_does_nt_match']
          : json['password_does_nt_match'],
      invalidEmail: (json['invalid_email'] == null ||
              (json['invalid_email'] as String).isEmpty)
          ? EN_LANG_TEXT['invalid_email']
          : json['invalid_email'],
      regular: (json['regular'] == null || (json['regular'] as String).isEmpty)
          ? EN_LANG_TEXT['regular']
          : json['regular'],
      taxTypeIsEmpty: (json['tax_type_is_empty'] == null ||
              (json['tax_type_is_empty'] as String).isEmpty)
          ? EN_LANG_TEXT['tax_type_is_empty']
          : json['tax_type_is_empty'],
      adult: (json['adult'] == null || (json['adult'] as String).isEmpty)
          ? EN_LANG_TEXT['adult']
          : json['adult'],
      child: (json['child'] == null || (json['child'] as String).isEmpty)
          ? EN_LANG_TEXT['child']
          : json['child'],
      adultCapacity: (json['adult_capacity'] == null ||
              (json['adult_capacity'] as String).isEmpty)
          ? EN_LANG_TEXT['adult_capacity']
          : json['adult_capacity'],
      childCapacity: (json['child_capacity'] == null ||
              (json['child_capacity'] as String).isEmpty)
          ? EN_LANG_TEXT['child_capacity']
          : json['child_capacity'],
      sort: (json['sort'] == null || (json['sort'] as String).isEmpty)
          ? EN_LANG_TEXT['sort']
          : json['sort'],
      isActive:
          (json['is_active'] == null || (json['is_active'] as String).isEmpty)
              ? EN_LANG_TEXT['is_active']
              : json['is_active'],
      brandName:
          (json['brand_name'] == null || (json['brand_name'] as String).isEmpty)
              ? EN_LANG_TEXT['brand_name']
              : json['brand_name'],
      invalidSortNumber: (json['invalid_sort_number'] == null ||
              (json['invalid_sort_number'] as String).isEmpty)
          ? EN_LANG_TEXT['invalid_sort_number']
          : json['invalid_sort_number'],
      categoryName: (json['category_name'] == null ||
              (json['category_name'] as String).isEmpty)
          ? EN_LANG_TEXT['category_name']
          : json['category_name'],
      taxName:
          (json['tax_name'] == null || (json['tax_name'] as String).isEmpty)
              ? EN_LANG_TEXT['tax_name']
              : json['tax_name'],
      value: (json['value'] == null || (json['value'] as String).isEmpty)
          ? EN_LANG_TEXT['value']
          : json['value'],
      action: (json['action'] == null || (json['action'] as String).isEmpty)
          ? EN_LANG_TEXT['action']
          : json['action'],
      port: (json['port'] == null || (json['port'] as String).isEmpty)
          ? EN_LANG_TEXT['port']
          : json['port'],
      ipAddress:
          (json['ip_address'] == null || (json['ip_address'] as String).isEmpty)
              ? EN_LANG_TEXT['ip_address']
              : json['ip_address'],
      someFieldIsEmpty: (json['some_field_is_empty'] == null ||
              (json['some_field_is_empty'] as String).isEmpty)
          ? EN_LANG_TEXT['some_field_is_empty']
          : json['some_field_is_empty'],
      syncFromIsNotSelected: (json['sync_from_is_not_selected'] == null ||
              (json['sync_from_is_not_selected'] as String).isEmpty)
          ? EN_LANG_TEXT['sync_from_is_not_selected']
          : json['sync_from_is_not_selected'],
      syncToIsNotSelected: (json['sync_to_is_not_selected'] == null ||
              (json['sync_to_is_not_selected'] as String).isEmpty)
          ? EN_LANG_TEXT['sync_to_is_not_selected']
          : json['sync_to_is_not_selected'],
      noInternetConnection: (json['no_internet_connection'] == null ||
              (json['no_internet_connection'] as String).isEmpty)
          ? EN_LANG_TEXT['no_internet_connection']
          : json['no_internet_connection'],
      invalidResponseFormat: (json['invalid_response_format'] == null ||
              (json['invalid_response_format'] as String).isEmpty)
          ? EN_LANG_TEXT['invalid_response_format']
          : json['invalid_response_format'],
      categoriesAreDeleted: (json['categories_are_deleted'] == null ||
              (json['categories_are_deleted'] as String).isEmpty)
          ? EN_LANG_TEXT['categories_are_deleted']
          : json['categories_are_deleted'],
      brandsAreDeleted: (json['brands_are_deleted'] == null ||
              (json['brands_are_deleted'] as String).isEmpty)
          ? EN_LANG_TEXT['brands_are_deleted']
          : json['brands_are_deleted'],
      tablesAreDeleted: (json['tables_are_deleted'] == null ||
              (json['tables_are_deleted'] as String).isEmpty)
          ? EN_LANG_TEXT['tables_are_deleted']
          : json['tables_are_deleted'],
      somethingWentWrong: (json['something_went_wrong'] == null ||
              (json['something_went_wrong'] as String).isEmpty)
          ? EN_LANG_TEXT['something_went_wrong']
          : json['something_went_wrong'],
      orderTypesAreDeleted: (json['order_types_are_deleted'] == null ||
              (json['order_types_are_deleted'] as String).isEmpty)
          ? EN_LANG_TEXT['order_types_are_deleted']
          : json['order_types_are_deleted'],
      taxAreDeleted: (json['tax_are_deleted'] == null ||
              (json['tax_are_deleted'] as String).isEmpty)
          ? EN_LANG_TEXT['tax_are_deleted']
          : json['tax_are_deleted'],
      setmenuAreDeleted: (json['setmenu_are_deleted'] == null ||
              (json['setmenu_are_deleted'] as String).isEmpty)
          ? EN_LANG_TEXT['setmenu_are_deleted']
          : json['setmenu_are_deleted'],
      productsAreDeleted: (json['products_are_deleted'] == null ||
              (json['products_are_deleted'] as String).isEmpty)
          ? EN_LANG_TEXT['products_are_deleted']
          : json['products_are_deleted'],
      featProdAreDeleted: (json['feat_prod_are_deleted'] == null ||
              (json['feat_prod_are_deleted'] as String).isEmpty)
          ? EN_LANG_TEXT['feat_prod_are_deleted']
          : json['feat_prod_are_deleted'],
      departmentsAreDeleted: (json['departments_are_deleted'] == null ||
              (json['departments_are_deleted'] as String).isEmpty)
          ? EN_LANG_TEXT['departments_are_deleted']
          : json['departments_are_deleted'],
      posLocationsAreDeleted: (json['pos_locations_are_deleted'] == null ||
              (json['pos_locations_are_deleted'] as String).isEmpty)
          ? EN_LANG_TEXT['pos_locations_are_deleted']
          : json['pos_locations_are_deleted'],
      emailIsSent: (json['email_is_sent'] == null ||
              (json['email_is_sent'] as String).isEmpty)
          ? EN_LANG_TEXT['email_is_sent']
          : json['email_is_sent'],
      success: (json['success'] == null || (json['success'] as String).isEmpty)
          ? EN_LANG_TEXT['success']
          : json['success'],
      tip: (json['tip'] == null || (json['tip'] as String).isEmpty)
          ? EN_LANG_TEXT['tip']
          : json['tip'],
      share: (json['share'] == null || (json['share'] as String).isEmpty)
          ? EN_LANG_TEXT['share']
          : json['share'],
      menu: (json['menu'] == null || (json['menu'] as String).isEmpty)
          ? EN_LANG_TEXT['menu']
          : json['menu'],
      productsTab: (json['products_tab'] == null ||
              (json['products_tab'] as String).isEmpty)
          ? EN_LANG_TEXT['products_tab']
          : json['products_tab'],
      sync: (json['sync'] == null || (json['sync'] as String).isEmpty)
          ? EN_LANG_TEXT['sync']
          : json['sync'],
      paymentWith: (json['payment_with'] == null ||
              (json['payment_with'] as String).isEmpty)
          ? EN_LANG_TEXT['payment_with']
          : json['payment_with'],
      time: (json['time'] == null || (json['time'] as String).isEmpty)
          ? EN_LANG_TEXT['time']
          : json['time'],
      notes: (json['notes'] == null || (json['notes'] as String).isEmpty)
          ? EN_LANG_TEXT['notes']
          : json['notes'],
      totalAmountTaken: (json['total_amount_taken'] == null ||
              (json['total_amount_taken'] as String).isEmpty)
          ? EN_LANG_TEXT['total_amount_taken']
          : json['total_amount_taken'],
      payAmount:
          (json['pay_amount'] == null || (json['pay_amount'] as String).isEmpty)
              ? EN_LANG_TEXT['pay_amount']
              : json['pay_amount'],
      booking: (json['booking'] == null || (json['booking'] as String).isEmpty)
          ? EN_LANG_TEXT['booking']
          : json['booking'],
      noOfCus:
          (json['no_of_cus'] == null || (json['no_of_cus'] as String).isEmpty)
              ? EN_LANG_TEXT['no_of_cus']
              : json['no_of_cus'],
      dateTimeFrom: (json['date_time_from'] == null ||
              (json['date_time_from'] as String).isEmpty)
          ? EN_LANG_TEXT['date_time_from']
          : json['date_time_from'],
      dateTimeTo: (json['date_time_to'] == null ||
              (json['date_time_to'] as String).isEmpty)
          ? EN_LANG_TEXT['date_time_to']
          : json['date_time_to'],
      bookNow:
          (json['book_now'] == null || (json['book_now'] as String).isEmpty)
              ? EN_LANG_TEXT['book_now']
              : json['book_now'],
      cusList:
          (json['cus_list'] == null || (json['cus_list'] as String).isEmpty)
              ? EN_LANG_TEXT['cus_list']
              : json['cus_list'],
      search: (json['search'] == null || (json['search'] as String).isEmpty)
          ? EN_LANG_TEXT['search']
          : json['search'],
      chooseDate: (json['choose_date'] == null ||
              (json['choose_date'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_date']
          : json['choose_date'],
      channel: (json['channel'] == null || (json['channel'] as String).isEmpty)
          ? EN_LANG_TEXT['channel']
          : json['channel'],
      areYouSureCancel: (json['are_you_sure_cancel'] == null ||
              (json['are_you_sure_cancel'] as String).isEmpty)
          ? EN_LANG_TEXT['are_you_sure_cancel']
          : json['are_you_sure_cancel'],
      areYouSureOk: (json['are_you_sure_ok'] == null ||
              (json['are_you_sure_ok'] as String).isEmpty)
          ? EN_LANG_TEXT['are_you_sure_ok']
          : json['are_you_sure_ok'],
      yes: (json['yes'] == null || (json['yes'] as String).isEmpty)
          ? EN_LANG_TEXT['yes']
          : json['yes'],
      no: (json['no'] == null || (json['no'] as String).isEmpty)
          ? EN_LANG_TEXT['no']
          : json['no'],
      reserveNo:
          (json['reserve_no'] == null || (json['reserve_no'] as String).isEmpty)
              ? EN_LANG_TEXT['reserve_no']
              : json['reserve_no'],
      cusUserU:
          (json['cus_user_u'] == null || (json['cus_user_u'] as String).isEmpty)
              ? EN_LANG_TEXT['cus_user_u']
              : json['cus_user_u'],
      na: (json['na'] == null || (json['na'] as String).isEmpty)
          ? EN_LANG_TEXT['na']
          : json['na'],
      orderDetailU: (json['order_detail_u'] == null ||
              (json['order_detail_u'] as String).isEmpty)
          ? EN_LANG_TEXT['order_detail_u']
          : json['order_detail_u'],
      orderNo:
          (json['order_no'] == null || (json['order_no'] as String).isEmpty)
              ? EN_LANG_TEXT['order_no']
              : json['order_no'],
      orderTypeU: (json['order_type_u'] == null ||
              (json['order_type_u'] as String).isEmpty)
          ? EN_LANG_TEXT['order_type_u']
          : json['order_type_u'],
      orderStatus: (json['order_status'] == null ||
              (json['order_status'] as String).isEmpty)
          ? EN_LANG_TEXT['order_status']
          : json['order_status'],
      deliveryAdd: (json['delivery_add'] == null ||
              (json['delivery_add'] as String).isEmpty)
          ? EN_LANG_TEXT['delivery_add']
          : json['delivery_add'],
      amountDetails: (json['amount_details'] == null ||
              (json['amount_details'] as String).isEmpty)
          ? EN_LANG_TEXT['amount_details']
          : json['amount_details'],
      subTotal:
          (json['sub_total'] == null || (json['sub_total'] as String).isEmpty)
              ? EN_LANG_TEXT['sub_total']
              : json['sub_total'],
      taxAmount:
          (json['tax_amount'] == null || (json['tax_amount'] as String).isEmpty)
              ? EN_LANG_TEXT['tax_amount']
              : json['tax_amount'],
      productWPriceD: (json['product_w_price_d'] == null ||
              (json['product_w_price_d'] as String).isEmpty)
          ? EN_LANG_TEXT['product_w_price_d']
          : json['product_w_price_d'],
      setmenuWPD: (json['setmenu_w_p_d'] == null ||
              (json['setmenu_w_p_d'] as String).isEmpty)
          ? EN_LANG_TEXT['setmenu_w_p_d']
          : json['setmenu_w_p_d'],
      transStatus: (json['trans_status'] == null ||
              (json['trans_status'] as String).isEmpty)
          ? EN_LANG_TEXT['trans_status']
          : json['trans_status'],
      holiSurgeAmt: (json['holi_surge_amt'] == null ||
              (json['holi_surge_amt'] as String).isEmpty)
          ? EN_LANG_TEXT['holi_surge_amt']
          : json['holi_surge_amt'],
      ccSurgeAmt: (json['cc_surge_amt'] == null ||
              (json['cc_surge_amt'] as String).isEmpty)
          ? EN_LANG_TEXT['cc_surge_amt']
          : json['cc_surge_amt'],
      noDataFound: (json['no_data_found'] == null ||
              (json['no_data_found'] as String).isEmpty)
          ? EN_LANG_TEXT['no_data_found']
          : json['no_data_found'],
      cancelOrder: (json['cancel_order'] == null ||
              (json['cancel_order'] as String).isEmpty)
          ? EN_LANG_TEXT['cancel_order']
          : json['cancel_order'],
      aystcOrder: (json['aystc_order'] == null ||
              (json['aystc_order'] as String).isEmpty)
          ? EN_LANG_TEXT['aystc_order']
          : json['aystc_order'],
      pay: (json['pay'] == null || (json['pay'] as String).isEmpty)
          ? EN_LANG_TEXT['pay']
          : json['pay'],
      notifiSet:
          (json['notifi_set'] == null || (json['notifi_set'] as String).isEmpty)
              ? EN_LANG_TEXT['notifi_set']
              : json['notifi_set'],
      taxTypeU:
          (json['tax_type_u'] == null || (json['tax_type_u'] as String).isEmpty)
              ? EN_LANG_TEXT['tax_type_u']
              : json['tax_type_u'],
      dateFormat: (json['date_format'] == null ||
              (json['date_format'] as String).isEmpty)
          ? EN_LANG_TEXT['date_format']
          : json['date_format'],
      productOutOfStock: (json['product_out_of_stock'] == null ||
              (json['product_out_of_stock'] as String).isEmpty)
          ? EN_LANG_TEXT['product_out_of_stock']
          : json['product_out_of_stock'],
      sortNo: (json['sort_no'] == null || (json['sort_no'] as String).isEmpty)
          ? EN_LANG_TEXT['sort_no']
          : json['sort_no'],
      posOrderType: (json['pos_order_type'] == null ||
              (json['pos_order_type'] as String).isEmpty)
          ? EN_LANG_TEXT['pos_order_type']
          : json['pos_order_type'],
      onlineOrderType: (json['online_order_type'] == null ||
              (json['online_order_type'] as String).isEmpty)
          ? EN_LANG_TEXT['online_order_type']
          : json['online_order_type'],
      allergens:
          (json['allergens'] == null || (json['allergens'] as String).isEmpty)
              ? EN_LANG_TEXT['allergens']
              : json['allergens'],
      loading: (json['loading'] == null || (json['loading'] as String).isEmpty)
          ? EN_LANG_TEXT['loading']
          : json['loading'],
      payMethodSetting: (json['pay_method_setting'] == null ||
              (json['pay_method_setting'] as String).isEmpty)
          ? EN_LANG_TEXT['pay_method_setting']
          : json['pay_method_setting'],
      key: (json['key'] == null || (json['key'] as String).isEmpty)
          ? EN_LANG_TEXT['key']
          : json['key'],
      secretKey:
          (json['secret_key'] == null || (json['secret_key'] as String).isEmpty)
              ? EN_LANG_TEXT['secret_key']
              : json['secret_key'],
      genQr: (json['gen_qr'] == null || (json['gen_qr'] as String).isEmpty)
          ? EN_LANG_TEXT['gen_qr']
          : json['gen_qr'],
      viewQr: (json['view_qr'] == null || (json['view_qr'] as String).isEmpty)
          ? EN_LANG_TEXT['view_qr']
          : json['view_qr'],
      tableQr:
          (json['table_qr'] == null || (json['table_qr'] as String).isEmpty)
              ? EN_LANG_TEXT['table_qr']
              : json['table_qr'],
      billAndSubs: (json['bill_and_subs'] == null ||
              (json['bill_and_subs'] as String).isEmpty)
          ? EN_LANG_TEXT['bill_and_subs']
          : json['bill_and_subs'],
      addNewCard: (json['add_new_card'] == null ||
              (json['add_new_card'] as String).isEmpty)
          ? EN_LANG_TEXT['add_new_card']
          : json['add_new_card'],
      nameOnCard: (json['name_on_card'] == null ||
              (json['name_on_card'] as String).isEmpty)
          ? EN_LANG_TEXT['name_on_card']
          : json['name_on_card'],
      enterNameCard: (json['enter_name_card'] == null ||
              (json['enter_name_card'] as String).isEmpty)
          ? EN_LANG_TEXT['enter_name_card']
          : json['enter_name_card'],
      emailAddress: (json['email_address'] == null ||
              (json['email_address'] as String).isEmpty)
          ? EN_LANG_TEXT['email_address']
          : json['email_address'],
      enterTheEmail: (json['enter_the_email'] == null ||
              (json['enter_the_email'] as String).isEmpty)
          ? EN_LANG_TEXT['enter_the_email']
          : json['enter_the_email'],
      poweredByStripe: (json['powered_by-stripe'] == null ||
              (json['powered_by-stripe'] as String).isEmpty)
          ? EN_LANG_TEXT['powered_by-stripe']
          : json['powered_by-stripe'],
      agreeTermsOnBilling: (json['agree_terms_on_billing'] == null ||
              (json['agree_terms_on_billing'] as String).isEmpty)
          ? EN_LANG_TEXT['agree_terms_on_billing']
          : json['agree_terms_on_billing'],
      saveAndUse: (json['save_and_use'] == null ||
              (json['save_and_use'] as String).isEmpty)
          ? EN_LANG_TEXT['save_and_use']
          : json['save_and_use'],
      biilingAddress: (json['biiling_address'] == null ||
              (json['biiling_address'] as String).isEmpty)
          ? EN_LANG_TEXT['biiling_address']
          : json['biiling_address'],
      state: (json['state'] == null || (json['state'] as String).isEmpty)
          ? EN_LANG_TEXT['state']
          : json['state'],
      street: (json['street'] == null || (json['street'] as String).isEmpty)
          ? EN_LANG_TEXT['street']
          : json['street'],
      postalCode: (json['postal_code'] == null ||
              (json['postal_code'] as String).isEmpty)
          ? EN_LANG_TEXT['postal_code']
          : json['postal_code'],
      npOfPos:
          (json['np_of_pos'] == null || (json['np_of_pos'] as String).isEmpty)
              ? EN_LANG_TEXT['np_of_pos']
              : json['np_of_pos'],
      expiryDate: (json['expiry_date'] == null ||
              (json['expiry_date'] as String).isEmpty)
          ? EN_LANG_TEXT['expiry_date']
          : json['expiry_date'],
      expiryDateCard: (json['expiry_date_card'] == null ||
              (json['expiry_date_card'] as String).isEmpty)
          ? EN_LANG_TEXT['expiry_date_card']
          : json['expiry_date_card'],
      cvv: (json['cvv'] == null || (json['cvv'] as String).isEmpty)
          ? EN_LANG_TEXT['cvv']
          : json['cvv'],
      securityCode: (json['security_code'] == null ||
              (json['security_code'] as String).isEmpty)
          ? EN_LANG_TEXT['security_code']
          : json['security_code'],
      cardNum:
          (json['card_num'] == null || (json['card_num'] as String).isEmpty)
              ? EN_LANG_TEXT['card_num']
              : json['card_num'],
      cardNumSub: (json['card_num_sub'] == null ||
              (json['card_num_sub'] as String).isEmpty)
          ? EN_LANG_TEXT['card_num_sub']
          : json['card_num_sub'],
      perMonLoc: (json['per_mon_loc'] == null ||
              (json['per_mon_loc'] as String).isEmpty)
          ? EN_LANG_TEXT['per_mon_loc']
          : json['per_mon_loc'],
      includes:
          (json['includes'] == null || (json['includes'] as String).isEmpty)
              ? EN_LANG_TEXT['includes']
              : json['includes'],
      integratePosapt: (json['integrate_posapt'] == null ||
              (json['integrate_posapt'] as String).isEmpty)
          ? EN_LANG_TEXT['integrate_posapt']
          : json['integrate_posapt'],
      buyNow: (json['buy_now'] == null || (json['buy_now'] as String).isEmpty)
          ? EN_LANG_TEXT['buy_now']
          : json['buy_now'],
      trialExpired: (json['trial_expired'] == null ||
              (json['trial_expired'] as String).isEmpty)
          ? EN_LANG_TEXT['trial_expired']
          : json['trial_expired'],
      choosePlanThatFits: (json['choose_plan_that_fits'] == null ||
              (json['choose_plan_that_fits'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_plan_that_fits']
          : json['choose_plan_that_fits'],
      userManagement: (json['user_management'] == null ||
              (json['user_management'] as String).isEmpty)
          ? EN_LANG_TEXT['user_management']
          : json['user_management'],
      addUser:
          (json['add_user'] == null || (json['add_user'] as String).isEmpty)
              ? EN_LANG_TEXT['add_user']
              : json['add_user'],
      userType:
          (json['user_type'] == null || (json['user_type'] as String).isEmpty)
              ? EN_LANG_TEXT['user_type']
              : json['user_type'],
      fullname:
          (json['fullname'] == null || (json['fullname'] as String).isEmpty)
              ? EN_LANG_TEXT['fullname']
              : json['fullname'],
      fullName:
          (json['full_name'] == null || (json['full_name'] as String).isEmpty)
              ? EN_LANG_TEXT['full_name']
              : json['full_name'],
      zipcode: (json['zipcode'] == null || (json['zipcode'] as String).isEmpty)
          ? EN_LANG_TEXT['zipcode']
          : json['zipcode'],
      sessionExpired: (json['session_expired'] == null ||
              (json['session_expired'] as String).isEmpty)
          ? EN_LANG_TEXT['session_expired']
          : json['session_expired'],
      personalInfo: (json['personal_info'] == null ||
              (json['personal_info'] as String).isEmpty)
          ? EN_LANG_TEXT['personal_info']
          : json['personal_info'],
      passAndSec: (json['pass_and_sec'] == null ||
              (json['pass_and_sec'] as String).isEmpty)
          ? EN_LANG_TEXT['pass_and_sec']
          : json['pass_and_sec'],
      lastUpOn:
          (json['last_up_on'] == null || (json['last_up_on'] as String).isEmpty)
              ? EN_LANG_TEXT['last_up_on']
              : json['last_up_on'],
      en2FaAccReadyText: (json['en_2fa_acc_ready_text'] == null ||
              (json['en_2fa_acc_ready_text'] as String).isEmpty)
          ? EN_LANG_TEXT['en_2fa_acc_ready_text']
          : json['en_2fa_acc_ready_text'],
      enable2Fa:
          (json['enable_2fa'] == null || (json['enable_2fa'] as String).isEmpty)
              ? EN_LANG_TEXT['enable_2fa']
              : json['enable_2fa'],
      editProfile: (json['edit_profile'] == null ||
              (json['edit_profile'] as String).isEmpty)
          ? EN_LANG_TEXT['edit_profile']
          : json['edit_profile'],
      pushNoti:
          (json['push_noti'] == null || (json['push_noti'] as String).isEmpty)
              ? EN_LANG_TEXT['push_noti']
              : json['push_noti'],
      profileAccReadyText: (json['profile_acc_ready_text'] == null ||
              (json['profile_acc_ready_text'] as String).isEmpty)
          ? EN_LANG_TEXT['profile_acc_ready_text']
          : json['profile_acc_ready_text'],
      deviceNotActive: (json['device_not_active'] == null ||
              (json['device_not_active'] as String).isEmpty)
          ? EN_LANG_TEXT['device_not_active']
          : json['device_not_active'],
      activePos:
          (json['active_pos'] == null || (json['active_pos'] as String).isEmpty)
              ? EN_LANG_TEXT['active_pos']
              : json['active_pos'],
      enterActiveKey: (json['enter_active_key'] == null ||
              (json['enter_active_key'] as String).isEmpty)
          ? EN_LANG_TEXT['enter_active_key']
          : json['enter_active_key'],
      activeKey:
          (json['active_key'] == null || (json['active_key'] as String).isEmpty)
              ? EN_LANG_TEXT['active_key']
              : json['active_key'],
      activatingKey: (json['activating_key'] == null ||
              (json['activating_key'] as String).isEmpty)
          ? EN_LANG_TEXT['activating_key']
          : json['activating_key'],
      activateNow: (json['activate_now'] == null ||
              (json['activate_now'] as String).isEmpty)
          ? EN_LANG_TEXT['activate_now']
          : json['activate_now'],
      choosePlan: (json['choose_plan'] == null ||
              (json['choose_plan'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_plan']
          : json['choose_plan'],
      chooseUrPlan: (json['choose_ur_plan'] == null ||
              (json['choose_ur_plan'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_ur_plan']
          : json['choose_ur_plan'],
      changePlan: (json['change_plan'] == null ||
              (json['change_plan'] as String).isEmpty)
          ? EN_LANG_TEXT['change_plan']
          : json['change_plan'],
      wishToChangePlan: (json['wish_to_change_plan'] == null ||
              (json['wish_to_change_plan'] as String).isEmpty)
          ? EN_LANG_TEXT['wish_to_change_plan']
          : json['wish_to_change_plan'],
      perMemMon: (json['per_mem_mon'] == null ||
              (json['per_mem_mon'] as String).isEmpty)
          ? EN_LANG_TEXT['per_mem_mon']
          : json['per_mem_mon'],
      mySubs: (json['my_subs'] == null || (json['my_subs'] as String).isEmpty)
          ? EN_LANG_TEXT['my_subs']
          : json['my_subs'],
      visa: (json['visa'] == null || (json['visa'] as String).isEmpty)
          ? EN_LANG_TEXT['visa']
          : json['visa'],
      cardType:
          (json['card_type'] == null || (json['card_type'] as String).isEmpty)
              ? EN_LANG_TEXT['card_type']
              : json['card_type'],
      addNewCart: (json['add_new_cart'] == null ||
              (json['add_new_cart'] as String).isEmpty)
          ? EN_LANG_TEXT['add_new_cart']
          : json['add_new_cart'],
      registeredCards: (json['registered_cards'] == null ||
              (json['registered_cards'] as String).isEmpty)
          ? EN_LANG_TEXT['registered_cards']
          : json['registered_cards'],
      allUsers:
          (json['all_users'] == null || (json['all_users'] as String).isEmpty)
              ? EN_LANG_TEXT['all_users']
              : json['all_users'],
      users: (json['users'] == null || (json['users'] as String).isEmpty)
          ? EN_LANG_TEXT['users']
          : json['users'],
      searchUser: (json['search_user'] == null ||
              (json['search_user'] as String).isEmpty)
          ? EN_LANG_TEXT['search_user']
          : json['search_user'],
      deviceNameLoc: (json['device_name_loc'] == null ||
              (json['device_name_loc'] as String).isEmpty)
          ? EN_LANG_TEXT['device_name_loc']
          : json['device_name_loc'],
      notification: (json['notification'] == null ||
              (json['notification'] as String).isEmpty)
          ? EN_LANG_TEXT['notification']
          : json['notification'],
      integration: (json['integration'] == null ||
              (json['integration'] as String).isEmpty)
          ? EN_LANG_TEXT['integration']
          : json['integration'],
      integrationSubText: (json['integration_sub_text'] == null ||
              (json['integration_sub_text'] as String).isEmpty)
          ? EN_LANG_TEXT['integration_sub_text']
          : json['integration_sub_text'],
      getStarted: (json['get_started'] == null ||
              (json['get_started'] as String).isEmpty)
          ? EN_LANG_TEXT['get_started']
          : json['get_started'],
      clientId:
          (json['client_id'] == null || (json['client_id'] as String).isEmpty)
              ? EN_LANG_TEXT['client_id']
              : json['client_id'],
      enterClientId: (json['enter_client_id'] == null ||
              (json['enter_client_id'] as String).isEmpty)
          ? EN_LANG_TEXT['enter_client_id']
          : json['enter_client_id'],
      clientSecret: (json['client_secret'] == null ||
              (json['client_secret'] as String).isEmpty)
          ? EN_LANG_TEXT['client_secret']
          : json['client_secret'],
      enClientSec: (json['en_client_sec'] == null ||
              (json['en_client_sec'] as String).isEmpty)
          ? EN_LANG_TEXT['en_client_sec']
          : json['en_client_sec'],
      connect: (json['connect'] == null || (json['connect'] as String).isEmpty)
          ? EN_LANG_TEXT['connect']
          : json['connect'],
      chartAcMap: (json['chart_ac_map'] == null ||
              (json['chart_ac_map'] as String).isEmpty)
          ? EN_LANG_TEXT['chart_ac_map']
          : json['chart_ac_map'],
      contactSetting: (json['contact_setting'] == null ||
              (json['contact_setting'] as String).isEmpty)
          ? EN_LANG_TEXT['contact_setting']
          : json['contact_setting'],
      productMacros: (json['product_macros'] == null ||
              (json['product_macros'] as String).isEmpty)
          ? EN_LANG_TEXT['product_macros']
          : json['product_macros'],
      sortOrder:
          (json['sort_order'] == null || (json['sort_order'] as String).isEmpty)
              ? EN_LANG_TEXT['sort_order']
              : json['sort_order'],
      deviceActivated: (json['device_activated'] == null ||
              (json['device_activated'] as String).isEmpty)
          ? EN_LANG_TEXT['device_activated']
          : json['device_activated'],
      profile: (json['profile'] == null || (json['profile'] as String).isEmpty)
          ? EN_LANG_TEXT['profile']
          : json['profile'],
      billsNSubs: (json['bills_n_subs'] == null ||
              (json['bills_n_subs'] as String).isEmpty)
          ? EN_LANG_TEXT['bills_n_subs']
          : json['bills_n_subs'],
      allOrders:
          (json['all_orders'] == null || (json['all_orders'] as String).isEmpty)
              ? EN_LANG_TEXT['all_orders']
              : json['all_orders'],
      newOrders:
          (json['new_orders'] == null || (json['new_orders'] as String).isEmpty)
              ? EN_LANG_TEXT['new_orders']
              : json['new_orders'],
      newBooking: (json['new_booking'] == null ||
              (json['new_booking'] as String).isEmpty)
          ? EN_LANG_TEXT['new_booking']
          : json['new_booking'],
      productDeactivated: (json['product_deactivated'] == null ||
              (json['product_deactivated'] as String).isEmpty)
          ? EN_LANG_TEXT['product_deactivated']
          : json['product_deactivated'],
      activate:
          (json['activate'] == null || (json['activate'] as String).isEmpty)
              ? EN_LANG_TEXT['activate']
              : json['activate'],
      deactivate:
          (json['deactivate'] == null || (json['deactivate'] as String).isEmpty)
              ? EN_LANG_TEXT['deactivate']
              : json['deactivate'],
      wannaDeactivate: (json['wanna_deactivate'] == null ||
              (json['wanna_deactivate'] as String).isEmpty)
          ? EN_LANG_TEXT['wanna_deactivate']
          : json['wanna_deactivate'],
      printKitchen: (json['print_kitchen'] == null ||
              (json['print_kitchen'] as String).isEmpty)
          ? EN_LANG_TEXT['print_kitchen']
          : json['print_kitchen'],
      eod: (json['eod'] == null || (json['eod'] as String).isEmpty)
          ? EN_LANG_TEXT['eod']
          : json['eod'],
      shortTCashFlow: (json['short_t_cash_flow'] == null ||
              (json['short_t_cash_flow'] as String).isEmpty)
          ? EN_LANG_TEXT['short_t_cash_flow']
          : json['short_t_cash_flow'],
      payBillsInstall: (json['pay_bills_install'] == null ||
              (json['pay_bills_install'] as String).isEmpty)
          ? EN_LANG_TEXT['pay_bills_install']
          : json['pay_bills_install'],
      applyNow:
          (json['apply_now'] == null || (json['apply_now'] as String).isEmpty)
              ? EN_LANG_TEXT['apply_now']
              : json['apply_now'],
      bookAppoint: (json['book_appoint'] == null ||
              (json['book_appoint'] as String).isEmpty)
          ? EN_LANG_TEXT['book_appoint']
          : json['book_appoint'],
      fastTrack:
          (json['fast_track'] == null || (json['fast_track'] as String).isEmpty)
              ? EN_LANG_TEXT['fast_track']
              : json['fast_track'],
      saveTime:
          (json['save_time'] == null || (json['save_time'] as String).isEmpty)
              ? EN_LANG_TEXT['save_time']
              : json['save_time'],
      takePressOff: (json['take_press_off'] == null ||
              (json['take_press_off'] as String).isEmpty)
          ? EN_LANG_TEXT['take_press_off']
          : json['take_press_off'],
      betterSupBuy: (json['better_sup_buy'] == null ||
              (json['better_sup_buy'] as String).isEmpty)
          ? EN_LANG_TEXT['better_sup_buy']
          : json['better_sup_buy'],
      partnerWith: (json['partner_with'] == null ||
              (json['partner_with'] as String).isEmpty)
          ? EN_LANG_TEXT['partner_with']
          : json['partner_with'],
      lucaDes:
          (json['luca_des'] == null || (json['luca_des'] as String).isEmpty)
              ? EN_LANG_TEXT['luca_des']
              : json['luca_des'],
      thankYou:
          (json['thank_you'] == null || (json['thank_you'] as String).isEmpty)
              ? EN_LANG_TEXT['thank_you']
              : json['thank_you'],
      formSent:
          (json['form_sent'] == null || (json['form_sent'] as String).isEmpty)
              ? EN_LANG_TEXT['form_sent']
              : json['form_sent'],
      goBackFromLuca: (json['go_back_from_luca'] == null ||
              (json['go_back_from_luca'] as String).isEmpty)
          ? EN_LANG_TEXT['go_back_from_luca']
          : json['go_back_from_luca'],
      fillDetailsLuca: (json['fill_details_luca'] == null ||
              (json['fill_details_luca'] as String).isEmpty)
          ? EN_LANG_TEXT['fill_details_luca']
          : json['fill_details_luca'],
      contactPerson: (json['contact_person'] == null ||
              (json['contact_person'] as String).isEmpty)
          ? EN_LANG_TEXT['contact_person']
          : json['contact_person'],
      contactNum: (json['contact_num'] == null ||
              (json['contact_num'] as String).isEmpty)
          ? EN_LANG_TEXT['contact_num']
          : json['contact_num'],
      busEmailAdd: (json['bus_email_add'] == null ||
              (json['bus_email_add'] as String).isEmpty)
          ? EN_LANG_TEXT['bus_email_add']
          : json['bus_email_add'],
      accSoft:
          (json['acc_soft'] == null || (json['acc_soft'] as String).isEmpty)
              ? EN_LANG_TEXT['acc_soft']
              : json['acc_soft'],
      clearForm:
          (json['clear_form'] == null || (json['clear_form'] as String).isEmpty)
              ? EN_LANG_TEXT['clear_form']
              : json['clear_form'],
      submit: (json['submit'] == null || (json['submit'] as String).isEmpty)
          ? EN_LANG_TEXT['submit']
          : json['submit'],
      refresh: (json['refresh'] == null || (json['refresh'] as String).isEmpty)
          ? EN_LANG_TEXT['refresh']
          : json['refresh'],
      available:
          (json['available'] == null || (json['available'] as String).isEmpty)
              ? EN_LANG_TEXT['available']
              : json['available'],
      printerNotFound: (json['printer_not_found'] == null ||
              (json['printer_not_found'] as String).isEmpty)
          ? EN_LANG_TEXT['printer_not_found']
          : json['printer_not_found'],
      printerIsConnected: (json['printer_is_connected'] == null ||
              (json['printer_is_connected'] as String).isEmpty)
          ? EN_LANG_TEXT['printer_is_connected']
          : json['printer_is_connected'],
      printerNotConnected: (json['printer_not_connected'] == null ||
              (json['printer_not_connected'] as String).isEmpty)
          ? EN_LANG_TEXT['printer_not_connected']
          : json['printer_not_connected'],
      acceptTerms: (json['accept_terms'] == null ||
              (json['accept_terms'] as String).isEmpty)
          ? EN_LANG_TEXT['accept_terms']
          : json['accept_terms'],
      storeChannel: (json['store_channel'] == null ||
              (json['store_channel'] as String).isEmpty)
          ? EN_LANG_TEXT['store_channel']
          : json['store_channel'],
      chooseChannel: (json['choose_channel'] == null ||
              (json['choose_channel'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_channel']
          : json['choose_channel'],
      catTypeDeleted: (json['cat_type_deleted'] == null ||
              (json['cat_type_deleted'] as String).isEmpty)
          ? EN_LANG_TEXT['cat_type_deleted']
          : json['cat_type_deleted'],
      catType:
          (json['cat_type'] == null || (json['cat_type'] as String).isEmpty)
              ? EN_LANG_TEXT['cat_type']
              : json['cat_type'],
      chooseCatType: (json['choose_cat_type'] == null ||
              (json['choose_cat_type'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_cat_type']
          : json['choose_cat_type'],
      sn: (json['sn'] == null || (json['sn'] as String).isEmpty)
          ? EN_LANG_TEXT['sn']
          : json['sn'],
      supplier:
          (json['supplier'] == null || (json['supplier'] as String).isEmpty)
              ? EN_LANG_TEXT['supplier']
              : json['supplier'],
      chooseSupplier: (json['choose_supplier'] == null ||
              (json['choose_supplier'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_supplier']
          : json['choose_supplier'],
      productVarients: (json['product_varients'] == null ||
              (json['product_varients'] as String).isEmpty)
          ? EN_LANG_TEXT['product_varients']
          : json['product_varients'],
      productStatus: (json['product_status'] == null ||
              (json['product_status'] as String).isEmpty)
          ? EN_LANG_TEXT['product_status']
          : json['product_status'],
      unitPrice:
          (json['unit_price'] == null || (json['unit_price'] as String).isEmpty)
              ? EN_LANG_TEXT['unit_price']
              : json['unit_price'],
      searchProduct: (json['search_product'] == null ||
              (json['search_product'] as String).isEmpty)
          ? EN_LANG_TEXT['search_product']
          : json['search_product'],
      updatePrice: (json['update_price'] == null ||
              (json['update_price'] as String).isEmpty)
          ? EN_LANG_TEXT['update_price']
          : json['update_price'],
      varientDeleted: (json['varient_deleted'] == null ||
              (json['varient_deleted'] as String).isEmpty)
          ? EN_LANG_TEXT['varient_deleted']
          : json['varient_deleted'],
      sureToDelete: (json['sure_to_delete'] == null ||
              (json['sure_to_delete'] as String).isEmpty)
          ? EN_LANG_TEXT['sure_to_delete']
          : json['sure_to_delete'],
      varient: (json['varient'] == null || (json['varient'] as String).isEmpty)
          ? EN_LANG_TEXT['varient']
          : json['varient'],
      posPrinter: (json['pos_printer'] == null ||
              (json['pos_printer'] as String).isEmpty)
          ? EN_LANG_TEXT['pos_printer']
          : json['pos_printer'],
      setMenuKit: (json['set_menu_kit'] == null ||
              (json['set_menu_kit'] as String).isEmpty)
          ? EN_LANG_TEXT['set_menu_kit']
          : json['set_menu_kit'],
      printInvoice: (json['print_invoice'] == null ||
              (json['print_invoice'] as String).isEmpty)
          ? EN_LANG_TEXT['print_invoice']
          : json['print_invoice'],
      paperSize:
          (json['paper_size'] == null || (json['paper_size'] as String).isEmpty)
              ? EN_LANG_TEXT['paper_size']
              : json['paper_size'],
      orPrintAuto: (json['or_print_auto'] == null ||
              (json['or_print_auto'] as String).isEmpty)
          ? EN_LANG_TEXT['or_print_auto']
          : json['or_print_auto'],
      autoInvoicePrint: (json['auto_invoice_print'] == null ||
              (json['auto_invoice_print'] as String).isEmpty)
          ? EN_LANG_TEXT['auto_invoice_print']
          : json['auto_invoice_print'],
      view: (json['view'] == null || (json['view'] as String).isEmpty)
          ? EN_LANG_TEXT['view']
          : json['view'],
      setMenuStatus: (json['set_menu_status'] == null ||
              (json['set_menu_status'] as String).isEmpty)
          ? EN_LANG_TEXT['set_menu_status']
          : json['set_menu_status'],
      printing:
          (json['printing'] == null || (json['printing'] as String).isEmpty)
              ? EN_LANG_TEXT['printing']
              : json['printing'],
      generalSetSubtitle: (json['general_set_subtitle'] == null ||
              (json['general_set_subtitle'] as String).isEmpty)
          ? EN_LANG_TEXT['general_set_subtitle']
          : json['general_set_subtitle'],
      posDeviceSet: (json['pos_device_set'] == null ||
              (json['pos_device_set'] as String).isEmpty)
          ? EN_LANG_TEXT['pos_device_set']
          : json['pos_device_set'],
      posDeviceSetSubtitle: (json['pos_device_set_subtitle'] == null ||
              (json['pos_device_set_subtitle'] as String).isEmpty)
          ? EN_LANG_TEXT['pos_device_set_subtitle']
          : json['pos_device_set_subtitle'],
      storeSetSubtitle: (json['store_set_subtitle'] == null ||
              (json['store_set_subtitle'] as String).isEmpty)
          ? EN_LANG_TEXT['store_set_subtitle']
          : json['store_set_subtitle'],
      notifySetSubtitle: (json['notify_set_subtitle'] == null ||
              (json['notify_set_subtitle'] as String).isEmpty)
          ? EN_LANG_TEXT['notify_set_subtitle']
          : json['notify_set_subtitle'],
      payMethodSetSubtitle: (json['pay_method_set_subtitle'] == null ||
              (json['pay_method_set_subtitle'] as String).isEmpty)
          ? EN_LANG_TEXT['pay_method_set_subtitle']
          : json['pay_method_set_subtitle'],
      userManageSetSubtitle: (json['user_manage_set_subtitle'] == null ||
              (json['user_manage_set_subtitle'] as String).isEmpty)
          ? EN_LANG_TEXT['user_manage_set_subtitle']
          : json['user_manage_set_subtitle'],
      changeAll:
          (json['change_all'] == null || (json['change_all'] as String).isEmpty)
              ? EN_LANG_TEXT['change_all']
              : json['change_all'],
      noItemsSelected: (json['no_items_selected'] == null ||
              (json['no_items_selected'] as String).isEmpty)
          ? EN_LANG_TEXT['no_items_selected']
          : json['no_items_selected'],
      removeFromCart: (json['remove_from_cart'] == null ||
              (json['remove_from_cart'] as String).isEmpty)
          ? EN_LANG_TEXT['remove_from_cart']
          : json['remove_from_cart'],
      payInvoice: (json['pay_invoice'] == null ||
              (json['pay_invoice'] as String).isEmpty)
          ? EN_LANG_TEXT['pay_invoice']
          : json['pay_invoice'],
      noOrdersPlaced: (json['no_orders_placed'] == null ||
              (json['no_orders_placed'] as String).isEmpty)
          ? EN_LANG_TEXT['no_orders_placed']
          : json['no_orders_placed'],
      newOrder:
          (json['new_order'] == null || (json['new_order'] as String).isEmpty)
              ? EN_LANG_TEXT['new_order']
              : json['new_order'],
      noBookFound: (json['no_book_found'] == null ||
              (json['no_book_found'] as String).isEmpty)
          ? EN_LANG_TEXT['no_book_found']
          : json['no_book_found'],
      invalidOtp: (json['invalid_otp'] == null ||
              (json['invalid_otp'] as String).isEmpty)
          ? EN_LANG_TEXT['invalid_otp']
          : json['invalid_otp'],
      clear: (json['clear'] == null || (json['clear'] as String).isEmpty)
          ? EN_LANG_TEXT['clear']
          : json['clear'],
      sendEmail:
          (json['send_email'] == null || (json['send_email'] as String).isEmpty)
              ? EN_LANG_TEXT['send_email']
              : json['send_email'],
      copyClipboard: (json['copy_clipboard'] == null ||
              (json['copy_clipboard'] as String).isEmpty)
          ? EN_LANG_TEXT['copy_clipboard']
          : json['copy_clipboard'],
      holidayChargeAmt: (json['holiday_charge_amt'] == null ||
              (json['holiday_charge_amt'] as String).isEmpty)
          ? EN_LANG_TEXT['holiday_charge_amt']
          : json['holiday_charge_amt'],
      creditSurchargeAmt: (json['credit_surcharge_amt'] == null ||
              (json['credit_surcharge_amt'] as String).isEmpty)
          ? EN_LANG_TEXT['credit_surcharge_amt']
          : json['credit_surcharge_amt'],
      subsNow:
          (json['subs_now'] == null || (json['subs_now'] as String).isEmpty)
              ? EN_LANG_TEXT['subs_now']
              : json['subs_now'],
      noItemFound: (json['no_item_found'] == null ||
              (json['no_item_found'] as String).isEmpty)
          ? EN_LANG_TEXT['no_item_found']
          : json['no_item_found'],
      noProductAdded: (json['no_product_added'] == null ||
              (json['no_product_added'] as String).isEmpty)
          ? EN_LANG_TEXT['no_product_added']
          : json['no_product_added'],
      startEndDate: (json['start_end_date'] == null ||
              (json['start_end_date'] as String).isEmpty)
          ? EN_LANG_TEXT['start_end_date']
          : json['start_end_date'],
      noHistoryReport: (json['no_history_report'] == null ||
              (json['no_history_report'] as String).isEmpty)
          ? EN_LANG_TEXT['no_history_report']
          : json['no_history_report'],
      selectTable: (json['select_table'] == null ||
              (json['select_table'] as String).isEmpty)
          ? EN_LANG_TEXT['select_table']
          : json['select_table'],
      taxInvoiceInfoEmpty: (json['tax_invoice_info_empty'] == null ||
              (json['tax_invoice_info_empty'] as String).isEmpty)
          ? EN_LANG_TEXT['tax_invoice_info_empty']
          : json['tax_invoice_info_empty'],
      dashboard:
          (json['dashboard'] == null || (json['dashboard'] as String).isEmpty)
              ? EN_LANG_TEXT['dashboard']
              : json['dashboard'],
      printRecptKit: (json['print_recpt_kit'] == null ||
              (json['print_recpt_kit'] as String).isEmpty)
          ? EN_LANG_TEXT['print_recpt_kit']
          : json['print_recpt_kit'],
      server: (json['server'] == null || (json['server'] as String).isEmpty)
          ? EN_LANG_TEXT['server']
          : json['server'],
      customer:
          (json['customer'] == null || (json['customer'] as String).isEmpty)
              ? EN_LANG_TEXT['customer']
              : json['customer'],
      setMenuItems: (json['set_menu_items'] == null ||
              (json['set_menu_items'] as String).isEmpty)
          ? EN_LANG_TEXT['set_menu_items']
          : json['set_menu_items'],
      creditCardSurcharge: (json['credit_card_surcharge'] == null ||
              (json['credit_card_surcharge'] as String).isEmpty)
          ? EN_LANG_TEXT['credit_card_surcharge']
          : json['credit_card_surcharge'],
      posPrinterSetup: (json['pos_printer_setup'] == null ||
              (json['pos_printer_setup'] as String).isEmpty)
          ? EN_LANG_TEXT['pos_printer_setup']
          : json['pos_printer_setup'],
      pos: (json['pos'] == null || (json['pos'] as String).isEmpty)
          ? EN_LANG_TEXT['pos']
          : json['pos'],
      pleaseTryAgain: (json['please_try_again'] == null ||
              (json['please_try_again'] as String).isEmpty)
          ? EN_LANG_TEXT['please_try_again']
          : json['please_try_again'],
      userRole:
          (json['user_role'] == null || (json['user_role'] as String).isEmpty)
              ? EN_LANG_TEXT['user_role']
              : json['user_role'],
      posDevice:
          (json['pos_device'] == null || (json['pos_device'] as String).isEmpty)
              ? EN_LANG_TEXT['pos_device']
              : json['pos_device'],
      deviceName: (json['device_name'] == null ||
              (json['device_name'] as String).isEmpty)
          ? EN_LANG_TEXT['device_name']
          : json['device_name'],
      planSubscribed: (json['plan_subscribed'] == null ||
              (json['plan_subscribed'] as String).isEmpty)
          ? EN_LANG_TEXT['plan_subscribed']
          : json['plan_subscribed'],
      posDevices: (json['pos_devices'] == null ||
              (json['pos_devices'] as String).isEmpty)
          ? EN_LANG_TEXT['pos_devices']
          : json['pos_devices'],
      twoFaUp:
          (json['two_fa_up'] == null || (json['two_fa_up'] as String).isEmpty)
              ? EN_LANG_TEXT['two_fa_up']
              : json['two_fa_up'],
      noSetMenuFound: (json['no_set_menu_found'] == null ||
              (json['no_set_menu_found'] as String).isEmpty)
          ? EN_LANG_TEXT['no_set_menu_found']
          : json['no_set_menu_found'],
      pleaseSePlan: (json['please_se_plan'] == null ||
              (json['please_se_plan'] as String).isEmpty)
          ? EN_LANG_TEXT['please_se_plan']
          : json['please_se_plan'],
      useThisDevice: (json['use_this_device'] == null ||
              (json['use_this_device'] as String).isEmpty)
          ? EN_LANG_TEXT['use_this_device']
          : json['use_this_device'],
      isOpen: (json['is_open'] == null || (json['is_open'] as String).isEmpty)
          ? EN_LANG_TEXT['is_open']
          : json['is_open'],
      exit: (json['exit'] == null || (json['exit'] as String).isEmpty)
          ? EN_LANG_TEXT['exit']
          : json['exit'],
      sureToExit: (json['sure_to_exit'] == null ||
              (json['sure_to_exit'] as String).isEmpty)
          ? EN_LANG_TEXT['sure_to_exit']
          : json['sure_to_exit'],
      discountHigher: (json['discount_higher'] == null ||
              (json['discount_higher'] as String).isEmpty)
          ? EN_LANG_TEXT['discount_higher']
          : json['discount_higher'],
      included:
          (json['included'] == null || (json['included'] as String).isEmpty)
              ? EN_LANG_TEXT['included']
              : json['included'],
      sendToKit: (json['send_to_kit'] == null ||
              (json['send_to_kit'] as String).isEmpty)
          ? EN_LANG_TEXT['send_to_kit']
          : json['send_to_kit'],
      updateOrder: (json['update_order'] == null ||
              (json['update_order'] as String).isEmpty)
          ? EN_LANG_TEXT['update_order']
          : json['update_order'],
      copiedToClip: (json['copied_to_clip'] == null ||
              (json['copied_to_clip'] as String).isEmpty)
          ? EN_LANG_TEXT['copied_to_clip']
          : json['copied_to_clip'],
      storeUrl:
          (json['store_url'] == null || (json['store_url'] as String).isEmpty)
              ? EN_LANG_TEXT['store_url']
              : json['store_url'],
      webUrl: (json['web_url'] == null || (json['web_url'] as String).isEmpty)
          ? EN_LANG_TEXT['web_url']
          : json['web_url'],
      deliAmt:
          (json['deli_amt'] == null || (json['deli_amt'] as String).isEmpty)
              ? EN_LANG_TEXT['deli_amt']
              : json['deli_amt'],
      remainAmt:
          (json['remain_amt'] == null || (json['remain_amt'] as String).isEmpty)
              ? EN_LANG_TEXT['remain_amt']
              : json['remain_amt'],
      addPhoto:
          (json['add_photo'] == null || (json['add_photo'] as String).isEmpty)
              ? EN_LANG_TEXT['add_photo']
              : json['add_photo'],
      takeCamera: (json['take_camera'] == null ||
              (json['take_camera'] as String).isEmpty)
          ? EN_LANG_TEXT['take_camera']
          : json['take_camera'],
      takeGallery: (json['take_gallery'] == null ||
              (json['take_gallery'] as String).isEmpty)
          ? EN_LANG_TEXT['take_gallery']
          : json['take_gallery'],
      invalidDisChar: (json['invalid_dis_char'] == null ||
              (json['invalid_dis_char'] as String).isEmpty)
          ? EN_LANG_TEXT['invalid_dis_char']
          : json['invalid_dis_char'],
      invalidAmt: (json['invalid_amt'] == null ||
              (json['invalid_amt'] as String).isEmpty)
          ? EN_LANG_TEXT['invalid_amt']
          : json['invalid_amt'],
      amtExtsive: (json['amt_extsive'] == null ||
              (json['amt_extsive'] as String).isEmpty)
          ? EN_LANG_TEXT['amt_extsive']
          : json['amt_extsive'],
      payableAmt: (json['payable_amt'] == null ||
              (json['payable_amt'] as String).isEmpty)
          ? EN_LANG_TEXT['payable_amt']
          : json['payable_amt'],
      picDeliDate: (json['pic_deli_date'] == null ||
              (json['pic_deli_date'] as String).isEmpty)
          ? EN_LANG_TEXT['pic_deli_date']
          : json['pic_deli_date'],
      refundOrder: (json['refund_order'] == null ||
              (json['refund_order'] as String).isEmpty)
          ? EN_LANG_TEXT['refund_order']
          : json['refund_order'],
      sureToRefund: (json['sure_to_refund'] == null ||
              (json['sure_to_refund'] as String).isEmpty)
          ? EN_LANG_TEXT['sure_to_refund']
          : json['sure_to_refund'],
      resetYourPass: (json['reset_your_pass'] == null ||
              (json['reset_your_pass'] as String).isEmpty)
          ? EN_LANG_TEXT['reset_your_pass']
          : json['reset_your_pass'],
      resetPassSubtitle: (json['reset_pass_subtitle'] == null ||
              (json['reset_pass_subtitle'] as String).isEmpty)
          ? EN_LANG_TEXT['reset_pass_subtitle']
          : json['reset_pass_subtitle'],
      resetMyPass: (json['reset_my_pass'] == null ||
              (json['reset_my_pass'] as String).isEmpty)
          ? EN_LANG_TEXT['reset_my_pass']
          : json['reset_my_pass'],
      selectNumItemsVariants: (json['select_num_items_variants'] == null ||
              (json['select_num_items_variants'] as String).isEmpty)
          ? EN_LANG_TEXT['select_num_items_variants']
          : json['select_num_items_variants'],
      productVariants: (json['product_variants'] == null ||
              (json['product_variants'] as String).isEmpty)
          ? EN_LANG_TEXT['product_variants']
          : json['product_variants'],
      addons: (json['addons'] == null || (json['addons'] as String).isEmpty)
          ? EN_LANG_TEXT['addons']
          : json['addons'],
      redeemCode: (json['redeem_code'] == null ||
              (json['redeem_code'] as String).isEmpty)
          ? EN_LANG_TEXT['redeem_code']
          : json['redeem_code'],
      the2FaAuthEmailTitle: (json['2fa_auth_email_title'] == null ||
              (json['2fa_auth_email_title'] as String).isEmpty)
          ? EN_LANG_TEXT['2fa_auth_email_title']
          : json['2fa_auth_email_title'],
      type: (json['type'] == null || (json['type'] as String).isEmpty)
          ? EN_LANG_TEXT['type']
          : json['type'],
      totalCashIn: (json['total_cash_in'] == null ||
              (json['total_cash_in'] as String).isEmpty)
          ? EN_LANG_TEXT['total_cash_in']
          : json['total_cash_in'],
      totalCashOut: (json['total_cash_out'] == null ||
              (json['total_cash_out'] as String).isEmpty)
          ? EN_LANG_TEXT['total_cash_out']
          : json['total_cash_out'],
      loyaltyPoint: (json['loyalty_point'] == null ||
              (json['loyalty_point'] as String).isEmpty)
          ? EN_LANG_TEXT['loyalty_point']
          : json['loyalty_point'],
      eligibleLoyalPoint: (json['eligible_loyal_point'] == null ||
              (json['eligible_loyal_point'] as String).isEmpty)
          ? EN_LANG_TEXT['eligible_loyal_point']
          : json['eligible_loyal_point'],
      enableLoyal: (json['enable_loyal'] == null ||
              (json['enable_loyal'] as String).isEmpty)
          ? EN_LANG_TEXT['enable_loyal']
          : json['enable_loyal'],
      tableBookResv: (json['table_book_resv'] == null ||
              (json['table_book_resv'] as String).isEmpty)
          ? EN_LANG_TEXT['table_book_resv']
          : json['table_book_resv'],
      noCashInOut: (json['no_cash_in_out'] == null ||
              (json['no_cash_in_out'] as String).isEmpty)
          ? EN_LANG_TEXT['no_cash_in_out']
          : json['no_cash_in_out'],
      recentAddProds: (json['recent_add_prods'] == null ||
              (json['recent_add_prods'] as String).isEmpty)
          ? EN_LANG_TEXT['recent_add_prods']
          : json['recent_add_prods'],
      createSetMenuCom: (json['create_set_menu_com'] == null ||
              (json['create_set_menu_com'] as String).isEmpty)
          ? EN_LANG_TEXT['create_set_menu_com']
          : json['create_set_menu_com'],
      prodVariants: (json['prod_variants'] == null ||
              (json['prod_variants'] as String).isEmpty)
          ? EN_LANG_TEXT['prod_variants']
          : json['prod_variants'],
      variant: (json['variant'] == null || (json['variant'] as String).isEmpty)
          ? EN_LANG_TEXT['variant']
          : json['variant'],
      updateSetMenuCom: (json['update_set_menu_com'] == null ||
              (json['update_set_menu_com'] as String).isEmpty)
          ? EN_LANG_TEXT['update_set_menu_com']
          : json['update_set_menu_com'],
      setMenuCombo: (json['set_menu_combo'] == null ||
              (json['set_menu_combo'] as String).isEmpty)
          ? EN_LANG_TEXT['set_menu_combo']
          : json['set_menu_combo'],
      selectItemsSetMenu: (json['select_items_set_menu'] == null ||
              (json['select_items_set_menu'] as String).isEmpty)
          ? EN_LANG_TEXT['select_items_set_menu']
          : json['select_items_set_menu'],
      notifications: (json['notifications'] == null ||
              (json['notifications'] as String).isEmpty)
          ? EN_LANG_TEXT['notifications']
          : json['notifications'],
      selectNumOfItems: (json['select_num_of_items'] == null ||
              (json['select_num_of_items'] as String).isEmpty)
          ? EN_LANG_TEXT['select_num_of_items']
          : json['select_num_of_items'],
      refundPay:
          (json['refund_pay'] == null || (json['refund_pay'] as String).isEmpty)
              ? EN_LANG_TEXT['refund_pay']
              : json['refund_pay'],
      fieldEmpty: (json['field_empty'] == null ||
              (json['field_empty'] as String).isEmpty)
          ? EN_LANG_TEXT['field_empty']
          : json['field_empty'],
      canceled:
          (json['canceled'] == null || (json['canceled'] as String).isEmpty)
              ? EN_LANG_TEXT['canceled']
              : json['canceled'],
      termOfService: (json['term_of_service'] == null ||
              (json['term_of_service'] as String).isEmpty)
          ? EN_LANG_TEXT['term_of_service']
          : json['term_of_service'],
      dontHaveAcc: (json['dont_have_acc'] == null ||
              (json['dont_have_acc'] as String).isEmpty)
          ? EN_LANG_TEXT['dont_have_acc']
          : json['dont_have_acc'],
      signup: (json['signup'] == null || (json['signup'] as String).isEmpty)
          ? EN_LANG_TEXT['signup']
          : json['signup'],
      registerNow: (json['register_now'] == null ||
              (json['register_now'] as String).isEmpty)
          ? EN_LANG_TEXT['register_now']
          : json['register_now'],
      sendVeriTitle: (json['send_veri_title'] == null ||
              (json['send_veri_title'] as String).isEmpty)
          ? EN_LANG_TEXT['send_veri_title']
          : json['send_veri_title'],
      resendOtp:
          (json['resend_otp'] == null || (json['resend_otp'] as String).isEmpty)
              ? EN_LANG_TEXT['resend_otp']
              : json['resend_otp'],
      veriCode:
          (json['veri_code'] == null || (json['veri_code'] as String).isEmpty)
              ? EN_LANG_TEXT['veri_code']
              : json['veri_code'],
      register:
          (json['register'] == null || (json['register'] as String).isEmpty)
              ? EN_LANG_TEXT['register']
              : json['register'],
      refund: (json['refund'] == null || (json['refund'] as String).isEmpty)
          ? EN_LANG_TEXT['refund']
          : json['refund'],
      deliverOrder: (json['deliver_order'] == null ||
              (json['deliver_order'] as String).isEmpty)
          ? EN_LANG_TEXT['deliver_order']
          : json['deliver_order'],
      orderDeli:
          (json['order_deli'] == null || (json['order_deli'] as String).isEmpty)
              ? EN_LANG_TEXT['order_deli']
              : json['order_deli'],
      sureToOrderDeli: (json['sure_to_order_deli'] == null ||
              (json['sure_to_order_deli'] as String).isEmpty)
          ? EN_LANG_TEXT['sure_to_order_deli']
          : json['sure_to_order_deli'],
      orderStatusNotChoosen: (json['order_status_not_choosen'] == null ||
              (json['order_status_not_choosen'] as String).isEmpty)
          ? EN_LANG_TEXT['order_status_not_choosen']
          : json['order_status_not_choosen'],
      removePhoto: (json['remove_photo'] == null ||
              (json['remove_photo'] as String).isEmpty)
          ? EN_LANG_TEXT['remove_photo']
          : json['remove_photo'],
      per: (json['per'] == null || (json['per'] as String).isEmpty)
          ? EN_LANG_TEXT['per']
          : json['per'],
      device: (json['device'] == null || (json['device'] as String).isEmpty)
          ? EN_LANG_TEXT['device']
          : json['device'],
      devices: (json['devices'] == null || (json['devices'] as String).isEmpty)
          ? EN_LANG_TEXT['devices']
          : json['devices'],
      addNewOrg: (json['add_new_org'] == null ||
              (json['add_new_org'] as String).isEmpty)
          ? EN_LANG_TEXT['add_new_org']
          : json['add_new_org'],
      addUrOrg:
          (json['add_ur_org'] == null || (json['add_ur_org'] as String).isEmpty)
              ? EN_LANG_TEXT['add_ur_org']
              : json['add_ur_org'],
      businessName: (json['business_name'] == null ||
              (json['business_name'] as String).isEmpty)
          ? EN_LANG_TEXT['business_name']
          : json['business_name'],
      businessPhone: (json['business_phone'] == null ||
              (json['business_phone'] as String).isEmpty)
          ? EN_LANG_TEXT['business_phone']
          : json['business_phone'],
      businessEmail: (json['business_email'] == null ||
              (json['business_email'] as String).isEmpty)
          ? EN_LANG_TEXT['business_email']
          : json['business_email'],
      choosePlatform: (json['choose_platform'] == null ||
              (json['choose_platform'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_platform']
          : json['choose_platform'],
      calculateEod: (json['calculate_eod'] == null ||
              (json['calculate_eod'] as String).isEmpty)
          ? EN_LANG_TEXT['calculate_eod']
          : json['calculate_eod'],
      chooseSubCat: (json['choose_sub_cat'] == null ||
              (json['choose_sub_cat'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_sub_cat']
          : json['choose_sub_cat'],
      subCategory: (json['sub_category'] == null ||
              (json['sub_category'] as String).isEmpty)
          ? EN_LANG_TEXT['sub_category']
          : json['sub_category'],
      subCatsDeleted: (json['sub_cats_deleted'] == null ||
              (json['sub_cats_deleted'] as String).isEmpty)
          ? EN_LANG_TEXT['sub_cats_deleted']
          : json['sub_cats_deleted'],
      subCatName: (json['sub_cat_name'] == null ||
              (json['sub_cat_name'] as String).isEmpty)
          ? EN_LANG_TEXT['sub_cat_name']
          : json['sub_cat_name'],
      addNewSubCat: (json['add_new_sub_cat'] == null ||
              (json['add_new_sub_cat'] as String).isEmpty)
          ? EN_LANG_TEXT['add_new_sub_cat']
          : json['add_new_sub_cat'],
      subCats:
          (json['sub_cats'] == null || (json['sub_cats'] as String).isEmpty)
              ? EN_LANG_TEXT['sub_cats']
              : json['sub_cats'],
      sendEmailAndFinalize: (json['send_email_and_finalize'] == null ||
              (json['send_email_and_finalize'] as String).isEmpty)
          ? EN_LANG_TEXT['send_email_and_finalize']
          : json['send_email_and_finalize'],
      payWithEodRecon: (json['pay_with_eod_recon'] == null ||
              (json['pay_with_eod_recon'] as String).isEmpty)
          ? EN_LANG_TEXT['pay_with_eod_recon']
          : json['pay_with_eod_recon'],
      finalize:
          (json['finalize'] == null || (json['finalize'] as String).isEmpty)
              ? EN_LANG_TEXT['finalize']
              : json['finalize'],
      finalizeEod: (json['finalize_eod'] == null ||
              (json['finalize_eod'] as String).isEmpty)
          ? EN_LANG_TEXT['finalize_eod']
          : json['finalize_eod'],
      otpCodeExpired5Min: (json["otp_code_expired_5_min"] == null ||
              (json["otp_code_expired_5_min"] as String).isEmpty)
          ? EN_LANG_TEXT['otp_code_expired_5_min']
          : json["otp_code_expired_5_min"],
      plAuthToCont: (json["pl_auth_to_cont"] == null ||
              (json["pl_auth_to_cont"] as String).isEmpty)
          ? EN_LANG_TEXT["pl_auth_to_cont"]
          : json["pl_auth_to_cont"],
      screenTime: (json["screen_time"] == null ||
              (json["screen_time"] as String).isEmpty)
          ? EN_LANG_TEXT["screen_time"]
          : json["screen_time"],
      enableAppLock: (json["enable_app_lock"] == null ||
              (json["enable_app_lock"] as String).isEmpty)
          ? EN_LANG_TEXT["enable_app_lock"]
          : json["enable_app_lock"],
      langModelContinue:
          (json["continue"] == null || (json["continue"] as String).isEmpty)
              ? EN_LANG_TEXT["continue"]
              : json["continue"],
      processOrder: (json["process_order"] == null ||
              (json["process_order"] as String).isEmpty)
          ? EN_LANG_TEXT["process_order"]
          : json["process_order"],
      tableNotSelected: (json["table_not_selected"] == null ||
              (json["table_not_selected"] as String).isEmpty)
          ? EN_LANG_TEXT["table_not_selected"]
          : json["table_not_selected"],
      eodOnDate: (json["eod_on_date"] == null ||
              (json["eod_on_date"] as String).isEmpty)
          ? EN_LANG_TEXT["eod_on_date"]
          : json["eod_on_date"],
      findEodReport: (json["find_eod_report"] == null ||
              (json["find_eod_report"] as String).isEmpty)
          ? EN_LANG_TEXT["find_eod_report"]
          : json["find_eod_report"],
      chooseOrderStatus: (json["choose_order_status"] == null ||
              (json["choose_order_status"] as String).isEmpty)
          ? EN_LANG_TEXT["choose_order_status"]
          : json["choose_order_status"],
      storeChangedSuccess: (json["store_changed_success"] == null ||
              (json["store_changed_success"] as String).isEmpty)
          ? EN_LANG_TEXT["store_changed_success"]
          : json["store_changed_success"],
      todaySale:
          (json["today_sale"] == null || (json["today_sale"] as String).isEmpty)
              ? EN_LANG_TEXT["today_sale"]
              : json["today_sale"],
      salesSummary: (json["sales_summary"] == null ||
              (json["sales_summary"] as String).isEmpty)
          ? EN_LANG_TEXT["sales_summary"]
          : json["sales_summary"],
      salesCat:
          (json["sales_cat"] == null || (json["sales_cat"] as String).isEmpty)
              ? EN_LANG_TEXT["sales_cat"]
              : json["sales_cat"],
      salesReportByMon: (json["sales_report_by_mon"] == null ||
              (json["sales_report_by_mon"] as String).isEmpty)
          ? EN_LANG_TEXT["sales_report_by_mon"]
          : json["sales_report_by_mon"],
      payReport:
          (json["pay_report"] == null || (json["pay_report"] as String).isEmpty)
              ? EN_LANG_TEXT["pay_report"]
              : json["pay_report"],
      salesByChannel: (json["sales_by_channel"] == null ||
              (json["sales_by_channel"] as String).isEmpty)
          ? EN_LANG_TEXT["sales_by_channel"]
          : json["sales_by_channel"],
      recommProducts: (json["recomm_products"] == null ||
              (json["recomm_products"] as String).isEmpty)
          ? EN_LANG_TEXT["recomm_products"]
          : json["recomm_products"],
      totalSales: (json["total_sales"] == null ||
              (json["total_sales"] as String).isEmpty)
          ? EN_LANG_TEXT["total_sales"]
          : json["total_sales"],
      totalOrders: (json["total_orders"] == null ||
              (json["total_orders"] as String).isEmpty)
          ? EN_LANG_TEXT["total_orders"]
          : json["total_orders"],
      totalRefund: (json["total_refund"] == null ||
              (json["total_refund"] as String).isEmpty)
          ? EN_LANG_TEXT["total_refund"]
          : json["total_refund"],
      totalCus:
          (json["total_cus"] == null || (json["total_cus"] as String).isEmpty)
              ? EN_LANG_TEXT["total_cus"]
              : json["total_cus"],
      upgradePlanFromFreeTrial: (json["upgrade_plan_from_free_trial"] == null ||
              (json["upgrade_plan_from_free_trial"] as String).isEmpty)
          ? EN_LANG_TEXT["upgrade_plan_from_free_trial"]
          : json["upgrade_plan_from_free_trial"],
      upgradeNow: (json["upgrade_now"] == null ||
              (json["upgrade_now"] as String).isEmpty)
          ? EN_LANG_TEXT["upgrade_now"]
          : json["upgrade_now"],
      payMethod:
          (json["pay_method"] == null || (json["pay_method"] as String).isEmpty)
              ? EN_LANG_TEXT["pay_method"]
              : json["pay_method"],
      sales: (json["sales"] == null || (json["sales"] as String).isEmpty)
          ? EN_LANG_TEXT["sales"]
          : json["sales"],
      product: (json["product"] == null || (json["product"] as String).isEmpty)
          ? EN_LANG_TEXT["product"]
          : json["product"],
      noStoreSelected: (json["no_store_selected"] == null ||
              (json["no_store_selected"] as String).isEmpty)
          ? EN_LANG_TEXT["no_store_selected"]
          : json["no_store_selected"],
      tryAgainAfterTime: (json["try_again_after_time"] == null ||
              (json["try_again_after_time"] as String).isEmpty)
          ? EN_LANG_TEXT["try_again_after_time"]
          : json["try_again_after_time"],
      pointOfSale: (json["point_of_sale"] == null ||
              (json["point_of_sale"] as String).isEmpty)
          ? EN_LANG_TEXT["point_of_sale"]
          : json["point_of_sale"],
      onlineOrSys: (json["online_or_sys"] == null ||
              (json["online_or_sys"] as String).isEmpty)
          ? EN_LANG_TEXT["online_or_sys"]
          : json["online_or_sys"],
      posOnlineOrderSys: (json["pos_online_order_sys"] == null ||
              (json["pos_online_order_sys"] as String).isEmpty)
          ? EN_LANG_TEXT["pos_online_order_sys"]
          : json["pos_online_order_sys"],
      onlineOrder: (json["online_order"] == null ||
              (json["online_order"] as String).isEmpty)
          ? EN_LANG_TEXT["online_order"]
          : json["online_order"],
      sureToUpTableBook: (json["sure_to_up_table_book"] == null ||
              (json["sure_to_up_table_book"] as String).isEmpty)
          ? EN_LANG_TEXT["sure_to_up_table_book"]
          : json["sure_to_up_table_book"],
      sureToBookTable: (json["sure_to_book_table"] == null ||
              (json["sure_to_book_table"] as String).isEmpty)
          ? EN_LANG_TEXT["sure_to_book_table"]
          : json["sure_to_book_table"],
      sureToDiscardChanges: (json["sure_to_discard_changes"] == null ||
              (json["sure_to_discard_changes"] as String).isEmpty)
          ? EN_LANG_TEXT["sure_to_discard_changes"]
          : json["sure_to_discard_changes"],
      invoiceNo:
          (json["invoice_no"] == null || (json["invoice_no"] as String).isEmpty)
              ? EN_LANG_TEXT["invoice_no"]
              : json["invoice_no"],
      barcodeType: (json["barcode_type"] == null ||
              (json["barcode_type"] as String).isEmpty)
          ? EN_LANG_TEXT["barcode_type"]
          : json["barcode_type"],
      chooseBarCode: (json["choose_bar_code"] == null ||
              (json["choose_bar_code"] as String).isEmpty)
          ? EN_LANG_TEXT["choose_bar_code"]
          : json["choose_bar_code"],
      show: (json["show"] == null || (json["show"] as String).isEmpty)
          ? EN_LANG_TEXT["show"]
          : json["show"],
      entries: (json["entries"] == null || (json["entries"] as String).isEmpty)
          ? EN_LANG_TEXT["entries"]
          : json["entries"],
      searchProdCat: (json["search_prod_cat"] == null ||
              (json["search_prod_cat"] as String).isEmpty)
          ? EN_LANG_TEXT["search_prod_cat"]
          : json["search_prod_cat"],
      variationNotAvai: (json["variation_not_avai"] == null ||
              (json["variation_not_avai"] as String).isEmpty)
          ? EN_LANG_TEXT["variation_not_avai"]
          : json["variation_not_avai"],
      newGiftCard: (json["new_gift_card"] == null ||
              (json["new_gift_card"] as String).isEmpty)
          ? EN_LANG_TEXT["new_gift_card"]
          : json["new_gift_card"],
      giftCardList: (json["gift_card_list"] == null ||
              (json["gift_card_list"] as String).isEmpty)
          ? EN_LANG_TEXT["gift_card_list"]
          : json["gift_card_list"],
      giftCard:
          (json["gift_card"] == null || (json["gift_card"] as String).isEmpty)
              ? EN_LANG_TEXT["gift_card"]
              : json["gift_card"],
      giftCardNo: (json["gift_card_no"] == null ||
              (json["gift_card_no"] as String).isEmpty)
          ? EN_LANG_TEXT["gift_card_no"]
          : json["gift_card_no"],
      amtOnGift: (json["amt_on_gift"] == null ||
              (json["amt_on_gift"] as String).isEmpty)
          ? EN_LANG_TEXT["amt_on_gift"]
          : json["amt_on_gift"],
      senderDetails: (json["sender_details"] == null ||
              (json["sender_details"] as String).isEmpty)
          ? EN_LANG_TEXT["sender_details"]
          : json["sender_details"],
      message: (json["message"] == null || (json["message"] as String).isEmpty)
          ? EN_LANG_TEXT["message"]
          : json["message"],
      yourMsgHere: (json["your_msg_here"] == null ||
              (json["your_msg_here"] as String).isEmpty)
          ? EN_LANG_TEXT["your_msg_here"]
          : json["your_msg_here"],
      receiverDetails: (json["receiver_details"] == null ||
              (json["receiver_details"] as String).isEmpty)
          ? EN_LANG_TEXT["receiver_details"]
          : json["receiver_details"],
      senderName: (json["sender_name"] == null ||
              (json["sender_name"] as String).isEmpty)
          ? EN_LANG_TEXT["sender_name"]
          : json["sender_name"],
      receiverName: (json["receiver_name"] == null ||
              (json["receiver_name"] as String).isEmpty)
          ? EN_LANG_TEXT["receiver_name"]
          : json["receiver_name"],
      purDate:
          (json["pur_date"] == null || (json["pur_date"] as String).isEmpty)
              ? EN_LANG_TEXT["pur_date"]
              : json["pur_date"],
      chooseGift: (json["choose_gift"] == null ||
              (json["choose_gift"] as String).isEmpty)
          ? EN_LANG_TEXT["choose_gift"]
          : json["choose_gift"],
      retailStore: (json["retail_store"] == null ||
              (json["retail_store"] as String).isEmpty)
          ? EN_LANG_TEXT["retail_store"]
          : json["retail_store"],
      noGiftFound: (json["no_gift_found"] == null ||
              (json["no_gift_found"] as String).isEmpty)
          ? EN_LANG_TEXT["no_gift_found"]
          : json["no_gift_found"],
      redeemHistory: (json["redeem_history"] == null ||
              (json["redeem_history"] as String).isEmpty)
          ? EN_LANG_TEXT["redeem_history"]
          : json["redeem_history"],
      redeemBy:
          (json["redeem_by"] == null || (json["redeem_by"] as String).isEmpty)
              ? EN_LANG_TEXT["redeem_by"]
              : json["redeem_by"],
      redeemAmt:
          (json["redeem_amt"] == null || (json["redeem_amt"] as String).isEmpty)
              ? EN_LANG_TEXT["redeem_amt"]
              : json["redeem_amt"],
      redeemDate: (json["redeem_date"] == null ||
              (json["redeem_date"] as String).isEmpty)
          ? EN_LANG_TEXT["redeem_date"]
          : json["redeem_date"],
      noRecord:
          (json["no_record"] == null || (json["no_record"] as String).isEmpty)
              ? EN_LANG_TEXT["no_record"]
              : json["no_record"],
      barCodeType: (json["bar_code_type"] == null ||
              (json["bar_code_type"] as String).isEmpty)
          ? EN_LANG_TEXT["bar_code_type"]
          : json["bar_code_type"],
      payAmtHigherGift: (json["pay_amt_higher_gift"] == null ||
              (json["pay_amt_higher_gift"] as String).isEmpty)
          ? EN_LANG_TEXT["pay_amt_higher_gift"]
          : json["pay_amt_higher_gift"],
      thankPur:
          (json["thank_pur"] == null || (json["thank_pur"] as String).isEmpty)
              ? EN_LANG_TEXT["thank_pur"]
              : json["thank_pur"],
      voucherRedeemCode: (json["voucher_redeem_code"] == null ||
              (json["voucher_redeem_code"] as String).isEmpty)
          ? EN_LANG_TEXT["voucher_redeem_code"]
          : json["voucher_redeem_code"],
      giftRedeemCode: (json["gift_redeem_code"] == null ||
              (json["gift_redeem_code"] as String).isEmpty)
          ? EN_LANG_TEXT["gift_redeem_code"]
          : json["gift_redeem_code"],
      chooseGiftCard: (json["choose_gift_card"] == null ||
              (json["choose_gift_card"] as String).isEmpty)
          ? EN_LANG_TEXT["choose_gift_card"]
          : json["choose_gift_card"],
      monthlySubs: (json["monthly_subs"] == null ||
              (json["monthly_subs"] as String).isEmpty)
          ? EN_LANG_TEXT["monthly_subs"]
          : json["monthly_subs"],
      commission:
          (json["commission"] == null || (json["commission"] as String).isEmpty)
              ? EN_LANG_TEXT["commission"]
              : json["commission"],
      priceChargedSales: (json["price_charged_sales"] == null ||
              (json["price_charged_sales"] as String).isEmpty)
          ? EN_LANG_TEXT["price_charged_sales"]
          : json["price_charged_sales"],
      barcodeTypes: (json["barcode_types"] == null ||
              (json["barcode_types"] as String).isEmpty)
          ? EN_LANG_TEXT["barcode_types"]
          : json["barcode_types"],
      searching:
          (json["searching"] == null || (json["searching"] as String).isEmpty)
              ? EN_LANG_TEXT["searching"]
              : json["searching"],
      pleaseChooseGift: (json["please_choose_gift"] == null ||
              (json["please_choose_gift"] as String).isEmpty)
          ? EN_LANG_TEXT["please_choose_gift"]
          : json["please_choose_gift"],
      dear: (json["dear"] == null || (json["dear"] as String).isEmpty)
          ? EN_LANG_TEXT["dear"]
          : json["dear"],
      thanksForChoosing: (json["thanks_for_choosing"] == null ||
              (json["thanks_for_choosing"] as String).isEmpty)
          ? EN_LANG_TEXT["thanks_for_choosing"]
          : json["thanks_for_choosing"],
      emailText1: (json["email_text_1"] == null ||
              (json["email_text_1"] as String).isEmpty)
          ? EN_LANG_TEXT["email_text_1"]
          : json["email_text_1"],
      emailText2: (json["email_text_2"] == null ||
              (json["email_text_2"] as String).isEmpty)
          ? EN_LANG_TEXT["email_text_2"]
          : json["email_text_2"],
      bestRegards: (json["best_regards"] == null ||
              (json["best_regards"] as String).isEmpty)
          ? EN_LANG_TEXT["best_regards"]
          : json["best_regards"],
      refundAmt:
          (json["refund_amt"] == null || (json["refund_amt"] as String).isEmpty)
              ? EN_LANG_TEXT["refund_amt"]
              : json["refund_amt"],
      barcodeGen: (json["barcode_gen"] == null ||
              (json["barcode_gen"] as String).isEmpty)
          ? EN_LANG_TEXT["barcode_gen"]
          : json["barcode_gen"],
      generate:
          (json["generate"] == null || (json["generate"] as String).isEmpty)
              ? EN_LANG_TEXT["generate"]
              : json["generate"],
      printBarcode: (json["print_barcode"] == null ||
              (json["print_barcode"] as String).isEmpty)
          ? EN_LANG_TEXT["print_barcode"]
          : json["print_barcode"],
      generateBarcode: (json["generate_barcode"] == null ||
              (json["generate_barcode"] as String).isEmpty)
          ? EN_LANG_TEXT["generate_barcode"]
          : json["generate_barcode"],
      invalidBarcodeImg: (json["invalid_barcode_img"] == null ||
              (json["invalid_barcode_img"] as String).isEmpty)
          ? EN_LANG_TEXT["invalid_barcode_img"]
          : json["invalid_barcode_img"],
      numOfBarcode: (json["num_of_barcode"] == null ||
              (json["num_of_barcode"] as String).isEmpty)
          ? EN_LANG_TEXT["num_of_barcode"]
          : json["num_of_barcode"],
      uploadImage: (json["upload_image"] == null ||
              (json["upload_image"] as String).isEmpty)
          ? EN_LANG_TEXT["upload_image"]
          : json["upload_image"],
      searchPrinter: (json["search_printer"] == null ||
              (json["search_printer"] as String).isEmpty)
          ? EN_LANG_TEXT["search_printer"]
          : json["search_printer"],
      slug: (json["slug"] == null || (json["slug"] as String).isEmpty)
          ? EN_LANG_TEXT["slug"]
          : json["slug"],
      filterTypes: (json["filter_types"] == null ||
              (json["filter_types"] as String).isEmpty)
          ? EN_LANG_TEXT["filter_types"]
          : json["filter_types"],
      icon: (json["icon"] == null || (json["icon"] as String).isEmpty)
          ? EN_LANG_TEXT["icon"]
          : json["icon"],
      identifier:
          (json["identifier"] == null || (json["identifier"] as String).isEmpty)
              ? EN_LANG_TEXT["identifier"]
              : json["identifier"],
      selectAll:
          (json["select_all"] == null || (json["select_all"] as String).isEmpty)
              ? EN_LANG_TEXT["select_all"]
              : json["select_all"],
      customDesc: (json["custom_desc"] == null ||
              (json["custom_desc"] as String).isEmpty)
          ? EN_LANG_TEXT["custom_desc"]
          : json["custom_desc"],
      labelName:
          (json["label_name"] == null || (json["label_name"] as String).isEmpty)
              ? EN_LANG_TEXT["label_name"]
              : json["label_name"],
      enableRetailScreen: (json["enable_retail_screen"] == null ||
              (json["enable_retail_screen"] as String).isEmpty)
          ? EN_LANG_TEXT["enable_retail_screen"]
          : json["enable_retail_screen"],
      promOfferDiscountPercent: (json["prom_offer_discount_percent"] == null ||
              (json["prom_offer_discount_percent"] as String).isEmpty)
          ? EN_LANG_TEXT["prom_offer_discount_percent"]
          : json["prom_offer_discount_percent"],
      discountPercent: (json["discount_percent"] == null ||
              (json["discount_percent"] as String).isEmpty)
          ? EN_LANG_TEXT["discount_percent"]
          : json["discount_percent"],
      promOfferThres: (json["prom_offer_thres"] == null ||
              (json["prom_offer_thres"] as String).isEmpty)
          ? EN_LANG_TEXT["prom_offer_thres"]
          : json["prom_offer_thres"],
      promImage:
          (json["prom_image"] == null || (json["prom_image"] as String).isEmpty)
              ? EN_LANG_TEXT["prom_image"]
              : json["prom_image"],
      commissionBasedSubsPlan: (json["commission_based_subs_plan"] == null ||
              (json["commission_based_subs_plan"] as String).isEmpty)
          ? EN_LANG_TEXT["commission_based_subs_plan"]
          : json["commission_based_subs_plan"],
      numOfPosLocation: (json["num_of_pos_location"] == null ||
              (json["num_of_pos_location"] as String).isEmpty)
          ? EN_LANG_TEXT["num_of_pos_location"]
          : json["num_of_pos_location"],
      monthlySubsPlan: (json["monthly_subs_plan"] == null ||
              (json["monthly_subs_plan"] as String).isEmpty)
          ? EN_LANG_TEXT["monthly_subs_plan"]
          : json["monthly_subs_plan"],
      areUSureUWantToChangePayMethTo:
          (json["are_u_sure_u_want_to_change_pay_meth_to"] == null ||
                  (json["are_u_sure_u_want_to_change_pay_meth_to"] as String)
                      .isEmpty)
              ? EN_LANG_TEXT["are_u_sure_u_want_to_change_pay_meth_to"]
              : json["are_u_sure_u_want_to_change_pay_meth_to"],
      changePayMethod: (json["change_pay_method"] == null ||
              (json["change_pay_method"] as String).isEmpty)
          ? EN_LANG_TEXT["change_pay_method"]
          : json["change_pay_method"],
      sendDeviceId: (json["send_device_id"] == null ||
              (json["send_device_id"] as String).isEmpty)
          ? EN_LANG_TEXT["send_device_id"]
          : json["send_device_id"],
      emailSuccess: (json["email_success"] == null ||
              (json["email_success"] as String).isEmpty)
          ? EN_LANG_TEXT["email_success"]
          : json["email_success"],
      seeNotifications: (json["see_notifications"] == null ||
              (json["see_notifications"] as String).isEmpty)
          ? EN_LANG_TEXT["see_notifications"]
          : json["see_notifications"],
      recentNotifications: (json["recent_notifications"] == null ||
              (json["recent_notifications"] as String).isEmpty)
          ? EN_LANG_TEXT["recent_notifications"]
          : json["recent_notifications"],
      markRead:
          (json["mark_read"] == null || (json["mark_read"] as String).isEmpty)
              ? EN_LANG_TEXT["mark_read"]
              : json["mark_read"],
      deviceIsActivated: (json["device_is_activated"] == null ||
              (json["device_is_activated"] as String).isEmpty)
          ? EN_LANG_TEXT["device_is_activated"]
          : json["device_is_activated"],
      amountReturned: (json["amount_returned"] == null ||
              (json["amount_returned"] as String).isEmpty)
          ? EN_LANG_TEXT["amount_returned"]
          : json["amount_returned"],
      amountPaid: (json["amount_paid"] == null ||
              (json["amount_paid"] as String).isEmpty)
          ? EN_LANG_TEXT["amount_paid"]
          : json["amount_paid"],
      insufficientAmount: (json["insufficient_amount"] == null ||
              (json["insufficient_amount"] as String).isEmpty)
          ? EN_LANG_TEXT["insufficient_amount"]
          : json["insufficient_amount"],
      sureRefund: (json["sure_refund"] == null ||
              (json["sure_refund"] as String).isEmpty)
          ? EN_LANG_TEXT["sure_refund"]
          : json["sure_refund"],
      receipt: (json["receipt"] == null || (json["receipt"] as String).isEmpty)
          ? EN_LANG_TEXT["receipt"]
          : json["receipt"],
      ccChargeMayApply: (json["cc_charge_may_apply"] == null ||
              (json["cc_charge_may_apply"] as String).isEmpty)
          ? EN_LANG_TEXT["cc_charge_may_apply"]
          : json["cc_charge_may_apply"],
      discountMayApply: (json["discount_may_apply"] == null ||
              (json["discount_may_apply"] as String).isEmpty)
          ? EN_LANG_TEXT["discount_may_apply"]
          : json["discount_may_apply"],
      eftposMerPay: (json["eftpos_mer_pay"] == null ||
              (json["eftpos_mer_pay"] as String).isEmpty)
          ? EN_LANG_TEXT["eftpos_mer_pay"]
          : json["eftpos_mer_pay"],
      eftposMerPayPro: (json["eftpos_mer_pay_pro"] == null ||
              (json["eftpos_mer_pay_pro"] as String).isEmpty)
          ? EN_LANG_TEXT["eftpos_mer_pay_pro"]
          : json["eftpos_mer_pay_pro"],
      merPay: (json["mer_pay"] == null || (json["mer_pay"] as String).isEmpty)
          ? EN_LANG_TEXT["mer_pay"]
          : json["mer_pay"],
      merPayPro: (json["mer_pay_pro"] == null ||
              (json["mer_pay_pro"] as String).isEmpty)
          ? EN_LANG_TEXT["mer_pay_pro"]
          : json["mer_pay_pro"],
      serialNo:
          (json["serial_no"] == null || (json["serial_no"] as String).isEmpty)
              ? EN_LANG_TEXT["serial_no"]
              : json["serial_no"],
      eftposTerDev: (json["eftpos_ter_dev"] == null ||
              (json["eftpos_ter_dev"] as String).isEmpty)
          ? EN_LANG_TEXT["eftpos_ter_dev"]
          : json["eftpos_ter_dev"],
      eftposMer:
          (json["eftpos_mer"] == null || (json["eftpos_mer"] as String).isEmpty)
              ? EN_LANG_TEXT["eftpos_mer"]
              : json["eftpos_mer"],
      chooseEftpos: (json["choose_eftpos"] == null ||
              (json["choose_eftpos"] as String).isEmpty)
          ? EN_LANG_TEXT["choose_eftpos"]
          : json["choose_eftpos"],
      eftposMerPro: (json["eftpos_mer_pro"] == null ||
              (json["eftpos_mer_pro"] as String).isEmpty)
          ? EN_LANG_TEXT["eftpos_mer_pro"]
          : json["eftpos_mer_pro"],
      eftposDevDeleted: (json["eftpos_dev_deleted"] == null ||
              (json["eftpos_dev_deleted"] as String).isEmpty)
          ? EN_LANG_TEXT["eftpos_dev_deleted"]
          : json["eftpos_dev_deleted"],
      chooseEftposTerDev: (json["choose_eftpos_ter_dev"] == null ||
              (json["choose_eftpos_ter_dev"] as String).isEmpty)
          ? EN_LANG_TEXT["choose_eftpos_ter_dev"]
          : json["choose_eftpos_ter_dev"],
      sureToDeleteAllItems: (json["sure_to_delete_all_items"] == null ||
              (json["sure_to_delete_all_items"] as String).isEmpty)
          ? EN_LANG_TEXT["sure_to_delete_all_items"]
          : json["sure_to_delete_all_items"],
      canNotRevertBack: (json["can_not_revert_back"] == null ||
              (json["can_not_revert_back"] as String).isEmpty)
          ? EN_LANG_TEXT["can_not_revert_back"]
          : json["can_not_revert_back"],
      noProductAvai: (json["no_product_avai"] == null ||
              (json["no_product_avai"] as String).isEmpty)
          ? EN_LANG_TEXT["no_product_avai"]
          : json["no_product_avai"],
      noBarcodeAvai: (json["no_barcode_avai"] == null ||
              (json["no_barcode_avai"] as String).isEmpty)
          ? EN_LANG_TEXT["no_barcode_avai"]
          : json["no_barcode_avai"],
      acceptAll:
          (json["accept_all"] == null || (json["accept_all"] as String).isEmpty)
              ? EN_LANG_TEXT["accept_all"]
              : json["accept_all"],
      pair: (json["pair"] == null || (json["pair"] as String).isEmpty)
          ? EN_LANG_TEXT["pair"]
          : json["pair"],
      posName:
          (json["pos_name"] == null || (json["pos_name"] as String).isEmpty)
              ? EN_LANG_TEXT["pos_name"]
              : json["pos_name"],
      paymentProvider: (json["payment_provider"] == null ||
              (json["payment_provider"] as String).isEmpty)
          ? EN_LANG_TEXT["payment_provider"]
          : json["payment_provider"],
      enablePrice: (json["enable_price"] == null ||
              (json["enable_price"] as String).isEmpty)
          ? EN_LANG_TEXT["enable_price"]
          : json["enable_price"],
      priceRange: (json["price_range"] == null ||
              (json["price_range"] as String).isEmpty)
          ? EN_LANG_TEXT["price_range"]
          : json["price_range"],
      todaySaleSum: (json["today_sale_sum"] == null ||
              (json["today_sale_sum"] as String).isEmpty)
          ? EN_LANG_TEXT["today_sale_sum"]
          : json["today_sale_sum"],
      chooseMerchantPro: (json["choose_merchant_pro"] == null ||
              (json["choose_merchant_pro"] as String).isEmpty)
          ? EN_LANG_TEXT["choose_merchant_pro"]
          : json["choose_merchant_pro"],
      giftCardImg: (json["gift_card_img"] == null ||
              (json["gift_card_img"] as String).isEmpty)
          ? EN_LANG_TEXT["gift_card_img"]
          : json["gift_card_img"],
      noImgFound: (json["no_img_found"] == null ||
              (json["no_img_found"] as String).isEmpty)
          ? EN_LANG_TEXT["no_img_found"]
          : json["no_img_found"],
      createNew:
          (json["create_new"] == null || (json["create_new"] as String).isEmpty)
              ? EN_LANG_TEXT["create_new"]
              : json["create_new"],
      removeImg:
          (json["remove_img"] == null || (json["remove_img"] as String).isEmpty)
              ? EN_LANG_TEXT["remove_img"]
              : json["remove_img"],
      giftCards:
          (json["gift_cards"] == null || (json["gift_cards"] as String).isEmpty)
              ? EN_LANG_TEXT["gift_cards"]
              : json["gift_cards"],
      plzSelectGiftCard: (json["plz_select_gift_card"] == null ||
              (json["plz_select_gift_card"] as String).isEmpty)
          ? EN_LANG_TEXT["plz_select_gift_card"]
          : json["plz_select_gift_card"],
      printNotAvai: (json["print_not_avai"] == null ||
              (json["print_not_avai"] as String).isEmpty)
          ? EN_LANG_TEXT["print_not_avai"]
          : json["print_not_avai"],
      displayName: (json["display_name"] == null ||
              (json["display_name"] as String).isEmpty)
          ? EN_LANG_TEXT["display_name"]
          : json["display_name"],
      paymentReceipt: (json["payment_receipt"] == null ||
              (json["payment_receipt"] as String).isEmpty)
          ? EN_LANG_TEXT["payment_receipt"]
          : json["payment_receipt"],
      totalQty:
          (json["total_qty"] == null || (json["total_qty"] as String).isEmpty)
              ? EN_LANG_TEXT["total_qty"]
              : json["total_qty"],
      refundQty:
          (json["refund_qty"] == null || (json["refund_qty"] as String).isEmpty)
              ? EN_LANG_TEXT["refund_qty"]
              : json["refund_qty"],
      invalidCardSurchargePer: (json["invalid_card_surcharge_per"] == null ||
              (json["invalid_card_surcharge_per"] as String).isEmpty)
          ? EN_LANG_TEXT["invalid_card_surcharge_per"]
          : json["invalid_card_surcharge_per"],
      printRefundReceipt: (json["print_refund_receipt"] == null ||
              (json["print_refund_receipt"] as String).isEmpty)
          ? EN_LANG_TEXT["print_refund_receipt"]
          : json["print_refund_receipt"],
      refundInvoice: (json["refund_invoice"] == null ||
              (json["refund_invoice"] as String).isEmpty)
          ? EN_LANG_TEXT["refund_invoice"]
          : json["refund_invoice"],
      refundReceipt: (json["refund_receipt"] == null ||
              (json["refund_receipt"] as String).isEmpty)
          ? EN_LANG_TEXT["refund_receipt"]
          : json["refund_receipt"],
      refundAmount: (json["refund_amount"] == null ||
              (json["refund_amount"] as String).isEmpty)
          ? EN_LANG_TEXT["refund_amount"]
          : json["refund_amount"],
      refundAmtDetail: (json["refund_amt_detail"] == null ||
              (json["refund_amt_detail"] as String).isEmpty)
          ? EN_LANG_TEXT["refund_amt_detail"]
          : json["refund_amt_detail"],
      refundProdPrice: (json["refund_prod_price"] == null ||
              (json["refund_prod_price"] as String).isEmpty)
          ? EN_LANG_TEXT["refund_prod_price"]
          : json["refund_prod_price"],
      refundComboPrice: (json["refund_combo_price"] == null ||
              (json["refund_combo_price"] as String).isEmpty)
          ? EN_LANG_TEXT["refund_combo_price"]
          : json["refund_combo_price"],
      ccNumEmpty: (json["cc_num_empty"] == null ||
              (json["cc_num_empty"] as String).isEmpty)
          ? EN_LANG_TEXT["cc_num_empty"]
          : json["cc_num_empty"],
      invalidCcLen: (json["invalid_cc_len"] == null ||
              (json["invalid_cc_len"] as String).isEmpty)
          ? EN_LANG_TEXT["invalid_cc_len"]
          : json["invalid_cc_len"],
      invalidCc:
          (json["invalid_cc"] == null || (json["invalid_cc"] as String).isEmpty)
              ? EN_LANG_TEXT["invalid_cc"]
              : json["invalid_cc"],
      expiryYear: (json["expiry_year"] == null ||
              (json["expiry_year"] as String).isEmpty)
          ? EN_LANG_TEXT["expiry_year"]
          : json["expiry_year"],
      yourCardNum: (json["your_card_num"] == null ||
              (json["your_card_num"] as String).isEmpty)
          ? EN_LANG_TEXT["your_card_num"]
          : json["your_card_num"],
      expiryMonth: (json["expiry_month"] == null ||
              (json["expiry_month"] as String).isEmpty)
          ? EN_LANG_TEXT["expiry_month"]
          : json["expiry_month"],
      changePrice: (json["change_price"] == null ||
              (json["change_price"] as String).isEmpty)
          ? EN_LANG_TEXT["change_price"]
          : json["change_price"],
      ok: (json["ok"] == null || (json["ok"] as String).isEmpty)
          ? EN_LANG_TEXT["ok"]
          : json["ok"],
      hospitalityPricing: (json["hospitality_pricing"] == null ||
              (json["hospitality_pricing"] as String).isEmpty)
          ? EN_LANG_TEXT["hospitality_pricing"]
          : json["hospitality_pricing"],
      retailPricing: (json["retail_pricing"] == null ||
              (json["retail_pricing"] as String).isEmpty)
          ? EN_LANG_TEXT["retail_pricing"]
          : json["retail_pricing"],
      slelectItemNumRefund: (json["slelect_item_num_refund"] == null ||
              (json["slelect_item_num_refund"] as String).isEmpty)
          ? EN_LANG_TEXT["slelect_item_num_refund"]
          : json["slelect_item_num_refund"],
      updateBeforePay: (json["update_before_pay"] == null ||
              (json["update_before_pay"] as String).isEmpty)
          ? EN_LANG_TEXT["update_before_pay"]
          : json["update_before_pay"],
      completePrevPayToNextPay:
          (json["complete_prev_pay_to_next_pay"] == null ||
                  (json["complete_prev_pay_to_next_pay"] as String).isEmpty)
              ? EN_LANG_TEXT["complete_prev_pay_to_next_pay"]
              : json["complete_prev_pay_to_next_pay"],
      sureUpdateOrder: (json["sure_update_order"] == null ||
              (json["sure_update_order"] as String).isEmpty)
          ? EN_LANG_TEXT["sure_update_order"]
          : json["sure_update_order"],
      disCantApplied: (json["dis_cant_applied"] == null ||
              (json["dis_cant_applied"] as String).isEmpty)
          ? EN_LANG_TEXT["dis_cant_applied"]
          : json["dis_cant_applied"],
      modifier:
          (json["modifier"] == null || (json["modifier"] as String).isEmpty)
              ? EN_LANG_TEXT["modifier"]
              : json["modifier"],
      trackNumber: (json["track_number"] == null ||
              (json["track_number"] as String).isEmpty)
          ? EN_LANG_TEXT["track_number"]
          : json["track_number"],
      searchFtProduct: (json["search_ft_product"] == null ||
              (json["search_ft_product"] as String).isEmpty)
          ? EN_LANG_TEXT["search_ft_product"]
          : json["search_ft_product"],
      alreadyExists: (json["already_exists"] == null ||
              (json["already_exists"] as String).isEmpty)
          ? EN_LANG_TEXT["already_exists"]
          : json["already_exists"],
      layout: (json["layout"] == null || (json["layout"] as String).isEmpty)
          ? EN_LANG_TEXT["layout"]
          : json["layout"],
      rotateTable: (json["rotate_table"] == null ||
              (json["rotate_table"] as String).isEmpty)
          ? EN_LANG_TEXT["rotate_table"]
          : json["rotate_table"],
      resizeTable: (json["resize_table"] == null ||
              (json["resize_table"] as String).isEmpty)
          ? EN_LANG_TEXT["resize_table"]
          : json["resize_table"],
      createLayoutFor: (json["create_layout_for"] == null ||
              (json["create_layout_for"] as String).isEmpty)
          ? EN_LANG_TEXT["create_layout_for"]
          : json["create_layout_for"],
      create: (json["create"] == null || (json["create"] as String).isEmpty)
          ? EN_LANG_TEXT["create"]
          : json["create"],
      selected:
          (json["selected"] == null || (json["selected"] as String).isEmpty)
              ? EN_LANG_TEXT["selected"]
              : json["selected"],
      floorPlan:
          (json["floor_plan"] == null || (json["floor_plan"] as String).isEmpty)
              ? EN_LANG_TEXT["floor_plan"]
              : json["floor_plan"],
      noFloorSetup: (json["no_floor_setup"] == null ||
              (json["no_floor_setup"] as String).isEmpty)
          ? EN_LANG_TEXT["no_floor_setup"]
          : json["no_floor_setup"],
      reservationList: (json["reservation_list"] == null ||
              (json["reservation_list"] as String).isEmpty)
          ? EN_LANG_TEXT["reservation_list"]
          : json["reservation_list"],
      tapMoveTableSpace: (json["tap_move_table_space"] == null ||
              (json["tap_move_table_space"] as String).isEmpty)
          ? EN_LANG_TEXT["tap_move_table_space"]
          : json["tap_move_table_space"],
      makeFree:
          (json["make_free"] == null || (json["make_free"] as String).isEmpty)
              ? EN_LANG_TEXT["make_free"]
              : json["make_free"],
      placeNewOrder: (json["place_new_order"] == null ||
              (json["place_new_order"] as String).isEmpty)
          ? EN_LANG_TEXT["place_new_order"]
          : json["place_new_order"],
      reseravtionType: (json["reseravtion_type"] == null ||
              (json["reseravtion_type"] as String).isEmpty)
          ? EN_LANG_TEXT["reseravtion_type"]
          : json["reseravtion_type"],
      reservedIn: (json["reserved_in"] == null ||
              (json["reserved_in"] as String).isEmpty)
          ? EN_LANG_TEXT["reserved_in"]
          : json["reserved_in"],
      tableAvailable: (json["table_available"] == null ||
              (json["table_available"] as String).isEmpty)
          ? EN_LANG_TEXT["table_available"]
          : json["table_available"],
      //

      viewLayout: (json["view_layout"] == null ||
              (json["view_layout"] as String).isEmpty)
          ? EN_LANG_TEXT["view_layout"]
          : json["view_layout"],
      createLayout: (json["create_layout"] == null ||
              (json["create_layout"] as String).isEmpty)
          ? EN_LANG_TEXT["create_layout"]
          : json["create_layout"],
      hours: (json["hours"] == null || (json["hours"] as String).isEmpty)
          ? EN_LANG_TEXT["hours"]
          : json["hours"],
      hour: (json["hour"] == null || (json["hour"] as String).isEmpty)
          ? EN_LANG_TEXT["hour"]
          : json["hour"],
      minutes: (json["minutes"] == null || (json["minutes"] as String).isEmpty)
          ? EN_LANG_TEXT["minutes"]
          : json["minutes"],
      minute: (json["minute"] == null || (json["minute"] as String).isEmpty)
          ? EN_LANG_TEXT["minute"]
          : json["minute"],
      reserve: (json["reserve"] == null || (json["reserve"] as String).isEmpty)
          ? EN_LANG_TEXT["reserve"]
          : json["reserve"],
      occupy: (json["occupy"] == null || (json["occupy"] as String).isEmpty)
          ? EN_LANG_TEXT["occupy"]
          : json["occupy"],
      tableOccupation: (json["table_occupation"] == null ||
              (json["table_occupation"] as String).isEmpty)
          ? EN_LANG_TEXT["table_occupation"]
          : json["table_occupation"],
      wannaOccupyTable: (json["wanna_occupy_table"] == null ||
              (json["wanna_occupy_table"] as String).isEmpty)
          ? EN_LANG_TEXT["wanna_occupy_table"]
          : json["wanna_occupy_table"],
      makeTableFree: (json["make_table_free"] == null ||
              (json["make_table_free"] as String).isEmpty)
          ? EN_LANG_TEXT["make_table_free"]
          : json["make_table_free"],
      wannaTableFree: (json["wanna_table_free"] == null ||
              (json["wanna_table_free"] as String).isEmpty)
          ? EN_LANG_TEXT["wanna_table_free"]
          : json["wanna_table_free"],
      checkout:
          (json["checkout"] == null || (json["checkout"] as String).isEmpty)
              ? EN_LANG_TEXT["checkout"]
              : json["checkout"],
      printMerchant: (json["print_merchant"] == null ||
              (json["print_merchant"] as String).isEmpty)
          ? EN_LANG_TEXT["print_merchant"]
          : json["print_merchant"],
      purchaseReceipt: (json["purchase_receipt"] == null ||
              (json["purchase_receipt"] as String).isEmpty)
          ? EN_LANG_TEXT["purchase_receipt"]
          : json["purchase_receipt"],
      salesTax:
          (json["sales_tax"] == null || (json["sales_tax"] as String).isEmpty)
              ? EN_LANG_TEXT["sales_tax"]
              : json["sales_tax"],
      purchaseTax: (json["purchase_tax"] == null ||
              (json["purchase_tax"] as String).isEmpty)
          ? EN_LANG_TEXT["purchase_tax"]
          : json["purchase_tax"],
      comments:
          (json["comments"] == null || (json["comments"] as String).isEmpty)
              ? EN_LANG_TEXT["comments"]
              : json["comments"],
      channelType: (json["channel_type"] == null ||
              (json["channel_type"] as String).isEmpty)
          ? EN_LANG_TEXT["channel_type"]
          : json["channel_type"],
      staySignedIn: (json["stay_signed_in"] == null ||
              (json["stay_signed_in"] as String).isEmpty)
          ? EN_LANG_TEXT["stay_signed_in"]
          : json["stay_signed_in"],
      noProductFound: (json["no_product_found"] == null ||
              (json["no_product_found"] as String).isEmpty)
          ? EN_LANG_TEXT["no_product_found"]
          : json["no_product_found"],
      willAutoLogoutDevices: (json["will_auto_logout_devices"] == null ||
              (json["will_auto_logout_devices"] as String).isEmpty)
          ? EN_LANG_TEXT["will_auto_logout_devices"]
          : json["will_auto_logout_devices"],

      confirmLogoutDeviceCheckSignin:
          (json["confirm_logout_device_check_signin"] == null ||
                  (json["confirm_logout_device_check_signin"] as String)
                      .isEmpty)
              ? EN_LANG_TEXT["confirm_logout_device_check_signin"]
              : json["confirm_logout_device_check_signin"],
      eodCasPay: (json["eod_cas_pay"] == null ||
              (json["eod_cas_pay"] as String).isEmpty)
          ? EN_LANG_TEXT["eod_cas_pay"]
          : json["eod_cas_pay"],
      calculatedCash: (json["calculated_cash"] == null ||
              (json["calculated_cash"] as String).isEmpty)
          ? EN_LANG_TEXT["calculated_cash"]
          : json["calculated_cash"],
      templateCategory: (json["template_category"] == null ||
              (json["template_category"] as String).isEmpty)
          ? EN_LANG_TEXT["template_category"]
          : json["template_category"],
      otherSettings: (json["other_settings"] == null ||
              (json["other_settings"] as String).isEmpty)
          ? EN_LANG_TEXT["other_settings"]
          : json["other_settings"],
      updateOrderChannel: (json["update_order_channel"] == null ||
              (json["update_order_channel"] as String).isEmpty)
          ? EN_LANG_TEXT["update_order_channel"]
          : json["update_order_channel"],
      tableQrOrderChannel: (json["table_qr_order_channel"] == null ||
              (json["table_qr_order_channel"] as String).isEmpty)
          ? EN_LANG_TEXT["table_qr_order_channel"]
          : json["table_qr_order_channel"],
      showReserveTable: (json["show_reserve_table"] == null ||
              (json["show_reserve_table"] as String).isEmpty)
          ? EN_LANG_TEXT["show_reserve_table"]
          : json["show_reserve_table"],
      showFooter: (json["show_footer"] == null ||
              (json["show_footer"] as String).isEmpty)
          ? EN_LANG_TEXT["show_footer"]
          : json["show_footer"],
      showPaymentPickup: (json["show_payment_pickup"] == null ||
              (json["show_payment_pickup"] as String).isEmpty)
          ? EN_LANG_TEXT["show_payment_pickup"]
          : json["show_payment_pickup"],
      showPaymentDine: (json["show_payment_dine"] == null ||
              (json["show_payment_dine"] as String).isEmpty)
          ? EN_LANG_TEXT["show_payment_dine"]
          : json["show_payment_dine"],
      showPaymentDelivery: (json["show_payment_delivery"] == null ||
              (json["show_payment_delivery"] as String).isEmpty)
          ? EN_LANG_TEXT["show_payment_delivery"]
          : json["show_payment_delivery"],
      livePaymentMode: (json["live_payment_mode"] == null ||
              (json["live_payment_mode"] as String).isEmpty)
          ? EN_LANG_TEXT["live_payment_mode"]
          : json["live_payment_mode"],
      barcode: (json["barcode"] == null || (json["barcode"] as String).isEmpty)
          ? EN_LANG_TEXT["barcode"]
          : json["barcode"],
      showTable:
          (json["show_table"] == null || (json["show_table"] as String).isEmpty)
              ? EN_LANG_TEXT["show_table"]
              : json["show_table"],
      enableUnderMaintain: (json["enable_under_maintain"] == null ||
              (json["enable_under_maintain"] as String).isEmpty)
          ? EN_LANG_TEXT["enable_under_maintain"]
          : json["enable_under_maintain"],
      isRetailScreen: (json["is_retail_screen"] == null ||
              (json["is_retail_screen"] as String).isEmpty)
          ? EN_LANG_TEXT["is_retail_screen"]
          : json["is_retail_screen"],
      enableOrderGiftForm: (json["enable_order_gift_form"] == null ||
              (json["enable_order_gift_form"] as String).isEmpty)
          ? EN_LANG_TEXT["enable_order_gift_form"]
          : json["enable_order_gift_form"],

      enableCopyrightFooter: (json["enable_copyright_footer"] == null ||
              (json["enable_copyright_footer"] as String).isEmpty)
          ? EN_LANG_TEXT["enable_copyright_footer"]
          : json["enable_copyright_footer"],
      enableFooter: (json["enable_footer"] == null ||
              (json["enable_footer"] as String).isEmpty)
          ? EN_LANG_TEXT["enable_footer"]
          : json["enable_footer"],
      enableGuestCheckout: (json["enable_guest_checkout"] == null ||
              (json["enable_guest_checkout"] as String).isEmpty)
          ? EN_LANG_TEXT["enable_guest_checkout"]
          : json["enable_guest_checkout"],
      hospitalityOnline: (json["hospitality_online"] == null ||
              (json["hospitality_online"] as String).isEmpty)
          ? EN_LANG_TEXT["hospitality_online"]
          : json["hospitality_online"],
      retailOnline: (json["retail_online"] == null ||
              (json["retail_online"] as String).isEmpty)
          ? EN_LANG_TEXT["retail_online"]
          : json["retail_online"],
      businessTypeCategory: (json["business_type_category"] == null ||
              (json["business_type_category"] as String).isEmpty)
          ? EN_LANG_TEXT["business_type_category"]
          : json["business_type_category"],
      spiceChoices: (json["spice_choices"] == null ||
              (json["spice_choices"] as String).isEmpty)
          ? EN_LANG_TEXT["spice_choices"]
          : json["spice_choices"],
      addCartSuccess: (json["add_cart_success"] == null ||
              (json["add_cart_success"] as String).isEmpty)
          ? EN_LANG_TEXT["add_cart_success"]
          : json["add_cart_success"],
      printRefundInvoice: (json["print_refund_invoice"] == null ||
              (json["print_refund_invoice"] as String).isEmpty)
          ? EN_LANG_TEXT["print_refund_invoice"]
          : json["print_refund_invoice"],
      printEftposSign: (json["print_eftpos_sign"] == null ||
              (json["print_eftpos_sign"] as String).isEmpty)
          ? EN_LANG_TEXT["print_eftpos_sign"]
          : json["print_eftpos_sign"],
      otherDetails: (json["other_details"] == null ||
              (json["other_details"] as String).isEmpty)
          ? EN_LANG_TEXT["other_details"]
          : json["other_details"],
      deliveryCannotForPast: (json["delivery_cannot_for_past"] == null ||
              (json["delivery_cannot_for_past"] as String).isEmpty)
          ? EN_LANG_TEXT["delivery_cannot_for_past"]
          : json["delivery_cannot_for_past"],
      deliveryTime: (json["delivery_time"] == null ||
              (json["delivery_time"] as String).isEmpty)
          ? EN_LANG_TEXT["delivery_time"]
          : json["delivery_time"],

      spice: (json["spice"] == null || (json["spice"] as String).isEmpty)
          ? EN_LANG_TEXT["spice"]
          : json["spice"],
      printMerchantCopy: (json["print_merchant_copy"] == null ||
              (json["print_merchant_copy"] as String).isEmpty)
          ? EN_LANG_TEXT["print_merchant_copy"]
          : json["print_merchant_copy"],
      printCustomerCopy: (json["print_customer_copy"] == null ||
              (json["print_customer_copy"] as String).isEmpty)
          ? EN_LANG_TEXT["print_customer_copy"]
          : json["print_customer_copy"],
      viewEftposLogs: (json["view_eftpos_logs"] == null ||
              (json["view_eftpos_logs"] as String).isEmpty)
          ? EN_LANG_TEXT["view_eftpos_logs"]
          : json["view_eftpos_logs"],
      printEftposLog: (json["print_eftpos_log"] == null ||
              (json["print_eftpos_log"] as String).isEmpty)
          ? EN_LANG_TEXT["print_eftpos_log"]
          : json["print_eftpos_log"],
      updatedSuccessfully: (json["updated_successfully"] == null ||
              (json["updated_successfully"] as String).isEmpty)
          ? EN_LANG_TEXT["updated_successfully"]
          : json["updated_successfully"],

      cusSearch:
          (json["cus_search"] == null || (json["cus_search"] as String).isEmpty)
              ? EN_LANG_TEXT["cus_search"]
              : json["cus_search"],

      orderHistory: (json["order_history"] == null ||
              (json["order_history"] as String).isEmpty)
          ? EN_LANG_TEXT["order_history"]
          : json["order_history"],
      selectCusOrderHistory: (json["select_cus_order_history"] == null ||
              (json["select_cus_order_history"] as String).isEmpty)
          ? EN_LANG_TEXT["select_cus_order_history"]
          : json["select_cus_order_history"],
      number: (json["number"] == null || (json["number"] as String).isEmpty)
          ? EN_LANG_TEXT["number"]
          : json["number"],
      anonymous:
          (json["anonymous"] == null || (json["anonymous"] as String).isEmpty)
              ? EN_LANG_TEXT["anonymous"]
              : json["anonymous"],
      scanBluetoothDevices: (json["scan_bluetooth_devices"] == null ||
              (json["scan_bluetooth_devices"] as String).isEmpty)
          ? EN_LANG_TEXT["scan_bluetooth_devices"]
          : json["scan_bluetooth_devices"],
      errorScanningPrinter: (json["error_scanning_printer"] == null ||
              (json["error_scanning_printer"] as String).isEmpty)
          ? EN_LANG_TEXT["error_scanning_printer"]
          : json["error_scanning_printer"],
      devicesFound: (json["devices_found"] == null ||
              (json["devices_found"] as String).isEmpty)
          ? EN_LANG_TEXT["devices_found"]
          : json["devices_found"],
      searchingDevice: (json["searching_device"] == null ||
              (json["searching_device"] as String).isEmpty)
          ? EN_LANG_TEXT["searching_device"]
          : json["searching_device"],

      noDeviceFound: (json["no_device_found"] == null ||
              (json["no_device_found"] as String).isEmpty)
          ? EN_LANG_TEXT["no_device_found"]
          : json["no_device_found"],
      isBluetoothDevice: (json["is_bluetooth_device"] == null ||
              (json["is_bluetooth_device"] as String).isEmpty)
          ? EN_LANG_TEXT["is_bluetooth_device"]
          : json["is_bluetooth_device"],
      enableBluetoothSetting: (json["enable_bluetooth_setting"] == null ||
              (json["enable_bluetooth_setting"] as String).isEmpty)
          ? EN_LANG_TEXT["enable_bluetooth_setting"]
          : json["enable_bluetooth_setting"],
      stockCount: (json["stock_count"] == null ||
              (json["stock_count"] as String).isEmpty)
          ? EN_LANG_TEXT["stock_count"]
          : json["stock_count"],
      connectionFailed: (json["connection_failed"] == null ||
              (json["connection_failed"] as String).isEmpty)
          ? EN_LANG_TEXT["connection_failed"]
          : json["connection_failed"],
      businessTypeCat: (json["business_type_cat"] == null ||
              (json["business_type_cat"] as String).isEmpty)
          ? EN_LANG_TEXT["business_type_cat"]
          : json["business_type_cat"],
      refundableAmt: (json["refundable_amt"] == null ||
              (json["refundable_amt"] as String).isEmpty)
          ? EN_LANG_TEXT["refundable_amt"]
          : json["refundable_amt"],
      printEftSign: (json["print_eft_sign"] == null ||
              (json["print_eft_sign"] as String).isEmpty)
          ? EN_LANG_TEXT["print_eft_sign"]
          : json["print_eft_sign"],
      printCusCopy: (json["print_cus_copy"] == null ||
              (json["print_cus_copy"] as String).isEmpty)
          ? EN_LANG_TEXT["print_cus_copy"]
          : json["print_cus_copy"],
      viewEftLogs: (json["view_eft_logs"] == null ||
              (json["view_eft_logs"] as String).isEmpty)
          ? EN_LANG_TEXT["view_eft_logs"]
          : json["view_eft_logs"],
      printEftLogs: (json["print_eft_logs"] == null ||
              (json["print_eft_logs"] as String).isEmpty)
          ? EN_LANG_TEXT["print_eft_logs"]
          : json["print_eft_logs"],
      eftLogs:
          (json["eft_logs"] == null || (json["eft_logs"] as String).isEmpty)
              ? EN_LANG_TEXT["eft_logs"]
              : json["eft_logs"],
      deliveryCantMadePast: (json["delivery_cant_made_past"] == null ||
              (json["delivery_cant_made_past"] as String).isEmpty)
          ? EN_LANG_TEXT["delivery_cant_made_past"]
          : json["delivery_cant_made_past"],
      allItemRefund: (json["all_item_refund"] == null ||
              (json["all_item_refund"] as String).isEmpty)
          ? EN_LANG_TEXT["all_item_refund"]
          : json["all_item_refund"],
      enCopyFootDes: (json["en_copy_foot_des"] == null ||
              (json["en_copy_foot_des"] as String).isEmpty)
          ? EN_LANG_TEXT["en_copy_foot_des"]
          : json["en_copy_foot_des"],
      adultCap:
          (json["adult_cap"] == null || (json["adult_cap"] as String).isEmpty)
              ? EN_LANG_TEXT["adult_cap"]
              : json["adult_cap"],
      enDocGroupSpliter: (json["en_doc_group_spliter"] == null ||
              (json["en_doc_group_spliter"] as String).isEmpty)
          ? EN_LANG_TEXT["en_doc_group_spliter"]
          : json["en_doc_group_spliter"],
      docGroup:
          (json["doc_group"] == null || (json["doc_group"] as String).isEmpty)
              ? EN_LANG_TEXT["doc_group"]
              : json["doc_group"],
      chooseDocGroup: (json["choose_doc_group"] == null ||
              (json["choose_doc_group"] as String).isEmpty)
          ? EN_LANG_TEXT["choose_doc_group"]
          : json["choose_doc_group"],
      cusCopy:
          (json["cus_copy"] == null || (json["cus_copy"] as String).isEmpty)
              ? EN_LANG_TEXT["cus_copy"]
              : json["cus_copy"],
      orderPrintCopy: (json["order_print_copy"] == null ||
              (json["order_print_copy"] as String).isEmpty)
          ? EN_LANG_TEXT["order_print_copy"]
          : json["order_print_copy"],
      revoke: (json["revoke"] == null || (json["revoke"] as String).isEmpty)
          ? EN_LANG_TEXT["revoke"]
          : json["revoke"],
      servedBy:
          (json["served_by"] == null || (json["served_by"] as String).isEmpty)
              ? EN_LANG_TEXT["served_by"]
              : json["served_by"],
      payProcessBy: (json["pay_process_by"] == null ||
              (json["pay_process_by"] as String).isEmpty)
          ? EN_LANG_TEXT["pay_process_by"]
          : json["pay_process_by"],
      orderProcessBy: (json["order_process_by"] == null ||
              (json["order_process_by"] as String).isEmpty)
          ? EN_LANG_TEXT["order_process_by"]
          : json["order_process_by"],
      cancelSendKitchen: (json["cancel_send_kitchen"] == null ||
              (json["cancel_send_kitchen"] as String).isEmpty)
          ? EN_LANG_TEXT["cancel_send_kitchen"]
          : json["cancel_send_kitchen"],
      reservCantEndBefStartDate:
          (json["reserv_cant_end_bef_start_date"] == null ||
                  (json["reserv_cant_end_bef_start_date"] as String).isEmpty)
              ? EN_LANG_TEXT["reserv_cant_end_bef_start_date"]
              : json["reserv_cant_end_bef_start_date"],
      noRcptFound: (json["no_rcpt_found"] == null ||
              (json["no_rcpt_found"] as String).isEmpty)
          ? EN_LANG_TEXT["no_rcpt_found"]
          : json["no_rcpt_found"],
      updateSuccess: (json["update_success"] == null ||
              (json["update_success"] as String).isEmpty)
          ? EN_LANG_TEXT["update_success"]
          : json["update_success"],
      invoicePrintCusCopy: (json["invoice_print_cus_copy"] == null ||
              (json["invoice_print_cus_copy"] as String).isEmpty)
          ? EN_LANG_TEXT["invoice_print_cus_copy"]
          : json["invoice_print_cus_copy"],
      viewReserve: (json["view_reserve"] == null ||
              (json["view_reserve"] as String).isEmpty)
          ? EN_LANG_TEXT["view_reserve"]
          : json["view_reserve"],
      orderCopy:
          (json["order_copy"] == null || (json["order_copy"] as String).isEmpty)
              ? EN_LANG_TEXT["order_copy"]
              : json["order_copy"],
      chooseHalfHalf: (json["choose_half_half"] == null ||
              (json["choose_half_half"] as String).isEmpty)
          ? EN_LANG_TEXT["choose_half_half"]
          : json["choose_half_half"],
      halfItem:
          (json["half_item"] == null || (json["half_item"] as String).isEmpty)
              ? EN_LANG_TEXT["half_item"]
              : json["half_item"],

      calSet: (json["cal_set"] == null || (json["cal_set"] as String).isEmpty)
          ? EN_LANG_TEXT["cal_set"]
          : json["cal_set"],
      autoEnable: (json["auto_enable"] == null ||
              (json["auto_enable"] as String).isEmpty)
          ? EN_LANG_TEXT["auto_enable"]
          : json["auto_enable"],
      autoEnHoliSur: (json["auto_en_holi_sur"] == null ||
              (json["auto_en_holi_sur"] as String).isEmpty)
          ? EN_LANG_TEXT["auto_en_holi_sur"]
          : json["auto_en_holi_sur"],
      weekendSur: (json["weekend_sur"] == null ||
              (json["weekend_sur"] as String).isEmpty)
          ? EN_LANG_TEXT["weekend_sur"]
          : json["weekend_sur"],
      autoEnWeekSur: (json["auto_en_week_sur"] == null ||
              (json["auto_en_week_sur"] as String).isEmpty)
          ? EN_LANG_TEXT["auto_en_week_sur"]
          : json["auto_en_week_sur"],
      autoEnCreSur: (json["auto_en_cre_sur"] == null ||
              (json["auto_en_cre_sur"] as String).isEmpty)
          ? EN_LANG_TEXT["auto_en_cre_sur"]
          : json["auto_en_cre_sur"],
      mailServer: (json["mail_server"] == null ||
              (json["mail_server"] as String).isEmpty)
          ? EN_LANG_TEXT["mail_server"]
          : json["mail_server"],
      allProducts: (json["all_products"] == null ||
              (json["all_products"] as String).isEmpty)
          ? EN_LANG_TEXT["all_products"]
          : json["all_products"],
      emailSetting: (json["email_setting"] == null ||
              (json["email_setting"] as String).isEmpty)
          ? EN_LANG_TEXT["email_setting"]
          : json["email_setting"],
      smsSetting: (json["sms_setting"] == null ||
              (json["sms_setting"] as String).isEmpty)
          ? EN_LANG_TEXT["sms_setting"]
          : json["sms_setting"],

      fromNum:
          (json["from_num"] == null || (json["from_num"] as String).isEmpty)
              ? EN_LANG_TEXT["from_num"]
              : json["from_num"],
      enTls: (json["en_tls"] == null || (json["en_tls"] as String).isEmpty)
          ? EN_LANG_TEXT["en_tls"]
          : json["en_tls"],
      enSsi: (json["en_ssi"] == null || (json["en_ssi"] as String).isEmpty)
          ? EN_LANG_TEXT["en_ssi"]
          : json["en_ssi"],
      sendSms:
          (json["send_sms"] == null || (json["send_sms"] as String).isEmpty)
              ? EN_LANG_TEXT["send_sms"]
              : json["send_sms"],
      printerType: (json["printer_type"] == null ||
              (json["printer_type"] as String).isEmpty)
          ? EN_LANG_TEXT["printer_type"]
          : json["printer_type"],
      choosePrintType: (json["choose_print_type"] == null ||
              (json["choose_print_type"] as String).isEmpty)
          ? EN_LANG_TEXT["choose_print_type"]
          : json["choose_print_type"],

      enAutoSendKit: (json["en_auto_send_kit"] == null ||
              (json["en_auto_send_kit"] as String).isEmpty)
          ? EN_LANG_TEXT["en_auto_send_kit"]
          : json["en_auto_send_kit"],
      enPayPair: (json["en_pay_pair"] == null ||
              (json["en_pay_pair"] as String).isEmpty)
          ? EN_LANG_TEXT["en_pay_pair"]
          : json["en_pay_pair"],
      enAutoSendKitDisplay: (json["en_auto_send_kit_display"] == null ||
              (json["en_auto_send_kit_display"] as String).isEmpty)
          ? EN_LANG_TEXT["en_auto_send_kit_display"]
          : json["en_auto_send_kit_display"],
      totalLoyaltyAmt: (json["total_loyalty_amt"] == null ||
              (json["total_loyalty_amt"] as String).isEmpty)
          ? EN_LANG_TEXT["total_loyalty_amt"]
          : json["total_loyalty_amt"],
      redeemLoyalty: (json["redeem_loyalty"] == null ||
              (json["redeem_loyalty"] as String).isEmpty)
          ? EN_LANG_TEXT["redeem_loyalty"]
          : json["redeem_loyalty"],
      balPoint:
          (json["bal_point"] == null || (json["bal_point"] as String).isEmpty)
              ? EN_LANG_TEXT["bal_point"]
              : json["bal_point"],

      amtSpent:
          (json["amt_spent"] == null || (json["amt_spent"] as String).isEmpty)
              ? EN_LANG_TEXT["amt_spent"]
              : json["amt_spent"],
      rewardCusAmtSpent: (json["reward_cus_amt_spent"] == null ||
              (json["reward_cus_amt_spent"] as String).isEmpty)
          ? EN_LANG_TEXT["reward_cus_amt_spent"]
          : json["reward_cus_amt_spent"],
      eveTimeCusSpnt: (json["eve_time_cus_spnt"] == null ||
              (json["eve_time_cus_spnt"] as String).isEmpty)
          ? EN_LANG_TEXT["eve_time_cus_spnt"]
          : json["eve_time_cus_spnt"],
      cusEarn:
          (json["cus_earn"] == null || (json["cus_earn"] as String).isEmpty)
              ? EN_LANG_TEXT["cus_earn"]
              : json["cus_earn"],
      eodReport:
          (json["eod_report"] == null || (json["eod_report"] as String).isEmpty)
              ? EN_LANG_TEXT["eod_report"]
              : json["eod_report"],
      eodReportNotFound: (json["eod_report_not_found"] == null ||
              (json["eod_report_not_found"] as String).isEmpty)
          ? EN_LANG_TEXT["eod_report_not_found"]
          : json["eod_report_not_found"],
      zReport:
          (json["z_report"] == null || (json["z_report"] as String).isEmpty)
              ? EN_LANG_TEXT["z_report"]
              : json["z_report"],
      salesSum:
          (json["sales_sum"] == null || (json["sales_sum"] as String).isEmpty)
              ? EN_LANG_TEXT["sales_sum"]
              : json["sales_sum"],
      discounts:
          (json["discounts"] == null || (json["discounts"] as String).isEmpty)
              ? EN_LANG_TEXT["discounts"]
              : json["discounts"],
      giftSales:
          (json["gift_sales"] == null || (json["gift_sales"] as String).isEmpty)
              ? EN_LANG_TEXT["gift_sales"]
              : json["gift_sales"],
      crCardSur: (json["cr_card_sur"] == null ||
              (json["cr_card_sur"] as String).isEmpty)
          ? EN_LANG_TEXT["cr_card_sur"]
          : json["cr_card_sur"],
      deliCharge: (json["deli_charge"] == null ||
              (json["deli_charge"] as String).isEmpty)
          ? EN_LANG_TEXT["deli_charge"]
          : json["deli_charge"],
      totalTax:
          (json["total_tax"] == null || (json["total_tax"] as String).isEmpty)
              ? EN_LANG_TEXT["total_tax"]
              : json["total_tax"],
      totalUnitSales: (json["total_unit_sales"] == null ||
              (json["total_unit_sales"] as String).isEmpty)
          ? EN_LANG_TEXT["total_unit_sales"]
          : json["total_unit_sales"],
      salesChannel: (json["sales_channel"] == null ||
              (json["sales_channel"] as String).isEmpty)
          ? EN_LANG_TEXT["sales_channel"]
          : json["sales_channel"],
      unit: (json["unit"] == null || (json["unit"] as String).isEmpty)
          ? EN_LANG_TEXT["unit"]
          : json["unit"],
      totalNetSales: (json["total_net_sales"] == null ||
              (json["total_net_sales"] as String).isEmpty)
          ? EN_LANG_TEXT["total_net_sales"]
          : json["total_net_sales"],
      salesByCat: (json["sales_by_cat"] == null ||
              (json["sales_by_cat"] as String).isEmpty)
          ? EN_LANG_TEXT["sales_by_cat"]
          : json["sales_by_cat"],
      salesByCatType: (json["sales_by_cat_type"] == null ||
              (json["sales_by_cat_type"] as String).isEmpty)
          ? EN_LANG_TEXT["sales_by_cat_type"]
          : json["sales_by_cat_type"],
      payMethods: (json["pay_methods"] == null ||
              (json["pay_methods"] as String).isEmpty)
          ? EN_LANG_TEXT["pay_methods"]
          : json["pay_methods"],
      totalPayment: (json["total_payment"] == null ||
              (json["total_payment"] as String).isEmpty)
          ? EN_LANG_TEXT["total_payment"]
          : json["total_payment"],
      variance:
          (json["variance"] == null || (json["variance"] as String).isEmpty)
              ? EN_LANG_TEXT["variance"]
              : json["variance"],
      printEod:
          (json["print_eod"] == null || (json["print_eod"] as String).isEmpty)
              ? EN_LANG_TEXT["print_eod"]
              : json["print_eod"],
      preparedDate: (json["prepared_date"] == null ||
              (json["prepared_date"] as String).isEmpty)
          ? EN_LANG_TEXT["prepared_date"]
          : json["prepared_date"],
      orderedDate: (json["ordered_date"] == null ||
              (json["ordered_date"] as String).isEmpty)
          ? EN_LANG_TEXT["ordered_date"]
          : json["ordered_date"],
      eftDevicePair: (json["eft_device_pair"] == null ||
              (json["eft_device_pair"] as String).isEmpty)
          ? EN_LANG_TEXT["eft_device_pair"]
          : json["eft_device_pair"],
      dualDisSet: (json["dual_dis_set"] == null ||
              (json["dual_dis_set"] as String).isEmpty)
          ? EN_LANG_TEXT["dual_dis_set"]
          : json["dual_dis_set"],
      searchComboProduct: (json["search_combo_product"] == null ||
              (json["search_combo_product"] as String).isEmpty)
          ? EN_LANG_TEXT["search_combo_product"]
          : json["search_combo_product"],
      searchNewIngre: (json["search_new_ingre"] == null ||
              (json["search_new_ingre"] as String).isEmpty)
          ? EN_LANG_TEXT["search_new_ingre"]
          : json["search_new_ingre"],
      select: (json["select"] == null || (json["select"] as String).isEmpty)
          ? EN_LANG_TEXT["select"]
          : json["select"],
      disAmtHigher: (json["dis_amt_higher"] == null ||
              (json["dis_amt_higher"] as String).isEmpty)
          ? EN_LANG_TEXT["dis_amt_higher"]
          : json["dis_amt_higher"],
      sellingPrice: (json["selling_price"] == null ||
              (json["selling_price"] as String).isEmpty)
          ? EN_LANG_TEXT["selling_price"]
          : json["selling_price"],
      disPrice:
          (json["dis_price"] == null || (json["dis_price"] as String).isEmpty)
              ? EN_LANG_TEXT["dis_price"]
              : json["dis_price"],
      newSellingPrice: (json["new_selling_price"] == null ||
              (json["new_selling_price"] as String).isEmpty)
          ? EN_LANG_TEXT["new_selling_price"]
          : json["new_selling_price"],

      addProductMessage: (json["add_product_message"] == null ||
              (json["add_product_message"] as String).isEmpty)
          ? EN_LANG_TEXT["add_product_message"]
          : json["add_product_message"],
      outOfStock: (json["out_of_stock"] == null ||
              (json["out_of_stock"] as String).isEmpty)
          ? EN_LANG_TEXT["out_of_stock"]
          : json["out_of_stock"],
      usbNotFound: (json["usb_not_found"] == null ||
              (json["usb_not_found"] as String).isEmpty)
          ? EN_LANG_TEXT["usb_not_found"]
          : json["usb_not_found"],
      printerNotSetup: (json["printer_not_setup"] == null ||
              (json["printer_not_setup"] as String).isEmpty)
          ? EN_LANG_TEXT["printer_not_setup"]
          : json["printer_not_setup"],
      npQrFound: (json["np_qr_found"] == null ||
              (json["np_qr_found"] as String).isEmpty)
          ? EN_LANG_TEXT["np_qr_found"]
          : json["np_qr_found"],
      posDeviceQr: (json["pos_device_qr"] == null ||
              (json["pos_device_qr"] as String).isEmpty)
          ? EN_LANG_TEXT["pos_device_qr"]
          : json["pos_device_qr"],
      occasion:
          (json["occasion"] == null || (json["occasion"] as String).isEmpty)
              ? EN_LANG_TEXT["occasion"]
              : json["occasion"],
      kitDocket:
          (json["kit_docket"] == null || (json["kit_docket"] as String).isEmpty)
              ? EN_LANG_TEXT["kit_docket"]
              : json["kit_docket"],
      item: (json["item"] == null || (json["item"] as String).isEmpty)
          ? EN_LANG_TEXT["item"]
          : json["item"],
      createHalfHalfItem: (json["create_half_half_item"] == null ||
              (json["create_half_half_item"] as String).isEmpty)
          ? EN_LANG_TEXT["create_half_half_item"]
          : json["create_half_half_item"],
      createUniHalf: (json["create_uni_half"] == null ||
              (json["create_uni_half"] as String).isEmpty)
          ? EN_LANG_TEXT["create_uni_half"]
          : json["create_uni_half"],
      selectItemUpdate: (json["select_item_update"] == null ||
              (json["select_item_update"] as String).isEmpty)
          ? EN_LANG_TEXT["select_item_update"]
          : json["select_item_update"],
      addItem:
          (json["add_item"] == null || (json["add_item"] as String).isEmpty)
              ? EN_LANG_TEXT["add_item"]
              : json["add_item"],
      up1StHalf: (json["up_1st_half"] == null ||
              (json["up_1st_half"] as String).isEmpty)
          ? EN_LANG_TEXT["up_1st_half"]
          : json["up_1st_half"],
      addHalfSucc: (json["add_half_succ"] == null ||
              (json["add_half_succ"] as String).isEmpty)
          ? EN_LANG_TEXT["add_half_succ"]
          : json["add_half_succ"],
      upHalfSucc: (json["up_half_succ"] == null ||
              (json["up_half_succ"] as String).isEmpty)
          ? EN_LANG_TEXT["up_half_succ"]
          : json["up_half_succ"],
      promtOffDis: (json["promt_off_dis"] == null ||
              (json["promt_off_dis"] as String).isEmpty)
          ? EN_LANG_TEXT["promt_off_dis"]
          : json["promt_off_dis"],
      comProd:
          (json["com_prod"] == null || (json["com_prod"] as String).isEmpty)
              ? EN_LANG_TEXT["com_prod"]
              : json["com_prod"],
      rawIngre:
          (json["raw_ingre"] == null || (json["raw_ingre"] as String).isEmpty)
              ? EN_LANG_TEXT["raw_ingre"]
              : json["raw_ingre"],
      enterName:
          (json["enter_name"] == null || (json["enter_name"] as String).isEmpty)
              ? EN_LANG_TEXT["enter_name"]
              : json["enter_name"],
      enterMsg:
          (json["enter_msg"] == null || (json["enter_msg"] as String).isEmpty)
              ? EN_LANG_TEXT["enter_msg"]
              : json["enter_msg"],
      point: (json["point"] == null || (json["point"] as String).isEmpty)
          ? EN_LANG_TEXT["point"]
          : json["point"],
      printEodSum: (json["print_eod_sum"] == null ||
              (json["print_eod_sum"] as String).isEmpty)
          ? EN_LANG_TEXT["print_eod_sum"]
          : json["print_eod_sum"],
      inStock:
          (json["in_stock"] == null || (json["in_stock"] as String).isEmpty)
              ? EN_LANG_TEXT["in_stock"]
              : json["in_stock"],

      orderStatusChangeSucc: (json["order_status_change_succ"] == null ||
              (json["order_status_change_succ"] as String).isEmpty)
          ? EN_LANG_TEXT["order_status_change_succ"]
          : json["order_status_change_succ"],
      up2NdHalf: (json["up_2nd_half"] == null ||
              (json["up_2nd_half"] as String).isEmpty)
          ? EN_LANG_TEXT["up_2nd_half"]
          : json["up_2nd_half"],
      choose2NdHalf: (json["choose_2nd_half"] == null ||
              (json["choose_2nd_half"] as String).isEmpty)
          ? EN_LANG_TEXT["choose_2nd_half"]
          : json["choose_2nd_half"],

      //add remaining all

      connected:
          (json['connected'] == null || (json['connected'] as String).isEmpty)
              ? EN_LANG_TEXT['connected']
              : json['connected'],
      disconnected: (json['disconnected'] == null ||
              (json['disconnected'] as String).isEmpty)
          ? EN_LANG_TEXT['disconnected']
          : json['disconnected'],
      notConnected: (json['not_connected'] == null ||
              (json['not_connected'] as String).isEmpty)
          ? EN_LANG_TEXT['not_connected']
          : json['not_connected'],
      ourChannels: (json['our_channels'] == null ||
              (json['our_channels'] as String).isEmpty)
          ? EN_LANG_TEXT['our_channels']
          : json['our_channels'],
      empName:
          (json['emp_name'] == null || (json['emp_name'] as String).isEmpty)
              ? EN_LANG_TEXT['emp_name']
              : json['emp_name'],
      empCode:
          (json['emp_code'] == null || (json['emp_code'] as String).isEmpty)
              ? EN_LANG_TEXT['emp_code']
              : json['emp_code'],
      empEmail:
          (json['emp_email'] == null || (json['emp_email'] as String).isEmpty)
              ? EN_LANG_TEXT['emp_email']
              : json['emp_email'],
      empPhone:
          (json['emp_phone'] == null || (json['emp_phone'] as String).isEmpty)
              ? EN_LANG_TEXT['emp_phone']
              : json['emp_phone'],
      currentDateTime: (json['current_date_time'] == null ||
              (json['current_date_time'] as String).isEmpty)
          ? EN_LANG_TEXT['current_date_time']
          : json['current_date_time'],
      workingHours: (json['working_hours'] == null ||
              (json['working_hours'] as String).isEmpty)
          ? EN_LANG_TEXT['working_hours']
          : json['working_hours'],
      punchOut:
          (json['punch_out'] == null || (json['punch_out'] as String).isEmpty)
              ? EN_LANG_TEXT['punch_out']
              : json['punch_out'],
      punchIn:
          (json['punch_in'] == null || (json['punch_in'] as String).isEmpty)
              ? EN_LANG_TEXT['punch_in']
              : json['punch_in'],
      punching:
          (json['punching'] == null || (json['punching'] as String).isEmpty)
              ? EN_LANG_TEXT['punching']
              : json['punching'],
      toConDevLocAcc: (json['to_con_dev_loc_acc'] == null ||
              (json['to_con_dev_loc_acc'] as String).isEmpty)
          ? EN_LANG_TEXT['to_con_dev_loc_acc']
          : json['to_con_dev_loc_acc'],
      openLocSet: (json['open_loc_set'] == null ||
              (json['open_loc_set'] as String).isEmpty)
          ? EN_LANG_TEXT['open_loc_set']
          : json['open_loc_set'],
      noThanks:
          (json['no_thanks'] == null || (json['no_thanks'] as String).isEmpty)
              ? EN_LANG_TEXT['no_thanks']
              : json['no_thanks'],
      downloading: (json['downloading'] == null ||
              (json['downloading'] as String).isEmpty)
          ? EN_LANG_TEXT['downloading']
          : json['downloading'],
      downloaded:
          (json['downloaded'] == null || (json['downloaded'] as String).isEmpty)
              ? EN_LANG_TEXT['downloaded']
              : json['downloaded'],
      downloadFailed: (json['download_failed'] == null ||
              (json['download_failed'] as String).isEmpty)
          ? EN_LANG_TEXT['download_failed']
          : json['download_failed'],
      permissionDenied: (json['permission_denied'] == null ||
              (json['permission_denied'] as String).isEmpty)
          ? EN_LANG_TEXT['permission_denied']
          : json['permission_denied'],
      chooseTerminal: (json['choose_terminal'] == null ||
              (json['choose_terminal'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_terminal']
          : json['choose_terminal'],
      deviceNotConnected: (json['device_not_connected'] == null ||
              (json['device_not_connected'] as String).isEmpty)
          ? EN_LANG_TEXT['device_not_connected']
          : json['device_not_connected'],
      initiatePayment: (json['initiate_payment'] == null ||
              (json['initiate_payment'] as String).isEmpty)
          ? EN_LANG_TEXT['initiate_payment']
          : json['initiate_payment'],
      successfullyConnected: (json['successfully_connected'] == null ||
              (json['successfully_connected'] as String).isEmpty)
          ? EN_LANG_TEXT['successfully_connected']
          : json['successfully_connected'],
      failedToOpenPort: (json['failed_to_open_port'] == null ||
              (json['failed_to_open_port'] as String).isEmpty)
          ? EN_LANG_TEXT['failed_to_open_port']
          : json['failed_to_open_port'],
      unexpectedError: (json['unexpected_error'] == null ||
              (json['unexpected_error'] as String).isEmpty)
          ? EN_LANG_TEXT['unexpected_error']
          : json['unexpected_error'],
      salesSummaryCap: (json['sales_summary_cap'] == null ||
              (json['sales_summary_cap'] as String).isEmpty)
          ? EN_LANG_TEXT['sales_summary_cap']
          : json['sales_summary_cap'],
      platformError: (json['platform_error'] == null ||
              (json['platform_error'] as String).isEmpty)
          ? EN_LANG_TEXT['platform_error']
          : json['platform_error'],
      continueTransaction: (json['continue_transaction'] == null ||
              (json['continue_transaction'] as String).isEmpty)
          ? EN_LANG_TEXT['continue_transaction']
          : json['continue_transaction'],
      emergencyContact: (json['emergency_contact'] == null ||
              (json['emergency_contact'] as String).isEmpty)
          ? EN_LANG_TEXT['emergency_contact']
          : json['emergency_contact'],
      incompleteTransactionRecovery:
          (json['incomplete_transaction_recovery'] == null ||
                  (json['incomplete_transaction_recovery'] as String).isEmpty)
              ? EN_LANG_TEXT['incomplete_transaction_recovery']
              : json['incomplete_transaction_recovery'],
      retry: (json['retry'] == null || (json['retry'] as String).isEmpty)
          ? EN_LANG_TEXT['retry']
          : json['retry'],
      punchInOut: (json['punch_in_out'] == null ||
              (json['punch_in_out'] as String).isEmpty)
          ? EN_LANG_TEXT['punch_in_out']
          : json['punch_in_out'],
      dismiss: (json['dismiss'] == null || (json['dismiss'] as String).isEmpty)
          ? EN_LANG_TEXT['dismiss']
          : json['dismiss'],
      createReservation: (json['create_reservation'] == null ||
              (json['create_reservation'] as String).isEmpty)
          ? EN_LANG_TEXT['create_reservation']
          : json['create_reservation'],
      recentIncomingCall: (json['recent_incoming_call'] == null ||
              (json['recent_incoming_call'] as String).isEmpty)
          ? EN_LANG_TEXT['recent_incoming_call']
          : json['recent_incoming_call'],
      line: (json['line'] == null || (json['line'] as String).isEmpty)
          ? EN_LANG_TEXT['line']
          : json['line'],
      decline: (json['decline'] == null || (json['decline'] as String).isEmpty)
          ? EN_LANG_TEXT['decline']
          : json['decline'],
      accept: (json['accept'] == null || (json['accept'] as String).isEmpty)
          ? EN_LANG_TEXT['accept']
          : json['accept'],
      openingCashDrawer: (json['opening_cash_drawer'] == null ||
              (json['opening_cash_drawer'] as String).isEmpty)
          ? EN_LANG_TEXT['opening_cash_drawer']
          : json['opening_cash_drawer'],
      failedToConnect: (json['failed_to_connect'] == null ||
              (json['failed_to_connect'] as String).isEmpty)
          ? EN_LANG_TEXT['failed_to_connect']
          : json['failed_to_connect'],
      purchaseCap: (json['purchase_cap'] == null ||
              (json['purchase_cap'] as String).isEmpty)
          ? EN_LANG_TEXT['purchase_cap']
          : json['purchase_cap'],
      refundCap:
          (json['refund_cap'] == null || (json['refund_cap'] as String).isEmpty)
              ? EN_LANG_TEXT['refund_cap']
              : json['refund_cap'],
      retryCap:
          (json['retry_cap'] == null || (json['retry_cap'] as String).isEmpty)
              ? EN_LANG_TEXT['retry_cap']
              : json['retry_cap'],
      blueScanError: (json['blue_scan_error'] == null ||
              (json['blue_scan_error'] as String).isEmpty)
          ? EN_LANG_TEXT['blue_scan_error']
          : json['blue_scan_error'],
      incomingCall: (json['incoming_call'] == null ||
              (json['incoming_call'] as String).isEmpty)
          ? EN_LANG_TEXT['incoming_call']
          : json['incoming_call'],
      failedToPrint: (json['failed_to_print'] == null ||
              (json['failed_to_print'] as String).isEmpty)
          ? EN_LANG_TEXT['failed_to_print']
          : json['failed_to_print'],
      blueConnectDenied: (json['blue_connect_denied'] == null ||
              (json['blue_connect_denied'] as String).isEmpty)
          ? EN_LANG_TEXT['blue_connect_denied']
          : json['blue_connect_denied'],
      blueScanDenied: (json['blue_scan_denied'] == null ||
              (json['blue_scan_denied'] as String).isEmpty)
          ? EN_LANG_TEXT['blue_scan_denied']
          : json['blue_scan_denied'],
      home: (json['home'] == null || (json['home'] as String).isEmpty)
          ? EN_LANG_TEXT['home']
          : json['home'],
      zReportCap: (json['z_report_cap'] == null ||
              (json['z_report_cap'] as String).isEmpty)
          ? EN_LANG_TEXT['z_report_cap']
          : json['z_report_cap'],
      paymentMethods: (json['payment_methods'] == null ||
              (json['payment_methods'] as String).isEmpty)
          ? EN_LANG_TEXT['payment_methods']
          : json['payment_methods'],
      half: (json['half'] == null || (json['half'] as String).isEmpty)
          ? EN_LANG_TEXT['half']
          : json['half'],
      noOfCustomers: (json['no_of_customers'] == null ||
              (json['no_of_customers'] as String).isEmpty)
          ? EN_LANG_TEXT['no_of_customers']
          : json['no_of_customers'],
      removeIngredients: (json['remove_ingredients'] == null ||
              (json['remove_ingredients'] as String).isEmpty)
          ? EN_LANG_TEXT['remove_ingredients']
          : json['remove_ingredients'],
      halfNHalf: (json['half_n_half'] == null ||
              (json['half_n_half'] as String).isEmpty)
          ? EN_LANG_TEXT['half_n_half']
          : json['half_n_half'],
      failedToGetUsb: (json['failed_to_get_usb'] == null ||
              (json['failed_to_get_usb'] as String).isEmpty)
          ? EN_LANG_TEXT['failed_to_get_usb']
          : json['failed_to_get_usb'],
      box: (json['box'] == null || (json['box'] as String).isEmpty)
          ? EN_LANG_TEXT['box']
          : json['box'],
      addBox: (json['add_box'] == null || (json['add_box'] as String).isEmpty)
          ? EN_LANG_TEXT['add_box']
          : json['add_box'],
      tapBoxToAdd: (json['tap_box_to_add'] == null ||
              (json['tap_box_to_add'] as String).isEmpty)
          ? EN_LANG_TEXT['tap_box_to_add']
          : json['tap_box_to_add'],
      dimensionCm: (json['dimension_cm'] == null ||
              (json['dimension_cm'] as String).isEmpty)
          ? EN_LANG_TEXT['dimension_cm']
          : json['dimension_cm'],
      weightGram: (json['weight_gram'] == null ||
              (json['weight_gram'] as String).isEmpty)
          ? EN_LANG_TEXT['weight_gram']
          : json['weight_gram'],
      length: (json['length'] == null || (json['length'] as String).isEmpty)
          ? EN_LANG_TEXT['length']
          : json['length'],
      height: (json['height'] == null || (json['height'] as String).isEmpty)
          ? EN_LANG_TEXT['height']
          : json['height'],
      depth: (json['depth'] == null || (json['depth'] as String).isEmpty)
          ? EN_LANG_TEXT['depth']
          : json['depth'],
      chooseItems: (json['choose_items'] == null ||
              (json['choose_items'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_items']
          : json['choose_items'],
      deliveryDriverPickup: (json['delivery_driver_pickup'] == null ||
              (json['delivery_driver_pickup'] as String).isEmpty)
          ? EN_LANG_TEXT['delivery_driver_pickup']
          : json['delivery_driver_pickup'],
      pickupCannotPast: (json['pickup_cannot_past'] == null ||
              (json['pickup_cannot_past'] as String).isEmpty)
          ? EN_LANG_TEXT['pickup_cannot_past']
          : json['pickup_cannot_past'],
      pickupTimeAtLeast10: (json['pickup_time_at_least_10'] == null ||
              (json['pickup_time_at_least_10'] as String).isEmpty)
          ? EN_LANG_TEXT['pickup_time_at_least_10']
          : json['pickup_time_at_least_10'],
      pickupTimeCannotAfter: (json['pickup_time_cannot_after'] == null ||
              (json['pickup_time_cannot_after'] as String).isEmpty)
          ? EN_LANG_TEXT['pickup_time_cannot_after']
          : json['pickup_time_cannot_after'],
      pickupTimeCannotMade: (json['pickup_time_cannot_made'] == null ||
              (json['pickup_time_cannot_made'] as String).isEmpty)
          ? EN_LANG_TEXT['pickup_time_cannot_made']
          : json['pickup_time_cannot_made'],
      deliveryCustomer: (json['delivery_customer'] == null ||
              (json['delivery_customer'] as String).isEmpty)
          ? EN_LANG_TEXT['delivery_customer']
          : json['delivery_customer'],
      failedToGetUsbDevices: (json['failed_to_get_usb_devices'] == null ||
              (json['failed_to_get_usb_devices'] as String).isEmpty)
          ? EN_LANG_TEXT['failed_to_get_usb_devices']
          : json['failed_to_get_usb_devices'],
      createDelivery: (json['create_delivery'] == null ||
              (json['create_delivery'] as String).isEmpty)
          ? EN_LANG_TEXT['create_delivery']
          : json['create_delivery'],
      delivery:
          (json['delivery'] == null || (json['delivery'] as String).isEmpty)
              ? EN_LANG_TEXT['delivery']
              : json['delivery'],
      details: (json['details'] == null || (json['details'] as String).isEmpty)
          ? EN_LANG_TEXT['details']
          : json['details'],
      pickUpTime: (json['pick_up_time'] == null ||
              (json['pick_up_time'] as String).isEmpty)
          ? EN_LANG_TEXT['pick_up_time']
          : json['pick_up_time'],
      viewDetails: (json['view_details'] == null ||
              (json['view_details'] as String).isEmpty)
          ? EN_LANG_TEXT['view_details']
          : json['view_details'],
      courierDetails: (json['courier_details'] == null ||
              (json['courier_details'] as String).isEmpty)
          ? EN_LANG_TEXT['courier_details']
          : json['courier_details'],
      vehicleType: (json['vehicle_type'] == null ||
              (json['vehicle_type'] as String).isEmpty)
          ? EN_LANG_TEXT['vehicle_type']
          : json['vehicle_type'],
      recipient:
          (json['recipient'] == null || (json['recipient'] as String).isEmpty)
              ? EN_LANG_TEXT['recipient']
              : json['recipient'],
      deliveryNotes: (json['delivery_notes'] == null ||
              (json['delivery_notes'] as String).isEmpty)
          ? EN_LANG_TEXT['delivery_notes']
          : json['delivery_notes'],
      itemDetails: (json['item_details'] == null ||
              (json['item_details'] as String).isEmpty)
          ? EN_LANG_TEXT['item_details']
          : json['item_details'],
      itemName:
          (json['item_name'] == null || (json['item_name'] as String).isEmpty)
              ? EN_LANG_TEXT['item_name']
              : json['item_name'],
      size: (json['size'] == null || (json['size'] as String).isEmpty)
          ? EN_LANG_TEXT['size']
          : json['size'],
      dimension:
          (json['dimension'] == null || (json['dimension'] as String).isEmpty)
              ? EN_LANG_TEXT['dimension']
              : json['dimension'],
      weight: (json['weight'] == null || (json['weight'] as String).isEmpty)
          ? EN_LANG_TEXT['weight']
          : json['weight'],
      mustBeUpright: (json['must_be_upright'] == null ||
              (json['must_be_upright'] as String).isEmpty)
          ? EN_LANG_TEXT['must_be_upright']
          : json['must_be_upright'],
      deliveryStatus: (json['delivery_status'] == null ||
              (json['delivery_status'] as String).isEmpty)
          ? EN_LANG_TEXT['delivery_status']
          : json['delivery_status'],
      totalPrice: (json['total_price'] == null ||
              (json['total_price'] as String).isEmpty)
          ? EN_LANG_TEXT['total_price']
          : json['total_price'],
      close: (json['close'] == null || (json['close'] as String).isEmpty)
          ? EN_LANG_TEXT['close']
          : json['close'],
      completeDelivery: (json['complete_delivery'] == null ||
              (json['complete_delivery'] as String).isEmpty)
          ? EN_LANG_TEXT['complete_delivery']
          : json['complete_delivery'],
      trackDelivery: (json['track_delivery'] == null ||
              (json['track_delivery'] as String).isEmpty)
          ? EN_LANG_TEXT['track_delivery']
          : json['track_delivery'],
      noDeliveryOrderFound: (json['no_delivery_order_found'] == null ||
              (json['no_delivery_order_found'] as String).isEmpty)
          ? EN_LANG_TEXT['no_delivery_order_found']
          : json['no_delivery_order_found'],
      giveUsRating: (json['give_us_rating'] == null ||
              (json['give_us_rating'] as String).isEmpty)
          ? EN_LANG_TEXT['give_us_rating']
          : json['give_us_rating'],
      shareDetails: (json['share_details'] == null ||
              (json['share_details'] as String).isEmpty)
          ? EN_LANG_TEXT['share_details']
          : json['share_details'],
      extra: (json['extra'] == null || (json['extra'] as String).isEmpty)
          ? EN_LANG_TEXT['extra']
          : json['extra'],
      chooseServiceStatus: (json['choose_service_status'] == null ||
              (json['choose_service_status'] as String).isEmpty)
          ? EN_LANG_TEXT['choose_service_status']
          : json['choose_service_status'],
      enterEmpCode: (json['enter_emp_code'] == null ||
              (json['enter_emp_code'] as String).isEmpty)
          ? EN_LANG_TEXT['enter_emp_code']
          : json['enter_emp_code'],
      startUnscheduledShift: (json['start_unscheduled_shift'] == null ||
              (json['start_unscheduled_shift'] as String).isEmpty)
          ? EN_LANG_TEXT['start_unscheduled_shift']
          : json['start_unscheduled_shift'],
      startShift: (json['start_shift'] == null ||
              (json['start_shift'] as String).isEmpty)
          ? EN_LANG_TEXT['start_shift']
          : json['start_shift'],
      scheduledBreaks: (json['scheduled_breaks'] == null ||
              (json['scheduled_breaks'] as String).isEmpty)
          ? EN_LANG_TEXT['scheduled_breaks']
          : json['scheduled_breaks'],
      startingAt: (json['starting_at'] == null ||
              (json['starting_at'] as String).isEmpty)
          ? EN_LANG_TEXT['starting_at']
          : json['starting_at'],
      noScheduledShifts: (json['no_scheduled_shifts'] == null ||
              (json['no_scheduled_shifts'] as String).isEmpty)
          ? EN_LANG_TEXT['no_scheduled_shifts']
          : json['no_scheduled_shifts'],
      shiftTime:
          (json['shift_time'] == null || (json['shift_time'] as String).isEmpty)
              ? EN_LANG_TEXT['shift_time']
              : json['shift_time'],
      early: (json['early'] == null || (json['early'] as String).isEmpty)
          ? EN_LANG_TEXT['early']
          : json['early'],
      late: (json['late'] == null || (json['late'] as String).isEmpty)
          ? EN_LANG_TEXT['late']
          : json['late'],
      onUnscheduledShift: (json['on_unscheduled_shift'] == null ||
              (json['on_unscheduled_shift'] as String).isEmpty)
          ? EN_LANG_TEXT['on_unscheduled_shift']
          : json['on_unscheduled_shift'],
      onBreak:
          (json['on_break'] == null || (json['on_break'] as String).isEmpty)
              ? EN_LANG_TEXT['on_break']
              : json['on_break'],
      iWillBeBack: (json['i_will_be_back'] == null ||
              (json['i_will_be_back'] as String).isEmpty)
          ? EN_LANG_TEXT['i_will_be_back']
          : json['i_will_be_back'],
      doYouWantConfirmEarlier: (json['do_you_want_confirm_earlier'] == null ||
              (json['do_you_want_confirm_earlier'] as String).isEmpty)
          ? EN_LANG_TEXT['do_you_want_confirm_earlier']
          : json['do_you_want_confirm_earlier'],
      doYouWantConfirmEndShift:
          (json['do_you_want_confirm_end_shift'] == null ||
                  (json['do_you_want_confirm_end_shift'] as String).isEmpty)
              ? EN_LANG_TEXT['do_you_want_confirm_end_shift']
              : json['do_you_want_confirm_end_shift'],
      earlyEndShift: (json['early_end_shift'] == null ||
              (json['early_end_shift'] as String).isEmpty)
          ? EN_LANG_TEXT['early_end_shift']
          : json['early_end_shift'],
      endShift:
          (json['end_shift'] == null || (json['end_shift'] as String).isEmpty)
              ? EN_LANG_TEXT['end_shift']
              : json['end_shift'],
      endBreak:
          (json['end_break'] == null || (json['end_break'] as String).isEmpty)
              ? EN_LANG_TEXT['end_break']
              : json['end_break'],
      pleaseSelectBreak: (json['please_select_break'] == null ||
              (json['please_select_break'] as String).isEmpty)
          ? EN_LANG_TEXT['please_select_break']
          : json['please_select_break'],
      addNote:
          (json['add_note'] == null || (json['add_note'] as String).isEmpty)
              ? EN_LANG_TEXT['add_note']
              : json['add_note'],
      noBreaksAvailable: (json['no_breaks_available'] == null ||
              (json['no_breaks_available'] as String).isEmpty)
          ? EN_LANG_TEXT['no_breaks_available']
          : json['no_breaks_available'],
      startBreak: (json['start_break'] == null ||
              (json['start_break'] as String).isEmpty)
          ? EN_LANG_TEXT['start_break']
          : json['start_break'],
      unscheduled: (json['unscheduled'] == null ||
              (json['unscheduled'] as String).isEmpty)
          ? EN_LANG_TEXT['unscheduled']
          : json['unscheduled'],
      scheduled:
          (json['scheduled'] == null || (json['scheduled'] as String).isEmpty)
              ? EN_LANG_TEXT['scheduled']
              : json['scheduled'],
      unpaid: (json['unpaid'] == null || (json['unpaid'] as String).isEmpty)
          ? EN_LANG_TEXT['unpaid']
          : json['unpaid'],
      paid: (json['paid'] == null || (json['paid'] as String).isEmpty)
          ? EN_LANG_TEXT['paid']
          : json['paid'],
      selectBreaks: (json['select_breaks'] == null ||
              (json['select_breaks'] as String).isEmpty)
          ? EN_LANG_TEXT['select_breaks']
          : json['select_breaks'],
      breakTaken: (json['break_taken'] == null ||
              (json['break_taken'] as String).isEmpty)
          ? EN_LANG_TEXT['break_taken']
          : json['break_taken'],
      endShiftWarning: (json['end_shift_warning'] == null ||
              (json['end_shift_warning'] as String).isEmpty)
          ? EN_LANG_TEXT['end_shift_warning']
          : json['end_shift_warning'],
      takeBreak:
          (json['take_break'] == null || (json['take_break'] as String).isEmpty)
              ? EN_LANG_TEXT['take_break']
              : json['take_break'],
      showGiftCard: (json['show_gift_card'] == null ||
              (json['show_gift_card'] as String).isEmpty)
          ? EN_LANG_TEXT['show_gift_card']
          : json['show_gift_card'],
      yourGiftCardBalance: (json['your_gift_card_balance'] == null ||
              (json['your_gift_card_balance'] as String).isEmpty)
          ? EN_LANG_TEXT['your_gift_card_balance']
          : json['your_gift_card_balance'],
      checkBalance: (json['check_balance'] == null ||
              (json['check_balance'] as String).isEmpty)
          ? EN_LANG_TEXT['check_balance']
          : json['check_balance'],
      giftCardTemplate: (json['gift_card_template'] == null ||
              (json['gift_card_template'] as String).isEmpty)
          ? EN_LANG_TEXT['gift_card_template']
          : json['gift_card_template'],
      checkGiftCardAmount: (json['check_gift_card_amount'] == null ||
              (json['check_gift_card_amount'] as String).isEmpty)
          ? EN_LANG_TEXT['check_gift_card_amount']
          : json['check_gift_card_amount'],
      giftCardEnquiry: (json['gift_card_enquiry'] == null ||
              (json['gift_card_enquiry'] as String).isEmpty)
          ? EN_LANG_TEXT['gift_card_enquiry']
          : json['gift_card_enquiry'],
      giftCardTemplateGroup: (json['gift_card_template_group'] == null ||
              (json['gift_card_template_group'] as String).isEmpty)
          ? EN_LANG_TEXT['gift_card_template_group']
          : json['gift_card_template_group'],
      allServices: (json['all_services'] == null ||
              (json['all_services'] as String).isEmpty)
          ? EN_LANG_TEXT['all_services']
          : json['all_services'],
      getDeviceInfo: (json['get_device_info'] == null ||
              (json['get_device_info'] as String).isEmpty)
          ? EN_LANG_TEXT['get_device_info']
          : json['get_device_info'],
      emergencyEmail: (json['emergency_email'] == null ||
              (json['emergency_email'] as String).isEmpty)
          ? EN_LANG_TEXT['emergency_email']
          : json['emergency_email'],
      emergencyPhone: (json['emergency_phone'] == null ||
              (json['emergency_phone'] as String).isEmpty)
          ? EN_LANG_TEXT['emergency_phone']
          : json['emergency_phone'],
      emergencyContactPerson: (json['emergency_contact_person'] == null ||
              (json['emergency_contact_person'] as String).isEmpty)
          ? EN_LANG_TEXT['emergency_contact_person']
          : json['emergency_contact_person'],
      emergencyContactName: (json['emergency_contact_name'] == null ||
              (json['emergency_contact_name'] as String).isEmpty)
          ? EN_LANG_TEXT['emergency_contact_name']
          : json['emergency_contact_name'],
      reportingEmployees: (json['reporting_employees'] == null ||
              (json['reporting_employees'] as String).isEmpty)
          ? EN_LANG_TEXT['reporting_employees']
          : json['reporting_employees'],
      hourlyRate: (json['hourly_rate'] == null ||
              (json['hourly_rate'] as String).isEmpty)
          ? EN_LANG_TEXT['hourly_rate']
          : json['hourly_rate'],
      annualSalary: (json['annual_salary'] == null ||
              (json['annual_salary'] as String).isEmpty)
          ? EN_LANG_TEXT['annual_salary']
          : json['annual_salary'],
      gender: (json['gender'] == null || (json['gender'] as String).isEmpty)
          ? EN_LANG_TEXT['gender']
          : json['gender'],
      preferredName: (json['preferred_name'] == null ||
              (json['preferred_name'] as String).isEmpty)
          ? EN_LANG_TEXT['preferred_name']
          : json['preferred_name'],
      employeeCode: (json['employee_code'] == null ||
              (json['employee_code'] as String).isEmpty)
          ? EN_LANG_TEXT['employee_code']
          : json['employee_code'],
      employeeInformation: (json['employee_information'] == null ||
              (json['employee_information'] as String).isEmpty)
          ? EN_LANG_TEXT['employee_information']
          : json['employee_information'],
      editEmployee: (json['edit_employee'] == null ||
              (json['edit_employee'] as String).isEmpty)
          ? EN_LANG_TEXT['edit_employee']
          : json['edit_employee'],
      modifiers:
          (json['modifiers'] == null || (json['modifiers'] as String).isEmpty)
              ? EN_LANG_TEXT['modifiers']
              : json['modifiers'],
      jobTitle:
          (json['job_title'] == null || (json['job_title'] as String).isEmpty)
              ? EN_LANG_TEXT['job_title']
              : json['job_title'],
      others: (json['others'] == null || (json['others'] as String).isEmpty)
          ? EN_LANG_TEXT['others']
          : json['others'],
      female: (json['female'] == null || (json['female'] as String).isEmpty)
          ? EN_LANG_TEXT['female']
          : json['female'],
      male: (json['male'] == null || (json['male'] as String).isEmpty)
          ? EN_LANG_TEXT['male']
          : json['male'],
      splitByItems: (json['split_by_items'] == null ||
              (json['split_by_items'] as String).isEmpty)
          ? EN_LANG_TEXT['split_by_items']
          : json['split_by_items'],
      splitAmount: (json['split_amount'] == null ||
              (json['split_amount'] as String).isEmpty)
          ? EN_LANG_TEXT['split_amount']
          : json['split_amount'],
      fullAmount: (json['full_amount'] == null ||
              (json['full_amount'] as String).isEmpty)
          ? EN_LANG_TEXT['full_amount']
          : json['full_amount'],
      yourOrderReady: (json['your_order_ready'] == null ||
              (json['your_order_ready'] as String).isEmpty)
          ? EN_LANG_TEXT['your_order_ready']
          : json['your_order_ready'],
      checkGiftCard: (json['check_gift_card'] == null ||
              (json['check_gift_card'] as String).isEmpty)
          ? EN_LANG_TEXT['check_gift_card']
          : json['check_gift_card'],
      hi: (json['hi'] == null || (json['hi'] as String).isEmpty)
          ? EN_LANG_TEXT['hi']
          : json['hi'],
      services:
          (json['services'] == null || (json['services'] as String).isEmpty)
              ? EN_LANG_TEXT['services']
              : json['services'],
      locationPermissionDenied: (json['location_permission_denied'] == null ||
              (json['location_permission_denied'] as String).isEmpty)
          ? EN_LANG_TEXT['location_permission_denied']
          : json['location_permission_denied'],
      pleaseTurnOnLocation: (json['please_turn_on_location'] == null ||
              (json['please_turn_on_location'] as String).isEmpty)
          ? EN_LANG_TEXT['please_turn_on_location']
          : json['please_turn_on_location'],
      enableLocationService: (json['enable_location_service'] == null ||
              (json['enable_location_service'] as String).isEmpty)
          ? EN_LANG_TEXT['enable_location_service']
          : json['enable_location_service'],
      customerSignature: (json['customer_signature'] == null ||
              (json['customer_signature'] as String).isEmpty)
          ? EN_LANG_TEXT['customer_signature']
          : json['customer_signature'],
      serviceChannel: (json['service_channel'] == null ||
              (json['service_channel'] as String).isEmpty)
          ? EN_LANG_TEXT['service_channel']
          : json['service_channel'],
      serviceStatus: (json['service_status'] == null ||
              (json['service_status'] as String).isEmpty)
          ? EN_LANG_TEXT['service_status']
          : json['service_status'],
      serviceDate: (json['service_date'] == null ||
              (json['service_date'] as String).isEmpty)
          ? EN_LANG_TEXT['service_date']
          : json['service_date'],
      serviceNo:
          (json['service_no'] == null || (json['service_no'] as String).isEmpty)
              ? EN_LANG_TEXT['service_no']
              : json['service_no'],
      serviceType: (json['service_type'] == null ||
              (json['service_type'] as String).isEmpty)
          ? EN_LANG_TEXT['service_type']
          : json['service_type'],
      serviceNumber: (json['service_number'] == null ||
              (json['service_number'] as String).isEmpty)
          ? EN_LANG_TEXT['service_number']
          : json['service_number'],
      totalServices: (json['total_services'] == null ||
              (json['total_services'] as String).isEmpty)
          ? EN_LANG_TEXT['total_services']
          : json['total_services'],
      printService: (json['print_service'] == null ||
              (json['print_service'] as String).isEmpty)
          ? EN_LANG_TEXT['print_service']
          : json['print_service'],
      viewService: (json['view_service'] == null ||
              (json['view_service'] as String).isEmpty)
          ? EN_LANG_TEXT['view_service']
          : json['view_service'],
      newServices: (json['new_services'] == null ||
              (json['new_services'] as String).isEmpty)
          ? EN_LANG_TEXT['new_services']
          : json['new_services'],
      goToKitchen: (json['go_to_kitchen'] == null ||
              (json['go_to_kitchen'] as String).isEmpty)
          ? EN_LANG_TEXT['go_to_kitchen']
          : json['go_to_kitchen'],
      minPurchaseQty: (json['min_purchase_qty'] == null ||
              (json['min_purchase_qty'] as String).isEmpty)
          ? EN_LANG_TEXT['min_purchase_qty']
          : json['min_purchase_qty'],
      recommendedServices: (json['recommended_services'] == null ||
              (json['recommended_services'] as String).isEmpty)
          ? EN_LANG_TEXT['recommended_services']
          : json['recommended_services'],
      merchantCopyWithSignature:
          (json['merchant_copy_with_signature'] == null ||
                  (json['merchant_copy_with_signature'] as String).isEmpty)
              ? EN_LANG_TEXT['merchant_copy_with_signature']
              : json['merchant_copy_with_signature'],
      merchantCopy: (json['merchant_copy'] == null ||
              (json['merchant_copy'] as String).isEmpty)
          ? EN_LANG_TEXT['merchant_copy']
          : json['merchant_copy'],
      customerCopy: (json['customer_copy'] == null ||
              (json['customer_copy'] as String).isEmpty)
          ? EN_LANG_TEXT['customer_copy']
          : json['customer_copy'],
      receiptType: (json['receipt_type'] == null ||
              (json['receipt_type'] as String).isEmpty)
          ? EN_LANG_TEXT['receipt_type']
          : json['receipt_type'],
      duplicateReceipt: (json['duplicate_receipt'] == null ||
              (json['duplicate_receipt'] as String).isEmpty)
          ? EN_LANG_TEXT['duplicate_receipt']
          : json['duplicate_receipt'],
      lastTransactionReceipt: (json['last_transaction_receipt'] == null ||
              (json['last_transaction_receipt'] as String).isEmpty)
          ? EN_LANG_TEXT['last_transaction_receipt']
          : json['last_transaction_receipt'],
      receiptPrinting: (json['receipt_printing'] == null ||
              (json['receipt_printing'] as String).isEmpty)
          ? EN_LANG_TEXT['receipt_printing']
          : json['receipt_printing'],
      channelsPrice: (json['channels_price'] == null ||
              (json['channels_price'] as String).isEmpty)
          ? EN_LANG_TEXT['channels_price']
          : json['channels_price'],
      runningStock: (json['running_stock'] == null ||
              (json['running_stock'] as String).isEmpty)
          ? EN_LANG_TEXT['running_stock']
          : json['running_stock'],
      invalidInput: (json['invalid_input'] == null ||
              (json['invalid_input'] as String).isEmpty)
          ? EN_LANG_TEXT['invalid_input']
          : json['invalid_input'],
      assignedStaffs: (json['assigned_staffs'] == null ||
              (json['assigned_staffs'] as String).isEmpty)
          ? EN_LANG_TEXT['assigned_staffs']
          : json['assigned_staffs'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (ln != null) data.addAll({"ln_1": ln});
    data['header_title'] = headerTitle;
    data['arrange_table'] = arrangeTable;
    data['table_location'] = tableLocation;
    data['choose_table'] = chooseTable;
    data['clear_tables'] = clearTables;
    data['add'] = add;
    data['update'] = update;
    data['tables'] = tables;
    data['enable_2fa_auth'] = enable2faAuth;
    data['2fa_auth_title_1'] = s2faAuthTitle1;
    data['2fa_auth_title_2'] = s2faAuthTitle2;
    data['2fa_auth_title_3'] = s2faAuthTitle3;
    data['enter_6digit'] = enter6digit;
    data['validate'] = validate;
    data['cancel'] = cancel;
    data['send_otp'] = sendOtp;
    data['google_2fa_ver'] = google2faVer;
    data['email_ver'] = emailVer;
    data['phone_ver'] = phoneVer;
    data['back'] = back;
    data['enter_email'] = enterEmail;
    data['otp_sent_email'] = otpSentEmail;
    data['coming_soon'] = comingSoon;
    data['welcome_back'] = welcomeBack;
    data['login_ac'] = loginAc;
    data['email'] = email;
    data['password'] = password;
    data['remember_me'] = rememberMe;
    data['forgot_password'] = forgotPassword;
    data['log_in'] = logIn;
    data['orders'] = orders;
    data['search_cat_menu'] = searchCatMenu;
    data['order_type'] = orderType;
    data['add_customer'] = addCustomer;
    data['customer_type'] = customerType;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['receive_mar_mat'] = receiveMarMat;
    data['add_cus'] = addCus;
    data['search_cus'] = searchCus;
    data['eligible_amount'] = eligibleAmount;
    data['edit'] = edit;
    data['cus_name'] = cusName;
    data['paid_amount'] = paidAmount;
    data['tip_amount'] = tipAmount;
    data['total_pay_amt'] = totalPayAmt;
    data['pay_amt'] = payAmt;
    data['pay_now'] = payNow;
    data['search_num'] = searchNum;
    data['send_details'] = sendDetails;
    data['phone'] = phone;
    data['reciever_details'] = recieverDetails;
    data['code'] = code;
    data['discount_amt'] = discountAmt;
    data['gift_amt'] = giftAmt;
    data['payment'] = payment;
    data['discount'] = discount;
    data['public_holiday_sc'] = publicHolidaySc;
    data['credit_card_sc'] = creditCardSc;
    data['items'] = items;
    data['qty'] = qty;
    data['price'] = price;
    data['pay_receipt'] = payReceipt;
    data['send_invoice_de'] = sendInvoiceDe;
    data['from'] = from;
    data['to'] = to;
    data['cc'] = cc;
    data['subject'] = subject;
    data['your_message'] = yourMessage;
    data['email_not_empty'] = emailNotEmpty;
    data['send'] = send;
    data['print_order'] = printOrder;
    data['department'] = department;
    data['printer'] = printer;
    data['un_contrct'] = unContrct;
    data['print'] = print;
    data['download_cmpt'] = downloadCmpt;
    data['do_you_want_open_rcpt'] = doYouWantOpenRcpt;
    data['open'] = open;
    data['order_by'] = orderBy;
    data['table'] = table;
    data['cashier'] = cashier;
    data['date_time'] = dateTime;
    data['tax'] = tax;
    data['tax_invoice'] = taxInvoice;
    data['abn'] = abn;
    data['description'] = description;
    data['sent_t_ktchn'] = sentTKtchn;
    data['place_order'] = placeOrder;
    data['subtotal'] = subtotal;
    data['tax_inc_in_total'] = taxIncInTotal;
    data['total'] = total;
    data['table_number'] = tableNumber;
    data['choose_staffs'] = chooseStaffs;
    data['cash_in_out'] = cashInOut;
    data['cash'] = cash;
    data['please_etr_val'] = pleaseEtrVal;
    data['your_note_here'] = yourNoteHere;
    data['cash_in'] = cashIn;
    data['cash_out'] = cashOut;
    data['pay_history'] = payHistory;
    data['end_of_the_day'] = endOfTheDay;
    data['payment_details'] = paymentDetails;
    data['cash_counter_amount'] = cashCounterAmount;
    data['status'] = status;
    data['receivable_from_door'] = receivableFromDoor;
    data['total_counted'] = totalCounted;
    data['difference'] = difference;
    data['cash_out_in'] = cashOutIn;
    data['finalize_now'] = finalizeNow;
    data['cash_counted_amt'] = cashCountedAmt;
    data['eftpos'] = eftpos;
    data['gift_card_sales'] = giftCardSales;
    data['gift_card_redem'] = giftCardRedem;
    data['float'] = float;
    data['receivable_from_uber'] = receivableFromUber;
    data['gross_sales'] = grossSales;
    data['gst'] = gst;
    data['viods'] = viods;
    data['refunds'] = refunds;
    data['rounding'] = rounding;
    data['training'] = training;
    data['net_sales'] = netSales;
    data['no_of_transaction'] = noOfTransaction;
    data['no_of_item_sold'] = noOfItemSold;
    data['no_of_voids'] = noOfVoids;
    data['no_of_training'] = noOfTraining;
    data['accumulated_sales'] = accumulatedSales;
    data['accumulated_no_of_items'] = accumulatedNoOfItems;
    data['date_n_time'] = dateNTime;
    data['final_report'] = finalReport;
    data['eod_declaration'] = eodDeclaration;
    data['download'] = download;
    data['print_receipt'] = printReceipt;
    data['email_receipt'] = emailReceipt;
    data['date'] = date;
    data['reciept_no'] = recieptNo;
    data['sales_amount'] = salesAmount;
    data['payment_method'] = paymentMethod;
    data['bank'] = bank;
    data['store_and_end_date'] = storeAndEndDate;
    data['receipt_no'] = receiptNo;
    data['product_name'] = productName;
    data['history'] = history;
    data['past_days'] = pastDays;
    data['search_now'] = searchNow;
    data['history_report'] = historyReport;
    data['added'] = added;
    data['set_menu'] = setMenu;
    data['quantity'] = quantity;
    data['add_to_cart'] = addToCart;
    data['categories'] = categories;
    data['frequently_selling_products'] = frequentlySellingProducts;
    data['choose_order_type'] = chooseOrderType;
    data['plz_choose_order_type'] = plzChooseOrderType;
    data['empty_adons'] = emptyAdons;
    data['save'] = save;
    data['product_lists'] = productLists;
    data['products'] = products;
    data['delete'] = delete;
    data['variations'] = variations;
    data['default_text'] = defaultText;
    data['calories'] = calories;
    data['stock'] = stock;
    data['min_stock_alert'] = minStockAlert;
    data['max_stock_alert'] = maxStockAlert;
    data['recently_added_products'] = recentlyAddedProducts;
    data['add_new_products'] = addNewProducts;
    data['update_product'] = updateProduct;
    data['recently_added_product'] = recentlyAddedProduct;
    data['featured_product'] = featuredProduct;
    data['create_set_menu'] = createSetMenu;
    data['product_description'] = productDescription;
    data['category'] = category;
    data['choose_category'] = chooseCategory;
    data['brand'] = brand;
    data['choose_brand'] = chooseBrand;
    data['tax_inc_excl'] = taxIncExcl;
    data['choose_tax_type'] = chooseTaxType;
    data['product_code'] = productCode;
    data['add_product_image'] = addProductImage;
    data['already_listed_on_adons'] = alreadyListedOnAdons;
    data['main_prod_cant_listed'] = mainProdCantListed;
    data['add_product'] = addProduct;
    data['search_set_menu'] = searchSetMenu;
    data['set_menu_small'] = setMenuSmall;
    data['no_image'] = noImage;
    data['our_set_menu'] = ourSetMenu;
    data['add_description'] = addDescription;
    data['no_products'] = noProducts;
    data['all_set_menu'] = allSetMenu;
    data['update_set_menu'] = updateSetMenu;
    data['name_of_set_menu'] = nameOfSetMenu;
    data['tax_type'] = taxType;
    data['add_set_menu_image'] = addSetMenuImage;
    data['creat_new_layout'] = creatNewLayout;
    data['round_table'] = roundTable;
    data['table_booking'] = tableBooking;
    data['change_password'] = changePassword;
    data['old_password'] = oldPassword;
    data['new_password'] = newPassword;
    data['confirm_new_password'] = confirmNewPassword;
    data['add_new_brand'] = addNewBrand;
    data['active'] = active;
    data['in_active'] = inActive;
    data['add_new_category'] = addNewCategory;
    data['categories_small'] = categoriesSmall;
    data['is_pos_order_type'] = isPosOrderType;
    data['is_online_order_type'] = isOnlineOrderType;
    data['save_n_add_another'] = saveNAddAnother;
    data['add_new_order_type'] = addNewOrderType;
    data['order_types'] = orderTypes;
    data['default_images'] = defaultImages;
    data['search_menu_images'] = searchMenuImages;
    data['confirm'] = confirm;
    data['add_new_table'] = addNewTable;
    data['table_loc_empty'] = tableLocEmpty;
    data['choose_table_loc'] = chooseTableLoc;
    data['add_image'] = addImage;
    data['table_numbers'] = tableNumbers;
    data['add_new_loc'] = addNewLoc;
    data['table_locations'] = tableLocations;
    data['add_tax'] = addTax;
    data['tax_types'] = taxTypes;
    data['general_settings'] = generalSettings;
    data['table_no'] = tableNo;
    data['choose_table_no'] = chooseTableNo;
    data['add_new_department'] = addNewDepartment;
    data['add_printer_location'] = addPrinterLocation;
    data['choose_department'] = chooseDepartment;
    data['printer_locations'] = printerLocations;
    data['pos_printer_settings'] = posPrinterSettings;
    data['printer_location'] = printerLocation;
    data['distance_type'] = distanceType;
    data['distance_from'] = distanceFrom;
    data['distance_to'] = distanceTo;
    data['amount'] = amount;
    data['store_name'] = storeName;
    data['abn_num'] = abnNum;
    data['store_image'] = storeImage;
    data['url'] = url;
    data['language'] = language;
    data['holiday_sur_percent'] = holidaySurPercent;
    data['invalid_number'] = invalidNumber;
    data['franchise'] = franchise;
    data['template'] = template;
    data['business_type'] = businessType;
    data['store_type'] = storeType;
    data['country'] = country;
    data['city'] = city;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['timezone'] = timezone;
    data['pick_up_hours'] = pickUpHours;
    data['delivery_hours'] = deliveryHours;
    data['day'] = day;
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    data['is_closed'] = isClosed;
    data['max_claim_amt'] = maxClaimAmt;
    data['max_claim_points'] = maxClaimPoints;
    data['amt_from'] = amtFrom;
    data['amt_to'] = amtTo;
    data['points'] = points;
    data['general'] = general;
    data['loyalty'] = loyalty;
    data['delivery_distance'] = deliveryDistance;
    data['opening_hours'] = openingHours;
    data['store_settings'] = storeSettings;
    data['settings'] = settings;
    data['table_layout'] = tableLayout;
    data['where_you_can_sync'] = whereYouCanSync;
    data['sync_from'] = syncFrom;
    data['sync_to'] = syncTo;
    data['sync_now'] = syncNow;
    data['view_order'] = viewOrder;
    data['move_order'] = moveOrder;
    data['accept_order'] = acceptOrder;
    data['reject_order'] = rejectOrder;
    data['order_number'] = orderNumber;
    data['order_date'] = orderDate;
    data['table_name'] = tableName;
    data['order_channel'] = orderChannel;
    data['total_amount'] = totalAmount;
    data['add_to_basket'] = addToBasket;
    data['select_varience'] = selectVarience;
    data['select_size'] = selectSize;
    data['select_adons'] = selectAdons;
    data['logout'] = logout;
    data['sure_to_logout'] = sureToLogout;
    data['log_out'] = logOut;
    data['splash_screen'] = splashScreen;
    data['error'] = error;
    data['unsupported_image'] = unsupportedImage;
    data['field_must_not_be_empty'] = fieldMustNotBeEmpty;
    data['want_to_delete'] = wantToDelete;
    data['of'] = of;
    data['password_not_empty'] = passwordNotEmpty;
    data['password_must_contain'] = passwordMustContain;
    data['password_must_atleast'] = passwordMustAtleast;
    data['password_does_nt_match'] = passwordDoesNtMatch;
    data['invalid_email'] = invalidEmail;
    data['regular'] = regular;
    data['tax_type_is_empty'] = taxTypeIsEmpty;
    data['adult'] = adult;
    data['child'] = child;
    data['adult_capacity'] = adultCapacity;
    data['child_capacity'] = childCapacity;
    data['sort'] = sort;
    data['is_active'] = isActive;
    data['brand_name'] = brandName;
    data['invalid_sort_number'] = invalidSortNumber;
    data['category_name'] = categoryName;
    data['tax_name'] = taxName;
    data['value'] = value;
    data['action'] = action;
    data['port'] = port;
    data['ip_address'] = ipAddress;
    data['some_field_is_empty'] = someFieldIsEmpty;
    data['sync_from_is_not_selected'] = syncFromIsNotSelected;
    data['sync_to_is_not_selected'] = syncToIsNotSelected;
    data['no_internet_connection'] = noInternetConnection;
    data['invalid_response_format'] = invalidResponseFormat;
    data['categories_are_deleted'] = categoriesAreDeleted;
    data['brands_are_deleted'] = brandsAreDeleted;
    data['tables_are_deleted'] = tablesAreDeleted;
    data['something_went_wrong'] = somethingWentWrong;
    data['order_types_are_deleted'] = orderTypesAreDeleted;
    data['tax_are_deleted'] = taxAreDeleted;
    data['setmenu_are_deleted'] = setmenuAreDeleted;
    data['products_are_deleted'] = productsAreDeleted;
    data['feat_prod_are_deleted'] = featProdAreDeleted;
    data['departments_are_deleted'] = departmentsAreDeleted;
    data['pos_locations_are_deleted'] = posLocationsAreDeleted;
    data['email_is_sent'] = emailIsSent;
    data['success'] = success;
    data['tip'] = tip;
    data['share'] = share;
    data['menu'] = menu;
    data['products_tab'] = productsTab;
    data['sync'] = sync;
    data['payment_with'] = paymentWith;
    data['time'] = time;
    data['notes'] = notes;
    data['total_amount_taken'] = totalAmountTaken;
    data['pay_amount'] = payAmount;
    data['booking'] = booking;
    data['no_of_cus'] = noOfCus;
    data['date_time_from'] = dateTimeFrom;
    data['date_time_to'] = dateTimeTo;
    data['book_now'] = bookNow;
    data['cus_list'] = cusList;
    data['search'] = search;
    data['choose_date'] = chooseDate;
    data['channel'] = channel;
    data['are_you_sure_cancel'] = areYouSureCancel;
    data['are_you_sure_ok'] = areYouSureOk;
    data['yes'] = yes;
    data['no'] = no;
    data['reserve_no'] = reserveNo;
    data['cus_user_u'] = cusUserU;
    data['na'] = na;
    data['order_detail_u'] = orderDetailU;
    data['order_no'] = orderNo;
    data['order_type_u'] = orderTypeU;
    data['order_status'] = orderStatus;
    data['delivery_add'] = deliveryAdd;
    data['amount_details'] = amountDetails;
    data['sub_total'] = subTotal;
    data['tax_amount'] = taxAmount;
    data['product_w_price_d'] = productWPriceD;
    data['setmenu_w_p_d'] = setmenuWPD;
    data['trans_status'] = transStatus;
    data['holi_surge_amt'] = holiSurgeAmt;
    data['cc_surge_amt'] = ccSurgeAmt;
    data['no_data_found'] = noDataFound;
    data['cancel_order'] = cancelOrder;
    data['aystc_order'] = aystcOrder;
    data['pay'] = pay;
    data['notifi_set'] = notifiSet;
    data['tax_type_u'] = taxTypeU;
    data['date_format'] = dateFormat;
    data['product_out_of_stock'] = productOutOfStock;
    data['sort_no'] = sortNo;
    data['pos_order_type'] = posOrderType;
    data['online_order_type'] = onlineOrderType;
    data['allergens'] = allergens;
    data['loading'] = loading;
    data['pay_method_setting'] = payMethodSetting;
    data['key'] = key;
    data['secret_key'] = secretKey;
    data['gen_qr'] = genQr;
    data['view_qr'] = viewQr;
    data['table_qr'] = tableQr;
    data['bill_and_subs'] = billAndSubs;
    data['add_new_card'] = addNewCard;
    data['name_on_card'] = nameOnCard;
    data['enter_name_card'] = enterNameCard;
    data['email_address'] = emailAddress;
    data['enter_the_email'] = enterTheEmail;
    data['powered_by-stripe'] = poweredByStripe;
    data['agree_terms_on_billing'] = agreeTermsOnBilling;
    data['save_and_use'] = saveAndUse;
    data['biiling_address'] = biilingAddress;
    data['state'] = state;
    data['street'] = street;
    data['postal_code'] = postalCode;
    data['np_of_pos'] = npOfPos;
    data['expiry_date'] = expiryDate;
    data['expiry_date_card'] = expiryDateCard;
    data['cvv'] = cvv;
    data['security_code'] = securityCode;
    data['card_num'] = cardNum;
    data['card_num_sub'] = cardNumSub;
    data['per_mon_loc'] = perMonLoc;
    data['includes'] = includes;
    data['integrate_posapt'] = integratePosapt;
    data['buy_now'] = buyNow;
    data['trial_expired'] = trialExpired;
    data['choose_plan_that_fits'] = choosePlanThatFits;
    data['user_management'] = userManagement;
    data['add_user'] = addUser;
    data['user_type'] = userType;
    data['fullname'] = fullname;
    data['full_name'] = fullName;
    data['zipcode'] = zipcode;
    data['session_expired'] = sessionExpired;
    data['personal_info'] = personalInfo;
    data['pass_and_sec'] = passAndSec;
    data['last_up_on'] = lastUpOn;
    data['en_2fa_acc_ready_text'] = en2FaAccReadyText;
    data['enable_2fa'] = enable2Fa;
    data['edit_profile'] = editProfile;
    data['push_noti'] = pushNoti;
    data['profile_acc_ready_text'] = profileAccReadyText;
    data['device_not_active'] = deviceNotActive;
    data['active_pos'] = activePos;
    data['enter_active_key'] = enterActiveKey;
    data['active_key'] = activeKey;
    data['activating_key'] = activatingKey;
    data['activate_now'] = activateNow;
    data['choose_plan'] = choosePlan;
    data['choose_ur_plan'] = chooseUrPlan;
    data['change_plan'] = changePlan;
    data['wish_to_change_plan'] = wishToChangePlan;
    data['per_mem_mon'] = perMemMon;
    data['my_subs'] = mySubs;
    data['visa'] = visa;
    data['card_type'] = cardType;
    data['add_new_cart'] = addNewCart;
    data['registered_cards'] = registeredCards;
    data['all_users'] = allUsers;
    data['users'] = users;
    data['search_user'] = searchUser;
    data['device_name_loc'] = deviceNameLoc;
    data['notification'] = notification;
    data['integration'] = integration;
    data['integration_sub_text'] = integrationSubText;
    data['get_started'] = getStarted;
    data['client_id'] = clientId;
    data['enter_client_id'] = enterClientId;
    data['client_secret'] = clientSecret;
    data['en_client_sec'] = enClientSec;
    data['connect'] = connect;
    data['chart_ac_map'] = chartAcMap;
    data['contact_setting'] = contactSetting;
    data['product_macros'] = productMacros;
    data['sort_order'] = sortOrder;
    data['device_activated'] = deviceActivated;
    data['profile'] = profile;
    data['bills_n_subs'] = billsNSubs;
    data['all_orders'] = allOrders;
    data['new_orders'] = newOrders;
    data['new_booking'] = newBooking;
    data['product_deactivated'] = productDeactivated;
    data['activate'] = activate;
    data['deactivate'] = deactivate;
    data['wanna_deactivate'] = wannaDeactivate;
    data['print_kitchen'] = printKitchen;
    data['eod'] = eod;
    data['short_t_cash_flow'] = shortTCashFlow;
    data['pay_bills_install'] = payBillsInstall;
    data['apply_now'] = applyNow;
    data['book_appoint'] = bookAppoint;
    data['fast_track'] = fastTrack;
    data['save_time'] = saveTime;
    data['take_press_off'] = takePressOff;
    data['better_sup_buy'] = betterSupBuy;
    data['partner_with'] = partnerWith;
    data['luca_des'] = lucaDes;
    data['thank_you'] = thankYou;
    data['form_sent'] = formSent;
    data['go_back_from_luca'] = goBackFromLuca;
    data['fill_details_luca'] = fillDetailsLuca;
    data['contact_person'] = contactPerson;
    data['contact_num'] = contactNum;
    data['bus_email_add'] = busEmailAdd;
    data['acc_soft'] = accSoft;
    data['clear_form'] = clearForm;
    data['submit'] = submit;
    data['refresh'] = refresh;
    data['available'] = available;
    data['printer_not_found'] = printerNotFound;
    data['printer_is_connected'] = printerIsConnected;
    data['printer_not_connected'] = printerNotConnected;
    data['accept_terms'] = acceptTerms;
    data['store_channel'] = storeChannel;
    data['choose_channel'] = chooseChannel;
    data['cat_type_deleted'] = catTypeDeleted;
    data['cat_type'] = catType;
    data['choose_cat_type'] = chooseCatType;
    data['sn'] = sn;
    data['supplier'] = supplier;
    data['choose_supplier'] = chooseSupplier;
    data['product_varients'] = productVarients;
    data['product_status'] = productStatus;
    data['unit_price'] = unitPrice;
    data['search_product'] = searchProduct;
    data['update_price'] = updatePrice;
    data['varient_deleted'] = varientDeleted;
    data['sure_to_delete'] = sureToDelete;
    data['varient'] = varient;
    data['pos_printer'] = posPrinter;
    data['set_menu_kit'] = setMenuKit;
    data['print_invoice'] = printInvoice;
    data['paper_size'] = paperSize;
    data['or_print_auto'] = orPrintAuto;
    data['auto_invoice_print'] = autoInvoicePrint;
    data['view'] = view;
    data['set_menu_status'] = setMenuStatus;
    data['printing'] = printing;
    data['general_set_subtitle'] = generalSetSubtitle;
    data['pos_device_set'] = posDeviceSet;
    data['pos_device_set_subtitle'] = posDeviceSetSubtitle;
    data['store_set_subtitle'] = storeSetSubtitle;
    data['notify_set_subtitle'] = notifySetSubtitle;
    data['pay_method_set_subtitle'] = payMethodSetSubtitle;
    data['user_manage_set_subtitle'] = userManageSetSubtitle;
    data['change_all'] = changeAll;
    data['no_items_selected'] = noItemsSelected;
    data['remove_from_cart'] = removeFromCart;
    data['pay_invoice'] = payInvoice;
    data['no_orders_placed'] = noOrdersPlaced;
    data['new_order'] = newOrder;
    data['no_book_found'] = noBookFound;
    data['invalid_otp'] = invalidOtp;
    data['clear'] = clear;
    data['send_email'] = sendEmail;
    data['copy_clipboard'] = copyClipboard;
    data['holiday_charge_amt'] = holidayChargeAmt;
    data['credit_surcharge_amt'] = creditSurchargeAmt;
    data['subs_now'] = subsNow;
    data['no_item_found'] = noItemFound;
    data['no_product_added'] = noProductAdded;
    data['start_end_date'] = startEndDate;
    data['no_history_report'] = noHistoryReport;
    data['select_table'] = selectTable;
    data['tax_invoice_info_empty'] = taxInvoiceInfoEmpty;
    data['dashboard'] = dashboard;
    data['print_recpt_kit'] = printRecptKit;
    data['server'] = server;
    data['customer'] = customer;
    data['set_menu_items'] = setMenuItems;
    data['credit_card_surcharge'] = creditCardSurcharge;
    data['pos_printer_setup'] = posPrinterSetup;
    data['pos'] = pos;
    data['please_try_again'] = pleaseTryAgain;
    data['user_role'] = userRole;
    data['pos_device'] = posDevice;
    data['device_name'] = deviceName;
    data['plan_subscribed'] = planSubscribed;
    data['pos_devices'] = posDevices;
    data['two_fa_up'] = twoFaUp;
    data['no_set_menu_found'] = noSetMenuFound;
    data['please_se_plan'] = pleaseSePlan;
    data['use_this_device'] = useThisDevice;
    data['is_open'] = isOpen;
    data['exit'] = exit;
    data['sure_to_exit'] = sureToExit;
    data['discount_higher'] = discountHigher;
    data['included'] = included;
    data['send_to_kit'] = sendToKit;
    data['update_order'] = updateOrder;
    data['copied_to_clip'] = copiedToClip;
    data['store_url'] = storeUrl;
    data['web_url'] = webUrl;
    data['deli_amt'] = deliAmt;
    data['remain_amt'] = remainAmt;
    data['add_photo'] = addPhoto;
    data['take_camera'] = takeCamera;
    data['take_gallery'] = takeGallery;
    data['invalid_dis_char'] = invalidDisChar;
    data['invalid_amt'] = invalidAmt;
    data['amt_extsive'] = amtExtsive;
    data['payable_amt'] = payableAmt;
    data['pic_deli_date'] = picDeliDate;
    data['refund_order'] = refundOrder;
    data['sure_to_refund'] = sureToRefund;
    data['reset_your_pass'] = resetYourPass;
    data['reset_pass_subtitle'] = resetPassSubtitle;
    data['reset_my_pass'] = resetMyPass;
    data['select_num_items_variants'] = selectNumItemsVariants;
    data['product_variants'] = productVariants;
    data['addons'] = addons;
    data['redeem_code'] = redeemCode;
    data['2fa_auth_email_title'] = the2FaAuthEmailTitle;
    data['type'] = type;
    data['total_cash_in'] = totalCashIn;
    data['total_cash_out'] = totalCashOut;
    data['loyalty_point'] = loyaltyPoint;
    data['eligible_loyal_point'] = eligibleLoyalPoint;
    data['enable_loyal'] = enableLoyal;
    data['table_book_resv'] = tableBookResv;
    data['no_cash_in_out'] = noCashInOut;
    data['recent_add_prods'] = recentAddProds;
    data['create_set_menu_com'] = createSetMenuCom;
    data['prod_variants'] = prodVariants;
    data['variant'] = variant;
    data['update_set_menu_com'] = updateSetMenuCom;
    data['set_menu_combo'] = setMenuCombo;
    data['select_items_set_menu'] = selectItemsSetMenu;
    data['notifications'] = notifications;
    data['select_num_of_items'] = selectNumOfItems;
    data['refund_pay'] = refundPay;
    data['field_empty'] = fieldEmpty;
    data['canceled'] = canceled;
    data['term_of_service'] = termOfService;
    data['dont_have_acc'] = dontHaveAcc;
    data['signup'] = signup;
    data['register_now'] = registerNow;
    data['send_veri_title'] = sendVeriTitle;
    data['resend_otp'] = resendOtp;
    data['veri_code'] = veriCode;
    data['register'] = register;
    data['refund'] = refund;
    data['deliver_order'] = deliverOrder;
    data['order_deli'] = orderDeli;
    data['sure_to_order_deli'] = sureToOrderDeli;
    data['order_status_not_choosen'] = orderStatusNotChoosen;
    data['remove_photo'] = removePhoto;
    data['per'] = per;
    data['device'] = device;
    data['devices'] = devices;
    data['add_new_org'] = addNewOrg;
    data['add_ur_org'] = addUrOrg;
    data['business_name'] = businessName;
    data['business_phone'] = businessPhone;
    data['business_email'] = businessEmail;
    data['choose_platform'] = choosePlatform;
    data['calculate_eod'] = calculateEod;
    data['choose_sub_cat'] = chooseSubCat;
    data['sub_category'] = subCategory;
    data['sub_cats_deleted'] = subCatsDeleted;
    data['sub_cat_name'] = subCatName;
    data['add_new_sub_cat'] = addNewSubCat;
    data['sub_cats'] = subCats;
    data['send_email_and_finalize'] = sendEmailAndFinalize;
    data['pay_with_eod_recon'] = payWithEodRecon;
    data['finalize'] = finalize;
    data['finalize_eod'] = finalizeEod;
    data['otp_code_expired_5_min'] = otpCodeExpired5Min;
    data['pl_auth_to_cont'] = plAuthToCont;
    data['screen_time'] = screenTime;
    data['enable_app_lock'] = enableAppLock;
    data['continue'] = langModelContinue;
    data['process_order'] = processOrder;
    data['table_not_selected'] = tableNotSelected;
    data['eod_on_date'] = eodOnDate;
    data['find_eod_report'] = findEodReport;
    data['choose_order_status'] = chooseOrderStatus;
    data['store_changed_success'] = storeChangedSuccess;
    data['today_sale'] = todaySale;
    data['sales_summary'] = salesSummary;
    data['sales_cat'] = salesCat;
    data['sales_report_by_mon'] = salesReportByMon;
    data['pay_report'] = payReport;
    data['sales_by_channel'] = salesByChannel;
    data['recomm_products'] = recommProducts;
    data['total_sales'] = totalSales;
    data['total_orders'] = totalOrders;
    data['total_refund'] = totalRefund;
    data['total_cus'] = totalCus;
    data['upgrade_plan_from_free_trial'] = upgradePlanFromFreeTrial;
    data['upgrade_now'] = upgradeNow;
    data['pay_method'] = payMethod;
    data['sales'] = sales;
    data['product'] = product;
    data['no_store_selected'] = noStoreSelected;
    data['try_again_after_time'] = tryAgainAfterTime;
    data['point_of_sale'] = pointOfSale;
    data['online_or_sys'] = onlineOrSys;
    data['pos_online_order_sys'] = posOnlineOrderSys;
    data['online_order'] = onlineOrder;
    data['sure_to_up_table_book'] = sureToUpTableBook;
    data['sure_to_book_table'] = sureToBookTable;
    data['sure_to_discard_changes'] = sureToDiscardChanges;
    data['invoice_no'] = invoiceNo;
    data['barcode_type'] = barcodeType;
    data['choose_bar_code'] = chooseBarCode;
    data['show'] = show;
    data['entries'] = entries;
    data['search_prod_cat'] = searchProdCat;
    data['variation_not_avai'] = variationNotAvai;
    data['new_gift_card'] = newGiftCard;
    data['gift_card_list'] = giftCardList;
    data['gift_card'] = giftCard;
    data['gift_card_no'] = giftCardNo;
    data['amt_on_gift'] = amtOnGift;
    data['sender_details'] = senderDetails;
    data['message'] = message;
    data['your_msg_here'] = yourMsgHere;
    data['receiver_details'] = receiverDetails;
    data['sender_name'] = senderName;
    data['receiver_name'] = receiverName;
    data['pur_date'] = purDate;
    data['choose_gift'] = chooseGift;
    data['retail_store'] = retailStore;
    data['no_gift_found'] = noGiftFound;
    data['redeem_history'] = redeemHistory;
    data['redeem_by'] = redeemBy;
    data['redeem_amt'] = redeemAmt;
    data['redeem_date'] = redeemDate;
    data['no_record'] = noRecord;
    data['bar_code_type'] = barCodeType;
    data['pay_amt_higher_gift'] = payAmtHigherGift;
    data['thank_pur'] = thankPur;
    data['voucher_redeem_code'] = voucherRedeemCode;
    data['gift_redeem_code'] = giftRedeemCode;
    data['choose_gift_card'] = chooseGiftCard;
    data['monthly_subs'] = monthlySubs;
    data['commission'] = commission;
    data['price_charged_sales'] = priceChargedSales;
    data['barcode_types'] = barcodeTypes;
    data['searching'] = searching;
    data['please_choose_gift'] = pleaseChooseGift;
    data['dear'] = dear;
    data['thanks_for_choosing'] = thanksForChoosing;
    data['email_text_1'] = emailText1;
    data['email_text_2'] = emailText2;
    data['best_regards'] = bestRegards;
    data['refund_amt'] = refundAmt;
    data['barcode_gen'] = barcodeGen;
    data["generate"] = generate;
    data['print_barcode'] = printBarcode;
    data['generate_barcode'] = generateBarcode;
    data['invalid_barcode_img'] = invalidBarcodeImg;
    data['num_of_barcode'] = numOfBarcode;
    data['upload_image'] = uploadImage;
    data['search_printer'] = searchPrinter;
    data['slug'] = slug;
    data['filter_types'] = filterTypes;
    data['icon'] = icon;
    data['identifier'] = identifier;
    data['select_all'] = selectAll;
    data['custom_desc'] = customDesc;
    data['label_name'] = labelName;
    data['enable_retail_screen'] = enableRetailScreen;
    data['prom_offer_discount_percent'] = promOfferDiscountPercent;
    data['discount_percent'] = discountPercent;
    data['prom_offer_thres'] = promOfferThres;
    data['prom_image'] = promImage;
    data['commission_based_subs_plan'] = commissionBasedSubsPlan;
    data['num_of_pos_location'] = numOfPosLocation;
    data['monthly_subs_plan'] = monthlySubsPlan;
    data['are_u_sure_u_want_to_change_pay_meth_to'] =
        areUSureUWantToChangePayMethTo;
    data['change_pay_method'] = changePayMethod;
    data['send_device_id'] = sendDeviceId;
    data['email_success'] = emailSuccess;
    data['see_notifications'] = seeNotifications;
    data['recent_notifications'] = recentNotifications;
    data['mark_read'] = markRead;
    data['device_is_activated'] = deviceIsActivated;
    data['amount_returned'] = amountReturned;
    data['amount_paid'] = amountPaid;
    data['insufficient_amount'] = insufficientAmount;
    data['sure_refund'] = sureRefund;
    data['receipt'] = receipt;
    data['cc_charge_may_apply'] = ccChargeMayApply;
    data['discount_may_apply'] = discountMayApply;
    data['eftpos_mer_pay'] = eftposMerPay;
    data['eftpos_mer_pay_pro'] = eftposMerPayPro;
    data['mer_pay'] = merPay;
    data['mer_pay_pro'] = merPayPro;
    data['serial_no'] = serialNo;
    data['eftpos_ter_dev'] = eftposTerDev;
    data['eftpos_mer'] = eftposMer;
    data['choose_eftpos'] = chooseEftpos;
    data['eftpos_mer_pro'] = eftposMerPro;
    data['eftpos_dev_deleted'] = eftposDevDeleted;
    data['choose_eftpos_ter_dev'] = chooseEftposTerDev;
    data['sure_to_delete_all_items'] = sureToDeleteAllItems;
    data['can_not_revert_back'] = canNotRevertBack;
    data["no_product_avai"] = noProductAvai;
    data["no_barcode_avai"] = noBarcodeAvai;
    data["accept_all"] = acceptAll;
    data["pair"] = pair;
    data["pos_name"] = posName;
    data["payment_provider"] = paymentProvider;
    data["enable_price"] = enablePrice;
    data["price_range"] = priceRange;
    data["today_sale_sum"] = todaySaleSum;
    data["choose_merchant_pro"] = chooseMerchantPro;
    data["gift_card_img"] = giftCardImg;
    data["no_img_found"] = noImgFound;
    data["create_new"] = createNew;
    data["remove_img"] = removeImg;
    data["gift_cards"] = giftCards;
    data["plz_select_gift_card"] = plzSelectGiftCard;
    data["print_not_avai"] = printNotAvai;
    data["display_name"] = displayName;
    data["payment_receipt"] = paymentReceipt;
    data["total_qty"] = totalQty;
    data["refund_qty"] = refundQty;
    data["invalid_card_surcharge_per"] = invalidCardSurchargePer;
    data["print_refund_receipt"] = printRefundReceipt;
    data["refund_invoice"] = refundInvoice;
    data["refund_receipt"] = refundReceipt;
    data["refund_amount"] = refundAmount;
    data["refund_amt_detail"] = refundAmtDetail;
    data["refund_prod_price"] = refundProdPrice;
    data["refund_combo_price"] = refundComboPrice;
    data["cc_num_empty"] = ccNumEmpty;
    data["invalid_cc_len"] = invalidCcLen;
    data["invalid_cc"] = invalidCc;
    data["expiry_year"] = expiryYear;
    data["your_card_num"] = yourCardNum;
    data["expiry_month"] = expiryMonth;
    data["change_price"] = changePrice;
    data["ok"] = ok;
    data["hospitality_pricing"] = hospitalityPricing;
    data["retail_pricing"] = retailPricing;

    data["slelect_item_num_refund"] = slelectItemNumRefund;
    data["update_before_pay"] = updateBeforePay;
    data["complete_prev_pay_to_next_pay"] = completePrevPayToNextPay;
    data["sure_update_order"] = sureUpdateOrder;
    data["dis_cant_applied"] = disCantApplied;
    data["modifier"] = modifier;
    data["track_number"] = trackNumber;
    data["search_ft_product"] = searchFtProduct;
    data["already_exists"] = alreadyExists;
    data["layout"] = layout;
    data["rotate_table"] = rotateTable;
    data["resize_table"] = resizeTable;
    data["create_layout_for"] = createLayoutFor;
    data["create"] = create;
    data["selected"] = selected;
    data["floor_plan"] = floorPlan;
    data["no_floor_setup"] = noFloorSetup;
    data["reservation_list"] = reservationList;
    data["tap_move_table_space"] = tapMoveTableSpace;
    data["make_free"] = makeFree;
    data["place_new_order"] = placeNewOrder;
    data["reseravtion_type"] = reseravtionType;
    data["reserved_in"] = reservedIn;
    data["table_available"] = tableAvailable;
    ////
    data["view_layout"] = viewLayout;
    data["create_layout"] = createLayout;
    data["hours"] = hours;
    data["hour"] = hour;
    data["minutes"] = minutes;
    data["minute"] = minute;
    data["reserve"] = reserve;
    data["occupy"] = occupy;
    data["table_occupation"] = tableOccupation;
    data["wanna_occupy_table"] = wannaOccupyTable;
    data["make_table_free"] = makeTableFree;
    data["wanna_table_free"] = wannaTableFree;
    data["checkout"] = checkout;
    data["print_merchant"] = printMerchant;
    data["purchase_receipt"] = purchaseReceipt;
    data["sales_tax"] = salesTax;
    data["purchase_tax"] = purchaseTax;
    data["comments"] = comments;
    data["channel_type"] = channelType;
    data["stay_signed_in"] = staySignedIn;
    data["no_product_found"] = noProductFound;
    data["will_auto_logout_devices"] = willAutoLogoutDevices;
    data["confirm_logout_device_check_signin"] = confirmLogoutDeviceCheckSignin;
    data["eod_cas_pay"] = eodCasPay;
    data["calculated_cash"] = calculatedCash;
    data["template_category"] = templateCategory;
    data["other_settings"] = otherSettings;
    data["update_order_channel"] = updateOrderChannel;
    data["table_qr_order_channel"] = tableQrOrderChannel;
    data["show_reserve_table"] = showReserveTable;
    data["show_footer"] = showFooter;
    data["show_payment_pickup"] = showPaymentPickup;
    data["show_payment_dine"] = showPaymentDine;
    data["show_payment_delivery"] = showPaymentDelivery;
    data["live_payment_mode"] = livePaymentMode;
    data["barcode"] = barcode;
    data["show_table"] = showTable;
    data["enable_under_maintain"] = enableUnderMaintain;
    data["is_retail_screen"] = isRetailScreen;
    data["enable_order_gift_form"] = enableOrderGiftForm;
    data["enable_copyright_footer"] = enableCopyrightFooter;
    data["enable_footer"] = enableFooter;
    data["enable_guest_checkout"] = enableGuestCheckout;
    data["hospitality_online"] = hospitalityOnline;
    data["retail_online"] = retailOnline;
    data["business_type_category"] = businessTypeCategory;
    data["spice_choices"] = spiceChoices;
    data["add_cart_success"] = addCartSuccess;
    data["print_refund_invoice"] = printRefundInvoice;
    data["print_eftpos_sign"] = printEftposSign;
    data["other_details"] = otherDetails;
    data["delivery_cannot_for_past"] = deliveryCannotForPast;
    data["delivery_time"] = deliveryTime;
    data["spice"] = spice;
    data["print_merchant_copy"] = printMerchantCopy;
    data["print_customer_copy"] = printCustomerCopy;
    data["view_eftpos_logs"] = viewEftposLogs;
    data["print_eftpos_log"] = printEftposLog;
    data["updated_successfully"] = updatedSuccessfully;

    data["cus_search"] = cusSearch;
    data["order_history"] = orderHistory;
    data["select_cus_order_history"] = selectCusOrderHistory;
    data["number"] = number;
    data["anonymous"] = anonymous;
    data["scan_bluetooth_devices"] = scanBluetoothDevices;
    data["error_scanning_printer"] = errorScanningPrinter;
    data["devices_found"] = devicesFound;
    data["searching_device"] = searchingDevice;
    data["no_device_found"] = noDeviceFound;
    data["is_bluetooth_device"] = isBluetoothDevice;
    data["enable_bluetooth_setting"] = enableBluetoothSetting;
    data["stock_count"] = stockCount;
    data["connection_failed"] = connectionFailed;
    data["business_type_cat"] = businessTypeCat;
    data["spice_choices"] = spiceChoices;
    data["add_cart_success"] = addCartSuccess;
    data["spice"] = spice;
    data["refundable_amt"] = refundableAmt;
    data["print_refund_invoice"] = printRefundInvoice;
    data["print_eft_sign"] = printEftSign;
    data["print_merchant_copy"] = printMerchantCopy;
    data["print_cus_copy"] = printCusCopy;
    data["view_eft_logs"] = viewEftLogs;
    data["print_eft_logs"] = printEftLogs;
    data["eft_logs"] = eftLogs;
    data["other_details"] = otherDetails;
    data["delivery_cant_made_past"] = deliveryCantMadePast;
    data["delivery_time"] = deliveryTime;
    data["all_item_refund"] = allItemRefund;
    data["en_copy_foot_des"] = enCopyFootDes;
    data["adult_cap"] = adultCap;
    data["en_doc_group_spliter"] = enDocGroupSpliter;
    data["doc_group"] = docGroup;
    data["choose_doc_group"] = chooseDocGroup;
    data["cus_copy"] = cusCopy;
    data["order_print_copy"] = orderPrintCopy;
    data["revoke"] = revoke;
    data["served_by"] = servedBy;
    data["pay_process_by"] = payProcessBy;
    data["order_process_by"] = orderProcessBy;
    data["cancel_send_kitchen"] = cancelSendKitchen;
    data["reserv_cant_end_bef_start_date"] = reservCantEndBefStartDate;
    data["no_rcpt_found"] = noRcptFound;
    data["update_success"] = updateSuccess;
    data["invoice_print_cus_copy"] = invoicePrintCusCopy;
    data["view_reserve"] = viewReserve;
    data["order_copy"] = orderCopy;
    data["choose_half_half"] = chooseHalfHalf;
    data["half_item"] = halfItem;
    data["cal_set"] = calSet;
    data["auto_enable"] = autoEnable;
    data["auto_en_holi_sur"] = autoEnHoliSur;
    data["weekend_sur"] = weekendSur;
    data["auto_en_week_sur"] = autoEnWeekSur;
    data["auto_en_cre_sur"] = autoEnCreSur;
    data["mail_server"] = mailServer;
    data["all_products"] = allProducts;
    data["email_setting"] = emailSetting;
    data["sms_setting"] = smsSetting;
    data["from_num"] = fromNum;
    data["en_tls"] = enTls;
    data["en_ssi"] = enSsi;
    data["send_sms"] = sendSms;
    data["printer_type"] = printerType;
    data["choose_print_type"] = choosePrintType;
    data["en_auto_send_kit"] = enAutoSendKit;
    data["en_pay_pair"] = enPayPair;
    data["en_auto_send_kit_display"] = enAutoSendKitDisplay;
    data["total_loyalty_amt"] = totalLoyaltyAmt;
    data["redeem_loyalty"] = redeemLoyalty;
    data["bal_point"] = balPoint;
    data["amt_spent"] = amtSpent;
    data["reward_cus_amt_spent"] = rewardCusAmtSpent;
    data["eve_time_cus_spnt"] = eveTimeCusSpnt;
    data["cus_earn"] = cusEarn;
    data["eod_report"] = eodReport;
    data["eod_report_not_found"] = eodReportNotFound;
    data["z_report"] = zReport;
    data["sales_sum"] = salesSum;
    data["discounts"] = discounts;
    data["gift_sales"] = giftSales;
    data["cr_card_sur"] = crCardSur;
    data["deli_charge"] = deliCharge;
    data["total_tax"] = totalTax;
    data["total_unit_sales"] = totalUnitSales;
    data["sales_channel"] = salesChannel;
    data["unit"] = unit;
    data["total_net_sales"] = totalNetSales;
    data["sales_by_cat"] = salesByCat;
    data["sales_by_cat_type"] = salesByCatType;
    data["pay_methods"] = payMethods;
    data["total_payment"] = totalPayment;
    data["variance"] = variance;
    data["print_eod"] = printEod;
    data["prepared_date"] = preparedDate;
    data["ordered_date"] = orderedDate;
    data["eft_device_pair"] = eftDevicePair;
    data["dual_dis_set"] = dualDisSet;
    data["search_combo_product"] = searchComboProduct;
    data["search_new_ingre"] = searchNewIngre;
    data["select"] = select;
    data["dis_amt_higher"] = disAmtHigher;
    data["selling_price"] = sellingPrice;
    data["dis_price"] = disPrice;
    data["new_selling_price"] = newSellingPrice;
    data["add_product_message"] = addProductMessage;
    data["out_of_stock"] = outOfStock;
    data["usb_not_found"] = usbNotFound;
    data["printer_not_setup"] = printerNotSetup;
    data["np_qr_found"] = npQrFound;
    data["pos_device_qr"] = posDeviceQr;
    data["occasion"] = occasion;
    data["kit_docket"] = kitDocket;
    data["item"] = item;
    data["create_half_half_item"] = createHalfHalfItem;
    data["create_uni_half"] = createUniHalf;
    data["select_item_update"] = selectItemUpdate;
    data["add_item"] = addItem;
    data["up_1st_half"] = up1StHalf;
    data["add_half_succ"] = addHalfSucc;
    data["up_half_succ"] = upHalfSucc;
    data["promt_off_dis"] = promtOffDis;
    data["com_prod"] = comProd;
    data["raw_ingre"] = rawIngre;
    data["enter_name"] = enterName;
    data["enter_msg"] = enterMsg;
    data["point"] = point;
    data["print_eod_sum"] = printEodSum;
    data["in_stock"] = inStock;

    data["order_status_change_succ"] = orderStatusChangeSucc;
    data["up_2nd_half"] = up2NdHalf;
    data["choose_2nd_half"] = choose2NdHalf;
    data['connected'] = connected;
    data['disconnected'] = disconnected;
    data['not_connected'] = notConnected;
    data['our_channels'] = ourChannels;
    data['emp_name'] = empName;
    data['emp_code'] = empCode;
    data['emp_email'] = empEmail;
    data['emp_phone'] = empPhone;
    data['current_date_time'] = currentDateTime;
    data['working_hours'] = workingHours;
    data['punch_out'] = punchOut;
    data['punch_in'] = punchIn;
    data['punching'] = punching;
    data['to_con_dev_loc_acc'] = toConDevLocAcc;
    data['open_loc_set'] = openLocSet;
    data['no_thanks'] = noThanks;
    data['downloading'] = downloading;
    data['downloaded'] = downloaded;
    data['download_failed'] = downloadFailed;
    data['permission_denied'] = permissionDenied;
    data['choose_terminal'] = chooseTerminal;
    data['device_not_connected'] = deviceNotConnected;
    data['initiate_payment'] = initiatePayment;
    data['successfully_connected'] = successfullyConnected;
    data['failed_to_open_port'] = failedToOpenPort;
    data['unexpected_error'] = unexpectedError;
    data['sales_summary_cap'] = salesSummaryCap;
    data['platform_error'] = platformError;
    data['modifiers'] = modifiers;
    data['continue_transaction'] = continueTransaction;
    data['incomplete_transaction_recovery'] = incompleteTransactionRecovery;
    data['retry'] = retry;
    data['dismiss'] = dismiss;
    data['create_reservation'] = createReservation;
    data['recent_incoming_call'] = recentIncomingCall;
    data['line'] = line;
    data['decline'] = decline;
    data['accept'] = accept;
    data['opening_cash_drawer'] = openingCashDrawer;
    data['failed_to_connect'] = failedToConnect;
    data['purchase_cap'] = purchaseCap;
    data['refund_cap'] = refundCap;
    data['retry_cap'] = retryCap;
    data['blue_scan_error'] = blueScanError;
    data['blue_connect_denied'] = blueConnectDenied;
    data['blue_scan_denied'] = blueScanDenied;
    data['z_report_cap'] = zReportCap;
    data['payment_methods'] = paymentMethods;
    data['half'] = half;
    data['no_of_customers'] = noOfCustomers;
    data['remove_ingredients'] = removeIngredients;
    data['half_n_half'] = halfNHalf;
    data['failed_to_get_usb'] = failedToGetUsb;
    data['box'] = box;
    data['add_box'] = addBox;
    data['tap_box_to_add'] = tapBoxToAdd;
    data['dimension_cm'] = dimensionCm;
    data['weight_gram'] = weightGram;
    data['length'] = length;
    data['height'] = height;
    data['depth'] = depth;
    data['choose_items'] = chooseItems;
    data['delivery_driver_pickup'] = deliveryDriverPickup;
    data['pickup_cannot_past'] = pickupCannotPast;
    data['pickup_time_at_least_10'] = pickupTimeAtLeast10;
    data['pickup_time_cannot_after'] = pickupTimeCannotAfter;
    data['pickup_time_cannot_made'] = pickupTimeCannotMade;
    data['delivery_customer'] = deliveryCustomer;
    data['failed_to_get_usb_devices'] = failedToGetUsbDevices;
    data['create_delivery'] = createDelivery;
    data['delivery'] = delivery;
    data['details'] = details;
    data['pick_up_time'] = pickUpTime;
    data['view_details'] = viewDetails;
    data['courier_details'] = courierDetails;
    data['vehicle_type'] = vehicleType;
    data['recipient'] = recipient;
    data['delivery_notes'] = deliveryNotes;
    data['item_details'] = itemDetails;
    data['item_name'] = itemName;
    data['size'] = size;
    data['dimension'] = dimension;
    data['weight'] = weight;
    data['must_be_upright'] = mustBeUpright;
    data['delivery_status'] = deliveryStatus;
    data['total_price'] = totalPrice;
    data['close'] = close;
    data['complete_delivery'] = completeDelivery;
    data['track_delivery'] = trackDelivery;
    data['no_delivery_order_found'] = noDeliveryOrderFound;
    data['give_us_rating'] = giveUsRating;
    data['share_details'] = shareDetails;
    data['enter_emp_code'] = enterEmpCode;
    data['start_unscheduled_shift'] = startUnscheduledShift;
    data['start_shift'] = startShift;
    data['scheduled_breaks'] = scheduledBreaks;
    data['starting_at'] = startingAt;
    data['no_scheduled_shifts'] = noScheduledShifts;
    data['shift_time'] = shiftTime;
    data['early'] = early;
    data['late'] = late;
    data['on_unscheduled_shift'] = onUnscheduledShift;
    data['on_break'] = onBreak;
    data['i_will_be_back'] = iWillBeBack;
    data['do_you_want_confirm_earlier'] = doYouWantConfirmEarlier;
    data['do_you_want_confirm_end_shift'] = doYouWantConfirmEndShift;
    data['early_end_shift'] = earlyEndShift;
    data['end_shift'] = endShift;
    data['end_break'] = endBreak;
    data['please_select_break'] = pleaseSelectBreak;
    data['add_note'] = addNote;
    data['no_breaks_available'] = noBreaksAvailable;
    data['start_break'] = startBreak;
    data['unscheduled'] = unscheduled;
    data['scheduled'] = scheduled;
    data['unpaid'] = unpaid;
    data['paid'] = paid;
    data['select_breaks'] = selectBreaks;
    data['break_taken'] = breakTaken;
    data['end_shift_warning'] = endShiftWarning;
    data['take_break'] = takeBreak;
    data['show_gift_card'] = showGiftCard;
    data['your_gift_card_balance'] = yourGiftCardBalance;
    data['check_balance'] = checkBalance;
    data['gift_card_template'] = giftCardTemplate;
    data['check_gift_card_amount'] = checkGiftCardAmount;
    data['gift_card_enquiry'] = giftCardEnquiry;
    data['gift_card_template_group'] = giftCardTemplateGroup;
    data['all_services'] = allServices;
    data['get_device_info'] = getDeviceInfo;
    data['emergency_email'] = emergencyEmail;
    data['emergency_phone'] = emergencyPhone;
    data['emergency_contact_person'] = emergencyContactPerson;
    data['emergency_contact_name'] = emergencyContactName;
    data['reporting_employees'] = reportingEmployees;
    data['hourly_rate'] = hourlyRate;
    data['annual_salary'] = annualSalary;
    data['gender'] = gender;
    data['preferred_name'] = preferredName;
    data['employee_code'] = employeeCode;
    data['employee_information'] = employeeInformation;
    data['edit_employee'] = editEmployee;
    data['job_title'] = jobTitle;
    data['others'] = others;
    data['female'] = female;
    data['male'] = male;
    data['split_by_items'] = splitByItems;
    data['split_amount'] = splitAmount;
    data['full_amount'] = fullAmount;
    data['your_order_ready'] = yourOrderReady;
    data['check_gift_card'] = checkGiftCard;
    data['hi'] = hi;
    data['services'] = services;
    data['location_permission_denied'] = locationPermissionDenied;
    data['please_turn_on_location'] = pleaseTurnOnLocation;
    data['enable_location_service'] = enableLocationService;
    data['customer_signature'] = customerSignature;
    data['service_channel'] = serviceChannel;
    data['service_status'] = serviceStatus;
    data['service_date'] = serviceDate;
    data['service_no'] = serviceNo;
    data['service_type'] = serviceType;
    data['service_number'] = serviceNumber;
    data['total_services'] = totalServices;
    data['print_service'] = printService;
    data['view_service'] = viewService;
    data['new_services'] = newServices;
    data['go_to_kitchen'] = goToKitchen;
    data['min_purchase_qty'] = minPurchaseQty;
    data['recommended_services'] = recommendedServices;
    data['merchant_copy_with_signature'] = merchantCopyWithSignature;
    data['merchant_copy'] = merchantCopy;
    data['customer_copy'] = customerCopy;
    data['receipt_type'] = receiptType;
    data['duplicate_receipt'] = duplicateReceipt;
    data['last_transaction_receipt'] = lastTransactionReceipt;
    data['receipt_printing'] = receiptPrinting;
    data['channels_price'] = channelsPrice;
    data['running_stock'] = runningStock;
    data['invalid_input'] = invalidInput;
    data['emergency_contact'] = emergencyContact;
    data['home'] = home;
    data['punch_in_out'] = punchInOut;
    data['incoming_call'] = incomingCall;
    data['failed_to_print'] = failedToPrint;
    data['extra'] = extra;
    data["assigned_staffs"] = assignedStaffs;

    //toJson from connected

    // data["failed_to_login_with_code"] = failedToLoginWithCode;
    // data["login_with_email"] = loginWithEmail;
    // data["login_w_code"] = loginWCode;
    // data["enter_4d_code"] = enter4DCode;
    // data["en_unit_price"] = enUnitPrice;
    // data["order_refresh_10"] = orderRefresh10;
    // data["eligible_amt"] = eligibleAmt;
    // data["trans_abort"] = transAbort;
    // data["trans_incom"] = transIncom;
    return data;
  }
}
