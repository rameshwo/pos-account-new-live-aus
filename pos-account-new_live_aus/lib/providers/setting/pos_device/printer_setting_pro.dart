import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/model/home/setting/pos_device/set_up/printer_add_sec.dart';
import 'package:pos_account/model/home/setting/pos_device/set_up/printer_setup.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/printer/bluetooth/bluetooth_service.dart';
import 'package:pos_account/services/printer/printer_enum.dart';
import 'package:pos_account/services/printer/printer_service.dart';
import 'package:pos_account/services/printer/usb/usb_service.dart';

class PrinterSettingPro extends ChangeNotifier {
  void get notify => notifyListeners();
  bool loading = true;

  PrinterSetupAddSec? addSec;
  PosPrinterSetup? editData;
  // AllPrinterSettingRes? allSetting;

  int? departmentIndex;
  int? printerIndex;
  int? deviceIndex;

  // var initEditData = PosPrinterSetup();

  Future<void> getPrinterData() async {
    editData = await Handler.getPrinterDetails();
  }

  Future<void> getData() async {
    addSec = await Handler.getPrinterAddSec();
    await getPrinterData();
    setData();
    loading = false;
    notify;
    // allSetting = await Handler.getAllPrinterSettings();
    notify;
  }

  void setData() {
    editData ??= PosPrinterSetup();
    editData?.id ??= "";
    editData?.orderPrintAutomatically ??= false;
    editData?.printBillAutomatically ??= false;
    if (editData?.printerCategoryTypeAddViewModels == null ||
        editData!.printerCategoryTypeAddViewModels!.isEmpty) {
      editData!.printerCategoryTypeAddViewModels = [];
      if (addSec != null && addSec!.posPrinters != null)
        for (final e in addSec!.posPrinters!) {
          editData!.printerCategoryTypeAddViewModels!
              .add(PrinterCategoryTypeAddViewModel(
            posPrinterId: e.id,
            // printSetMenuKit: false,
            categoryTypeIds: [],
            paperSize: '80mm',
            printInvoice: false,
            printEftPosSignature: false,
            printEftPosLog: false,
            printBillCustomerCopy: false,
            orderPrintCopy: false,
            // openCashRegister: false,
            printEodSummary: false,
          ));
        }
    }
    // initEditData = editData!; // TODO set with equtable
  }

  PrinterCategoryTypeAddViewModel? getCat(int printerIndex) {
    if (editData?.printerCategoryTypeAddViewModels != null) {
      if (editData!.printerCategoryTypeAddViewModels!.any((e) =>
          e.posPrinterId?.toLowerCase() ==
          addSec?.posPrinters?[printerIndex].id?.toLowerCase())) {
      } else {
        editData!.printerCategoryTypeAddViewModels!
            .add(PrinterCategoryTypeAddViewModel(
          posPrinterId: addSec?.posPrinters?[printerIndex].id,
          // printSetMenuKit: false,
          categoryTypeIds: [],
          paperSize: '80mm',
          printInvoice: false,
          printEftPosSignature: false,
          printEftPosLog: false,
          printBillCustomerCopy: false,
          orderPrintCopy: false,
          // openCashRegister: false,
          printEodSummary: false,
        ));
      }

      final pctavm = editData!.printerCategoryTypeAddViewModels!.firstWhere(
          (e) =>
              e.posPrinterId?.toLowerCase() ==
              addSec?.posPrinters?[printerIndex].id?.toLowerCase());

      return pctavm;
    }
    return null;
  }

  bool updateLoad = false;

  Future<void> addUpdatePrinter() async {
    updateLoad = true;
    notify;

    editData?.posDeviceIdentifier = await SupportHandler.getDeviceId;

    await Handler.addUpPrinterSetup(setUp: editData!);

    updateLoad = false;
    notify;
  }

  void clear() {
    loading = true;
    updateLoad = false;
    addSec = null;
    editData = null;
    // allSetting = null;
    departmentIndex = null;
    printerIndex = null;
    deviceIndex = null;
    // _printerDetails = null;
    opencashDrawerLoad = false;
  }

  // open cash drawer loading
  bool opencashDrawerLoad = false;
  // InvoicePrinterDetail? _printerDetails;

  Future<void> openCashDrawer() async {
    opencashDrawerLoad = true;
    notify;

    final _printerDetails = await Handler.getInvoicePrinterDetail();

    if (_printerDetails != null) {
      if (_printerDetails.openCashRegister ?? false) {
        Utils.openIminDrawer();

        if (_printerDetails.printerType == PrinterTypeEnum.Bluetooth.name) {
          await _bluetoothPrint(macAddress: _printerDetails.ipAddress);
        } else if (_printerDetails.printerType == PrinterTypeEnum.USB.name) {
          await _usbPrint(
              vendorId: _printerDetails.ipAddress,
              productId: _printerDetails.port);
        } else {
          await PrinterService.cashDrawerOpenFromPrinter(
            printerIp: _printerDetails.ipAddress ?? '',
            port: int.tryParse(_printerDetails.port ?? '') ?? 9100,
          );
        }
      }
    }

    // _cashRegisterRes = await Handler.getDataCashRegister();

    opencashDrawerLoad = false;
    notify;
  }

  Future<bool?> _bluetoothPrint({String? macAddress}) async {
    final blueStatus =
        await BluetoothService.getConnectionStatus(macAddress: macAddress);
    if (blueStatus
        // && BluetoothService.connectedDevice != null
        ) {
      return await BluetoothService.cashDrawerOpenFromPrinter();
    } else {
      return null;
      // return await BluetoothService.showDeviceList(
      //   function: () async => await _bluetoothPrint(),
      // );
    }
  }

  Future<bool?> _usbPrint(
      {required String? vendorId, required String? productId}) async {
    if (UsbService.connectedDevice != null &&
        UsbService.connectedDevice?.vendorId == vendorId) {
      return await UsbService.cashDrawerOpenFromPrinter();
    } else {
      final status = await UsbService.checkConnection(
          vendorId: vendorId, productId: productId);
      if (status) {
        return _usbPrint(vendorId: vendorId, productId: productId);
      }
      return null;
    }
  }
}
