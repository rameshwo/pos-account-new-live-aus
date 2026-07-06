import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/model/common/table_id_name.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/home/booking/all_customer.dart';
import 'package:pos_account/model/home/booking/all_table_rsrv_res.dart';
import 'package:pos_account/model/home/booking/confirm_table_resv.dart';
import 'package:pos_account/model/home/booking/order_item_detail_floor.dart';
import 'package:pos_account/model/home/booking/table_resev_model.dart';
import 'package:pos_account/model/home/booking/table_resv_add_sec.dart';
import 'package:pos_account/model/home/booking/table_slot_avai_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../ln.dart';

/// [TableResvPro] table reservation

class TableResvPro extends ChangeNotifier {
  bool loadiing = true;
  TableResvAddSec? tableResvAddSec;

  // inputs
  final formKey = GlobalKey<FormState>();
  String? tableRsvNo;
  final nameCltr = TextEditingController();
  int? phoneCodeIndex;
  final phoneCltr = TextEditingController();
  final emailCltr = TextEditingController();
  int? countryIndex;
  final adultCltr = TextEditingController();
  final childCltr = TextEditingController();
  final dateTimeFromCltr = TextEditingController();
  final dateTimeToCltr = TextEditingController();

  final orderChannels = <TableLocation>[];
  int? orderChannelIndex;

  final ocassionList = <TableLocation>[];
  int? ocassionIndex;

  final messageCltr = TextEditingController();

  final tables = <TableLocation>[];
  // int? tableNoIndex;
  List<TableIdName>? tableIdName;

  String customerId = "";
  String resvId = "";

  String? dateFormat;

  clear() {
    customerId = "";
    resvId = "";
    tableRsvNo = null; // tableResvAddSec?.reservationNumber;
    nameCltr.clear();
    phoneCltr.clear();
    emailCltr.clear();
    adultCltr.clear();
    childCltr.clear();
    messageCltr.clear();
    dateTimeFromCltr.clear();
    dateTimeToCltr.clear();
    orderChannelIndex = null;
    ocassionIndex = null;
    // tableNoIndex = null;

    tableIdName = null;
    phoneCodeIndex = null;
    countryIndex = null;
    notify;
  }

  Future<void> getReservNumber() async {
    loadiing = true;
    notify;

    tableRsvNo = await Handler.getTableReservNo();

    if (orderChannels.any((e) => e.isSelected ?? false)) {
      orderChannelIndex =
          orderChannels.indexWhere((e) => e.isSelected ?? false);
    } else if (orderChannels.isNotEmpty) {
      orderChannelIndex = 0;
    }
    loadiing = false;
    notify;
  }

  Future<void> getData({bool init = true}) async {
    dateFormat ??= await SharedPrefs.dateFormat;
    tableResvAddSec = TableResvAddSec.fromJson(GlobalCVP.allAddSection);
    // await Handler.getAllTabResvAddSec();

    setData();
    if (init) getCountryList();

    // tableRsvNo = tableResvAddSec?.reservationNumber;
    loadiing = false;
    notify;
  }

