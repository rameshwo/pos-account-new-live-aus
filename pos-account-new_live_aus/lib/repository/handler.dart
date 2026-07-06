import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/utils/print_utils.dart';
import 'package:pos_account/env.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/auth/configure_device_req.dart';
import 'package:pos_account/model/auth/opt_send_res.dart';
import 'package:pos_account/model/auth/refresh_token_model.dart';
import 'package:pos_account/model/auth/register_req.dart';
import 'package:pos_account/model/auth/store_detail_res.dart';
import 'package:pos_account/model/auth/user_stores_res.dart';
import 'package:pos_account/model/auth/validate_pin_code_res.dart';
import 'package:pos_account/model/billing_and_subs/all_bill_and_subs.dart';
import 'package:pos_account/model/billing_and_subs/billing_subs_add_sec.dart';
import 'package:pos_account/model/billing_and_subs/billing_subs_plan.dart';
import 'package:pos_account/model/billing_and_subs/subs_and_billing.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/common/setting_res.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/common/view_keys.dart';
import 'package:pos_account/model/home/booking/all_customer.dart';
import 'package:pos_account/model/home/booking/all_table_rsrv_res.dart';
import 'package:pos_account/model/home/booking/confirm_table_resv.dart';
import 'package:pos_account/model/home/booking/edit_table_rsv.dart';
import 'package:pos_account/model/home/booking/order_item_detail_floor.dart';
import 'package:pos_account/model/home/booking/table_resev_model.dart';
import 'package:pos_account/model/home/booking/table_slot_avai_res.dart';
import 'package:pos_account/model/home/booking/table_status_update_req.dart';
import 'package:pos_account/model/home/dashboard/dash_channel_filter_sec.dart';
import 'package:pos_account/model/home/dashboard/dash_channel_up_req.dart';
import 'package:pos_account/model/home/dashboard/dashboard_res.dart';
import 'package:pos_account/model/home/employee/break_end_req.dart';
import 'package:pos_account/model/home/employee/break_start_req.dart';
import 'package:pos_account/model/home/employee/break_start_res.dart';
import 'package:pos_account/model/home/employee/check_in_req.dart';
import 'package:pos_account/model/home/employee/check_in_res.dart';
import 'package:pos_account/model/home/employee/check_out_req.dart';
import 'package:pos_account/model/home/employee/employee_by_code_res.dart';
import 'package:pos_account/model/home/employee/shift_status.dart';
import 'package:pos_account/model/home/eod/all_cash_in_out.dart';
import 'package:pos_account/model/home/eod/all_eod_data.dart';
import 'package:pos_account/model/home/eod/eod_add_sec.dart';
import 'package:pos_account/model/home/eod/eod_report.dart';
import 'package:pos_account/model/home/eod/finalize_eod_req.dart';
import 'package:pos_account/model/home/history/history_report.dart';
import 'package:pos_account/model/home/history/report_add_sec.dart';
import 'package:pos_account/model/home/integration/acc_integ_add_sec.dart';
import 'package:pos_account/model/home/integration/chart_acc_model.dart';
import 'package:pos_account/model/home/integration/acc_contact_setting.dart';
import 'package:pos_account/model/home/integration/plat_inte_conn_model.dart';
import 'package:pos_account/model/home/menu/customer/customer_order_history.dart';
import 'package:pos_account/model/home/menu/gift_card/gift_card_add_sec.dart';
import 'package:pos_account/model/home/menu/gift_card/gift_card_req.dart';
import 'package:pos_account/model/home/menu/gift_card/gift_card_res.dart';
import 'package:pos_account/model/home/menu/gift_card/gift_card_search_sec.dart';
import 'package:pos_account/model/home/menu/gift_card/gift_redeem_history.dart';
import 'package:pos_account/model/home/menu/gift_card/image/all_gift_card_img_res.dart';
import 'package:pos_account/model/home/menu/gift_card/image/gift_card_img_ad_sec.dart';
import 'package:pos_account/model/home/menu/gift_card/image/gift_card_img_data.dart';
import 'package:pos_account/model/home/menu/kitchen/kitchen_all_orders.dart';
import 'package:pos_account/model/home/menu/orders/all_orders_res.dart';
import 'package:pos_account/model/home/menu/orders/delivery/create_deli_pos_req.dart';
import 'package:pos_account/model/home/menu/orders/order_detail_by_id.dart';
import 'package:pos_account/model/home/menu/orders/refund_order.dart';
import 'package:pos_account/model/home/menu/orders/sms/order_sms_send.dart';
import 'package:pos_account/model/home/menu/orders/sms/sms_cus_detail.dart';
import 'package:pos_account/model/home/menu/payment/cus_loyal_res.dart';
import 'package:pos_account/model/home/menu/payment/eftpos/eftpos_merchant_log_res.dart';
import 'package:pos_account/model/home/menu/payment/eftpos/merchant_log.dart';
import 'package:pos_account/model/home/menu/payment/make_pay_res.dart';
import 'package:pos_account/model/home/menu/payment/refund_pay_res.dart';
import 'package:pos_account/model/home/menu/payment/eftpos/signature_res.dart';
import 'package:pos_account/model/home/menu/payment/uni_by_pay_res.dart';
import 'package:pos_account/model/home/menu/place_order/menu_schedule_res.dart';
import 'package:pos_account/model/home/menu/place_order/online_order_id.dart';
import 'package:pos_account/model/home/menu/place_order/order_tab/comp_dis_res.dart';
import 'package:pos_account/model/home/menu/place_order/order_tab/order_tab_req.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/combo_detail_by_id.dart';
import 'package:pos_account/model/home/menu/place_order/delivery/cus_delivery_data.dart';
import 'package:pos_account/model/home/menu/place_order/delivery/deli_dis_res.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/model/home/menu/place_order/pay_invoice_send_email_req.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_res.dart';
import 'package:pos_account/model/home/menu/place_order/po_make_pay_req.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_cat_res.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_combo_res.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_ingre_res.dart';
import 'package:pos_account/model/home/menu/place_order/product_filter_option.dart';
import 'package:pos_account/model/home/menu/place_order/promotion_res.dart';
import 'package:pos_account/model/home/menu/signal_r/order_print_status.dart';
import 'package:pos_account/model/home/menu/signal_r/place_order_info.dart';
import 'package:pos_account/model/home/menu/signal_r/print_status_req.dart';
import 'package:pos_account/model/home/product/add_raw_ingre_history_req.dart';
import 'package:pos_account/model/home/product/barcode/barcode_addsec.dart';
import 'package:pos_account/model/home/product/barcode/barcode_print_res.dart';
import 'package:pos_account/model/home/product/barcode/generate_barcode_req.dart';
import 'package:pos_account/model/home/product/combo/combo_add_sec.dart';
import 'package:pos_account/model/home/product/combo/combo_pack_res.dart';
import 'package:pos_account/model/home/product/combo/create_combo_req.dart';
import 'package:pos_account/model/home/product/feat_product/feat_prod_data.dart';
import 'package:pos_account/model/home/product/feat_product/get_all_feat_prod_res.dart';
import 'package:pos_account/model/home/product/gen_barcode/combo/combo_barcode_list.dart';
import 'package:pos_account/model/home/product/gen_barcode/combo/combo_barcode_print_req.dart';
import 'package:pos_account/model/home/product/gen_barcode/gen_bar_addsec.dart';
import 'package:pos_account/model/home/product/gen_barcode/gen_bar_print_res.dart';
import 'package:pos_account/model/home/product/gen_barcode/gen_barcode_print_req.dart';
import 'package:pos_account/model/home/product/gen_barcode/invoice_printer_detail.dart';
import 'package:pos_account/model/home/product/gen_barcode/retail_pos_poduct.dart';
import 'package:pos_account/model/home/product/modifier/prod_var_modi_group_res.dart';
import 'package:pos_account/model/home/product/modifier/prod_var_modi_req.dart';
import 'package:pos_account/model/home/product/modifier/up_prod_var_modi_group_req.dart';
import 'package:pos_account/model/home/product/new_product/adon_res.dart';
import 'package:pos_account/model/home/product/new_product/all_prod_add_sec.dart';
import 'package:pos_account/model/home/product/new_product/edit_price_res.dart';
import 'package:pos_account/model/home/product/new_product/get_all_products.dart';
import 'package:pos_account/model/home/product/product_cat_add.dart';
import 'package:pos_account/model/home/product/product_data_req.dart';
import 'package:pos_account/model/home/product/setmenu/all_set_menu_res.dart';
import 'package:pos_account/model/home/product/setmenu/prod_by_prod_res.dart';
import 'package:pos_account/model/home/product/setmenu/set_menu_data.dart';
import 'package:pos_account/model/home/product/setmenu/setmenu_res.dart';
import 'package:pos_account/model/home/setting/general/barcode/barcode_req.dart';
import 'package:pos_account/model/home/setting/general/barcode/barcode_type_add_sec.dart';
import 'package:pos_account/model/home/setting/general/barcode/barcode_type_res.dart';
import 'package:pos_account/model/home/setting/general/brand/brand_req.dart';
import 'package:pos_account/model/home/setting/general/cat_type/cat_type_res.dart';
import 'package:pos_account/model/home/setting/general/category/pro_cat_image.dart';
import 'package:pos_account/model/home/setting/general/docket/docket_req.dart';
import 'package:pos_account/model/home/setting/general/docket/docket_res.dart';
import 'package:pos_account/model/home/setting/general/docket/product_tag_docket.dart';
import 'package:pos_account/model/home/setting/general/docket/tag_product_docket_req.dart';
import 'package:pos_account/model/home/setting/general/order_status_res.dart';
import 'package:pos_account/model/home/setting/general/order_type/get_all_orders.dart';
import 'package:pos_account/model/home/setting/general/order_type/order_type_add_sec.dart';
import 'package:pos_account/model/home/setting/general/quick_note_res.dart';
import 'package:pos_account/model/home/setting/general/sub_cat/all_sub_cat.dart';
import 'package:pos_account/model/home/setting/general/sub_cat/subcat_add_req.dart';
import 'package:pos_account/model/home/setting/general/sub_cat/subcat_addsec.dart';
import 'package:pos_account/model/home/setting/general/table_lay/table_lay.dart';
import 'package:pos_account/model/home/setting/general/table_lay/table_loc_status.dart';
import 'package:pos_account/model/home/setting/general/table_loc/all_table_loc.dart';
import 'package:pos_account/model/home/setting/general/table_number/au_table_list.dart';
import 'package:pos_account/model/home/setting/general/order_type/order_type_add_req.dart';
import 'package:pos_account/model/common/message.dart';
import 'package:pos_account/model/auth/login_res.dart';
import 'package:pos_account/model/home/setting/general/tax_in_ex/setting_res_2.dart';
import 'package:pos_account/model/home/setting/general/tax_in_ex/tax_in_ex_add_sec.dart';
import 'package:pos_account/model/home/setting/general/tax_in_ex/tax_in_ex_req.dart';
import 'package:pos_account/model/home/setting/notification/email_setup_res.dart';
import 'package:pos_account/model/home/setting/notification/sms_setup_res.dart';
import 'package:pos_account/model/home/setting/pos_device/kd/pos_device_detail_res.dart';
import 'package:pos_account/model/home/setting/pos_device/pos_device/pos_device_addsec.dart';
import 'package:pos_account/model/home/setting/pos_device/pos_printer/get_all_pos_loc_res.dart';
import 'package:pos_account/model/home/setting/notification/notification_type.dart';
import 'package:pos_account/model/home/setting/payment_method/get_all_pay_method.dart';
import 'package:pos_account/model/home/setting/payment_method/pay_method_model.dart';
import 'package:pos_account/model/home/setting/pos_device/pos_device/all_pos_device.dart';
import 'package:pos_account/model/home/setting/pos_device/pos_device/pos_device_model.dart';
import 'package:pos_account/model/home/setting/pos_device/pos_printer/pos_printer_add_sec.dart';
import 'package:pos_account/model/home/setting/pos_device/printer_product/printer_prod_detail_res.dart';
import 'package:pos_account/model/home/setting/pos_device/printer_product/printer_prod_req.dart';
import 'package:pos_account/model/home/setting/pos_device/set_up/printer_add_sec.dart';
import 'package:pos_account/model/home/setting/pos_device/set_up/printer_setup.dart';
import 'package:pos_account/model/home/setting/pos_device/pos_printer/printer_location.dart';
import 'package:pos_account/model/home/setting/store/store_data.dart';
import 'package:pos_account/model/home/setting/store/store_res.dart';
import 'package:pos_account/model/home/setting/general/table_number/table_qr.dart';
import 'package:pos_account/model/home/setting/table_layout/all_table_add_res.dart';
import 'package:pos_account/model/home/setting/table_layout/all_table_lay_res.dart';
import 'package:pos_account/model/home/setting/table_layout/tr_calender.dart';
import 'package:pos_account/model/home/sync/sync_sec_res.dart';
import 'package:pos_account/model/language/translated_lang.dart';
import 'package:pos_account/model/new_org/board_add_sec.dart';
import 'package:pos_account/model/new_org/board_store_req.dart';
import 'package:pos_account/model/notification/new_order_notifi.dart';
import 'package:pos_account/model/notification/notification_data.dart';
import 'package:pos_account/model/notification/recent_call_res.dart';
import 'package:pos_account/model/profile/all_employees.dart';
import 'package:pos_account/model/profile/commission_details.dart';
import 'package:pos_account/model/profile/create_up_user.dart';
import 'package:pos_account/model/profile/emp_info.dart';
import 'package:pos_account/model/profile/user_add_sec.dart';
import 'package:pos_account/model/profile/user_info.dart';
import 'package:pos_account/providers/auth/db_login_req.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/uber/delivery/model/track/deli_track_list.dart';
import 'package:pos_account/services/uber/delivery/model/track/track_detail_res.dart';
import '../model/home/menu/gift_card/template/gift_card_temp_data.dart';
import '../model/home/menu/place_order/pos_res/popular_products_res.dart';
import '../model/home/menu/place_order/retail_pos_res.dart';
import '../model/home/product/add_raw_ingre_request.dart';
import '../model/home/product/all_raw_ingredient_response.dart';
import '../model/home/product/modifier/prod_with_variation_res.dart';
import '../model/home/product/modifier/tag_modi_add_sec_res.dart';
import '../model/home/product/new_product/sort_product_res.dart';
import '../model/home/product/raw_ingre_add_sec.dart';
import '../model/home/product/raw_ingre_history_res.dart';
import '../model/home/product/store_printers.dart';
import '../model/home/setting/general/discount_res.dart';
import '../model/home/setting/general/table_number/all_table_asl.dart';
import '../model/home/setting/general/table_number/all_table_res.dart';
import '../model/home/setting/all_setting.dart';
import '../model/home/setting/general/upload_image_s3_res.dart';
import '../model/home/setting/store/store_charge_model.dart';
import '../model/home/setting/store/store_color_model.dart';
import '../model/home/setting/store/store_deli_dis_model.dart';
import '../model/home/setting/store/store_general_model.dart';
import '../model/home/setting/store/store_open_hour_model.dart';
import '../model/home/setting/store/store_other_set_model.dart';
import '../model/keypad/keypad_add_section.dart';
import '../model/keypad/keypad_checkout_model.dart';
import '../model/profile/assign_service_model.dart';
import '../model/profile/commison_add_sec.dart';
import '../model/profile/emp_add_sec.dart';
import '../providers/menu/gift_card/gift_card_check_pro.dart';
import 'repo.dart';
part 'support_handler.dart';
part 'package:pos_account/constant/api.dart';

class Handler with SupportHandler {
  static Future<Map<String, String>?> get _header async =>
      await SupportHandler._header;

