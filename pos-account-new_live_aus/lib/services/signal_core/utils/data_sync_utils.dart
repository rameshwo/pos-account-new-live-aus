import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import 'package:provider/provider.dart';

import '../../../config/utils/menu_schedule_utils.dart';
import '../../../constant/constant.dart';
import '../../../providers/auth/auth_pro.dart';
import '../../../providers/booking/table_arrange_pro.dart';
import '../../../providers/cus_val_pro.dart';
import '../../../providers/menu/orders_pro.dart';
import '../../../providers/menu/payment_pro.dart';
import '../../../providers/menu/pos_retail_pro.dart';
import '../../database/shared_pref.dart';
import '../model/data_sync_event.dart';

class DataSyncUtils {
  static String? _getAuth;
  static String? _deviceId;

  static void clear() {}

  static Future<void> event({
    List<dynamic>? payload,
  }) async {
    _getAuth ??= await SharedPrefs.isAuth;

    if (_getAuth != AuthStatus.AUTHENTICATE.name) return;

    if (payload == null || payload.isEmpty) {
      kPrint('DataSyncUtils: 1');
      return;
    }

    final _newData = List<DataSyncEvent>.from(
      payload.map((x) => DataSyncEvent.fromJson(x)),
    );

    _deviceId ??= (await DbLocalData.getAllStores())?.id;

    if (_newData.first.posDeviceId?.toLowerCase() != _deviceId?.toLowerCase())
      return;

    if (_newData.first.dataTypeList != null) {
      for (final a in _newData.first.dataTypeList!) {
        await _apiCall(dataType: a.toString());
      }
      IfException.showMessage(message: "Data Syncing..", isError: false);
    }
  }

  static Future<void> _apiCall({
    String? dataType,
  }) async {
    final context = CUS_CTX;

    if (context == null) return;

    final _syncType = dataType._getSyncType;

    final _cvp = Provider.of<CusValuePro>(context, listen: false);

    final _placeOrderPro = Provider.of<PlaceOrderPro>(context, listen: false);
    final _payPro = Provider.of<PaymentPro>(context, listen: false);
    final _retailPro = Provider.of<PosRetailPro>(context, listen: false);

    //
    if (_syncType == SyncDataType.Products) {
      if (_cvp.isRetailStore) {
        await _retailPro.getAllRetailProducts(isServerCall: true);
        _retailPro.getItemData();
      } else {
        await _placeOrderPro.getAllProducts(isServerCall: true);
        _placeOrderPro.getItemData();
      }
    } //

    else if (_syncType == SyncDataType.Promotions) {
      if (_cvp.isRetailStore) {
        _retailPro.getAllPromotions();
      } else {
        _placeOrderPro.getAllPromotions();
      }
    } //

    else if (_syncType == SyncDataType.Brands) {
      final _data = await Handler.syncBrand();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"brands": _data});
      _placeOrderPro.getOrderAddSection();
      _placeOrderPro.notify;
    } //

    else if (_syncType == SyncDataType.OrderTypes) {
      final _data1 = await Handler.syncPosOrderType();
      final _data2 = await Handler.syncOrdersOrderType();

      _cvp.updateAddSection(data: {
        if (_data1 != null) "posOrderTypes": _data1,
        if (_data2 != null) "allOrdersOrderTypes": _data2,
      });
      _placeOrderPro.getOrderAddSection();
      _placeOrderPro.notify;
      final _orderPro = Provider.of<OrderPro>(context, listen: false);
      _orderPro.getOrDeSec();
    } //

    else if (_syncType == SyncDataType.DocketGroup) {
      final _data = await Handler.syncDocketGroup();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"docketGroups": _data});

      _placeOrderPro.getOrderAddSection();
      _placeOrderPro.notify;
    } //

    else if (_syncType == SyncDataType.OrderItemStatus) {
      final _data = await Handler.syncOrderItemStatus();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"orderItemStatus": _data});

      _placeOrderPro.getOrderAddSection();
      _placeOrderPro.notify;
    } //

    else if (_syncType == SyncDataType.Discounts) {
      final _data = await Handler.syncDiscount();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"discounts": _data});

      _payPro.getData();
    } //

    else if (_syncType == SyncDataType.CustomerGroups) {
      final _data = await Handler.syncCusGroup();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"customerGroups": _data});
    } //

    else if (_syncType == SyncDataType.Merchants) {
      final _data = await Handler.syncMerchant();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"eftPosMerchants": _data});
      _payPro.getData();
    } //

    else if (_syncType == SyncDataType.StoreInfo) {
      final _data1 = await Handler.syncStoreInfo();
      // to get tax value and type, need to call this api too.
      final _data2 = await Handler.getStoreChargeInfo();
      // final _data2 = await Handler.syncStockDeduct();
      // final _data3 = await Handler.syncDeliveryInfo();

      _cvp.updateAddSection(
        data: {
          "storeInformation": {
            if (_data1 != null) ..._data1,
            if (_data2 != null) ..._data2,
          },
        },
      );

      _placeOrderPro.getOrderAddSection();
      _placeOrderPro.notify;
    }
    //
    else if (_syncType == SyncDataType.OrderNote) {
      if (_cvp.isRetailStore) return;
      final _data = await Handler.syncOrderNote();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"orderNotes": _data});
      _placeOrderPro.setOrderNotes();
    }
    //
    else if (_syncType == SyncDataType.Menus) {
      if (_cvp.isRetailStore) return;
      final _data = await Handler.syncMenus();
      if (_data == null) return;
      _cvp.updateAddSection(data: {"menus": _data});
      _placeOrderPro.getOrderAddSection();
    }
    //
    else if (_syncType == SyncDataType.ScheduleMenu) {
      final _placeOrderPro = Provider.of<PlaceOrderPro>(context, listen: false);
      if (GlobalCVP.isHospitality) {
        MenuScheduleUtils.listen(
          (slot) async {
            _placeOrderPro.menuslot = slot;
            _placeOrderPro.getItemData();
          },
          enableCloseTimeCheck: false,
        );
      }
    }
    //
    else if (_syncType == SyncDataType.PrintOrder) {
      // if (_syncData.payload != null) {
      //   StkUtils.newOrderStk(
      //     _syncData.payload!,
      //     bypass: false,
      //     isNewOrderPopup: false,
      //   );
      // }
    }
    //
    else if (_syncType == SyncDataType.NewOrder) {
      // CusNotifyDia.show(
      //   //payload: _syncData.payload
      //   title: title,
      //   body: body,
      //   payLoad: syncData.payload,
      // );
    }
    //
    else if (_syncType == SyncDataType.TableLocation) {
      final _data = await Handler.syncTableLocations();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"tableLocations": _data});
      final _tableArrPro = Provider.of<TableArrangePro>(context, listen: false);
      _tableArrPro.setTableLocations();
    }
    //
    else if (_syncType == SyncDataType.FloorPlan) {
      final _tableArrPro = Provider.of<TableArrangePro>(context, listen: false);
      if (_tableArrPro.addSecRes?.tableLocationsWithTables?.isNotEmpty ??
          false) {
        _tableArrPro.getTableStatus(
          id: _tableArrPro
                  .addSecRes
                  ?.tableLocationsWithTables?[_tableArrPro.selectedForEdit]
                  .id ??
              '',
          serverLoad: true,
          doPageLoad: false,
          doResize: true,
        );
      }
    }
    //
    else if (_syncType == SyncDataType.Orders) {
      final _orderPro = Provider.of<OrderPro>(context, listen: false);
      _orderPro.getData(blockRecallWithinSeconds: 3);
    }
    //
    else if (_syncType == SyncDataType.PopularProducts) {
      await _placeOrderPro.getPopularProducts();
      _placeOrderPro.getAllProducts(serverCallLater: false);
    }
    //
    else if (_syncType == SyncDataType.DocketPrintSetups) {
      final _data = await Handler.syncPrintDocket();

      if (_data == null) return;

      _cvp.updateAddSection(data: {"printingSetUps": _data});
      _cvp.setSyncData();
    }
    //
  }
}

