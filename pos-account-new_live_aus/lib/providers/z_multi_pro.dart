import 'package:flutter/material.dart';
import 'package:pos_account/providers/common/review_pro.dart';
import 'package:pos_account/providers/keypad/keypad_pro.dart';
import 'package:pos_account/providers/menu/gift_card/gift_card_template_group_pro.dart';
import 'package:pos_account/services/uber/delivery/provider/deli_tracking_pro.dart';
import 'package:pos_account/services/uber/delivery/provider/delivery_pro.dart';
import 'package:pos_account/providers/notification/recent_call_pro.dart';
import 'package:provider/provider.dart';
import '../ln.dart';
import 'auth/change_pass_pro.dart';
import 'auth/auth_pro.dart';
import 'booking/table_arrange_pro.dart';
import 'booking/table_resv_pro.dart';
import 'common/eftpro.dart';
import 'common/invoice_pro.dart';
import 'cus_val_pro.dart';
import 'dashboard/dashboard_pro.dart';
import 'dashboard/punch_pro.dart';
import 'eod/cash_inout_pro.dart';
import 'eod/eod_pro.dart';
import 'history/history_pro.dart';
import 'integration/integration_pro.dart';
import 'integration/terminal_pro.dart';
import 'kitchen/kitchen_pro.dart';
import 'menu/cus_history_pro.dart';
import 'menu/generate_barcode_pro.dart';
import 'menu/gift_card/gift_card_check_pro.dart';
import 'menu/gift_card/gift_card_image_pro.dart';
import 'menu/gift_card/gift_card_list_pro.dart';
import 'menu/gift_card/new_gift_card_pro.dart';
import 'menu/order_tab/order_tab_pro.dart';
import 'menu/orders_pro.dart';
import 'menu/payment_pro.dart';
import 'menu/place_order_pro.dart';
import 'menu/pos_retail_pro.dart';
import 'menu/raw_ingre_pro.dart';
import 'new_org/new_org_pro.dart';
import 'notification/order_notify_pro.dart';
import 'product/assign_modi_pro.dart';
import 'product/combo_pack_pro.dart';
import 'product/edit_modifier_pro.dart';
import 'product/featured_product_pro.dart';
import 'product/manage_prod_pro.dart';
import 'product/modifier_pro.dart';
import 'product/new_product_pro.dart';
import 'product/set_menu_pro.dart';
import 'profile/profile_pro.dart';
import 'profile/user_manage_pro.dart';
import 'screen_saver/screen_saver_pro.dart';
import 'setting/general/all_table_loc_pro.dart';
import 'setting/general/all_table_no_pro.dart';
import 'setting/general/barcode_pro.dart';
import 'setting/general/cat_type_pro.dart';
import 'setting/general/discount_pro.dart';
import 'setting/general/docket_group_pro.dart';
import 'setting/general/order_status_pro.dart';
import 'setting/general/order_type_pro.dart';
import 'setting/general/product_brand_pro.dart';
import 'setting/general/product_cat_pro.dart';
import 'setting/general/quick_note_pro.dart';
import 'setting/general/sub_cat_pro.dart';
import 'setting/general/tax_ie_pro.dart';
import 'setting/notification/notify_pro.dart';
import 'setting/pay_method_pro.dart';
import 'setting/pos_device/cus_display_pro.dart';
import 'setting/pos_device/department_pro.dart';
// import 'setting/pos_printer/eft_pos_pro.dart';
import 'setting/pos_device/kit_product_assign_pro.dart';
import 'setting/pos_device/location_pro.dart';
import 'setting/pos_device/pos_device_pro.dart';
import 'setting/pos_device/printer_product_pro.dart';
import 'setting/pos_device/printer_setting_pro.dart';
import 'setting/setting_pro.dart';
import 'setting/store/store_pro.dart';
import 'setting/store/store_pro_v2.dart';
import 'stcf/short_tcf_pro.dart';
import 'subs_billing/sub_billing_pro.dart';
import 'sync/sync_pro.dart';

class MultiPro extends StatelessWidget {
  final Widget child;
  const MultiPro({super.key, required this.child});