  TableResvModel initDateSetup(
      {isQuick = false, PlaceOrderPro? placeOrderPro}) {
    if (isQuick) {
      if (noOfPeopleList.any(
          (e) => e == int.tryParse(placeOrderPro?.noOfCustomer.text ?? ''))) {
        noPeopleIndex = noOfPeopleList.indexWhere(
            (e) => e == int.tryParse(placeOrderPro?.noOfCustomer.text ?? ''));
      }
      nameCltr.text = (placeOrderPro?.cusNameCltr.text.isNotEmpty ?? false)
          ? placeOrderPro!.cusNameCltr.text
          : LN.anonymous;
      emailCltr.text = (placeOrderPro?.cusEmailCltr.text.isNotEmpty ?? false)
          ? placeOrderPro!.cusEmailCltr.text
          : "posaptest@gmail.com";
      phoneCltr.text = (placeOrderPro?.cusPhoneCltr.text.isNotEmpty ?? false)
          ? placeOrderPro!.cusPhoneCltr.text
          : "555555555";
      // adultCltr.text = '1';
      if (orderChannels.any((e) => e.isSelected ?? false)) {
        orderChannelIndex =
            orderChannels.indexWhere((e) => e.isSelected ?? false);
      } else if (orderChannels.isNotEmpty) {
        orderChannelIndex = 0;
      }

      if (ocassionList.any((e) => e.isSelected ?? false)) {
        ocassionIndex = ocassionList.indexWhere((e) => e.isSelected ?? false);
      }

      dateTimeFromCltr.text = DateFormat(dateFormat)
          .format(DateTime.now().add(Duration(seconds: 30)));

      dateTimeToCltr.text = DateFormat(dateFormat)
          .format(DateTime.now().add(Duration(minutes: 30, seconds: 30)));
    } else {
      dateTimeFromCltr.text = DateFormat(dateFormat)
          .format(DateTime.now().add(Duration(minutes: 10)));

      dateTimeToCltr.text = DateFormat(dateFormat)
          .format(DateTime.now().add(Duration(minutes: 40)));
    }

    return addableData();
  }

  setData() {
    if ((tableResvAddSec?.tables?.isNotEmpty ?? false) &&
        (tableResvAddSec?.tables?.first.id?.isNotEmpty ?? false))
      tableResvAddSec?.tables?.insert(
          0,
          TableLocation(
              id: "", // "00000000-0000-0000-0000-000000000000",
              name: "All Tables",
              value: "All Tables"));

    if ((tableResvAddSec?.orderChannels?.isNotEmpty ?? false) &&
        (tableResvAddSec?.orderChannels?.first.id?.isNotEmpty ?? false))
      tableResvAddSec?.orderChannels?.insert(
          0,
          TableLocation(
              id: "00000000-0000-0000-0000-000000000000",
              name: "All",
              value: "All"));

    if ((tableResvAddSec?.tableReservationStatus?.isNotEmpty ?? false) &&
        (tableResvAddSec?.tableReservationStatus?.first.id?.isNotEmpty ??
            false))
      tableResvAddSec?.tableReservationStatus?.insert(
          0,
          TableLocation(
              id: "00000000-0000-0000-0000-000000000000",
              name: "All",
              value: "All"));

    if (tableResvAddSec?.orderChannels != null) {
      orderChannels.clear();
      for (final e in tableResvAddSec!.orderChannels!) {
        if (!(e.value?.toLowerCase().contains("all") ?? false))
          orderChannels.add(e);
      }
    }

    if (tableResvAddSec?.occasions != null) {
      ocassionList.clear();
      for (final e in tableResvAddSec!.occasions!) {
        if (!(e.value?.toLowerCase().contains("all") ?? false))
          ocassionList.add(e);
      }
    }

    if (tableResvAddSec?.tables != null) {
      tables.clear();
      for (final e in tableResvAddSec!.tables!) {
        if (!(e.value?.toLowerCase().contains("all") ?? false)) tables.add(e);
      }
    }

    dateCltr.text =
        DateFormat(dateFormat?.split(' ').first).format(DateTime.now());
  }

  //get countrylist
  Future<void> getCountryList() async {
    // countryList = await Handler.getListCountry();
    if (tableResvAddSec?.countries != null &&
        tableResvAddSec!.countries!.any((e) => (e.isSelected ?? false))) {
      countryIndex = tableResvAddSec!.countries!
          .indexWhere((e) => (e.isSelected ?? false));
      phoneCodeIndex = tableResvAddSec!.countries!
          .indexWhere((e) => (e.isSelected ?? false));
    }

    if (orderChannels.any((e) => (e.isSelected ?? false))) {
      orderChannelIndex =
          orderChannels.indexWhere((e) => (e.isSelected ?? false));
    }
    notify;
  }