enum SyncDataType {
  Promotions,
  Brands,
  Products,
  Merchants,
  OrderTypes,
  DocketGroup,
  OrderItemStatus,
  Discounts,
  CustomerGroups,
  StoreInfo,
  OrderNote,
  // MxMerchantCredential,
  Menus,
  ScheduleMenu,
  PrintOrder,
  NewOrder,
  TableLocation,
  FloorPlan,
  Orders,
  Tables,
  PopularProducts,
  DocketPrintSetups,
  None
}

extension SyncDataTypeX on String? {
  /// Key-value mapping
  static const Map<int, SyncDataType> _map = {
    1: SyncDataType.Promotions,
    2: SyncDataType.Brands,
    3: SyncDataType.Products,
    4: SyncDataType.Merchants,
    5: SyncDataType.OrderTypes,
    6: SyncDataType.DocketGroup,
    7: SyncDataType.OrderItemStatus,
    8: SyncDataType.Discounts,
    9: SyncDataType.CustomerGroups,
    10: SyncDataType.StoreInfo,
    11: SyncDataType.OrderNote,
    // 12: SyncDataType.MxMerchantCredential,
    14: SyncDataType.Menus,
    15: SyncDataType.ScheduleMenu,
    16: SyncDataType.PrintOrder,
    17: SyncDataType.NewOrder,
    18: SyncDataType.TableLocation,
    19: SyncDataType.FloorPlan,
    20: SyncDataType.Orders,
    21: SyncDataType.Tables,
    22: SyncDataType.PopularProducts,
    23: SyncDataType.DocketPrintSetups,
  };

  SyncDataType get _getSyncType {
    if (this == null)
      return SyncDataType.None;
    else {
      return _map.entries
          .firstWhere(
            (e) => e.value.name == this || e.key.toDouble() == this?.inDouble,
            orElse: () => const MapEntry(0, SyncDataType.None),
          )
          .value;
    }
  }
}