  static Future<LoginRes?> login(
      {required String email, required String password}) async {
    final body = {
      "Email": email,
      "Password": password,
      "FCMToken": await SupportHandler.getFcmToken,
      // "ChannelPlatForm": "PosTab",
      "DeviceIdentifier": await SupportHandler.getDeviceId,
      "DeviceType": Platform.isAndroid
          ? "Android"
          : Platform.isIOS
              ? "IOS"
              : Platform.isMacOS
                  ? "MacOS"
                  : Platform.isWindows
                      ? "Windows"
                      : "",
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
          h: await _header, dataInJson: jsonEncode(body), api: Api._LOGIN);
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final loginRes = LoginRes.fromJson(jsonDecode(res.body));
        await DbLocalData.updateLoginData(loginRes: loginRes);
        EncryptSharedPref.setLoginReq =
            DbLoginReq(email: email, password: password);
        return loginRes;
      } else {
        return Future.error(IfException.onError(res: res, showToast: false));
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<LoginRes?> loginWithCode(
      {String? email, required String code}) async {
    final _body = {
      if (email != null) "Email": email,
      "LoginPinCode": code,
      "FCMToken": await SupportHandler.getFcmToken,
      "DeviceIdentifier": await SupportHandler.getDeviceId,
      "DeviceType": Platform.isAndroid
          ? "Android"
          : Platform.isIOS
              ? "IOS"
              : Platform.isMacOS
                  ? "MacOS"
                  : Platform.isWindows
                      ? "Windows"
                      : "",
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(h: {
        "ChannelPlatForm": "PosApp",
      }, dataInJson: jsonEncode(_body), api: Api._LOGIN_WITH_CODE);
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final loginRes = LoginRes.fromJson(jsonDecode(res.body));
        await DbLocalData.updateLoginData(loginRes: loginRes);
        return loginRes;
      } else {
        return Future.error(IfException.onError(res: res, showToast: false));
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<RefreshTokenModel?> getRefreshToken() async {
    final body = {
      "RefreshToken": (await DbLocalData.getLoginData())?.refreshToken,
      "UserId": await SharedPrefs.userId,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._GET_ACCESS_TOKEN_WITH_REFRESH_TOKEN,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = RefreshTokenModel.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        return Future.error(IfException.onError(res: res, showToast: true));
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<LoginRes?> validateUser(
      {required String userId,
      required String otpCode,
      required bool isEmail}) async {
    final body = {
      "UserId": userId,
      // "ChannelPlatForm": "POSMobile",
      "Code": otpCode,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: isEmail ? Api._VALIDATE_OTP_MAIL : Api._VALIDATE_2FA_QR,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final loginRes = LoginRes.fromJson(jsonDecode(res.body));
        await DbLocalData.updateLoginData(loginRes: loginRes);
        return loginRes;
      } else {
        return Future.error(IfException.onError(res: res, showToast: true));
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<OtpSendRes?> sendOtpToMail({required String email}) async {
    final body = {
      "Email": email,
      // "ChannelPlatForm": "POSMobile",
    };
    try {
      final res = await Repo.post(
          h: await _header,
          dataInJson: jsonEncode(body),
          api: Api._SENT_OTP_MAIL);
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final result = OtpSendRes.fromJson(jsonDecode(res.body));
        return result;
      } else {
        return Future.error(IfException.onError(res: res, showToast: false));
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<OtpSendRes?> sendOtpToMailRegister(
      {required String email}) async {
    final body = {
      "Email": email,
      // "ChannelPlatForm": "POSMobile",
    };
    try {
      final res = await Repo.post(
          h: await _header,
          dataInJson: jsonEncode(body),
          api: Api._SEND_OTP_TO_EMAIL_FOR_REGISTER);
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final result = OtpSendRes.fromJson(jsonDecode(res.body));
        return result;
      } else {
        return Future.error(IfException.onError(res: res, showToast: false));
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<OtpSendRes?> changePassword({
    required String email,
    required String oldPass,
    required String newPass,
    bool staySignedIn = true,
  }) async {
    final body = {
      "Email": email,
      "OldPassword": oldPass,
      "NewPassword": newPass,
      "IsStaySigned": staySignedIn,
    };
    try {
      final res = await Repo.post(
          h: await _header,
          dataInJson: jsonEncode(body),
          api: Api._CHANGE_PASS);
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final result = OtpSendRes.fromJson(jsonDecode(res.body));
        return result;
      } else {
        return Future.error(IfException.onError(res: res, showToast: false));
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> sendEmailDeviceIdCommon() async {
    final body = {
      "DeviceIdentifier": await SupportHandler.getDeviceId,
    };
    // log(jsonEncode(_body));

    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DEVICE_ID_SEND_EMAIL_COMMON,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final result = Message.fromJson(jsonDecode(res.body));
        IfException.showMessage(message: result.message ?? '', isError: false);
        return true;
      } else {
        return Future.error(IfException.onError(res: res, showToast: false));
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> sendEmailDeviceId() async {
    final body = {
      "DeviceIdentifier": await SupportHandler.getDeviceId,
    };
    // log(jsonEncode(_body));

    try {
      final res = await Repo.post(
          h: await _header,
          dataInJson: jsonEncode(body),
          api: Api._DEVICE_ID_SEND_EMAIL);
      // log(res.body);
      // log(res.statusCode.toString());
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      } else {
        return Future.error(IfException.onError(res: res, showToast: false));
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<OtpSendRes?> forgotPassword({
    required String email,
  }) async {
    final body = {
      "Email": email,
      // "ChannelPlatForm": "POSMobile",
    };
    try {
      final res = await Repo.post(
          h: await _header,
          dataInJson: jsonEncode(body),
          api: Api._FORGOT_PASS);
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final result = OtpSendRes.fromJson(jsonDecode(res.body));
        return result;
      } else {
        return Future.error(IfException.onError(res: res, showToast: false));
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> onChangeStore({required String storeId}) async {
    final body = {
      "StoreId": storeId,
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._ACTIVATE_STORE,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        // final resData = StoreDetailRes.fromJson(json.decode(res.body));
        // return resData;
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static void logout() {
    DbLocalData.clear();
  }

  static Future<CateTypeRes?> getCatTypes({required int page}) async {
    final body = {
      "Page": page,
      "PageSize": 10,
      "ExternalFilter": {"Id": "test", "Name": ""},
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._GET_ALL_CAT_TYPE,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final pCatRes = CateTypeRes.fromJson(jsonDecode(res.body));
        return pCatRes;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<DiscountSetRes?> getDiscountsSet(
      {required int page, String searchKey = ''}) async {
    final _body = {
      "Page": page,
      "PageSize": 10,
      "SearchKeyWords": searchKey,
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._GET_ALL_DIS_TYPE,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final pCatRes = DiscountSetRes.fromJson(jsonDecode(res.body));
        return pCatRes;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpCatTypes(
      {required List<SRDatum> catTypeList, bool showToast = true}) async {
    // log(jsonEncode(catTypeList.map((e) => e.toJson()).toList()));
    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(
          catTypeList.map((e) => e.toJson()).toList(),
        ),
        api: Api._ADD_UP_CAT_TYPE,
      ),
      showToast: showToast,
    );
  }

  static Future<bool?> addUpDiscounts(
      {required SRDatum discountList, bool showToast = true}) async {
    // log(jsonEncode(catTypeList.map((e) => e.toJson()).toList()));
    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(
          discountList.toJson(),
        ),
        api: Api._ADD_UP_DIS,
      ),
      showToast: showToast,
    );
  }

  static Future<bool?> deleteCatTypes(
      {required List<SRDatum> catTypeList}) async {
    final body = List.generate(
        catTypeList.length,
        (index) => {
              "Id": catTypeList[index].id,
              "Name": catTypeList[index].name,
            });
    // log(json.encode(_body));

    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DELETE_CAT_TYPE,
      ),
      messge: body.length > 1 ? "${body.length} ${LN.catTypeDeleted}" : "",
    );
  }

  static Future<bool?> addProductCat({
    required CatAddReq catData,
    bool showToast = true,
  }) async {
    // log(jsonEncode(catData.toJson()));
    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(catData.toJson()),
        api: Api._ADD_UPDATE_PRODUCT_CAT,
      ),
      showToast: showToast,
    );
  }

  static Future<AllProductCat?> getProductCats(
      {required int page, String searchKey = ''}) async {
    final _body = {
      "Page": page,
      "PageSize": 10,
      "SearchKeyWords": searchKey,
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._GET_PRODUCT_CATS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final pCatRes = AllProductCat.fromJson(jsonDecode(res.body));
        return pCatRes;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<PCatImages?> getProdCatsAddSecList() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_PRODUCT_CATS_ADD_SEC_LIST,
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final pCatRes = PCatImages.fromJson(jsonDecode(res.body));
        return pCatRes;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> deleteProductCats(
      {required List<SRDatum> productCatsList}) async {
    final body = List.generate(
        productCatsList.length,
        (index) => {
              "Id": productCatsList[index].id,
              "Name": productCatsList[index].name,
            });

    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DELETE_PRODUCT_CATS,
      ),
      messge:
          body.length > 1 ? "${body.length} ${LN.categoriesAreDeleted}" : "",
    );
  }

  static Future<CatAddReq?> editProdCats({required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_PROD_CATS(id),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = CatAddReq.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addProductBrand({
    required BrandReq brandReq,
    String filePath = "",
  }) async {
    // log(jsonEncode(brandReq.toJson()));

    return await IfException.boolExpt(
        function: Repo.httpPostFile(
      h: await _header,
      api: Api._ADD_UPDATE_PRODUCT_BRAND,
      data: {"Request": jsonEncode(brandReq.toJson())},
      filePath: filePath,
    ));
  }

  static Future<SettingRes?> getProductBrands(
      {required int page, String searchKey = ''}) async {
    final _body = {
      "Page": page,
      "PageSize": 10,
      "SearchKeyWords": searchKey,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._GET_PRODUCT_BRANDS,
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final pCatRes = SettingRes.fromJson(jsonDecode(res.body));
        return pCatRes;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<BrandReq?> editProdBrands({required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_BRAND(id),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = BrandReq.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> deleteProductBrand(
      {required List<SRDatum> productCatsList}) async {
    final body = List.generate(
        productCatsList.length,
        (index) => {
              "Id": productCatsList[index].id,
              "Name": productCatsList[index].name,
            });

    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DELETE_PRODUCT_BRAND,
      ),
      messge: body.length > 1 ? "${body.length} ${LN.brandsAreDeleted}" : "",
    );
  }

  static Future<AllSettings?> getAllSetting() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_SETTING,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllSettings.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<AllTableLocationModel?> getAllTableLocation(
      {required int page, String searchKey = ''}) async {
    final _body = {
      "Page": page,
      "PageSize": 10,
      "SearchKeyWords": searchKey,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._GET_ALL_TABLE_LOCATION,
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllTableLocationModel.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpdateTableLocation(
      {required List<SRDatum> tableList}) async {
    final body = tableList.map((e) => e.toJson()).toList();

    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(body),
      api: Api._ADD_UPDATE_TABLE_LOCATION,
    ));
  }

  static Future<bool?> deleteTableLocation(
      {required List<SRDatum> dataList}) async {
    final body = List.generate(
        dataList.length,
        (index) => {
              "Id": dataList[index].id,
              "Name": dataList[index].name,
            });

    return IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DELETE_TABLE_LOCATION,
      ),
      messge:
          body.length > 1 ? "${body.length} ${LN.categoriesAreDeleted}" : "",
    );
  }

  static Future<AllTableRes?> getAllTableNum(
      {required int page, String searchKey = ''}) async {
    final _body = {
      "Page": page,
      "PageSize": 9,
      "SearchKeyWords": searchKey,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._GET_ALL_TABLES,
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllTableRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpdateTableNum(
      {required List<AllTableNoList> tableList}) async {
    final body = tableList.map((e) => e.toJson()).toList();
    // log(jsonEncode(_body));

    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(body),
      api: Api._ADD_UPDATE_TABLES,
    ));
  }

  static Future<GaTableAsl?> getAllTableAddSecList() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_TABLE_ADD_SEC_LIST,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = GaTableAsl.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> deleteTablesNum(
      {required List<SRDatum> dataList}) async {
    final body = List.generate(
        dataList.length,
        (index) => {
              "Id": dataList[index].id,
              "Name": dataList[index].name,
            });
    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DELETE_TABLES,
      ),
      messge: body.length > 1 ? "${body.length} ${LN.tablesAreDeleted}" : "",
    );
  }

  static Future<AllTableNoList?> editTable({required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_TABLE(id),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllTableNoList.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<OrderTypeAddSecRes?> getOrderTypeAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_ORDER_TYPE_ADD_SEC,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = OrderTypeAddSecRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<GetAllOrderTypeRes?> getAllOrderTypes(
      {required int page, String searchKey = ''}) async {
    final _body = {
      "Page": page,
      "PageSize": 10,
      "SearchKeyWords": searchKey,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._GET_ALL_ORDER_TYPES,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = GetAllOrderTypeRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpOrderTypes(
      {required List<OrderTypeAddReq> orderTypeList}) async {
    final body = orderTypeList.map((e) => e.toJson()).toList();
    // log(jsonEncode(_body));

    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(body),
      api: Api._ADD_UP_ORDER_TYPES,
    ));
  }

  static Future<OrderTypeAddReq?> editOrderTypes(
      {required String reqStoredId}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_ORDER_TYPES(reqStoredId),
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = OrderTypeAddReq.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> deleteOrderType(
      {required List<SRDatum> dataList}) async {
    final body = List.generate(
        dataList.length,
        (index) => {
              "Id": dataList[index].id,
              "Name": dataList[index].name,
            });

    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DELETE_ORDER_TYPES,
      ),
      messge:
          body.length > 1 ? "${body.length} ${LN.orderTypesAreDeleted}" : "",
    );
  }

  static Future<TaxInExAddSec?> getTaxAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_TAX_ADD_SEC,
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = TaxInExAddSec.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<SettingResTyp2?> getAllTaxIE(
      {required int page, String searchKey = ''}) async {
    final _body = {
      "Page": page,
      "PageSize": 10,
      "SearchKeyWords": searchKey,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._GET_ALL_TAX_IE,
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = SettingResTyp2.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpTaxIE({required TaxInExReq data}) async {
    // log(jsonEncode(_body));
    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(data.toJson()),
      api: Api._ADD_UP_TAX_IE,
    ));
  }

  static Future<TaxInExReq?> editTaxIE({required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_TAX_IE(id),
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = TaxInExReq.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> deleteTaxIE({required List<SRDatum> dataList}) async {
    final body = List.generate(
        dataList.length,
        (index) => {
              "Id": dataList[index].id,
              "Name": dataList[index].name,
            });
    return IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DELETE_TAX_IE,
      ),
      messge: body.length > 1 ? "${body.length} ${LN.taxAreDeleted}" : "",
    );
  }

  static Future<DocketGroupRes?> getAllDocketGroup(
      {required int page, String searchKey = ''}) async {
    final _body = {
      "Page": page,
      "PageSize": 10,
      "SearchKeyWords": searchKey,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._GET_ALL_DOCKET_GROUP,
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = DocketGroupRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addDocketGroup(
      {required List<DocketGroupReq> dataList}) async {
    final body = dataList.map((e) => e.toJson()).toList();
    // log(jsonEncode(_body));
    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(body),
      api: Api._ADD_UP_DOCKET_GROUP,
    ));
  }

  static Future<DocketGroupReq?> editDocketGroup({required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_DOCKET_GROUP(id),
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = DocketGroupReq.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<List<ProductTagToDocketRes>?> getProductTagToDocket(
      {required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_PRODUCT_TAG_DOCKET(id),
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<ProductTagToDocketRes>.from(json
            .decode(res.body)
            .map((x) => ProductTagToDocketRes.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<StoreRes?> getAllStoreList() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_STORE_LIST,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = StoreRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpStore(
      {required StoreData storeData, String? filePath}) async {
    // log(jsonEncode(storeData.toJson()));
    return await IfException.boolExpt(
        function: Repo.httpPostFile(
      h: await _header,
      data: {
        "Request": json.encode(storeData.toJson()),
      },
      api: Api._ADD_UP_STORE,
      filePath: filePath ?? '',
    ));
  }

  static Future<StoreData?> editStore() async {
    try {
      final storeId = await SharedPrefs.storeId;
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_STORE(storeId),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = StoreData.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<StoreGeneralModel?> getStoreGeneralSettings() async {
    try {
      final storeId = await SharedPrefs.storeId;
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_STORE_GENERAL(storeId),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = StoreGeneralModel.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<StoreOpenHourModel?> getStoreOpenHours() async {
    try {
      final storeId = await SharedPrefs.storeId;
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_STORE_OPENING_HOUR(storeId),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = StoreOpenHourModel.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<StoreDeliDistanceModel?> getStoreDeliDistance() async {
    try {
      final storeId = await SharedPrefs.storeId;
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_STORE_DELIVERY_DIS(storeId),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = StoreDeliDistanceModel.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<StoreExtraChargeModel?> getStoreExtraCharges() async {
    try {
      final storeId = await SharedPrefs.storeId;
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_STORE_SURCHARGE(storeId),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = StoreExtraChargeModel.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<StoreColorModel?> getStoreColorSettings() async {
    try {
      final storeId = await SharedPrefs.storeId;
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_STORE_COLORS(storeId),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = StoreColorModel.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<StoreOtherSettingModel?> getStoreOtherSettings() async {
    try {
      final storeId = await SharedPrefs.storeId;
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_STORE_OTHERS(storeId),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = StoreOtherSettingModel.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> upStoreGeneral({
    required StoreGeneralModel storeData,
  }) async {
    // log(jsonEncode(storeData.toJson()));
    return await IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: json.encode(storeData.toJson()),
      api: Api._UP_STORE_GENERAL,
    ));
  }

  static Future<bool?> upStoreOpenHour({
    required StoreOpenHourModel storeData,
  }) async {
    // log(jsonEncode(storeData.toJson()));
    return await IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: json.encode(storeData.toJson()),
      api: Api._UP_STORE_OPEN_HOUR,
    ));
  }

  static Future<bool?> upStoreDeliDis({
    required StoreDeliDistanceModel storeData,
  }) async {
    // log(jsonEncode(storeData.toJson()));
    return await IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: json.encode(storeData.toJson()),
      api: Api._UP_STORE_DELI_DIS,
    ));
  }

  static Future<bool?> upStoreSurcharge({
    required StoreExtraChargeModel storeData,
  }) async {
    // log(jsonEncode(storeData.toJson()));
    return await IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: json.encode(storeData.toJson()),
      api: Api._UP_STORE_SURCHARGE,
    ));
  }

  static Future<bool?> upStoreColors({
    required StoreColorModel storeData,
  }) async {
    // log(jsonEncode(storeData.toJson()));
    return await IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: json.encode(storeData.toJson()),
      api: Api._UP_STORE_COLORS,
    ));
  }

  static Future<bool?> resetStoreColors({
    required String id,
  }) async {
    final _data = {"Id": id};
    // log(jsonEncode(storeData.toJson()));
    return await IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: json.encode(_data),
      api: Api._RESET_STORE_COLORS,
    ));
  }

  static Future<bool?> upStoreOtherSettings({
    required StoreOtherSettingModel storeData,
  }) async {
    // log(jsonEncode(storeData.toJson()));
    return await IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: json.encode(storeData.toJson()),
      api: Api._UP_STORE_OTHERS,
    ));
  }

  static Future<SetMenuRes?> getAllSetMenuAS() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_SET_MENU_ADD_SEC,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = SetMenuRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      showToast(LN.somethingWentWrong);
      // print(e.toString());
    }
    return null;
  }

  static Future<ProdByProdCatRes?> getAllVarByCat({required String id}) async {
    final Map<String, dynamic> data = {
      "Id": id,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_ALL_V_B_P,
        dataInJson: json.encode(data),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = ProdByProdCatRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<ProdByProdCatRes>?> getAllProdBProd(
      {required List<String> ids}) async {
    final Map<String, dynamic> data = {
      "Ids": ids,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_ALL_P_B_P,
        dataInJson: json.encode(data),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<ProdByProdCatRes>.from(
            jsonDecode(res.body).map((e) => ProdByProdCatRes.fromJson(e)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> deleteSetMenu({required List<SRDatum> dataList}) async {
    final body = List.generate(
        dataList.length,
        (index) => {
              "Id": dataList[index].id,
              "Name": dataList[index].name,
            });
    // log(jsonEncode(_body));
    return IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DELETE_SET_MENU,
      ),
      messge: body.length > 1 ? "${body.length} ${LN.setmenuAreDeleted}" : "",
    );
  }

  static Future<SetMenuData?> editSetMenu({required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_SET_MENU(id),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = SetMenuData.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> addUpSetMenu(
      {required SetMenuData setMenuData, String? filePath}) async {
    // log(jsonEncode(setMenuData.toJson()));
    return await IfException.boolExpt(
        function: Repo.httpPostFile(
      h: await _header,
      data: {
        "Request": json.encode(setMenuData.toJson()),
      },
      api: Api._ADD_UP_SET_MENU,
      filePath: filePath ?? '',
    ));
  }

  static Future<AllSetMenuRes?> getAllSetMenu(
      {required int page, int pageSize = 10, String searchKey = ""}) async {
    final body = {
      "Page": page,
      "PageSize": pageSize,
      "ExternalFilter": {
        "SearchKeywords": searchKey,
      },
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._GET_ALL_SET_MENU,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllSetMenuRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpProducts({
    required ProductDataReq productDataReq,
    dynamic Function(bool)? onPopMsg,
  }) async {
    // log(jsonEncode(productDataReq.toJson()));
    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: json.encode(productDataReq.toJson()),
        api: Api._ADD_UP_PRODUCTS,
      ),
      onPopMsg: onPopMsg,
    );
  }

  static Future<bool?> deleteProducts({required List<SRDatum> dataList}) async {
    final body = List.generate(
        dataList.length,
        (index) => {
              "Id": dataList[index].id,
              "Name": dataList[index].name,
            });

    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DELETE_PRODUCTS,
      ),
      messge: body.length > 1 ? "${body.length} ${LN.productsAreDeleted}" : "",
    );
  }

  static Future<bool?> deleteProductVarient(
      {required List<SRDatum> dataList}) async {
    final body = List.generate(
        dataList.length,
        (index) => {
              "Id": dataList[index].id,
              "Name": dataList[index].name,
            });

    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DELETE_PROD_VARIENT,
      ),
      messge: body.length > 1 ? "${body.length} ${LN.varientDeleted}" : "",
    );
  }

  static Future<bool?> deactivateProducts(
      {required List<SRDatum> dataList}) async {
    final body = List.generate(
        dataList.length,
        (index) => {
              "Id": dataList[index].id,
            });
    // log(json.encode(_body));

    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DEACTIVE_PRODUCTS,
      ),
      messge: body.length > 1 ? "${body.length} ${LN.productDeactivated}" : "",
    );
  }

  static Future<GetAllProductRes?> getAllProducts({
    required int page,
    String searchKey = "",
    String orderTypeId = "",
    String categoryId = "",
    int pageSize = 12,
  }) async {
    final body = {
      "Page": page,
      "PageSize": pageSize,
      "ExternalFilter": {
        "SearchKeywords": searchKey,
        // "OrderTypeId": orderTypeId,
        "CategoryId": categoryId,
      },
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._GET_ALL_PRODUCTS,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = GetAllProductRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<AllProductAddSecRes?> getAllProductAddSection() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_PROD_ADD_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllProductAddSecRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<ProductDataReq?> editProducts(
      {required String reqStoredId}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_PRODUCTS(reqStoredId),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = ProductDataReq.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<List<EditPriceRes>?> editProdPrice(
      {required String pId}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_PROD_PRICE(pId),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<EditPriceRes>.from(
            json.decode(res.body).map((x) => EditPriceRes.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> updateProdPrice(
      {required List<EditPriceRes> editedPrice}) async {
    // log(json.encode(editedPrice.map((e) => e.toJson()).toList()));

    return await IfException.boolExpt(
        function: Repo.post(
            h: await _header,
            api: Api._UPDATE_PROD_PRICE,
            dataInJson:
                json.encode(editedPrice.map((e) => e.toJson()).toList())));
  }

  static Future<List<AdonRes>?> getAllProductByStore(
      {int page = 1, String keyWord = ""}) async {
    final body = {
      "Page": page,
      "PageSize": 10,
      "SearchKeywords": keyWord,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._GET_ALL_PRO_SB_STORE,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<AdonRes>.from(
            jsonDecode(res.body).map((e) => AdonRes.fromJson(e)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<FeatProRes?> getAllFeatProds({
    required int page,
    int pageSize = 10,
    String searchKey = "",
  }) async {
    final body = {
      "Page": page,
      "PageSize": pageSize,
      "ExternalFilter": {
        "SearchKeywords": searchKey,
      },
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._GET_ALL_FEAT_PROD,
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = FeatProRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpFeatProd(
      {required List<AddFeatProData> dataList}) async {
    final data = dataList.map((e) => e.toJson()).toList();
    // log(jsonEncode(data));
    return await IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      api: Api._ADD_UP_FEAT_PROD,
      dataInJson: json.encode(data),
    ));
  }

  static Future<bool?> deleteFeaturedProd(
      {required List<SRDatum> dataList}) async {
    final body = List.generate(
        dataList.length,
        (index) => {
              "Id": dataList[index].id,
              "Name": dataList[index].name,
            });
    // log(jsonEncode(_body));
    return IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DELETE_FEAT_PROD,
      ),
      messge: body.length > 1 ? "${body.length} ${LN.featProdAreDeleted}" : "",
    );
  }

  static Future<PrinterSetupAddSec?> getPrinterAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_PRINTER_ADD_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = PrinterSetupAddSec.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<PosPrinterSetup?> getPrinterDetails() async {
    final data = {
      "Id": "",
      "DeviceIdentifier": await SupportHandler.getDeviceId,
    };
    // log(json.encode(_data));
    try {
      final res = await Repo.post(
          h: await _header,
          api: Api._GET_PRINTER_DETAIL,
          dataInJson: json.encode(data));
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = PosPrinterSetup.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> addUpPrinterSetup(
      {required PosPrinterSetup setUp}) async {
    // log(jsonEncode(setUp.toJson()));
    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(setUp.toJson()),
      api: Api._ADD_UP_PRINTER_SET,
    ));
  }

  static Future<SettingRes?> getAllDeparment(
      {required int page, String searchKey = ''}) async {
    final _body = {
      "Page": page,
      "PageSize": 10,
      "SearchKeyWords": searchKey,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._GET_ALL_DEPART,
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = SettingRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpDepartment(
      {required List<SRDatum> tableList}) async {
    final body = tableList.map((e) => e.toJson()).toList();

    return await IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(body),
      api: Api._CREATE_UP_DEPART,
    ));
  }

  static Future<bool?> deleteDepartment(
      {required List<SRDatum> dataList}) async {
    final body = List.generate(
        dataList.length,
        (index) => {
              "Id": dataList[index].id,
              "Name": dataList[index].name,
            });

    return IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DELETE_DEPART,
      ),
      messge:
          body.length > 1 ? "${body.length} ${LN.departmentsAreDeleted}" : "",
    );
  }

  static Future<PosPrinterAddSec?> getPosPrinterAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._POS_PRINTER_ADD_SEC,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = PosPrinterAddSec.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      showToast(LN.noInternetConnection);
    } on FormatException catch (_) {
      showToast(LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<GetAllPosLocBdRes?> getAllPosLocByDepart(
      {required int page, String searchKey = ''}) async {
    final _body = {
      "Page": page,
      "PageSize": 10,
      "SearchKeyWords": searchKey,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._GET_ALL_POS_PRINTER,
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = GetAllPosLocBdRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpPosLoc(
      {required List<PrinterLocationReq> dataList}) async {
    final body = dataList.map((e) => e.toJson()).toList();

    // log(json.encode(_body));

    return await IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(body),
      api: Api._CREATE_UP_POS_PRINTER,
    ));
  }

  static Future<PrinterLocationReq?> editPosLoc({required String reqId}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_POS_PRINTER(reqId),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = PrinterLocationReq.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> deletePosLoc({required List<SRDatum> dataList}) async {
    final body = List.generate(
        dataList.length,
        (index) => {
              "Id": dataList[index].id,
              "Name": dataList[index].name,
            });
    // log(jsonEncode(_body));

    return IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DELETE_POS_PRINTER,
      ),
      messge:
          body.length > 1 ? "${body.length} ${LN.posLocationsAreDeleted}" : "",
    );
  }

  static Future<List<ProductFilterOption>?> getProdFilterOption(
      {String? id}) async {
    if (id == null) return null;
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_PROD_FILTER_OPTION(id),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<ProductFilterOption>.from(
            json.decode(res.body).map((x) => ProductFilterOption.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<PosDeviceAddSec?> getPosDeviceAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._POS_DEVICE_ADD_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = PosDeviceAddSec.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<AllPosDevices?> getAllPosDevice({
    required int page,
    int pageSize = 50,
    String searchKey = '',
  }) async {
    final _body = {
      "Page": page,
      "PageSize": pageSize,
      "SearchKeyWords": searchKey,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._GET_ALL_POS_DEVICES,
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllPosDevices.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpPosDevice({required PosDeviceModel data}) async {
    final _body = data.toJson();
    // log(jsonEncode(_body));

    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(_body),
      api: Api._ADD_UP_POS_DEVICE,
    ));
  }

  static Future<PosDeviceModel?> editPosDevice({required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_POS_DEVICE(id),
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = PosDeviceModel.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> updateDevice4Pos({required String id}) async {
    final body = {
      "Id": id,
    };
    // log(jsonEncode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._UPDATE_DEVICE_4_POS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = Message.fromJson(jsonDecode(res.body));
        // return resData;
        if (resData.message?.isNotEmpty ?? false)
          IfException.showMessage(
              message: resData.message ?? '', isError: false);
        return true;
      } else {
        IfException.showMessage(
          seconds: 0,
          message: IfException.onError(res: res, showToast: false),
        );
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<PlaceOrderInfo?> placeOrder({
    required PlaceOrderReq placeOrderRes,
    bool isUpdateAfterCancelled = false,
  }) async {
    // log(jsonEncode(placeOrderRes.toJson()));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(placeOrderRes.toJson()),
        api: Api._PLACE_ORDER_OR_CHECK_OUT,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = PlaceOrderInfo.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        if (!isUpdateAfterCancelled)
          IfException.showMessage(
              seconds: 0,
              message: IfException.onError(res: res, showToast: false),
              msg: Msg.Dialog);
      }
    } on SocketException catch (_) {
      IfException.showMessage(message: LN.noInternetConnection);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<DeliveryDisRes?> getDeliveryAmount({
    String? lat,
    String? long,
    String? id,
    String? address,
  }) async {
    final data = {
      "Id": id ?? '',
      "Latitude": lat,
      "Longitude": long,
      "DropOffAddress": address,
    };
    // log(jsonEncode(_data));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(data),
        api: Api._GET_DELIVERY_AMOUNT_BY_DIST,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = DeliveryDisRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<UniByPayRes?> searchUnicode(
      {required String uniCode, required String payMenthod}) async {
    final body = {
      "UniqueCode": uniCode,
      "PaymentMethodId": payMenthod,
    };
    try {
      // log(jsonEncode(_body));
      final res = await Repo.post(
        h: await _header,
        api: Api._SEARCH_UNI_CODE,
        dataInJson: json.encode(body),
      );
      // log(res.statusCode.toString());
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = UniByPayRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<CusForLoyalityRes?> searchCustomer({
    String? phoneNumber,
    // String? email,
    String? cusId,
    bool showMessage = false,
  }) async {
    final _body = {
      if (phoneNumber?.isNotEmpty ?? false) "PhoneNumber": phoneNumber,
      // if (email != null) "Email": email,
      if (cusId != null) "CustomerId": cusId,
    };

    if (_body.isEmpty) return null;

    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._SEARCH_CUS,
        dataInJson: json.encode(_body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = CusForLoyalityRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        if (showMessage) IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      if (showMessage)
        IfException.showMessage(
            message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      if (showMessage) IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<List<CusDeliveryData>?> getCusDeliveryAddress({
    required String id,
    required String name,
  }) async {
    final body = {
      "Id": id,
      "Name": name,
    };
    try {
      // log(jsonEncode(_body));
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_CUS_DELIVERY_ADDRESS,
        dataInJson: json.encode(body),
      );
      // log(res.statusCode.toString());
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return List<CusDeliveryData>.from(
            json.decode(res.body).map((x) => CusDeliveryData.fromJson(x)));
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<CustomerHistory?> getCusOrders({
    int page = 1,
    int pageSize = 10,
    required String cusId,
  }) async {
    final data = {
      "Page": page,
      "PageSize": pageSize,
      "ExternalFilter": {"CustomerId": cusId}
    };
    // log(jsonEncode(_data));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_CUS_ORDERS,
        dataInJson: json.encode(data),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = CustomerHistory.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<MakePaymentRes?> placeOrderMakePays(
      {required PoMakePaymentReq paymentReq}) async {
    // log(jsonEncode(paymentReq.toJson()));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._PLACE_ORDER_MAKE_PAYMENT,
        dataInJson: json.encode(paymentReq.toJson()),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = MakePaymentRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.showMessage(
          seconds: 0,
          message: IfException.onError(res: res, showToast: false),
          msg: Msg.Dialog,
          popNav: false,
        );
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog, popNav: false);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime, popNav: false);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<MakePaymentRes?> printReceipt(
      {required PoMakePaymentReq paymentReq}) async {
    // log(jsonEncode(paymentReq.toJson()));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._PRINT_RECEIPT,
        dataInJson: json.encode(paymentReq.toJson()),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = MakePaymentRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.showMessage(
            message: IfException.onError(res: res, showToast: false),
            msg: Msg.Dialog);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> cancelPlaceOrderItem({
    required String orderId,
    required ItemCancelType type,
    required List<String> itemIds,
    required List<String> setmenuId,
  }) async {
    final body = {
      "OrderId": orderId,
      "Type": type == ItemCancelType.setmenu
          ? "setMenu"
          : type == ItemCancelType.order
              ? "OrderItems"
              : type == ItemCancelType.rawingre
                  ? "RawLooseItems"
                  : "",
      if (type == ItemCancelType.order && itemIds.isNotEmpty)
        "OrderItemsOrsetMenuOrderIds": itemIds
      else if (type == ItemCancelType.setmenu && setmenuId.isNotEmpty)
        "OrderItemsOrsetMenuOrderIds": setmenuId
      else if (type == ItemCancelType.rawingre && itemIds.isNotEmpty)
        "LooseRawOrderItemIds": itemIds,
      //
      if (type == ItemCancelType.setmenu && itemIds.isNotEmpty)
        "SetMenuOrderItemIds": itemIds,
    };

    // log(jsonEncode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._CANCEL_ORDER_ITEM,
        dataInJson: json.encode(body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        // final resData = MakePaymentRes.fromJson(jsonDecode(res.body));
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  // static Future<PayInvoiceDetailRes?> getPaymentInvoiceDetail(
  //     {required String orderId}) async {
  //   // log(orderId);
  //   try {
  //     final res = await Repo.get(
  //       h: await _header,
  //       api: Api._GET_PAY_INVOICE_DETAIL(orderId),
  //     );
  //     // log(res.body);
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       final resData = PayInvoiceDetailRes.fromJson(jsonDecode(res.body));
  //       return resData;
  //     } else {
  //       IfException.onError(res: res);
  //     }
  //   } on SocketException catch (_) {
  //     IfException.showMessage(
  //         message: LN.noInternetConnection, msg: Msg.Dialog);
  //   } on FormatException catch (_) {
  //     IfException.showMessage(message: LN.tryAgainAfterTime);
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  //   return null;
  //   // return null;
  // }

  static Future<bool?> pOPayInvoiceSendEmail(
      {required PayInvoiceSendEmailReq reqData}) async {
    // log(jsonEncode(reqData.toJson()));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._POS_IN_SEND_EMAIL,
        dataInJson: json.encode(reqData.toJson()),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        showToast(LN.emailIsSent);
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<SignatureRes?> printSignatureReceipt(
      {required String orderId}) async {
    final data = {"OrderId": orderId};
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._PRINT_SIG_RECEIPT,
        dataInJson: json.encode(data),
      );

      // log(jsonEncode(res.body));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return SignatureRes.fromJson(jsonDecode(res.body));
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> eftPosMerchantLogs({required MerchantLog data}) async {
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._EFTPOS_MERCHANT_LOGS,
        dataInJson: json.encode(data.toJson()),
      );

      // log(jsonEncode(res.body));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<EftposMerchantLogRes?> printEftPosMerchantLogs(
      {required String orderId}) async {
    final data = {"OrderId": orderId};
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._PRINT_EFTPOS_MERCHANT_LOGS,
        dataInJson: json.encode(data),
      );

      // log(jsonEncode(res.body));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return EftposMerchantLogRes.fromJson(jsonDecode(res.body));
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<AllOrdersRes?> getAllOrders({
    String searchKey = "",
    String storeChannelId = "",
    String orderStatusId = "",
    String orderTypeId = "",
    String tableId = "",
    int page = 1,
    int pageSize = 12,
  }) async {
    final body = {
      "Page": page,
      "PageSize": pageSize,
      "SearchKeywords": searchKey,
      "ExternalFilter": {
        "ChannelId": storeChannelId,
        "OrderStatusId": orderStatusId,
        "OrderTypeId": orderTypeId,
        "TableId": tableId,
      }
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_ALL_ORDERS,
        dataInJson: json.encode(body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllOrdersRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> changeOrderStatus({
    String orderId = "",
    String orderStatusId = "",
    String? trackingDetail,
  }) async {
    final _body = {
      "OrderId": orderId,
      "OrderStatusId": orderStatusId,
      if (trackingDetail?.isNotEmpty ?? false) "TrackingNumber": trackingDetail,
    };
    // log(json.encode(_body));
    return IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        api: Api._ORDER_CHANGE_STATUS,
        dataInJson: json.encode(_body),
      ),
      showToast: true,
      isDia: false,
    );
  }

  static Future<OrderDetailById?> getOrderDeById(
      {required String orderId}) async {
    // log(orderId);
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_OR_DETAILS(orderId),
      );
      // log(res.statusCode.toString());
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = OrderDetailById.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<OrderDetailById?> getOrderTranById(
      {required String orderId}) async {
    // log(orderId);
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_OR_TRAN_DETAILS(orderId),
      );
      // log(res.statusCode.toString());
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = OrderDetailById.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<PlaceOrderRes?> bulkOrderSendToKitUpdate({
    required List<String> orderIds,
  }) async {
    final body = {
      "OrderIds": orderIds,
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._BULK_ORDER_SEND_KIT,
        dataInJson: json.encode(body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = PlaceOrderRes.fromJson(jsonDecode(res.body));
        // showToast(resData.message ?? "");
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> bulkAcceptOrder({
    required List<String> orderIds,
  }) async {
    final body = {
      "OrderIds": orderIds,
    };
    // log(json.encode(_body));
    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      api: Api._BULK_ACCEPT_ORDER,
      dataInJson: json.encode(body),
    ));
  }

  static Future<PlaceOrderRes?> orderSentKitchen({
    String? orderId,
    bool? printAllItem,
    int? timeInMin,
    String? sessionId,
    String? posDeviceId,
    bool isSendToPrinter = false,
    bool isSendToKitchen = false,
  }) async {
    if (orderId == null) return null;

    final _body = {
      "OrderId": orderId,
      "IsSendToKitchenPrinter": isSendToPrinter,
      "IsSendToKitchenDisplay": isSendToKitchen,
      if (sessionId != null) "sessionId": sessionId,
      if (posDeviceId != null) "posDeviceId": posDeviceId,
      if (printAllItem != null) "printAllItems": printAllItem,
      if (timeInMin != null) "ExtendedPickupDeliveryTimeInMins": "$timeInMin",
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._POS_ORDER_SEND_KITCHEN,
        dataInJson: json.encode(_body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (res.body.isEmpty) return PlaceOrderRes(orderId: orderId);

        final resData = PlaceOrderRes.fromJson(jsonDecode(res.body));
        if ((resData.message?.isNotEmpty ?? false) &&
            (resData.printingDetailsResponseViewModels?.isEmpty ?? false)) {
          IfException.onError(res: res);
        }
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<MakePaymentRes?> orderPayInvoice({
    required String orderId,
  }) async {
    final body = {
      "OrderId": orderId,
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._POS_ORDER_PAY_INVOICE,
        dataInJson: json.encode(body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = MakePaymentRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<AllTableLayAddSecRes?> getAllTableLayAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_TABLE_LAY_ADD_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllTableLayAddSecRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<TableReservationCalender?> getTableReservCalender() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_TABLE_RESERV_CALENDER,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = TableReservationCalender.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> addUpTableLay({required TableLayReq tableLayReq}) async {
    // log(jsonEncode(tableLayReq.toJson()));
    return await IfException.boolExpt(
        function: Repo.post(
            h: await _header,
            api: Api._ADD_UP_TABLE_LAY,
            dataInJson: json.encode(tableLayReq.toJson())));
  }

  static Future<TableLayReq?> editTableLayout({required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_TABLE_LAY(id),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = TableLayReq.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<TableLayReq?> getTableLayout({required String tableId}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_TABLE_LAYOUT(tableId),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = TableLayReq.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<List<TableReservationStatus>?> getTableStatus() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_TABLE_STATUS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<TableReservationStatus>.from(json
            .decode(res.body)
            .map((x) => TableReservationStatus.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> updateTableStatus({
    required List<TableStatusUpdateReq> data,
  }) async {
    return IfException.boolExpt(
        isDia: false,
        function: Repo.post(
            h: await _header,
            api: Api._UPDATE_TABLE_STATUS,
            dataInJson: jsonEncode(data.map((e) => e.toJson()).toList())));
  }

  // static Future<bool?> updateTableStatusFree({
  //   String? tableId,
  //   String? tableName,
  // }) async {
  //   final data = {"Id": tableId, "Name": tableName};
  //   return IfException.boolExpt(
  //       showToast: false,
  //       function: Repo.post(
  //           h: await _header,
  //           api: Api._UPDATE_TABLE_STATUS_AVAI,
  //           dataInJson: jsonEncode(data)));
  // }

  static Future<bool?> switchTable({
    String? orderId,
    String? tableId,
    dynamic Function(bool)? onPopMsg,
  }) async {
    final _body = {
      "OrderId": orderId ?? '',
      "TableId": tableId ?? '',
    };
    return IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._SWITCH_TABLE,
          dataInJson: jsonEncode(_body)),
      onPopMsg: onPopMsg,
      isDia: false,
    );
  }

  static Future<bool?> mergeTable({
    required List<TableStatusUpdateReq> req,
    dynamic Function(bool)? onPopMsg,
  }) async {
    return IfException.boolExpt(
      showToast: true,
      function: Repo.post(
          h: await _header,
          api: Api._MERGE_TABLE,
          dataInJson: jsonEncode(req.map((e) => e.toJson()).toList())),
      onPopMsg: onPopMsg,
      isDia: false,
    );
  }

  static Future<AllTableLayRes?> getAllTableLayout() async {
    final body = {
      "Page": 1,
      "PageSize": 10,
      "ExternalFilter": {"Id": "test", "Name": ""}
    };
    try {
      final res = await Repo.post(
          h: await _header,
          api: Api._GET_ALL_TABLE_LAYOUT,
          dataInJson: json.encode(body));
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllTableLayRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<SyncSecListRes?> syncSecList() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._SYNC_SEC_LIST,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = SyncSecListRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> syncProduct(
      {required String syncFromChannelId,
      required String syncToChannelId}) async {
    final body = {
      "SyncFrom": {"ChannelId": syncFromChannelId},
      "SyncTo": {"ChannelId": syncToChannelId}
    };
    // log(jsonEncode(_body));

    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      api: Api._SYNC_PROD_FOOCTOOC,
      dataInJson: json.encode(body),
    ));
  }

  static Future<List<GetTranslatedLang>?> getTranslatedLang() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api.__GET_ALL_LANG_WIT_TRANS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<GetTranslatedLang>.from(
            json.decode(res.body).map((x) => GetTranslatedLang.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<void> changeLanguage({required String langId}) async {
    final body = {
      "LanguageId": langId,
    };
    // log(jsonEncode(_body));
    IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      api: Api._CHANGE_LANG,
      dataInJson: json.encode(body),
    ));
  }

  static Future<AllCustomer?> getAllCus({
    String keyword = "",
    required int page,
    required int pageSize,
  }) async {
    final data = {
      "Page": page,
      "PageSize": pageSize,
      "SearchKeywords": keyword,
      "ExternalFilter": {}
    };
    try {
      // log(json.encode(_data));
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_ALL_CUS,
        dataInJson: json.encode(data),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllCustomer.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  //get cus by id
  static Future<CusData?> getCusById({required String cusId}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_CUS(cusId),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = CusData.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  //add up cus
  static Future<bool?> addUpCus({required CusData cusData}) async {
    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      api: Api._ADD_UP_CUS,
      dataInJson: json.encode(cusData.toJson()),
    ));
  }

  static Future<AllTableRsrv?> getAllTabResv({
    int page = 1,
    int pageSize = 12,
    String keyword = "",
    String date = "",
    String channelId = "",
    String tableId = "",
    String statusId = "",
  }) async {
    final data = {
      "Page": page,
      "PageSize": pageSize,
      "SearchKeywords": keyword,
      "ExternalFilter": {
        "Date": date,
        "OrderChannelId": channelId,
        "TableId": tableId,
        "TableReservationStatusId": statusId,
      }
    };
    // log(json.encode(_data));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_ALL_TAB_RESV,
        dataInJson: json.encode(data),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllTableRsrv.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> addUpTableRerv(
      {required TableResvModel tableResvModel, BuildContext? diaCtx}) async {
    // log(jsonEncode(tableResvModel.toJson()));

    return IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        api: Api._ADD_UP_TAB_RESV,
        dataInJson: json.encode(tableResvModel.toJson()),
      ),
      diaCtx: diaCtx,
    );
  }

  static Future<bool?> confirmTabRes(
      {required List<ConfirmTabRes> confirmTabResList}) async {
    final data = confirmTabResList.map((e) => e.toJson()).toList();
    // log(jsonEncode(_data));
    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      api: Api._CONFIRM_TAB_RESV,
      dataInJson: json.encode(data),
    ));
  }

  static Future<bool?> cancelBooking(
      {required List<ConfirmTabRes> confirmTabResList}) async {
    final _data = confirmTabResList.map((e) => e.toJson()).toList();
    // log(jsonEncode(_data));
    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      api: Api._CANCEL_BOOKING,
      dataInJson: json.encode(_data),
    ));
  }

  static Future<bool?> arriveBooking({required String id}) async {
    final _data = {
      "Id": id,
    };
    // log(jsonEncode(_data));
    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      api: Api._ARRIVE_BOOKING,
      dataInJson: json.encode(_data),
    ));
  }

  static Future<EditTableResv?> editTableResv({required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_TABLE_RE(id),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = EditTableResv.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<NotificationType?> getNotifyType({required int page}) async {
    final body = {
      "Page": page,
      "PageSize": 10,
      "ExternalFilter": {"Id": "test", "Name": ""},
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._NOTIFICATION_TYPE,
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = NotificationType.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpNotifyType(
      {required List<NotifyData> notifyData}) async {
    final body = notifyData
        .map((e) => {
              "Id": e.id,
              "IsActive": e.isActive,
            })
        .toList();
    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(body),
      api: Api._ADD_UP_NOTIFy_TYPE,
    ));
  }

  static Future<GetAllPaymentMethod?> getAllPayMethod() async {
    final body = {
      "Page": 1,
      "PageSize": 10,
      "ExternalFilter": {"Id": "test", "Name": ""}
    };
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_ALL_PAY_METHOD,
        dataInJson: json.encode(body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = GetAllPaymentMethod.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> addUpPayMethod(
      {required List<PayMethodModel> payMethod}) async {
    final body = payMethod.map((e) => e.toJson()).toList();

    // log(json.encode(_body));

    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(body),
      api: Api._ADD_UP_PAY_METHOD,
    ));
  }

  static Future<bool?> generateQR4table({
    required String tableId,
  }) async {
    final body = {
      "Id": tableId,
    };
    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(body),
      api: Api._GENERATE_QR,
    ));
  }

  static Future<List<TableQr>?> getTableQr({
    required String tableId,
  }) async {
    final body = {
      "Id": tableId,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_TABLE_QR,
        dataInJson: json.encode(body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<TableQr>.from(
            json.decode(res.body).map((x) => TableQr.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<List<BillingSubsPlan>?> getBillingSubsPlan() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_BILL_SUBS_PLAN,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<BillingSubsPlan>.from(
            json.decode(res.body).map((x) => BillingSubsPlan.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<BillingSubsAddSec?> getBillingSubsAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_SUBS_ADD_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = BillingSubsAddSec.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> createSubsAndBilling(
      {required SubsAndBilling subsAndBilling}) async {
    // log(json.encode(subsAndBilling.toJson()));
    return IfException.boolExpt(
        function: Repo.post(
            h: await _header,
            api: Api._CREATE_SUBS_BILL,
            dataInJson: json.encode(subsAndBilling.toJson())));
  }

  // static Future<PosActivate?> activateDevice({
  //   required String key,
  //   required String nameOrLoc,
  // }) async {
  //   final body = {
  //     "ActivationKey": key,
  //     "DeviceIdentifier": await SupportHandler.getDeviceId,
  //     "DeviceNameOrLocation": nameOrLoc,
  //   };
  //   // log(json.encode(_body));

  //   try {
  //     final res = await Repo.post(
  //         h: await _header,
  //         api: Api._ACTIVATE_POS_DEVICE,
  //         dataInJson: json.encode(body));
  //     // log(res.body);
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       final resData = PosActivate.fromJson(json.decode(res.body));
  //       return resData;
  //     } else {
  //       IfException.onError(res: res);
  //     }
  //   } on SocketException catch (_) {
  //     IfException.showMessage(
  //         message: LN.noInternetConnection, msg: Msg.Dialog);
  //   } on FormatException catch (_) {
  //     IfException.showMessage(message: LN.tryAgainAfterTime);
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  //   return null;
  // }

  static Future<UserStoresRes?> getStoreList() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_USER_STORES,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return UserStoresRes.fromJson(json.decode(res.body));
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<StoreDetailRes?> getStoreDetail() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_USER_STORE_DETAIL,
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return StoreDetailRes.fromJson(json.decode(res.body));
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> enableDis2fa({
    required String email,
    required bool isEnable,
  }) async {
    final body = {
      "Email": email,
      "IsEnable": isEnable,
    };
    // log(json.encode(_body));

    try {
      final res = await Repo.post(
          h: await _header, api: Api._ENDIS2FA, dataInJson: json.encode(body));
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        // final resData = PosActivate.fromJson(json.decode(res.body));
        // showToast(LN.twoFaUp);
        IfException.showMessage(message: LN.twoFaUp, isError: false);
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<UserInfo?> getUserInfo({required String userId}) async {
    try {
      // log(_userId);
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_USER_B_ID(userId),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = UserInfo.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<EmployeeInfo?> getEmployeeInfo({required String empId}) async {
    try {
      // log(_userId);
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_EMP_B_ID(empId),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = EmployeeInfo.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> updateUserProfile({
    required CreateUpUser updateUser,
    String? filePath,
  }) async {
    // log(json.encode(updateUser.toJson()));

    return IfException.boolExpt(
        function: Repo.httpPostFile(
      h: await _header,
      api: Api._UPDATE_USER,
      data: {
        "Request": json.encode(updateUser.toJson()),
      },
      filePath: filePath ?? '',
    ));
  }

  static Future<bool?> createUpUser({
    required CreateUpUser createUpUser,
    String? filePath,
  }) async {
    // log(json.encode(createUpUser.toJson()));

    return IfException.boolExpt(
        function: Repo.httpPostFile(
      h: await _header,
      api: Api._ADD_UP_USER,
      data: {
        "Request": json.encode(createUpUser.toJson()),
      },
      filePath: filePath ?? '',
    ));
  }

  static Future<bool?> addUpEmployee({
    required EmployeeInfo emp,
    String? filePath,
  }) async {
    return IfException.boolExpt(
        function: Repo.httpPostFile(
      h: await _header,
      api: Api._ADD_UP_EMP,
      data: {
        "Request": json.encode(emp.toJson()),
      },
      filePath: filePath,
    ));
  }

  static Future<UserAddSec?> getUserAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_USER_ADD_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = UserAddSec.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<EmpAddSec?> getEmpAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_EMP_ADD_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = EmpAddSec.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<ReportAddSec?> getReportAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_REPORT_ADD_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = ReportAddSec.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<HistoryReport?> historyReport({
    required String paymentMethodId,
    required String fromDate,
    required String toDate,
    required String channelId,
    int page = 1,
    int pageSize = 10,
  }) async {
    final body = {
      "Page": page,
      "PageSize": pageSize,
      "ExternalFilter": {
        "PaymentMethodId": paymentMethodId,
        "FromDate": fromDate,
        "ToDate": toDate,
        "ChannelId": channelId,
      }
    };
    // log(json.encode(_body));

    try {
      final res = await Repo.post(
          h: await _header,
          api: Api._HISTORY_REPORT,
          dataInJson: json.encode(body));
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = HistoryReport.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<AllBillAndSubs?> getAllBillAndSubs() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_SUBS_AND_BILLING,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllBillAndSubs.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> changeBillSubsPlan({
    required String ssPlanId,
    required String subsPlanId,
    required String numOfPosLoc,
    BuildContext? ctx,
  }) async {
    final body = {
      "StoreSubscriptionPlanId": ssPlanId,
      "SubscripitonPlanId": subsPlanId,
      "NumberofPOSLocation": numOfPosLoc,
    };
    // log(json.encode(_body));

    return await IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._CHANGE_SUBS_PLAN,
          dataInJson: json.encode(body)),
      diaCtx: ctx,
    );
  }

  // static Future<AllUsers?> getAllUsers({
  //   String userType = "",
  //   String searchKey = "",
  //   int page = 1,
  //   int pageSize = 10,
  // }) async {
  //   final body = {
  //     "Page": page,
  //     "PageSize": pageSize,
  //     "SearchKeywords": searchKey,
  //     "ExternalFilter": {
  //       "UserType": userType,
  //     }
  //   };
  //   // log(json.encode(_body));

  //   try {
  //     final res = await Repo.post(
  //         h: await _header,
  //         api: Api._GET_ALL_USERS,
  //         dataInJson: json.encode(body));
  //     // log(res.body);
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       final resData = AllUsers.fromJson(json.decode(res.body));
  //       return resData;
  //     } else {
  //       IfException.onError(res: res);
  //     }
  //   } on SocketException catch (_) {
  //     IfException.showMessage(
  //         message: LN.noInternetConnection, msg: Msg.Dialog);
  //   } on FormatException catch (_) {
  //     IfException.showMessage(message: LN.tryAgainAfterTime);
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  //   return null;
  // }

  static Future<AllEmployees?> getAllEmployees({
    String searchKey = "",
    int page = 1,
    int pageSize = 10,
  }) async {
    final body = {
      "Page": page,
      "PageSize": pageSize,
      "SearchKeywords": searchKey,
      "ExternalFilter": {}
    };
    // log(json.encode(_body));

    try {
      final res = await Repo.post(
          h: await _header,
          api: Api._GET_ALL_EMPLOYEES,
          dataInJson: json.encode(body));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllEmployees.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<BillingSubsAddSec?> getCommonListCountry() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._REGISTER_ADD_SECTION,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return BillingSubsAddSec.fromJson(json.decode(res.body));
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<List<NewOrderNotifi>?> getAllNewOrdNoti() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_NEW_NOTI,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return List<NewOrderNotifi>.from(
            json.decode(res.body).map((x) => NewOrderNotifi.fromJson(x)));
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // Fluttertoast.showToast(msg: LN.noInternetConnection);
      // return Future.error(LN.noInternetConnection);
    } on FormatException catch (_) {
      // Fluttertoast.showToast(msg: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<NotificationData?> getAllNotification({
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      "Page": page,
      "PageSize": pageSize,
    };

    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(data),
        api: Api._GET_ALL_NOTIFICATION,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return NotificationData.fromJson(json.decode(res.body));
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> markAllNotifySeen() async {
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._MARK_ALL_NOTIFY_SEEN,
      );
      // log(res.body);
      // log(res.statusCode.toString());
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> updateOrdNotifi({
    required String id,
  }) async {
    final body = {
      "Id": id,
    };
    // log(json.encode(_body));

    try {
      final res = await Repo.post(
          h: await _header,
          api: Api._UPDATE_ORD_NOTI,
          dataInJson: json.encode(body));
      // log(res.statusCode.toString());
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        // final resData = AllUsers.fromJson(json.decode(res.body));
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<AccIntegAddSec?> getAcIntegSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_AC_INTEG_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AccIntegAddSec.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<PlatInteConnById?> getPlatIntegConnById(String id) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_AC_PLAT_CON_B_PLAT_ID(id),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = PlatInteConnById.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<List<ChartOfAccModel>?> getChartOfAccInteById(String id) async {
    try {
      // log(id);
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_AC_CHART_AC_INTE(id),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<ChartOfAccModel>.from(
            json.decode(res.body).map((x) => ChartOfAccModel.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> addUpPlatIntegConn({
    required PlatInteConnById platInteConnById,
    BuildContext? diaCtx,
    bool showToast = true,
  }) async {
    // log(json.encode(platInteConnById.toJson()));

    return await IfException.boolExpt(
        diaCtx: diaCtx,
        showToast: showToast,
        function: Repo.post(
            h: await _header,
            api: Api._ADD_UP_PLAT_INTEG_CONN,
            dataInJson: json.encode(platInteConnById.toJson())));
  }

  static Future<bool?> addUpChartOfAcMap({
    required List<ChartOfAccModel> accMap,
  }) async {
    final data = json.encode((accMap.map((e) => e.toJson()).toList()));
    // log(_data);

    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      api: Api._ADD_UP_CHART_OF_AC_MAP,
      dataInJson: data,
    ));
  }

  static Future<AccContactSetting?> getAccContactSetting(
      {required String id}) async {
    try {
      // log(id);
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ACC_CONTACT_SETTING(id),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AccContactSetting.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> createUpAccContactSetting(
      {AccContactSetting? accContactSetting}) async {
    // log(_data);
    // log(json.encode(accContactSetting?.toJson()));

    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      api: Api._CREATE_UP_ACC_CONTACT_SETTING,
      dataInJson: json.encode(accContactSetting?.toJson()),
    ));
  }

  static Future<bool?> deleteIntegPlat({SRDatum? data}) async {
    // log(_data);
    // log(json.encode(accContactSetting?.toJson()));

    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      api: Api._DELETE_INTEGRATION_PLAT,
      dataInJson: json.encode([data?.toJson()]),
    ));
  }

  static Future<List<UserAddSecData>?> getLoginBannners() async {
    try {
      final res = await Repo.get(
        api: Api._LOGIN_BANNER,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<UserAddSecData>.from(
            json.decode(res.body).map((x) => UserAddSecData.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> applyLucaPay({
    required Map<String, dynamic> body,
  }) async {
    // log(json.encode(body));

    return await IfException.boolExpt(
        function: Repo.post(
            h: await _header,
            api: Api._APPLY_STC_LUCA_PAY,
            dataInJson: json.encode(body)));
  }

  static Future<ViewKeys?> getAllUserPermission() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_USER_PER,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = ViewKeys.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<AllCashInOut?> getAllCashInOut({
    int page = 1,
    required String date,
  }) async {
    final body = {
      "Page": page,
      "PageSize": 100,
      "SearchKeywords": "",
      "ExternalFilter": {
        "Date": date,
      }
    };
    // log(json.encode(_body));

    try {
      final res = await Repo.post(
          h: await _header,
          api: Api._ALL_CASH_INOUT,
          dataInJson: json.encode(body));
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllCashInOut.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpCashInOut({
    required CashInOutData req,
  }) async {
    // log(json.encode(req.toJson()));

    return await IfException.boolExpt(
        function: Repo.post(
            h: await _header,
            api: Api._ADD_UP_CASH_IN_OUT,
            dataInJson: json.encode(req.toJson())));
  }

  static Future<CashInOutData?> editCashInOut({required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_CASH_INOUT(id),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = CashInOutData.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<AllEodData?> allEodFinalized({
    int page = 1,
    required String date,
    String? platId,
    String? taxTypeId,
  }) async {
    final body = {
      "Page": page,
      "PageSize": 100,
      "SearchKeywords": "",
      "ExternalFilter": {
        "Date": date,
        "AccountingPlatFormId": platId,
        "TaxExclusiveInclusiveId": taxTypeId,
      }
    };
    // log(json.encode(_body));

    try {
      final res = await Repo.post(
          h: await _header,
          api: Api._ALL_EOD_FINAL,
          dataInJson: json.encode(body));
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllEodData.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<EodAddSec?> allEodSecList() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._ALL_EOD_SEC_LIST,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = EodAddSec.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> finalizeEod({required FinalizeEodReq reqData}) async {
    // log(json.encode(reqData.toJson()));

    return IfException.boolExpt(
        function: Repo.post(
            h: await _header,
            api: Api._FINALIZE_EOD,
            dataInJson: json.encode(reqData.toJson())));
  }

  static Future<EodReportRes?> printEod({
    String? date,
    String? taxTypeId,
  }) async {
    final data = {
      "Date": date,
      "TaxExclusiveInclusiveId": taxTypeId,
    };

    try {
      final res = await Repo.post(
          h: await _header, api: Api._PRINT_EOD, dataInJson: json.encode(data));
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return EodReportRes.fromJson(json.decode(res.body));
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<Message?> registerUser(
      {required RegisterReq registerReq}) async {
    // log(json.encode(registerReq.toJson()));

    try {
      final res = await Repo.post(
          h: await _header,
          api: Api._REGISTER_USER,
          dataInJson: json.encode(registerReq.toJson()));
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = SettingRes.fromJson(json.decode(res.body));
        if (resData.message != null && resData.message!.isNotEmpty) {
          // showToast(resData.message!.first.message ?? '');
          return resData.message?.first;
        }
      } else {
        return Future.error(IfException.onError(res: res, showToast: false));
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<BoardStoreAddSec?> boardAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._BOARD_ADD_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = BoardStoreAddSec.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> boardStore({required BoardStoreReq req}) async {
    // log(json.encode(req.toJson()));

    return IfException.boolExpt(
        function: Repo.post(
            h: await _header,
            api: Api._BOARD_STORE,
            dataInJson: json.encode(req.toJson())));
  }

  static Future<bool?> addUpdateSubCat({
    required SubCatAddReq subcat,
    bool showToast = true,
  }) async {
    // log(jsonEncode(subcatList.map((e) => e.toJson()).toList()));
    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(subcat.toJson()),
        api: Api._ADD_UPDATE_SUB_CAT,
      ),
      showToast: showToast,
    );
  }

  static Future<AllSubCat?> getSubCat(
      {required int page, String searchKey = ''}) async {
    final _body = {
      "Page": page,
      "PageSize": 10,
      "SearchKeyWords": searchKey,
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._GET_SUB_CAT,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllSubCat.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<SubCatAddSec?> getSubCatAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_SUB_CAT_ADD_SEC,
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final redData = SubCatAddSec.fromJson(jsonDecode(res.body));
        return redData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> deleteSubCat({required List<SRDatum> subCatList}) async {
    final body = List.generate(
        subCatList.length,
        (index) => {
              "Id": subCatList[index].id,
              "Name": subCatList[index].name,
            });

    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._DELETE_SUB_CAT,
      ),
      messge: body.length > 1 ? "${body.length} ${LN.subCatsDeleted}" : "",
    );
  }

  static Future<SubCatAddReq?> editSubCat({required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_SUB_CAT(id),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = SubCatAddReq.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  // static Future<DashboardRes?> getAllPosDashboard() async {
  //   try {
  //     final res = await Repo.get(
  //       h: await _header,
  //       api: Api._POS_DASHBOARD,
  //     );
  //     // log(res.body);
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       final resData = DashboardRes.fromJson(jsonDecode(res.body));
  //       return resData;
  //     } else {
  //       IfException.onError(res: res);
  //     }
  //   } on SocketException catch (_) {
  //     IfException.showMessage(
  //         message: LN.noInternetConnection, msg: Msg.Dialog);
  //   } on FormatException catch (_) {
  //     IfException.showMessage(message: LN.tryAgainAfterTime);
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  //   return null;
  // }

  static Future<List<RecommendedProductsModel>?>
      getRecommendedProducts() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._DASH_RECOMM_PRODS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return List<RecommendedProductsModel>.from(jsonDecode(res.body)
            .map((x) => RecommendedProductsModel.fromJson(x)));
        // final resData = DashboardRes.fromJson(jsonDecode(res.body));
        // return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<PaymentMethodModel>?> getSalesByPaymentMethod() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._DASH_SALES_BY_PAY_METHOD,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return List<PaymentMethodModel>.from(
            jsonDecode(res.body).map((x) => PaymentMethodModel.fromJson(x)));
        // final resData = DashboardRes.fromJson(jsonDecode(res.body));
        // return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<AvailiableChannel>?> getAvailableChannels() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._DASH_AVAI_CHANNELS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return List<AvailiableChannel>.from(
            jsonDecode(res.body).map((x) => AvailiableChannel.fromJson(x)));
        // final resData = DashboardRes.fromJson(jsonDecode(res.body));
        // return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<SalesChannelMonthModel>?>
      getSalesByChannelWithMonths() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._DASH_SALES_BY_CHANNEL,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return List<SalesChannelMonthModel>.from(jsonDecode(res.body)
            .map((x) => SalesChannelMonthModel.fromJson(x)));

        // final resData = DashboardRes.fromJson(jsonDecode(res.body));
        // return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<SalesByCategoryModel>?> getSalesByCategory() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._DASH_SALES_BY_CATS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return List<SalesByCategoryModel>.from(
            jsonDecode(res.body).map((x) => SalesByCategoryModel.fromJson(x)));
        // final resData = DashboardRes.fromJson(jsonDecode(res.body));
        // return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<DashBoardStatisticsToday?> getDashboardStatisticsToday() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._DASH_STATS_TODAYS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = DashBoardStatisticsToday.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<EmployeeSalesModel>?> getEmployeeSales() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._DASH_EMPLOYEE_SALES,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return List<EmployeeSalesModel>.from(
            jsonDecode(res.body).map((x) => EmployeeSalesModel.fromJson(x)));
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<UserAddSecData>?> getLockScreenBanner() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._SCREEN_LOCK_BANNER_LIST,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<UserAddSecData>.from(
            jsonDecode(res.body).map((x) => UserAddSecData.fromJson(x)));
        return resData;
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> checkStatusCode({required String api}) async {
    final res = await Repo.get(
      api: api,
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    }
    return null;
  }

  static Future<BarCodeTypeAddSec?> getBarcodeAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._BAR_CODE_ADD_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = BarCodeTypeAddSec.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<BarCodeTypeList?> getAllBarCodes({required int page}) async {
    final body = {
      "Page": page,
      "PageSize": 10,
      "ExternalFilter": {"SearchKeyWords": ""},
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._GET_BAR_CODE_TYPE,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final pCatRes = BarCodeTypeList.fromJson(jsonDecode(res.body));
        return pCatRes;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> updateBarCodeType({required BarCodeReq req}) async {
    final body = [req.toJson()];

    // log(jsonEncode(_body));

    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(body),
      api: Api._UPDATE_BAR_CODE_TYPE,
    ));
  }

  static Future<List<RetailProductRes>?> getRetailPosOrderProduct() async {
    try {
      final res = await Repo.get(
        h: await _header,
        // dataInJson: jsonEncode(_body),
        api: Api._RETAIL_POS_ORDER_PRODUCT,
      );

      // log(res.body);s

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<RetailProductRes>.from(
            jsonDecode(res.body).map((x) => RetailProductRes.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<GiftCardAddSec?> giftCardAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GIFT_CARD_ADD_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = GiftCardAddSec.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpGiftCards({
    required GiftcardReq req,
  }) async {
    // log(jsonEncode(req.toJson()));

    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(req.toJson()),
      api: Api._ADD_UP_GIFTS,
    ));
  }

  static Future<GiftRedeemHistory?> getGiftCardDetail({
    required String id,
  }) async {
    final body = {
      "Id": id,
    };
    // log(jsonEncode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._GIFT_DETAILS_WITH_REEDEM_SUMM,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = GiftRedeemHistory.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> deactivateGiftCard({
    required String id,
  }) async {
    final body = {
      "Id": id,
    };
    // log(jsonEncode(_body));

    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(body),
      api: Api._DEACT_GIFT_CARD,
    ));
  }

  static Future<GiftCardSearchSec?> giftCardSearchList() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GIFT_SEARCH_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = GiftCardSearchSec.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<AllGiftCardRes?> getAllGiftCard({
    int page = 1,
    int pageSize = 10,
    String code = "",
    String reName = "",
    String statusId = "",
    String dateFrom = "",
    String dateTo = "",
  }) async {
    final body = {
      "Page": page,
      "PageSize": pageSize,
      "ExternalFilter": {
        "GiftCardCode": code,
        "ReceiverName": reName,
        "GiftCardStatusId": statusId,
        "ExpiryDateFrom": dateFrom,
        "ExpiryDateTo": dateTo,
      }
    };
    // log(jsonEncode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._GET_ALL_GIFTS,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllGiftCardRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<GiftCardCheckModel> checkGiftBalance({
    required String code,
  }) async {
    final body = {"GiftCardCode": code};
    GiftCardCheckModel resData;
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._GIFT_BALANCE_CHECK,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        resData = GiftCardCheckModel.fromJson(jsonDecode(res.body));
      } else {
        final error = GiftCardCheckErrorModel.fromJson(jsonDecode(res.body));
        resData = GiftCardCheckModel(
          message: error.message.isNotEmpty
              ? error.message[0].message
              : "Some error occurred",
        );
      }
    } on SocketException catch (_) {
      resData = GiftCardCheckModel(
        message: LN.noInternetConnection,
      );
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      resData = GiftCardCheckModel(
        message: LN.tryAgainAfterTime,
      );
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      resData = GiftCardCheckModel(
        message: "",
      );
      IfException.showMessage(message: LN.tryAgainAfterTime);
    }
    return resData;
  }

  // gift card image

  static Future<GiftCardImageAddSec?> giftCardImageAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GIFT_CARD_IMAGE_ADD_SEC,
      );
      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = GiftCardImageAddSec.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> createGiftCardTemplateGroup({
    GiftCardTempData? giftCardTempData,
  }) async {
    if (giftCardTempData == null) return null;

    // log(imagePath ?? '');

    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(giftCardTempData),
      api: Api._GIFT_CARD_TEMPLATE_GROUP_CREATE,
    ));
  }

  static Future<bool?> createUpGiftCardImage({
    GiftCardImageData? giftCardImageData,
    String? imagePath,
  }) async {
    if (giftCardImageData == null) return null;

    // log(jsonEncode(giftCardImageData.toJson()));
    // log(imagePath ?? '');

    return IfException.boolExpt(
        function: Repo.httpPostFile(
      h: await _header,
      data: {
        "Request": json.encode(giftCardImageData.toJson()),
      },
      api: Api._GIFT_CARD_IMAGE_CREATE,
      filePath: imagePath,
    ));
  }

  static Future<GiftCardTempData?> giftCardTempGroupEdit({String? id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: '${Api._GIFT_CARD_TEMPLATE_GROUP_EDIT}/$id',
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = GiftCardTempData.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<GiftCardImageData?> giftCardImageEdit({String? id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: '${Api._GIFT_CARD_IMAGE_EDIT}/$id',
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = GiftCardImageData.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<AllGiftCardImageRes?> getAllGiftCardTemplate({
    int page = 1,
    int pageSize = 10,
    String searchKey = "",
  }) async {
    final data = {
      "Page": page,
      "PageSize": pageSize,
      "SearchKeywords": searchKey,
    };

    // log(jsonEncode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(data),
        api: Api._GIFT_CARD_TEMPLATE_GROUP,
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllGiftCardImageRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<AllGiftCardImageRes?> getAllGiftCardImage({
    int page = 1,
    int pageSize = 500,
    String searchKey = "",
  }) async {
    final data = {
      "Page": page,
      "PageSize": pageSize,
      "SearchKeywords": searchKey,
    };

    // log(jsonEncode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(data),
        api: Api._GIFT_CARD_IMAGE_GET_ALL,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllGiftCardImageRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<OrderDetailById?> getOrderDeByIdForRefund(
      {required String orderId}) async {
    // log(orderId);
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ORDER_DETAIL_4_REFUND(orderId),
      );
      // log(res.statusCode.toString());
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = OrderDetailById.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<RefundPaymentRes?> makeRefund(
      {required RefundOrderReq refundOrderReq}) async {
    // log(jsonEncode(refundOrderReq.toJson()));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(refundOrderReq.toJson()),
        api: Api._MAKE_REFUND,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = RefundPaymentRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      showToast(LN.noInternetConnection);
    } on FormatException catch (_) {
      showToast(LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<RefundPaymentRes?> orderRefundInvoice({
    required String orderId,
  }) async {
    final body = {
      "OrderId": orderId,
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._REFUND_INVOICE_PRINT,
        dataInJson: json.encode(body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = RefundPaymentRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<BarcodeAddSec?> getBarcodeSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._BAR_CODE_SEC_LIST,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = BarcodeAddSec.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> generateBarcode({
    required GenerateBarcodeReq data,
    BuildContext? diaCtx,
  }) async {
    // log(jsonEncode(data.toJson()));

    return IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(data.toJson()),
        api: Api._GENERATE_BARCODE,
      ),
      diaCtx: diaCtx,
    );
  }

  static Future<BarcodePrintRes?> printBarcode({
    required GenerateBarcodeReq data,
    BuildContext? diaCtx,
  }) async {
    // log(jsonEncode(data.toJson()));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(data.toJson()),
        api: Api._PRINT_BARCODE,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = BarcodePrintRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<List<OnlineOrderId>?> getOnlineOrderFotSTK() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._POS_ONLINE_ORDER_SEND_KITCHEN,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return List<OnlineOrderId>.from(
            json.decode(res.body).map((x) => OnlineOrderId.fromJson(x)));
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // Fluttertoast.showToast(msg: LN.noInternetConnection);
      // return Future.error(LN.noInternetConnection);
    } on FormatException catch (_) {
      // Fluttertoast.showToast(msg: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<List<OrderPrintStatus>?> getOrderPrintStatus() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ORDER_PRINT_STATUS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return List<OrderPrintStatus>.from(
            json.decode(res.body).map((x) => OrderPrintStatus.fromJson(x)));
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // Fluttertoast.showToast(msg: LN.noInternetConnection);
      // return Future.error(LN.noInternetConnection);
    } on FormatException catch (_) {
      // Fluttertoast.showToast(msg: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> confirmOrderSendToKitPrint({
    required List<Map<String, dynamic>> data,
  }) async {
    // log(json.encode(data));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._CONFIRM_ON_ORDER_SEND_KITCHEN,
        dataInJson: json.encode(data),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        // final resData = RefundPaymentRes.fromJson(jsonDecode(res.body));
        return true;
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  // static Future<bool?> confirmOnlineOrderSendToKitPrint({
  //   required List<Map<String, dynamic>> data,
  // }) async {
  //   // log(json.encode(data));
  //   try {
  //     final res = await Repo.post(
  //       h: await _header,
  //       api: Api._CONFIRM_ON_ORDER_SEND_KITCHEN,
  //       dataInJson: json.encode(data),
  //     );
  //     // log(res.body);
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       // final resData = RefundPaymentRes.fromJson(jsonDecode(res.body));
  //       return true;
  //     } else {
  //       // IfException.onError(res: res);
  //     }
  //   } on SocketException catch (_) {
  //     // IfException.showMessage(
  //     //     message: LN.noInternetConnection, msg: Msg.Dialog);
  //   } on FormatException catch (_) {
  //     // IfException.showMessage(message: LN.tryAgainAfterTime);
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  //   return null;
  //   // return null;
  // }

  static Future<bool?> addRecentCalls({
    String? phone,
    bool isAccept = false,
  }) async {
    final data = {"PhoneNumber": phone, "IsAccepted": isAccept};
    // log(json.encode(data));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._ADD_RECENT_CALL,
        dataInJson: json.encode(data),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        // final resData = RefundPaymentRes.fromJson(jsonDecode(res.body));
        return true;
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<RecentCallRes?> getRecentCalls({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final data = {
        "Page": page,
        "PageSize": pageSize,
        "SearchKeywords": "",
      };

      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(data),
        api: Api._GET_RECENT_CALLS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = RecentCallRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<SmsCusDetail?> getSmsCusDetails(
      {required String orderId}) async {
    // log(orderId);
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_SMS_CUS_DETAILS(orderId),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = SmsCusDetail.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> sendOrderReadySms({
    OrderSmsSendReq? smsSendReq,
    BuildContext? diaCtx,
  }) async {
    // log(jsonEncode(data.toJson()));

    return IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(smsSendReq?.toJson()),
        api: Api._SEND_ORDER_READY_SMS,
      ),
      diaCtx: diaCtx,
    );
  }

  static Future<SmsSetupRes?> getAllSmsSetting({
    int page = 1,
    int pageSize = 10,
    String searchKey = "",
  }) async {
    try {
      final data = {
        "Page": page,
        "PageSize": pageSize,
        "SearchKeywords": searchKey,
      };

      final res = await Repo.post(
        h: await _header,
        dataInJson: json.encode(data),
        api: Api._GET_ALL_SMS_SETTING,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return SmsSetupRes.fromJson(json.decode(res.body));
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> createUpSmsSettings({
    SmsSetupData? reqData,
  }) async {
    return IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(reqData?.toJson()),
        api: Api._CREATE_UP_SMS_SET,
      ),
    );
  }

  static Future<EmailSetupRes?> getAllEmailSetting({
    int page = 1,
    int pageSize = 10,
    String searchKey = "",
  }) async {
    try {
      final data = {
        "Page": page,
        "PageSize": pageSize,
        "SearchKeywords": searchKey,
      };

      final res = await Repo.post(
        h: await _header,
        dataInJson: json.encode(data),
        api: Api._GET_EMAIL_SETTING,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return EmailSetupRes.fromJson(json.decode(res.body));
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<PosScreenCatRes?> getAllPosOrCats() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._POSOrderScreenCategories,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = PosScreenCatRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<PosComboRes?> getAllPosComboProducts({
    String catId = "",
    String? channelEnum,
    int page = 1,
    int pageSize = 24,
    String searchKey = "",
    String alphaId = "",
  }) async {
    final body = {
      "CategoryId": catId,
      "OrderChannelEnum": channelEnum ?? "",
      "Page": page,
      "PageSize": pageSize,
      "SearchKeywords": searchKey,
      "AlphabetSearch": alphaId,
    };
    // log(jsonEncode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._POSOrderScreenComboProducts,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = PosComboRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<PosIngreRes?> getAllPosRawIngredients({
    String catId = "",
    String? channelEnum,
    int page = 1,
    int pageSize = 24,
    String searchKey = "",
    String alphaId = "",
  }) async {
    final body = {
      "CategoryId": catId,
      "OrderChannelEnum": channelEnum ?? "",
      "Page": page,
      "PageSize": pageSize,
      "SearchKeywords": searchKey,
      "AlphabetSearch": alphaId,
    };
    // log(jsonEncode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._POSOrderScreenRawLooseProducts,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = PosIngreRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<ComboDetailById?> getSetMenuDetailById(
      {required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._SetMenuDetailsById(id),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = ComboDetailById.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<List<CategoryData>?> getRetailComboCats() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._RETAIL_COMBO_CATS,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (res.body.isEmpty) return null;
        final resData = List<CategoryData>.from(
            jsonDecode(res.body).map((x) => CategoryData.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<CategoryData>?> getRetailIngreCats() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._RETAIL_INGRE_CATS,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (res.body.isEmpty) return null;
        final resData = List<CategoryData>.from(
            jsonDecode(res.body).map((x) => CategoryData.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<KitAllOrders?> getKDOrders({
    String searchKey = "",
    String storeChannelId = "",
    String orderStatusId = "",
    String orderTypeId = "",
    String tableId = "",
    String date = "",
    int page = 1,
    int pageSize = 12,
  }) async {
    final body = {
      "Page": page,
      "PageSize": pageSize,
      "SearchKeywords": searchKey,
      "ExternalFilter": {
        "ChannelId": storeChannelId,
        "OrderStatusId": orderStatusId,
        "OrderTypeId": orderTypeId,
        "TableId": tableId,
        "Date": date,
      }
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._KDOrders,
        dataInJson: json.encode(body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = KitAllOrders.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> kitOrderStatusUpdate({
    String orderId = "",
    String orderStatusId = "",
  }) async {
    final body = {
      "OrderId": orderId,
      "OrderStatusId": orderStatusId,
    };
    // log(json.encode(_body));

    return await IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._KDOrderStatusUpdate,
          dataInJson: json.encode(body)),
      showToast: false,
    );
  }

  static Future<bool?> kitOrderItemStatusUpdate({
    String? orderId,
    List<String>? orderItemIds,
    List<String>? setmenuIds,
    bool isPrepared = false,
  }) async {
    final body = {
      "OrderId": orderId,
      "Type": setmenuIds != null ? "setMenu" : "OrderItems",
      if (setmenuIds != null) "SetMenuOrderItemIds": setmenuIds,
      if (orderItemIds != null) "OrderItemsIds": orderItemIds,
      "IsPrepared": isPrepared,
    };
    // log(json.encode(_body));

    return await IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._kDOrderItemStatus,
          dataInJson: json.encode(body)),
      showToast: false,
    );
  }

  static Future<bool?> kitPriorOrder(
      {List<Map<String, String>>? dataList}) async {
    // log(json.encode(_body));

    return await IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._kDPriorOrder,
          dataInJson: json.encode(dataList)),
      showToast: false,
    );
  }

  static Future<bool?> createUpEmailSettings(
      {List<EmailSetupData>? setupReqList}) async {
    return IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(setupReqList?.map((e) => e.toJson()).toList()),
        api: Api._CREATE_UP_EMAIL_SET,
      ),
    );
  }

  static Future<bool?> generateQRForPos({String? deviceId}) async {
    final body = {
      "DeviceIdentifier": deviceId,
    };

    return IfException.boolExpt(
        function: Repo.post(
      h: await _header,
      dataInJson: jsonEncode(body),
      api: Api._GENERATE_QR_FOR_POS,
    ));
  }

  static Future<CusForLoyalityRes?> searchCusForLoyaltyQr() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._SEARCH_CUS_FOR_LOYALTY_QR,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = CusForLoyalityRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<CusForLoyalityRes?> searchCusForLoyaltyFromCusQr({
    required String cusId,
  }) async {
    final data = {
      "CustomerId": cusId,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._SEARCH_CUS_FOR_LOYALTY_CUS_QR,
        dataInJson: json.encode(data),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = CusForLoyalityRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  // static Future<CashRegisterRes?> getDataCashRegister() async {
  //   // log(json.encode(_data));
  //   try {
  //     final res = await Repo.get(
  //       h: await _header,
  //       api: Api._OPEN_CASH_REGISTER,
  //     );
  //     // log(res.body);
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       final resData = CashRegisterRes.fromJson(jsonDecode(res.body));
  //       return resData;
  //     } else {
  //       IfException.onError(res: res);
  //     }
  //   } on SocketException catch (_) {
  //     IfException.showMessage(
  //         message: LN.noInternetConnection, msg: Msg.Dialog);
  //   } on FormatException catch (_) {
  //     IfException.showMessage(message: LN.tryAgainAfterTime);
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  //   return null;
  //   // return null;
  // }

  static Future<TableSlotAvaiRes?> getTableSlots({
    required String dateTime,
    required String noOfPeople,
  }) async {
    final body = {
      "DesiredDateTime": dateTime,
      "NoOfPeople": noOfPeople,
    };
    try {
      final res = await Repo.post(
          h: await _header,
          api: Api._GET_TABLE_BOOK_SLOT,
          dataInJson: json.encode(body));
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = TableSlotAvaiRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<TrackDetailRes?> getTrackDetail({required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_DELIVERY_DETAIL(id),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = TrackDetailRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.somethingWentWrong);
    } catch (e) {
      IfException.showMessage(message: LN.somethingWentWrong);
    }
    return null;
    // return null;
  }

  static Future<bool?> createPosDelivery({
    CreateDeliPosReq? req,
  }) async {
    // log(jsonEncode(data.toJson()));

    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(req?.toJson()),
        api: Api._DELIVERY_CREATE,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = Message.fromJson(jsonDecode(res.body));
        IfException.showMessage(message: resData.message ?? '', isError: false);
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<DeliTrackRes?> getTrackList({
    String searchKey = "",
    int page = 1,
    int pageSize = 12,
    String? trackingStatusId,
  }) async {
    final body = {
      "Page": page,
      "PageSize": pageSize,
      "SearchKeywords": searchKey,
      "ExternalFilter": {
        "TrackingStatusId": trackingStatusId,
      }
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._DELIVERY_ORDER_LIST,
        dataInJson: json.encode(body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = DeliTrackRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<GenBarAddSec?> genBarcodeAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GEN_BAR_CODE_ADD_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = GenBarAddSec.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<RetailPosProduct?> getRetailPosProduct({
    required int page,
    String searchText = "",
    String brandId = "",
    String categoryId = "",
    String productTypeId = "",
  }) async {
    final body = {
      "Page": page,
      "PageSize": 10,
      "SearchKeyWords": searchText,
      "ExternalFilter": {
        "BrandId": brandId,
        "CategoryId": categoryId,
        "ProductTypeId": productTypeId,
      },
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._GET_RETAIL_POS_PRODUCTS,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final pCatRes = RetailPosProduct.fromJson(jsonDecode(res.body));
        return pCatRes;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<BarcodeLabelPrintViewModel?> barcodePrint(
      {String? variationId}) async {
    try {
      final body = {
        "ProductVariationId": variationId,
      };

      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._GET_BARCODE_PRINT,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final pCatRes =
            BarcodeLabelPrintViewModel.fromJson(jsonDecode(res.body));
        return pCatRes;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<GenBarcodePrintRes?> barcodePrintBulk(
      {List<GenBarcodePrintReq>? req}) async {
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(req?.map((e) => e.toJson()).toList()),
        api: Api._GEN_BARCODE_PRINT_BULK,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final pCatRes = GenBarcodePrintRes.fromJson(jsonDecode(res.body));
        return pCatRes;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<InvoicePrinterDetail?> getInvoicePrinterDetail() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_INVOICE_PRINTER,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = InvoicePrinterDetail.fromJson(jsonDecode(res.body));
        // final resData = List<InvoicePrinterDetail>.from(
        //     jsonDecode(res.body).map((x) => InvoicePrinterDetail.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<DashChannelFilterSec?> getDashChannelFilterSec(
      {required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_CHANNEL_FILTER_SEC_LIST(id),
      );
// log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = DashChannelFilterSec.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
// print(e.toString());
    }
    return null;
// return null;
  }

  static Future<bool?> dashConnectChannel({
    DashChannelUpdateReq? req,
  }) async {
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._CONNECT_CHANNEL,
        dataInJson: json.encode(req?.toJson()),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = Message.fromJson(jsonDecode(res.body));
        IfException.showMessage(message: resData.message ?? '', isError: false);
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<FeaturedProduct?> getProductDetailByVarId({
    required String prodVarId,
  }) async {
    final body = {
      "ProductVariationId": prodVarId,
    };
    // log(jsonEncode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._PRODUCT_DETAIL_BY_VAR_ID,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = FeaturedProduct.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<RetailPosComboBarcodeRes?> getRetailPosCombo({
    required int page,
    String searchText = "",
  }) async {
    final body = {
      "Page": page,
      "PageSize": 10,
      "ExternalFilter": {
        "SearchKeyWords": searchText,
      },
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(body),
        api: Api._GET_RETAIL_POS_COMBO,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final pCatRes = RetailPosComboBarcodeRes.fromJson(jsonDecode(res.body));
        return pCatRes;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<BarcodeLabelPrintViewModel?> barcodeComboPrint(
      {BarcodePrintReq? req}) async {
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(req?.toJson()),
        api: Api._GET_COMBO_BARCODE_PRINT,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final pCatRes =
            BarcodeLabelPrintViewModel.fromJson(jsonDecode(res.body));
        return pCatRes;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<GenBarcodePrintRes?> barcodeComboPrintBulk(
      {List<BarcodePrintReq>? req}) async {
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(req?.map((e) => e.toJson()).toList()),
        api: Api._GEN_BARCODE_COMBO_PRINT_BULK,
      );

      // log(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final pCatRes = GenBarcodePrintRes.fromJson(jsonDecode(res.body));
        return pCatRes;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<ValidatePinCodeRes?> validatePinCode({
    required String pinCode,
  }) async {
    final body = {
      "LoginPinCode": pinCode,
    };
    try {
      final res = await Repo.post(
          h: (await _header)?..addAll(body),
          dataInJson: jsonEncode(body),
          api: Api._VALIDATE_LOGIN_PINCODE);
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final result = ValidatePinCodeRes.fromJson(jsonDecode(res.body));
        return result;
      } else {
        IfException.onError(res: res, showToast: true);
      }
    } on SocketException catch (_) {
      IfException.showMessage(message: LN.noInternetConnection, msg: Msg.Toast);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<PrintProdDetailRes?> getPrinterProdDetails({
    PrintProdReq? req,
  }) async {
    // log(json.encode(_data));
    try {
      final res = await Repo.post(
          h: await _header,
          api: Api._GET_PRINTER_PROD_DETAILS,
          dataInJson: json.encode(req?.toJson()));
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = PrintProdDetailRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> addUpPrinterProdDetails({
    List<PrintProdDetailRes>? req,
  }) async {
    // log(json.encode(_data));

    return await IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._ADD_UP_PRINTER_PRODUCT,
          dataInJson: json.encode(req?.map((e) => e.toJson()).toList())),
      showToast: true,
    );
  }

  static Future<AssignServiceTypeModel?> getAssignServiceAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ASSIGN_SERVICE_ADD_SEC,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AssignServiceTypeModel.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  //getAssignedServiceList

  static Future<AssignedServiceRes?> getAssignedServiceList({
    required String employeeId,
    required String employeeName,
  }) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ASSIGNED_SERVICE_ITEMS(employeeId),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AssignedServiceRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpAssignedService({
    AssignedServiceRes? req,
  }) async {
    // log(json.encode(_data));

    return await IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._ASSIGN_SERVICES,
          dataInJson: json.encode(req?.toJson())),
      showToast: true,
    );
  }

  static Future<bool?> addReview({
    ReviewQuestionUserViewModel? req,
  }) async {
    // log(json.encode(_data));

    return await IfException.boolExpt(
        function: Repo.post(
            h: await _header,
            api: Api._ADD_REVIEW,
            dataInJson: json.encode(req?.toJson())),
        showToast: true,
        onPopMsg: (bool val) {
          Navigator.canPop(CUS_CTX!) ? Navigator.pop(CUS_CTX!) : null;
        });
  }

  static Future<EmployeByCodeRes?> getEmployeeByCode({
    String? code,
  }) async {
    try {
      final data = {"LoginPinCode": code};
      final res = await Repo.post(
          h: await _header,
          api: Api._GET_EMPLOYEE_BY_CODE,
          dataInJson: json.encode(data));
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = EmployeByCodeRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<EmployeShiftStatus?> checkShiftStatus(
      {String? employeeId}) async {
    try {
      final res = await Repo.get(
        h: (await _header)
          ?..addAll({
            "EmployeeId": employeeId ?? '',
          }),
        api: Api._CHECK_SHIFT_STATUS,
      );
// log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = EmployeShiftStatus.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
// return null;
  }

  static Future<EmployeCheckInRes?> employeeCheckIn({
    EmployeeCheckInReq? req,
  }) async {
    try {
      final res = await Repo.post(
          h: (await _header)
            ?..addAll({
              "EmployeeId": req?.employeeId ?? '',
            }),
          api: Api._EMPLOYEE_CHECK_IN,
          dataInJson: json.encode(req?.toJson()));
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = EmployeCheckInRes.fromJson(jsonDecode(res.body));
        IfException.showMessage(
            message: resData.message ?? '', msg: Msg.Dialog, isError: false);
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> employeeCheckOut({
    EmployeeCheckOutReq? req,
  }) async {
    return await IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._EMPLOYEE_CHECK_OUT,
          dataInJson: json.encode(req?.toJson())),
      showToast: true,
    );
  }

  static Future<EmployeBreakStartRes?> employeeBreakStart({
    EmployeeBreakStartReq? req,
  }) async {
    try {
      final res = await Repo.post(
          h: await _header,
          api: Api._EMPLOYEE_BREAK_START,
          dataInJson: json.encode(req?.toJson()));
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = EmployeBreakStartRes.fromJson(jsonDecode(res.body));
        IfException.showMessage(
            message: resData.message ?? '', msg: Msg.Dialog, isError: false);
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<bool?> employeeBreakEnd({
    EmployeBreakEndReq? req,
  }) async {
    return await IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._EMPLOYEE_BREAK_END,
          dataInJson: json.encode(req?.toJson())),
      showToast: true,
    );
  }

  static Future<AllOrdersRes?> getAllServices({
    String searchKey = "",
    String storeChannelId = "",
    String orderStatusId = "",
    String orderTypeId = "",
    // String tableId = "",
    int page = 1,
    int pageSize = 12,
  }) async {
    final body = {
      "Page": page,
      "PageSize": pageSize,
      "SearchKeywords": searchKey,
      "ExternalFilter": {
        "ChannelId": storeChannelId,
        "ServiceStatusId": orderStatusId,
        "OrderTypeId": orderTypeId,
        // "TableId": tableId,
      }
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_ALL_SERVICES,
        dataInJson: json.encode(body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllOrdersRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  //get commission add sec

  static Future<CommissionAddSec?> getCommissionAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_COMM_ADD_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = CommissionAddSec.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  //get commission details

  static Future<ServiceCommissionDetailsModel?> getCommissionDetails({
    required String employeeId,
  }) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_COMM_DETAILS(employeeId),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData =
            ServiceCommissionDetailsModel.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  //update commission details

  static Future<bool?> updateCommissionDetails({
    ServiceCommissionDetailsModel? req,
  }) async {
    return await IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._ADD_UP_COMM_DETAILS,
          dataInJson: json.encode(req?.toJson())),
      showToast: true,
    );
  }

  //get all store printer

  static Future<List<StorePrintersRes>?> getAllStorePrinter() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_PRINTER,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<StorePrintersRes>.from(
            jsonDecode(res.body).map((x) => StorePrintersRes.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  //get all assigned printer products

  static Future<List<PrinterProductVariation>?> getAllAssignedPrinterProducts(
      {required String printerId}) async {
    try {
      final body = {"Id": printerId};
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_ALL_ASSIGNED_PRODUCT,
        dataInJson: json.encode(body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<PrinterProductVariation>.from(jsonDecode(res.body)
            .map((x) => PrinterProductVariation.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  //keypad getKeypadCheckoutAddSectionList

  static Future<KeyPadAddSectionListModel?>
      getKeypadCheckoutAddSectionList() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_KEYPAD_ADD_SEC,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData =
            KeyPadAddSectionListModel.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  //keypad checkout

  static Future<bool?> keypadCheckout({
    KeyPadCheckOutRequestModel? req,
  }) async {
    return await IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._KEYPAD_CHECKOUT,
          dataInJson: json.encode(req?.toJson())),
      showToast: true,
    );
  }

  static Future<bool?> createUpdateOrderTab({OrderTabReq? req}) async {
    return await IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._CREATE_UP_ORDER_TAB,
          dataInJson: json.encode(req?.toJson())),
      showToast: true,
    );
  }

  static Future<List<OrderTabReq>?> getAllOrderTabs({
    required String orderStatusId,
  }) async {
    try {
      final body = {
        "ExternalFilter": {
          "OrderStatusId": orderStatusId,
        },
      };
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_ALLORDER_TABLS,
        dataInJson: json.encode(body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<OrderTabReq>.from(
            jsonDecode(res.body).map((x) => OrderTabReq.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<OrderTabReq?> editOrderTab({required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_ORDER_TAB(id),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = OrderTabReq.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<CompDisRes?> getCompAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._COMP_ADD_SEC,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = CompDisRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<RawIngreAddSectionList?> getRawIngreAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_RAW_INGRE_ADD_SEC,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = RawIngreAddSectionList.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addRawIngre({
    AddRawIngreRequest? req,
  }) async {
    return await IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._ADD_UP_RAW_INGRE,
          dataInJson: json.encode(req?.toJson())),
      showToast: true,
    );
  }

  static Future<AddRawIngreRequest?> editRawIngre({
    required String id,
  }) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_RAW_INGRE(id),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AddRawIngreRequest.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  //get all raw ingre
  static Future<AllRawIngredientResponse?> getAllRawIngre({
    String searchKey = "",
    int page = 1,
    int pageSize = 10,
  }) async {
    final _body = {
      "Page": page,
      "PageSize": pageSize,
      "SearchKeywords": searchKey,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_ALL_RAW_INGRE,
        dataInJson: json.encode(_body),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllRawIngredientResponse.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> cancelOrderTab({
    required String orderId,
  }) async {
    // log(orderId);
    final _body = {"OrderId": orderId};
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._CANCEL_ORDER_TAB,
        dataInJson: json.encode(_body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        IfException.showMessage(
            message: "Order has been cancelled",
            // msg: Msg.Dialog,
            isError: false);
        // final resData = PayInvoiceDetailRes.fromJson(jsonDecode(res.body));
        // return resData;
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<ComboPackRes?> getAllComboPack({
    int page = 1,
    int pageSize = 10,
    String searchKey = "",
  }) async {
    final _body = {
      "Page": page,
      "PageSize": pageSize,
      "SearchKeywords": searchKey,
    };
    // log(jsonEncode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._GET_ALL_COMBOPACK,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = ComboPackRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<ComboAddSec?> getComboAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_COMBO_ADD_SEC,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = ComboAddSec.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> createUpComboReq({
    CreateUpComboReq? req,
    String? imagePath,
    dynamic Function(bool)? onPopMsg,
  }) async {
    if (req == null) return null;
    // log(jsonEncode(_body));
    return IfException.boolExpt(
      function: Repo.httpPostFile(
        h: await _header,
        data: {
          "Request": json.encode(req.toJson()),
        },
        api: Api._CREATE_UP_COMBO,
        filePath: imagePath,
      ),
      onPopMsg: onPopMsg,
    );
  }

  static Future<CreateUpComboReq?> editComboPack({required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._EDIT_COMBO_PACK(id),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = CreateUpComboReq.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> deleteComboPack({
    String? id,
    String? name,
  }) async {
    final _body = {
      "Id": id,
      "Name": name,
    };
    // log(jsonEncode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._DELETE_COMBO_PACK,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        // final resData = ComboPackRes.fromJson(jsonDecode(res.body));
        // return resData;
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  //get _GET_RAW_INGRE_HISTORY
  static Future<RawIngreHistoryResponse?> getRawIngreHistory({
    required String id,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final body = {
        "Page": page,
        "PageSize": 10,
        "ExternalFilter": {
          "RawLooseIngredientId": id,
        },
      };
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_RAW_INGRE_HISTORY,
        dataInJson: json.encode(body),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = RawIngreHistoryResponse.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpRawIngreHistory({
    AddRawIngreHistoryRequest? req,
  }) async {
    return await IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._ADD_UP_RAW_INGRE_HISTORY,
          dataInJson: json.encode(req?.toJson())),
      showToast: true,
    );
  }

  static Future<AllPromotionRes?> getAllPromotions() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_PROMOTION,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllPromotionRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<dynamic>?> getAllPosOrProductsV2() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_HOS_POSORDER_PRODUCTS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return jsonDecode(res.body) as List<dynamic>;
        // final resData = List<AllPosProductRes>.from(
        //     jsonDecode(res.body).map((x) => AllPosProductRes.fromJson(x)));
        // return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // kPrint(e.toString());
    }
    return null;
  }

  static Future<String?> generatePassword() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GENERATE_PASSWORD,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return jsonDecode(res.body);
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<String?> generatePin() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GENERATE_PIN,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return jsonDecode(res.body);
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<PosDeviceDetailsRes?> getPosDeviceSetupDetails({
    required String? id,
    required String? name,
  }) async {
    try {
      final body = {
        "PosDeviceId": id,
        "PosDeviceName": name,
      };
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_POS_DEVICE_SETUP_DETAIL,
        dataInJson: json.encode(body),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = PosDeviceDetailsRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpPosDeviceDetails({
    List<PosDeviceDetailsRes>? req,
  }) async {
    // log(json.encode(_data));

    return await IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._CREATE_UP_POS_DEVICE_PRODUCT,
          dataInJson: json.encode(req?.map((e) => e.toJson()).toList())),
      showToast: true,
    );
  }

  static Future<List<OrderItemDetailsOnFloor>?> getOrderItemFloor(
      {required String id}) async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ORDER_ITEM_FLOOR(id),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<OrderItemDetailsOnFloor>.from(jsonDecode(res.body)
            .map((x) => OrderItemDetailsOnFloor.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  // static Future<List<PaymentMethodSec>?> getPayMethods() async {
  //   try {
  //     final res = await Repo.get(
  //       h: await _header,
  //       api: Api._GET_PAY_METHODS,
  //     );
  //     // log(res.body);
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       final resData = List<PaymentMethodSec>.from(
  //           jsonDecode(res.body).map((x) => PaymentMethodSec.fromJson(x)));
  //       return resData;
  //     } else {
  //       IfException.onError(res: res);
  //     }
  //   } on SocketException catch (_) {
  //     IfException.showMessage(
  //         message: LN.noInternetConnection, msg: Msg.Dialog);
  //   } on FormatException catch (_) {
  //     IfException.showMessage(message: LN.tryAgainAfterTime);
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  //   return null;
  //   // return null;
  // }

  static Future<bool?> updatePayMethod({
    required String? id,
    required String? methodId,
  }) async {
    try {
      final body = {
        "Id": id,
        "PaymentMethodId": methodId,
      };
      final res = await Repo.post(
        h: await _header,
        api: Api._CHANGE_PAY_METHOD,
        dataInJson: json.encode(body),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        // final resData = PosDeviceDetailsRes.fromJson(jsonDecode(res.body));
        // return resData;
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<void> sendPrintStatus({
    required PrintStatusReq req,
  }) async {
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._TRACK_PRINT_STATUS,
        dataInJson: json.encode(req.toJson()),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        // final resData = AllRawIngredientResponse.fromJson(jsonDecode(res.body));
        // return resData;
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //   message: LN.noInternetConnection,
      //   msg: Msg.Dialog,
      // );
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
  }

  static Future<List<TableLocation>?> getAllProdParentCats() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_PROD_PARENT_CATS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<TableLocation>.from(
            jsonDecode(res.body).map((x) => TableLocation.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<ProdByProdCatRes?> getAllProductByProductCat(
      {required String id}) async {
    try {
      final body = {"Id": id};
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_ALL_PROD_BY_PROD_CAT,
        dataInJson: json.encode(body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = ProdByProdCatRes.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<GetSortProductRes>?> getSortProductByCats(
      {required String id}) async {
    try {
      final body = {"Id": id};
      final res = await Repo.post(
        h: await _header,
        api: Api._SORT_PROD_BY_CATS,
        dataInJson: json.encode(body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<GetSortProductRes>.from(
            jsonDecode(res.body).map((x) => GetSortProductRes.fromJson(x)));

        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> updateSortProductByCats(
      {List<GetSortProductRes>? data}) async {
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._UPDATE_SORT_PROD_BY_CATS,
        dataInJson: json.encode(data?.map((a) => a.toJson()).toList()),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = Message.fromJson(jsonDecode(res.body));
        IfException.showMessage(message: resData.message ?? '', isError: false);
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> tagProductToDocket({TagProductToDocketReq? req}) async {
    return await IfException.boolExpt(
      function: Repo.post(
          h: await _header,
          api: Api._TAG_PROD_TO_DOCKET,
          dataInJson: json.encode(req?.toJson())),
      showToast: true,
    );
  }

  static Future<bool> revokeOrder({
    required String orderId,
  }) async {
    final _body = {
      "Id": orderId,
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._REVOKE_ORDER,
        dataInJson: json.encode(_body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return false;
    // return null;
  }

  /// Sync

  static Future<Map<String, dynamic>?> posAddSection(
      {required bool isRetail}) async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: isRetail ? Api._SYNC_RETAIL_DATA : Api._SYNC_HOS_DATA,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return jsonDecode(res.body);
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> syncBrand() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._SYNC_BRANDS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is List) {
          return body.map((e) => e as Map<String, dynamic>).toList();
        }
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> syncMerchant() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._SYNC_MERCHANTS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is List) {
          return body.map((e) => e as Map<String, dynamic>).toList();
        }
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> syncPosOrderType() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._SYNC_POS_ORDER_TYPE,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is List) {
          return body.map((e) => e as Map<String, dynamic>).toList();
        }
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> syncOrdersOrderType() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._SYNC_ORDERS_ORDER_TYPE,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is List) {
          return body.map((e) => e as Map<String, dynamic>).toList();
        }
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> syncDocketGroup() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._SYNC_DOCKET_GRP,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is List) {
          return body.map((e) => e as Map<String, dynamic>).toList();
        }
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> syncOrderItemStatus() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._SYNC_ORDER_ITEM_STATUS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is List) {
          return body.map((e) => e as Map<String, dynamic>).toList();
        }
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> syncDiscount() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._SYNC_DISCOUNTS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is List) {
          return body.map((e) => e as Map<String, dynamic>).toList();
        }
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> syncCusGroup() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._SYNC_CUS_GROUP,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is List) {
          return body.map((e) => e as Map<String, dynamic>).toList();
        }
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<Map<String, dynamic>?> syncStoreInfo() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._SYNC_STORE_INFO,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is Map<String, dynamic>) {
          return body;
        }
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getStoreChargeInfo() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_STORE_CHARGE_INFO,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is Map<String, dynamic>) {
          return body;
        }
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  // static Future<Map<String, dynamic>?> syncStockDeduct() async {
  //   // log(jsonEncode(_body));
  //   try {
  //     final res = await Repo.get(
  //       h: await _header,
  //       api: Api._SYNC_STOCK_DEDUCT_INTO,
  //     );
  //     // log(res.body);
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       final body = jsonDecode(res.body);
  //       if (body is Map<String, dynamic>) {
  //         return body;
  //       }
  //     } else {
  //       // IfException.onError(res: res);
  //     }
  //   } on SocketException catch (_) {
  //     // IfException.showMessage(
  //     //     message: LN.noInternetConnection, msg: Msg.Dialog);
  //   } on FormatException catch (_) {
  //     // IfException.showMessage(message: LN.tryAgainAfterTime);
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  //   return null;
  // }

  // static Future<Map<String, dynamic>?> syncDeliveryInfo() async {
  //   // log(jsonEncode(_body));
  //   try {
  //     final res = await Repo.get(
  //       h: await _header,
  //       api: Api._SYNC_DELIVERY_INFO,
  //     );
  //     // log(res.body);
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       final body = jsonDecode(res.body);
  //       if (body is Map<String, dynamic>) {
  //         return body;
  //       }
  //     } else {
  //       // IfException.onError(res: res);
  //     }
  //   } on SocketException catch (_) {
  //     // IfException.showMessage(
  //     //     message: LN.noInternetConnection, msg: Msg.Dialog);
  //   } on FormatException catch (_) {
  //     // IfException.showMessage(message: LN.tryAgainAfterTime);
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  //   return null;
  // }

  static Future<List<Map<String, dynamic>>?> syncOrderNote() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._SYNC_NOTES,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is List) {
          return body.map((e) => e as Map<String, dynamic>).toList();
        }
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> syncTableLocations() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_TABLE_LOCATIONS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is List) {
          return body.map((e) => e as Map<String, dynamic>).toList();
        }
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<PopularProductRes>?> getPopularProducts() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_POPULAR_PRODUCTS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        final _jsonData = List<PopularProductRes>.from(
            body.map((x) => PopularProductRes.fromJson(x)));

        return _jsonData;
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<String?> getTableReservNo() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_TABLE_RESERV_NO,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is String) {
          return body;
        }
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<PlaceOrderRes?> posOrderStkPrinter({
    required PlaceOrderInfo req,
  }) async {
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._POS_ORDER_SEND_KITCHEN_PRINTER,
        dataInJson: json.encode(req.toJson()),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (res.body.isEmpty) return PlaceOrderRes(orderId: req.orderId);

        final resData = PlaceOrderRes.fromJson(jsonDecode(res.body));
        if ((resData.message?.isNotEmpty ?? false) &&
            (resData.printingDetailsResponseViewModels?.isEmpty ?? false)) {
          IfException.onError(res: res);
        }
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  // static Future<bool?> posOrderStkitDisplay({
  //   required PlaceOrderInfo req,
  // }) async {
  //   // log(json.encode(_body));
  //   try {
  //     // final _startTime = DateTime.now();
  //     // kPrint(
  //     //     "Start: ${Api._POS_ORDER_SEND_KITCHEN_DISPLAY} ${req.orderId} : $_startTime");
  //     final res = await Repo.post(
  //       h: await _header,
  //       api: Api._POS_ORDER_SEND_KITCHEN_DISPLAY,
  //       dataInJson: json.encode(req.toJson()),
  //     );
  //     // kPrint(
  //     //     "End: ${Api._POS_ORDER_SEND_KITCHEN_DISPLAY} ${req.orderId} : ${DateTime.now()} ${DateTime.now().difference(_startTime).inMilliseconds} ms");
  //     // log(res.body);
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       return true;
  //     } else {
  //       IfException.onError(res: res);
  //     }
  //   } on SocketException catch (_) {
  //     // IfException.showMessage(
  //     //     message: LN.noInternetConnection, msg: Msg.Dialog);
  //   } on FormatException catch (_) {
  //     // IfException.showMessage(message: LN.tryAgainAfterTime);
  //   } catch (e) {
  //     // kPrint("posOrderStkitDisplay Error : $e");
  //   }

  //   return null;
  // }

  static Future<QuickNoteRes?> getAllNotes(
      {required int page, String searchKey = ''}) async {
    final _body = {
      "Page": page,
      "PageSize": 10,
      "SearchKeyWords": searchKey,
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._GET_ALL_NOTES,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final mRes = QuickNoteRes.fromJson(jsonDecode(res.body));
        return mRes;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> addUpNotes(
      {required SRDatum quickNote, bool showToast = true}) async {
    // log(jsonEncode(catTypeList.map((e) => e.toJson()).toList()));
    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(
          quickNote.toJson(),
        ),
        api: Api._CREATE_UP_NOTES,
      ),
      showToast: showToast,
    );
  }

  // static Future<void> editNote({String id = ''}) async {
  //   // log(json.encode(_body));
  //   try {
  //     final res = await Repo.get(
  //       h: await _header,
  //       api: Api._EDIT_NOTES(id),
  //     );
  //     // log(res.body);
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       // final pCatRes = DiscountSetRes.fromJson(jsonDecode(res.body));
  //       // return pCatRes;
  //     } else {
  //       IfException.onError(res: res);
  //     }
  //   } on SocketException catch (_) {
  //     IfException.showMessage(
  //         message: LN.noInternetConnection, msg: Msg.Dialog);
  //   } on FormatException catch (_) {
  //     IfException.showMessage(message: LN.tryAgainAfterTime);
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  //   // return null;
  // }

  static Future<bool?> deleteNote({required List<SRDatum> dataList}) async {
    final _body = List.generate(
        dataList.length,
        (index) => {
              "Id": dataList[index].id,
              if (dataList[index].name != null) "Name": dataList[index].name,
            });
    // log(json.encode(_body));

    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._DELETE_NOTES,
      ),
      messge: _body.length > 1 ? "${_body.length} Order Notes Deleted" : "",
    );
  }

  static Future<bool?> windcaveLog({
    required String logs,
    required String orderId,
  }) async {
    final _body = {
      "OrderId": orderId,
      "Data": logs,
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._WINDCAVE_LOGS,
        dataInJson: json.encode(_body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      } else {
        // IfException.onError(res: res);
      }
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  // static Future<PaymentCredentials?> getMxMerchantCred() async {
  //   // log(jsonEncode(_body));
  //   try {
  //     final res = await Repo.get(
  //       h: await _header,
  //       api: Api._GET_MX_MERCHANT_CRED,
  //     );
  //     // log(res.body);
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       final mRes = PaymentCredentials.fromJson(jsonDecode(res.body));
  //       return mRes;
  //     } else {
  //       IfException.onError(res: res);
  //     }
  //   } on SocketException catch (_) {
  //     IfException.showMessage(
  //         message: LN.noInternetConnection, msg: Msg.Dialog);
  //   } on FormatException catch (_) {
  //     IfException.showMessage(message: LN.tryAgainAfterTime);
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  //   return null;
  // }

  // static Future<bool?> updateMxCred(
  //     {PaymentCredentials? data, Function(bool)? onPop}) async {
  //   if (data == null) return null;

  //   return await IfException.boolExpt(
  //     function: Repo.post(
  //         h: await _header,
  //         api: Api._UPDATE_MX_MERCHANT_CRED,
  //         dataInJson: jsonEncode(data.toJson())),
  //     showToast: true,
  //     onPopMsg: onPop,
  //   );
  // }

  static Future<List<AllOrderStatusRes>?> getAllOrderStatus(
      {required int page, String searchKey = ''}) async {
    final _body = {
      "Page": page,
      "PageSize": 10,
      "SearchKeyWords": searchKey,
    };
    // log(json.encode(_body));
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._GET_ALL_ORDER_STATUS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return List<AllOrderStatusRes>.from(
            json.decode(res.body).map((x) => AllOrderStatusRes.fromJson(x)));
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> updateOrderStatus({
    required List<AllOrderStatusRes> data,
  }) async {
    final _body = data.map((e) => e.toJson()).toList();

    return await IfException.boolExpt(
      function: Repo.post(
        h: await _header,
        dataInJson: jsonEncode(_body),
        api: Api._UPDATE_ORDER_STATUS,
      ),
      showToast: true,
    );
  }

  static Future<List<MenuScheduleRes>?> getMenuSchedule() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._MENU_SCHEDULE,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return List<MenuScheduleRes>.from(
            json.decode(res.body).map((x) => MenuScheduleRes.fromJson(x)));
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> syncMenus() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_MENUS,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is List) {
          return body.map((e) => e as Map<String, dynamic>).toList();
        }
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> syncPrintDocket() async {
    // log(jsonEncode(_body));
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_PRINT_DOCKET_SETUP,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is List) {
          return body.map((e) => e as Map<String, dynamic>).toList();
        }
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> checkTableStatus({String? tableId}) async {
    final body = {"TableId": tableId ?? ''};
    try {
      final res = await Repo.post(
          h: await _header,
          api: Api._CHECK_TABLE_STATUS,
          dataInJson: json.encode(body));
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      } else {
        final err = SettingRes.fromJson(jsonDecode(res.body));
        if (err.message is List<Message>) {
          final _mesg = err.message as List<Message>;
          if (_mesg.isNotEmpty) {
            IfException.showMessage(
                message: _mesg.first.message ?? '',
                msg: Msg.Dialog,
                seconds: 0);
          }
        }
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<Uint8List?> getDocketByte({
    Uint8List? data,
  }) async {
    if (data == null) return null;

    return await PrintUtils.getDocketRasterByteData(data);

    // log(json.encode(_body));
    // final _h = await _header;
    // try {
    //   final res = await Repo.post(
    //     h: {
    //       ...(_h ?? {}),
    //       "Content-Type": "application/octet-stream",
    //     },
    //     dataInJson: data,
    //     api: Api._GET_DOCKET_BYTE,
    //   );
    //   if (res.statusCode >= 200 && res.statusCode < 300) {
    //     return res.bodyBytes;
    //   } else {
    //     IfException.onError(res: res);
    //   }
    // } on SocketException catch (_) {
    //   IfException.showMessage(
    //       message: LN.noInternetConnection, msg: Msg.Dialog);
    // } on FormatException catch (_) {
    //   IfException.showMessage(message: LN.tryAgainAfterTime);
    // } catch (e) {
    //   // print(e.toString());
    // }
    // return null;
  }

  static Future<UploadImageS3Res?> uploadUrls3({
    String? fileName,
    String? identifier,
  }) async {
    // log(json.encode(_body));
    final _data = {
      "FolderName": fileName,
      "Identifier": identifier,
      "MaxUploadCount": 1,
    };
    try {
      final res = await Repo.post(
        h: await _header,
        dataInJson: json.encode(_data),
        api: Api._UPLOAD_URL_S3,
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final mRes = UploadImageS3Res.fromJson(jsonDecode(res.body));
        return mRes;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<bool?> uploadImageOnUrl({
    String? filepath,
    String? url,
    required String? contentType,
  }) async {
    if (url == null || filepath == null) return null;
    try {
      final res = await Repo.put(
        h: {
          'Content-type': contentType ?? "image/webp",
        },
        api: url,
        dataInJson: await File(filepath).readAsBytes(),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      } else {
        // IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(
      //     message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      // IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  // static Future<DeviceDetailRes?> getDeviceDetailById() async {
  //   try {
  //     final _body = {
  //       "DeviceIdentifier": await SupportHandler.getDeviceId,
  //     };

  //     final res = await Repo.post(
  //       h: await _header,
  //       api: Api._GET_DEVICE_DETAIL_BY_ID,
  //       dataInJson: json.encode(_body),
  //     );
  //     // log(res.body);
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       final resData = DeviceDetailRes.fromJson(jsonDecode(res.body));
  //       return resData;
  //     } else {
  //       IfException.onError(res: res);
  //     }
  //   } on SocketException catch (_) {
  //     IfException.showMessage(
  //         message: LN.noInternetConnection, msg: Msg.Dialog);
  //   } on FormatException catch (_) {
  //     IfException.showMessage(message: LN.tryAgainAfterTime);
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  //   return null;
  // }

  static Future<bool?> tagFcmTokenDevice({required String deviceId}) async {
    try {
      final _body = {
        "Id": deviceId,
        "FcmToken": await SupportHandler.getFcmToken
      };

      final res = await Repo.post(
        h: await _header,
        api: Api._TAG_FCM_TOKEN,
        dataInJson: json.encode(_body),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  //get all raw ingre
  static Future<AllProdWithVariation?> getAllProdWithVars({
    String searchKey = "",
    int page = 1,
    int pageSize = 10,
    String catId = "",
  }) async {
    final _body = {
      "Page": page,
      "PageSize": pageSize,
      "SearchKeywords": searchKey,
      "ExternalFilter": {
        "CategoryId": catId,
        "BrandId": null,
      },
    };
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_ALL_PROD_WITH_VARS,
        dataInJson: json.encode(_body),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = AllProdWithVariation.fromJson(jsonDecode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
        message: LN.noInternetConnection,
        msg: Msg.Dialog,
      );
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<TagModiAddSecRes?> getAllTagModiAddSec() async {
    try {
      final res = await Repo.get(
        h: await _header,
        api: Api._GET_ALL_TAG_MODI_ADD_SEC,
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = TagModiAddSecRes.fromJson(json.decode(res.body));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
    // return null;
  }

  static Future<Message?> createProdVarModi({ProdVarModiReq? request}) async {
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._CREATE_PROD_VAR_MODI,
        dataInJson: json.encode(request?.toJson()),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = Message.fromJson(jsonDecode(res.body));
        IfException.showMessage(message: resData.message ?? '', isError: false);
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<List<ProdVarModiGroupRes>?> getProdVarModiGroup(
      {List<SRDatum>? dataList}) async {
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._GET_PROD_VAR_MODI_GROUP,
        dataInJson: json.encode(dataList?.map((a) => a.toJson()).toList()),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = List<ProdVarModiGroupRes>.from(
            json.decode(res.body).map((x) => ProdVarModiGroupRes.fromJson(x)));
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<Message?> updateProdVar(
      {List<UpProdVarModiGroupReq>? data}) async {
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._CREATE_UP_PROD_VAR_MODI,
        dataInJson: json.encode(data?.map((a) => a.toJson()).toList()),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = Message.fromJson(jsonDecode(res.body));
        IfException.showMessage(message: resData.message ?? '', isError: false);
        return resData;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  // static Future<DeviceTypeRes?> getConfigureDeviceList() async {
  //   try {
  //     final res = await Repo.get(
  //       h: await _header,
  //       api: Api._CONFIGURE_DEVICE_SEC_LIST,
  //     );
  //     // log(res.body);
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       final resData = DeviceTypeRes.fromJson(jsonDecode(res.body));
  //       return resData;
  //     } else {
  //       IfException.onError(res: res);
  //     }
  //   } on SocketException catch (_) {
  //     IfException.showMessage(
  //         message: LN.noInternetConnection, msg: Msg.Dialog);
  //   } on FormatException catch (_) {
  //     IfException.showMessage(message: LN.tryAgainAfterTime);
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  //   return null;
  // }

  static Future<bool?> configureDevice({ConfigureDeviceReq? data}) async {
    try {
      final res = await Repo.post(
        h: await _header,
        api: Api._CONFIGURE_DEVICE,
        dataInJson: json.encode(data?.toJson()),
      );
      // log(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      } else {
        IfException.onError(res: res);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  // static Future<Uint8List?> getDocketImage({
  //   String filePath = '',
  // }) async {
  //   // log(json.encode(_body));
  //   final _h = await _header;
  //   try {
  //     final res = await Repo.httpPostFile(
  //       h: {
  //         ...(_h ?? {}),
  //         "Content-Type": "application/octet-stream",
  //       },
  //       data: {},
  //       filePath: filePath,
  //       api: Api._GET_DOCKET_IMAGE,
  //     );
  //     // log(res.bodyBytes.toString());
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       return res.bodyBytes;
  //     } else {
  //       IfException.onError(res: res);
  //     }
  //   } on SocketException catch (_) {
  //     IfException.showMessage(
  //         message: LN.noInternetConnection, msg: Msg.Dialog);
  //   } on FormatException catch (_) {
  //     IfException.showMessage(message: LN.tryAgainAfterTime);
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  //   return null;
  // }
}