  TableResvModel addableData() {
    final data = TableResvModel()
      ..id = resvId
      ..reservationNumber = tableRsvNo
      ..adult = adultCltr.text
      ..child = childCltr.text
      ..dateTimeFrom = dateTimeFromCltr.text
      ..dateTimeTo = dateTimeToCltr.text
      ..message = messageCltr.text
      ..customerViewModel = CustomerViewModel(
        id: customerId,
        name: nameCltr.text,
        email: emailCltr.text,
        phoneNumber: phoneCltr.text,
        countryId: countryIndex == null
            ? null
            : tableResvAddSec!.countries?[countryIndex!].id,
        countryPhoneNumberPrefixId: phoneCodeIndex == null
            ? null
            : tableResvAddSec!.countries?[phoneCodeIndex!].id,
      );

    if (orderChannelIndex != null)
      data.orderChannelId = orderChannels[orderChannelIndex!].id;

    if (ocassionIndex != null)
      data.occasionId = ocassionList[ocassionIndex!].id;

    // if (tableNoIndex != null) _data.tableId = tables[tableNoIndex!].id;
    data.tables = tableIdName;

    return data;
  }

  TableResvModel initEditData = TableResvModel();

  Future<bool?> addUpData({BuildContext? diaCtx}) async {
    if (tableResvAddSec == null) return null;

    final data = addableData();

    loadiing = true;
    notify;

    final status = await Handler.addUpTableRerv(
      tableResvModel: data,
      diaCtx: diaCtx,
    );
    if (status ?? false) {
      clear();
      getData(init: false);
      getAllTableResv(page: bookPageIndex);
    }

    loadiing = false;
    notify;
    return status;
  }

  //set customer data

  void setCustomerData(dynamic cusData) {
    if (cusData != null && cusData is CusData) {
      customerId = cusData.id ?? "";
      nameCltr.text = cusData.name ?? "";
      phoneCltr.text = cusData.phoneNumber ?? "";
      emailCltr.text = cusData.email ?? "";

      if (tableResvAddSec?.countries != null &&
          tableResvAddSec!.countries!.any(
              (e) => cusData.countryId?.toLowerCase() == e.id?.toLowerCase())) {
        countryIndex = tableResvAddSec!.countries!.indexWhere(
            (e) => cusData.countryId?.toLowerCase() == e.id?.toLowerCase());
      }

      if (tableResvAddSec?.countries != null &&
          tableResvAddSec!.countries!.any((e) =>
              cusData.countryPhoneNumberPrefixId?.toLowerCase() ==
              e.id?.toLowerCase())) {
        phoneCodeIndex = tableResvAddSec!.countries!.indexWhere((e) =>
            cusData.countryPhoneNumberPrefixId?.toLowerCase() ==
            e.id?.toLowerCase());
      }

      notify;
    }
  }

// details section
  int bookPageIndex = 1;
  final int _booingPageSize = 30;
  int _bookTotalPage = 0;

  final searchCltr = TextEditingController();
  final dateCltr = TextEditingController();
  int? deOrderChIndex = 0;
  int? deTableIndex = 0;
  int? deStatusIndex = 0;

  // AllTableRsrv? allTableRsrv;
  final bookingList = <AllTableResvData>[];
  final bookingRefreshCltr = RefreshController(initialRefresh: false);

  void clear2() {
    // loadiing = true;
    // bookingList.clear();
    bookPageIndex = 1;
    searchCltr.clear();
    // dateCltr.clear();
    dateCltr.text =
        DateFormat(dateFormat?.split(' ').first).format(DateTime.now());
    deOrderChIndex = 0;
    deTableIndex = 0;
    deStatusIndex = 0;
    resvId = "";
  }