  static void get reset {
    if (CUS_CTX == null) return;
    Provider.of<StorePro>(CUS_CTX!, listen: false).reset();
    Provider.of<StoreProV2>(CUS_CTX!, listen: false).reset();
    Provider.of<PlaceOrderPro>(CUS_CTX!, listen: false).reset();
    Provider.of<DashboardPro>(CUS_CTX!, listen: false).clear();
    Provider.of<PosRetailPro>(CUS_CTX!, listen: false).clearAll();
    Provider.of<TableArrangePro>(CUS_CTX!, listen: false).clearAll();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // auth
        ChangeNotifierProvider<AuthProvider>(
            create: (ctx) => AuthProvider.init()),

        // custom global value
        ChangeNotifierProvider<CusValuePro>(create: (ctx) => CusValuePro()),

        // language
        ChangeNotifierProvider<LNProvider>(create: (ctx) => LNProvider()),

        // notification
        ...[
          ChangeNotifierProvider<NotifyPro>(create: (ctx) => NotifyPro()),
          ChangeNotifierProvider<OrderNotifyPro>(
              create: (ctx) => OrderNotifyPro()),
          // recent call
          ChangeNotifierProvider<RecentCallPro>(
              create: (ctx) => RecentCallPro()),
        ],

        // eftpos
        ChangeNotifierProvider<EftPro>(create: (ctx) => EftPro()),

        // screen saver data
        ChangeNotifierProvider<ScreenSaverPro>(
            create: (ctx) => ScreenSaverPro()),

        // gift card
        ...[
          ChangeNotifierProvider<NewGiftCardPro>(
              create: (ctx) => NewGiftCardPro()),
          ChangeNotifierProvider<GiftCardListPro>(
              create: (ctx) => GiftCardListPro()),
          ChangeNotifierProvider<GiftCardTemplatePro>(
              create: (ctx) => GiftCardTemplatePro()),
          ChangeNotifierProvider<GiftCardImagePro>(
              create: (ctx) => GiftCardImagePro()),
          ChangeNotifierProvider<GiftCardCheckPro>(
              create: (ctx) => GiftCardCheckPro()),
        ],

        // new organization create
        ChangeNotifierProvider<NewOrgPro>(create: (ctx) => NewOrgPro()),

        // activate device
        // ChangeNotifierProvider<ActDevPro>(create: (ctx) => ActDevPro()),

        // all order
        ChangeNotifierProvider<OrderPro>(create: (ctx) => OrderPro()),

        // kitchen screen
        ChangeNotifierProvider<KitchenPro>(create: (ctx) => KitchenPro()),

        // dashboard screen
        ChangeNotifierProvider<DashboardPro>(create: (ctx) => DashboardPro()),
        ChangeNotifierProvider<KeyPadPro>(create: (ctx) => KeyPadPro()),
        ChangeNotifierProvider<PunchPro>(create: (ctx) => PunchPro()),

        // pos retail screen
        ChangeNotifierProvider<PosRetailPro>(create: (ctx) => PosRetailPro()),

        // customer history data on pos screen
        ChangeNotifierProvider<CusHistoryPro>(create: (ctx) => CusHistoryPro()),

        // place order on pos screen
        ...[
          ChangeNotifierProvider<RawIngrePro>(create: (ctx) => RawIngrePro()),
          ChangeNotifierProvider<PlaceOrderPro>(
              create: (ctx) => PlaceOrderPro()),
          ChangeNotifierProvider<OrderTabPro>(create: (ctx) => OrderTabPro()),
        ],

        // payment process
        ...[
          ChangeNotifierProvider<PayMethodPro>(create: (ctx) => PayMethodPro()),
          // ChangeNotifierProvider<EftPosPro>(create: (ctx) => EftPosPro()),
          ChangeNotifierProvider<PaymentPro>(create: (ctx) => PaymentPro()),
        ],

        // invoice print
        ChangeNotifierProvider<InvoicePro>(create: (ctx) => InvoicePro()),
        ChangeNotifierProvider<ReviewPro>(create: (ctx) => ReviewPro()),

        // product screen
        ...[
          ChangeNotifierProvider<NewProductPro>(
              create: (ctx) => NewProductPro()),
          ChangeNotifierProvider<SetMenuPro>(create: (ctx) => SetMenuPro()),
          ChangeNotifierProvider<FeaturedProductPro>(
              create: (ctx) => FeaturedProductPro()),
          ChangeNotifierProvider<GenBarcodePro>(
              create: (ctx) => GenBarcodePro()),
          ChangeNotifierProvider<ComboPackPro>(create: (ctx) => ComboPackPro()),
          ChangeNotifierProvider<ManageProdPro>(
              create: (ctx) => ManageProdPro()),
          ChangeNotifierProvider<ModifierPro>(create: (ctx) => ModifierPro()),
          ChangeNotifierProvider<AssignModiPro>(
              create: (ctx) => AssignModiPro()),
          ChangeNotifierProvider<EditModiPro>(create: (ctx) => EditModiPro()),
        ],

        //synce screen
        ChangeNotifierProvider<SyncPro>(create: (ctx) => SyncPro()),

        // history screen
        ChangeNotifierProvider<HistoryPro>(create: (ctx) => HistoryPro()),

        // floor plan screen
        ...[
          ChangeNotifierProvider<TableArrangePro>(
              create: (ctx) => TableArrangePro()),
          ChangeNotifierProvider<TableResvPro>(create: (ctx) => TableResvPro()),
        ],

        // eod screen
        ...[
          ChangeNotifierProvider<EodPro>(create: (ctx) => EodPro()),
          ChangeNotifierProvider<EodCashInOutPro>(
              create: (ctx) => EodCashInOutPro()),
        ],

        //// settings screen

        // general settings
        ...[
          ChangeNotifierProvider<SettingProvider>(
              create: (ctx) => SettingProvider()),
          ChangeNotifierProvider<CatTypePro>(create: (ctx) => CatTypePro()),
          ChangeNotifierProvider<ProductCatPro>(
              create: (ctx) => ProductCatPro()),
          ChangeNotifierProvider<SubCatPro>(create: (ctx) => SubCatPro()),
          ChangeNotifierProvider<ProductBrandPro>(
              create: (ctx) => ProductBrandPro()),
          ChangeNotifierProvider<AllTableLocPro>(
              create: (ctx) => AllTableLocPro()),
          ChangeNotifierProvider<AllTableNumPro>(
              create: (ctx) => AllTableNumPro()),
          ChangeNotifierProvider<OrderTypePro>(create: (ctx) => OrderTypePro()),
          ChangeNotifierProvider<TaxIEPro>(create: (ctx) => TaxIEPro()),
          ChangeNotifierProvider<BarcodePro>(create: (ctx) => BarcodePro()),
          ChangeNotifierProvider<DocketGroupPro>(
              create: (ctx) => DocketGroupPro()),
          ChangeNotifierProvider<DiscountPro>(create: (ctx) => DiscountPro()),
          ChangeNotifierProvider<QuickNotePro>(create: (ctx) => QuickNotePro()),
          ChangeNotifierProvider<OrderStatusPro>(
              create: (ctx) => OrderStatusPro()),
        ],

        // pos device settings
        ...[
          ChangeNotifierProvider<DepartmentPro>(
              create: (ctx) => DepartmentPro()),
          ChangeNotifierProvider<PrinterSettingPro>(
              create: (ctx) => PrinterSettingPro()),
          ChangeNotifierProvider<POSPLocationPro>(
              create: (ctx) => POSPLocationPro()),
          ChangeNotifierProvider<PosDevicePro>(create: (ctx) => PosDevicePro()),
          ChangeNotifierProvider<CustomerDisplayPro>(
              create: (ctx) => CustomerDisplayPro()),
          ChangeNotifierProvider<PrinterProductPro>(
              create: (ctx) => PrinterProductPro()),
          ChangeNotifierProvider<KitProdAssignPro>(
              create: (ctx) => KitProdAssignPro()),
        ],

        // store setting
        ChangeNotifierProvider<StorePro>(create: (ctx) => StorePro()),
        ChangeNotifierProvider<StoreProV2>(create: (ctx) => StoreProV2()),

        // user management
        ChangeNotifierProvider<UserManagePro>(create: (ctx) => UserManagePro()),

        // integration
        ChangeNotifierProvider<IntegrationPro>(
            create: (ctx) => IntegrationPro()),
        ChangeNotifierProvider<TerminalPro>(create: (ctx) => TerminalPro()),

        // paybills
        ChangeNotifierProvider<StcfPro>(create: (ctx) => StcfPro()),

        // profie screen
        ...[
          ChangeNotifierProvider<ProfilePro>(create: (ctx) => ProfilePro()),
          ChangeNotifierProvider<ChangePassPro>(
              create: (ctx) => ChangePassPro()),
        ],

        // subscription and billing
        ChangeNotifierProvider<SubsBillingPro>(
            create: (ctx) => SubsBillingPro()),

        // uber delivery
        ChangeNotifierProvider<DeliveryPro>(create: (ctx) => DeliveryPro()),
        ChangeNotifierProvider<DeliTrackPro>(create: (ctx) => DeliTrackPro()),

        //  remove it later dual screen
        // ChangeNotifierProvider<SecondScreenPro>(
        //     create: (ctx) => SecondScreenPro()),
      ],
      child: child,
    );
  }
}