  Future<void> getAllTableResv({int page = 1}) async {
    final _channelId = deOrderChIndex != null &&
            (tableResvAddSec?.orderChannels?.isNotEmpty ?? false)
        ? (tableResvAddSec?.orderChannels?[deOrderChIndex!].id ?? "")
        : "";
    final _tableId =
        deTableIndex != null && (tableResvAddSec?.tables?.isNotEmpty ?? false)
            ? (tableResvAddSec?.tables?[deTableIndex!].id ?? "")
            : "";
    final _statusId = deStatusIndex != null &&
            (tableResvAddSec?.tableReservationStatus?.isNotEmpty ?? false)
        ? (tableResvAddSec?.tableReservationStatus?[deStatusIndex!].id ?? "")
        : "";

    if (page == 1 || bookPageIndex * _booingPageSize < _bookTotalPage) {
      bookPageIndex = page;

      final allTableRsrv = await Handler.getAllTabResv(
        page: page,
        pageSize: _booingPageSize,
        keyword: searchCltr.text,
        date: dateCltr.text,
        channelId: _channelId,
        tableId: _tableId,
        statusId: _statusId,
      );

      if (page == 1) {
        bookingList.clear();
      }

      if (allTableRsrv?.data != null) {
        _bookTotalPage = allTableRsrv?.total ?? 0;
        bookingList.addAll(allTableRsrv!.data!);

        bookingList.sort((a, b) {
          if (a.hasArrived == b.hasArrived) {
            return 0;
          }
          return a.hasArrived == true ? 1 : -1;
        });
      }
    }

    bookingRefreshCltr.loadComplete();
    bookingRefreshCltr.refreshCompleted();
    loadiing = false;
    notify;
  }

  Future<void> confirmTabRes({
    required String type,
    required String id,
  }) async {
    final data = ConfirmTabRes(
      type: type,
      reservationId: id,
    );
    loadiing = true;
    notify;

    final status = await Handler.confirmTabRes(confirmTabResList: [data]);
    if (status != null && status) {
      getAllTableResv(page: bookPageIndex);
    }

    loadiing = false;
    notify;
  }

  Future<void> cancelBooking({
    required String type,
    required String id,
  }) async {
    final _data = ConfirmTabRes(
      type: type,
      reservationId: id,
    );
    loadiing = true;
    notify;

    final _status = await Handler.cancelBooking(confirmTabResList: [_data]);
    if (_status != null && _status) {
      getAllTableResv(page: bookPageIndex);
    }

    loadiing = false;
    notify;
  }

  Future<void> editReservation({required String id}) async {
    loadiing = true;
    notify;

    final editData = await Handler.editTableResv(id: id);
    if (editData == null) return;

    resvId = id;
    tableRsvNo = editData.reservationNumber;

    adultCltr.text = editData.adult ?? "";
    childCltr.text = editData.child ?? "";
    messageCltr.text = editData.message ?? '';

    if (orderChannels.isNotEmpty &&
        orderChannels.any((e) =>
            e.id?.toLowerCase() == editData.orderChannelId?.toLowerCase())) {
      orderChannelIndex = orderChannels.indexWhere(
          (e) => e.id?.toLowerCase() == editData.orderChannelId?.toLowerCase());
    }

    if (ocassionList.isNotEmpty &&
        ocassionList.any(
            (e) => e.id?.toLowerCase() == editData.occasionId?.toLowerCase())) {
      ocassionIndex = ocassionList.indexWhere(
          (e) => e.id?.toLowerCase() == editData.occasionId?.toLowerCase());
    }
    tableIdName = editData.tables;
    // if (tables.isNotEmpty &&
    //     tables.any(
    //         (e) => e.id?.toLowerCase() == _editData.tableId?.toLowerCase())) {
    //   tableNoIndex = tables.indexWhere(
    //       (e) => e.id?.toLowerCase() == _editData.tableId?.toLowerCase());
    // }

    dateTimeFromCltr.text = editData.dateTimeFrom ?? "";
    dateTimeToCltr.text = editData.dateTimeTo ?? "";

    customerId = editData.customerViewModel?.id ?? '';
    nameCltr.text = editData.customerViewModel?.name ?? '';
    emailCltr.text = editData.customerViewModel?.email ?? '';
    phoneCltr.text = editData.customerViewModel?.phoneNumber ?? '';

    if (tableResvAddSec?.countries != null &&
        editData.customerViewModel != null) {
      if (tableResvAddSec!.countries!.any((e) =>
          e.id?.toLowerCase() ==
          editData.customerViewModel!.countryPhoneNumberPrefixId
              ?.toLowerCase())) {
        phoneCodeIndex = tableResvAddSec!.countries!.indexWhere((e) =>
            e.id?.toLowerCase() ==
            editData.customerViewModel!.countryPhoneNumberPrefixId
                ?.toLowerCase());
      }
      if (tableResvAddSec!.countries!.any((e) =>
          e.id?.toLowerCase() ==
          editData.customerViewModel!.countryId?.toLowerCase())) {
        countryIndex = tableResvAddSec!.countries!.indexWhere((e) =>
            e.id?.toLowerCase() ==
            editData.customerViewModel!.countryId?.toLowerCase());
      }
    }
    initEditData = addableData();
    loadiing = false;
    notify;
  }

  Future<void> arriveBooking({required String id}) async {
    loadiing = true;
    notify;
    final _status = await Handler.arriveBooking(id: id);
    if (_status ?? false) {
      await getAllTableResv(page: 1);
    }
    loadiing = false;
    notify;
  }

  // table slot search
  final noOfPeopleList = List.generate(20, (i) => i + 1);
  int noPeopleIndex = 0;

  final timeList = <String>[];
  int timeIndex = 0;

  String searchDate = "";

  bool findLoad = false;

  TableSlotAvaiRes? tableSlotAvaiRes;

  int? selectedSlot;

  Future<void> getTableSlot() async {
    findLoad = true;
    notify;

    final _noOfPeople = noOfPeopleList[noPeopleIndex].toString();

    tableSlotAvaiRes = await Handler.getTableSlots(
        dateTime: searchDate, noOfPeople: _noOfPeople);

    if (adultCltr.text.isNotEmpty && adultCltr.text.inDouble <= 1) {
      adultCltr.text = _noOfPeople;
      childCltr.text = "0";
    }

    findLoad = false;
    notify;
  }

  void slotClear() {
    tableSlotAvaiRes = null;
    findLoad = false;
    noPeopleIndex = 0;
    selectedSlot = null;
    adultCltr.clear();
    childCltr.clear();
    dateTimeFromCltr.clear();
    dateTimeToCltr.clear();
    timeIndex = 0;
  }

  Map<String, List<OrderItemDetailsOnFloor>?>?
      orderDetailsById; // orderId : List<Orders>
  bool orderLoad = false;

  Future<void> getOrderDetails({required String id}) async {
    if (id.isEmpty) return;

    orderLoad = true;
    notify;

    final _allOrders = await Handler.getOrderItemFloor(id: id);

    if (_allOrders?.isNotEmpty ?? false)
      for (final e in _allOrders!) {
        e.modifiers?.forEach((a) {
          a.productType = e.productType;
        });
      }

    orderDetailsById ??= {};
    orderDetailsById?.addAll({id: _allOrders});

    // kPrint("1. ${orderDetailsById?.keys.toList()}");

    orderLoad = false;
    notify;
  }

  void removeOrderDetails({String? orderId}) {
    if (orderId == null) return;

    // kPrint("2. ${orderDetailsById?.keys.toList()}");

    try {
      orderDetailsById
          ?.removeWhere((a, b) => a.toLowerCase() == orderId.toLowerCase());
    } catch (e) {
      //
    }
    // kPrint("$orderId :: ${orderDetailsById?.keys.toList()}");
    notify;
  }

  void get notify => notifyListeners();
}
