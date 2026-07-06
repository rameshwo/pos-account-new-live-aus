import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_res.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'package:pos_account/model/ui_model/print_invoice.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
// import 'package:pos_account/screens/home_screen/com/items/sidebar/pay_receipt/com/stk.dart';
// import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/pos_setting/com/printer_list_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/pos_setting/com/printer_list_dia_2.dart';
import 'package:pos_account/services/database/shared_pref.dart';
// import 'package:pos_account/services/printer/bluetooth/blue_receipt.dart';
// import 'package:pos_account/services/printer/bluetooth/bluetooth_service.dart';
// import 'package:pos_account/services/printer/printer_enum.dart';
// import 'package:pos_account/services/printer/usb/usb_service.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
// import 'package:pos_account/widgets/loading.dart';
import '../../../config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import '../stk_print.dart';
// import 'image_print.dart';

class SendToKitchenPrint {
  ///[Print_Data] pos order send to kitchen
  ///
  ///show Printer Dialog Sent To Kitchen
  ///
  // static Future<void> stkOnline(
  //   BuildContext? context, {
  //   PlaceOrderRes? order,
  //   Future<void> Function()?
  //       runSuccessFun, // function to call confirm docket print api of online orders
  //   bool showMsg = true,
  //   bool showLoading = true,
  // }) async {
  //   if (order == null) return;

  //   _printerList.clear();

  //   if ((order.askForPrintConfirmation ?? true) && context != null) {
  //     await showDialog(
  //         context: context,
  //         builder: (builder) => ConfirmDialog(
  //               title: LN.printReceipt,
  //               subTitle: LN.printRecptKit,
  //               actionText: LN.print,
  //               onDelete: () async {
  //                 await _pRSendToKitchen(
  //                   context,
  //                   order: order,
  //                   runSuccessFun: runSuccessFun,
  //                   showLoading: showLoading,
  //                 );
  //                 return null;
  //               },
  //             ));
  //   } else {
  //     await _pRSendToKitchen(
  //       context,
  //       order: order,
  //       runSuccessFun: runSuccessFun,
  //       showMsg: showMsg,
  //       showLoading: showLoading,
  //     );
  //   }
  // }

  static Future<void> stkPos(
    BuildContext? context, {
    PlaceOrderRes? order,
    Future<void> Function()?
        runSuccessFun, // function to call confirm docket print api of online orders
  }) async {
    if (order == null) return;

    if ((order.askForPrintConfirmation ?? true) && context != null) {
      await showDialog(
          context: context,
          builder: (builder) => ConfirmDialog(
                title: LN.printReceipt,
                subTitle: LN.printRecptKit,
                actionText: LN.print,
                onDelete: () async {
                  _stkPrintPOS(
                    order: order,
                    runSuccessFun: runSuccessFun,
                  );
                  return null;
                },
              ));
    } else {
      await _stkPrintPOS(
        order: order,
        runSuccessFun: runSuccessFun,
      );
    }
  }

  // static Timer? _timer;

  static Future<void> _stkPrintPOS({
    PlaceOrderRes? order,
    Future<void> Function()? runSuccessFun,
  }) async {
    _ptptsrm = GlobalCVP.posThermalPrintTypeSetupResponseModels;
    _curSym = await SharedPrefs.curSym;

    if (order?.printingDetailsResponseViewModels == null ||
        order!.printingDetailsResponseViewModels!.isEmpty) {
      // showToast(LN.printNotAvai);
      return;
    }

    await Future.delayed(Duration(milliseconds: 200));

    final _lanPrintList = <LanPrintModel>[];

    for (final e in order.printingDetailsResponseViewModels!) {
      final _hasItemToPrint =
          (e.orderItemsDetailsResponseViewModels?.isNotEmpty ?? false) ||
              (e.setMenuOrderOrderDetailsResponseViewModels?.isNotEmpty ??
                  false) ||
              (e.orderItemsDetailsResponseDocketGroupViewModels?.isNotEmpty ??
                  false) ||
              (e.description?.isNotEmpty ?? false);

      _lanPrintList.add(LanPrintModel(
        title: e.printerName,
        ip: e.ipAddress,
        port: e.port,
        type: e.printerType,
        hasItem: _hasItemToPrint,
        e: e,
      ));
    }

    final _stkManager = StkPrintManager(
      printerList: _lanPrintList,
      order: order,
      runSuccessFun: runSuccessFun,
      load: () {},
    );
    // kPrint("_stkManager.setData : Printing Start");
    await _stkManager.setData();

    await Future.delayed(Duration(seconds: 2));

    do {
      final _printStatus = _stkManager.checkPrintingStatus();
      if (_printStatus) {
        final _allPrinted = _stkManager.printerList.every((a) =>
            a.printerStatus == PrinterStatus.Success ||
            a.printerStatus == PrinterStatus.Failed ||
            a.printerStatus == PrinterStatus.NoData);

        // kPrint("_allPrinted: $_allPrinted");

        if (_allPrinted) {
          final _allPrintSucess = _stkManager.printerList
              .every((a) => a.printerStatus == PrinterStatus.Success);

          if (!_allPrintSucess) {
            if (!PrinterListDia2.isPrintDiaOpen && CUS_CTX != null) {
              PrinterListDia2.isPrintDiaOpen = true;
              showDialog(
                  context: CUS_CTX!,
                  barrierDismissible: false,
                  builder: (_) {
                    return SimpleDialog(
                      titlePadding: EdgeInsets.zero,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      children: [
                        PrinterListDia2(
                          stkPrintManager: _stkManager..init = false,
                        )
                      ],
                    );
                  }).then((_) => PrinterListDia2.isPrintDiaOpen = false);
            }
          }
          break;
        }
      }

      await Future.delayed(Duration(seconds: 1));
    } while (true);

    // _timer = Timer.periodic(Duration(seconds: 1), (_) async {
    //   final _printStatus = _stkManager.checkPrintingStatus();

    //   kPrint("_printStatus: $_printStatus");
    //   if (_printStatus) {
    //     final _allPrinted = _stkManager.printerList.every((a) =>
    //         a.printerStatus == PrinterStatus.Success ||
    //         a.printerStatus == PrinterStatus.Failed ||
    //         a.printerStatus == PrinterStatus.NoData);

    //     kPrint("_allPrinted: $_allPrinted");

    //     if (_allPrinted) {
    //       _.cancel();
    //       _timer?.cancel();

    //       final _allPrintSucess = _stkManager.printerList
    //           .every((a) => a.printerStatus == PrinterStatus.Success);

    //       if (!_allPrintSucess) {
    //         if (!PrinterListDia2.isPrintDiaOpen && CUS_CTX != null) {
    //           PrinterListDia2.isPrintDiaOpen = true;
    //           await showDialog(
    //               context: CUS_CTX!,
    //               barrierDismissible: false,
    //               builder: (_) {
    //                 return SimpleDialog(
    //                   titlePadding: EdgeInsets.zero,
    //                   contentPadding:
    //                       EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    //                   shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(15)),
    //                   children: [
    //                     PrinterListDia2(
    //                       stkPrintManager: _stkManager..init = false,
    //                     )
    //                   ],
    //                 );
    //               });
    //           PrinterListDia2.isPrintDiaOpen = false;
    //         }
    //       }
    //     }
    //   }
    // });
  }

  ///print receipt Sent To Kitchen

  // static Future<void> _pRSendToKitchen(
  //   BuildContext? context, {
  //   PlaceOrderRes? order,
  //   Future<void> Function()? runSuccessFun,
  //   bool showMsg = true,
  //   bool showLoading = true,
  // }) async {
  //   _ptptsrm = order?.posThermalPrintTypeSetupResponseModels;
  //   _curSym = await SharedPrefs.curSym;
  //   // print('printing data check: only send to kitchen');

  //   if (order?.printingDetailsResponseViewModels == null ||
  //       order!.printingDetailsResponseViewModels!.isEmpty) {
  //     // showToast(LN.printNotAvai);
  //     return;
  //   }

  //   await Future.delayed(Duration(milliseconds: 200));
  //   if (showLoading && !Stk.isTesting && context != null)
  //     Loading.dialog(context,
  //         title: "Printing Kitchen Docket",
  //         width: 300,
  //         child: SizedBox(
  //           width: 100,
  //           child: Lottie.asset(
  //             "assets/json/printing.json",
  //           ),
  //         ));

  //   for (final e in order.printingDetailsResponseViewModels!) {
  //     if ((e.orderItemsDetailsResponseViewModels?.isNotEmpty ?? false) ||
  //         (e.setMenuOrderOrderDetailsResponseViewModels?.isNotEmpty ?? false) ||
  //         (e.orderItemsDetailsResponseDocketGroupViewModels?.isNotEmpty ??
  //             false) ||
  //         (e.description?.isNotEmpty ?? false)) {
  //       final _j = (e.orderPrintCopy ?? false) ? 2 : 1;

  //       for (int i = 0; i < _j; i++) {
  //         final _pi = cISentToKitchen(
  //           e,
  //           url: order.url,
  //           stkRt: i == 0
  //               ? SendToKitReceiptType.Normal
  //               : SendToKitReceiptType.Waiter,
  //         );

  //         Stk.GlobalpI = _pi;
  //         Stk.isPrinting = true;
  //         GlobalCVP.notify;

  //         await Future.delayed(Duration(milliseconds: 200));
  //         // print("2 -- ${DateTime.now()}");

  //         if (_pi.captureKey != null) {
  //           final _img = await Stk.getImage(key: _pi.captureKey!);
  //           Stk.GlobalpI = null;
  //           Stk.isPrinting = false;

  //           if (Stk.isTesting) return;

  //           GlobalCVP.notify;

  //           if (_img != null) {
  //             _printerList.add(PrinterModel(
  //               name: e.ipAddress,
  //               subName: e.port,
  //               type: e.printerType,
  //             ));

  //             if (e.printerType == PrinterTypeEnum.Bluetooth.name) {
  //               // final _status = await BluetoothService.bluetoothPrint(pI: _pi);
  //               final _status = await BluetoothService.printImage(data: _img);
  //               if ((_status ?? false) && runSuccessFun != null) {
  //                 await runSuccessFun();
  //               }
  //               if (_printerList.any((f) => f.name == e.ipAddress)) {
  //                 _printerList.firstWhere((f) => f.name == e.ipAddress).status =
  //                     _status ?? false;
  //               }
  //             } else if (e.printerType == PrinterTypeEnum.USB.name) {
  //               // final _status = await UsbService.usbPrint(pI: _pi);
  //               final _status = await UsbService.printImage(
  //                   data: _img, vendorId: _pi.ipAddress, productId: _pi.port);
  //               if ((_status ?? false) && runSuccessFun != null) {
  //                 await runSuccessFun();
  //               }
  //               if (_printerList.any((f) => f.name == e.ipAddress)) {
  //                 _printerList.firstWhere((f) => f.name == e.ipAddress).status =
  //                     _status ?? false;
  //               }
  //             } else {
  //               final bytes = await BlueReceipt.getImageData(
  //                 data: _img,
  //               );
  //               if (bytes != null) {
  //                 final _status = await ImagePrint.sendToEthernetPrinter(
  //                   bytes: bytes,
  //                   port: int.tryParse(e.port ?? '') ?? 9100,
  //                   ip: e.ipAddress ?? '',
  //                 );
  //                 if (_printerList.any((f) => f.name == e.ipAddress)) {
  //                   _printerList
  //                       .firstWhere((f) => f.name == e.ipAddress)
  //                       .status = _status;
  //                 }

  //                 if (_status && runSuccessFun != null) await runSuccessFun();
  //               }
  //             }
  //           }
  //         }
  //       }
  //     } else {
  //       // _spStatus.isIpPrinterScanned = true;
  //       // _spStatus.isStreamClosed = true;

  //       // showToast("Order details are empty");
  //     }
  //   }

  //   // _spStatus.isAllScanned = true;
  //   if (context != null) printerDia(context, showLoading: showLoading);

  //   // print("-------- printer work over");
  // }

  // static final _printerList = <PrinterModel>[];
  // static bool _isPrintDiaOpen = false;

  // static Future<void> printerDia(
  //   BuildContext context, {
  //   bool showLoading = true,
  // }) async {
  //   // print(
  //   //     "-------- printer dialog ${_spStatus.isAllScanned} && ${_spStatus.isIpPrinterScanned} && ${_spStatus.isStreamClosed}");

  //   // if (_spStatus.isAllScanned &&
  //   //     _spStatus.isIpPrinterScanned &&
  //   //     _spStatus.isStreamClosed) {
  //   if (showLoading && Loading.loadDiaOn && Navigator.canPop(context)) {
  //     Navigator.pop(context);
  //     await Future.delayed(Duration(milliseconds: 200));
  //   }
  //   // show print status
  //   if (!_isPrintDiaOpen &&
  //       _printerList.any((e) => !e.status) &&
  //       CUS_CTX != null) {
  //     _isPrintDiaOpen = true;
  //     await showDialog(
  //         context: CUS_CTX!,
  //         builder: (_) {
  //           return SimpleDialog(
  //             titlePadding: EdgeInsets.zero,
  //             contentPadding:
  //                 EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15)),
  //             children: [
  //               PrinterListDia(
  //                 printerList: _printerList,
  //               )
  //             ],
  //           );
  //         });
  //     _isPrintDiaOpen = false;
  //   }

  //   // }
  // }

  /// Create Invoice Sent To Kitchen

  static PrintInvoice cISentToKitchen(
    PrintingDetailsResponseViewModel e, {
    String? url,
    SendToKitReceiptType stkRt = SendToKitReceiptType.Normal,
  }) {
    final key = GlobalKey();

    final pI = PrintInvoice(
        captureKey: key,
        ipAddress: e.ipAddress,
        port: e.port,
        printerType: e.printerType,
        isDocket: true,
        // image: 'assets/png/lototop.png',
        title: LN.kitDocket,
        // +
        //     ((e.docketNumber != null && e.docketNumber != 0) &&
        //             !GlobalCVP.isRetailStore
        //         ? " - ${e.docketNumber}"
        //         : ""), // e.storeName,
        // subtitle:  e.storeAddress,
        subtitleList: [
          SubtitleList(
            text: "${LN.dateTime}: ${e.date ?? ''}",
            style: PrinterTextStyle.Bold,
          ),
          if (stkRt == SendToKitReceiptType.Waiter)
            SubtitleList(
              text: "**${LN.orderCopy}**",
              style: PrinterTextStyle.Bold,
              size: 2,
            ),
        ],
        body: Body(
            header: headerList(e),
            item: [],
            itemFooter: e.description == null || e.description!.isEmpty
                ? null
                : ItemFooterElement(
                    title: "SPECIAL INSTRUCTIONS:\n${e.description}")),
        footerList: [
          if ((e.docketNumber != null && e.docketNumber != 0) &&
              !GlobalCVP.isRetailStore)
            "#${e.docketNumber}",
          // "${LN.thankYou}!",
          // url,
        ]);

    final itemView = _hasValue(key: StkViewKeys.Item);

    if (itemView.isActive) {
      final groupItemList = <Item>[];

      if (e.orderItemsDetailsResponseDocketGroupViewModels?.isNotEmpty ??
          false) {
        for (final a in e.orderItemsDetailsResponseDocketGroupViewModels!) {
          final groupItem = Item(
            itemHeader: ItemFooterElement(
                title: a.docketGroupName,
                body2: (itemView.enableAmount ?? false) ? " " : null),
            isSpliter: a.enableDocketGroupSpliter,
            sortNumber: (a.orderItemsDetailsResponseViewModels?.isNotEmpty ??
                    false)
                ? a.orderItemsDetailsResponseViewModels?.last.docketGroupSort
                : null,
            itemBody: _orderItemList(
              orderItemList: a.orderItemsDetailsResponseViewModels,
              hasItPrice: itemView.enableAmount ?? false,
            ),
          );
          groupItemList.add(groupItem);
        }
      }

      // e.orderItemsDetailsResponseViewModels?.sort(
      //     (a, b) => (a.productType ?? '').compareTo(b.productType ?? ''));

      final _orderlength = e.orderItemsDetailsResponseViewModels!.length +
          (e.orderItemsDetailsResponseDocketGroupViewModels != null
              ? e.orderItemsDetailsResponseDocketGroupViewModels!.fold(
                  0,
                  (pV, nV) =>
                      pV + nV.orderItemsDetailsResponseViewModels!.length)
              : 0);

      final preferredOrder = ['item', 'half', 'combo', 'quart'];

      Map<String, List<OrderItemsDetailsResponseViewModel>> tempGrouped = {};

// Step 1: Group the items
      for (var item in e.orderItemsDetailsResponseViewModels!) {
        final type = item.productType ?? '';
        tempGrouped.putIfAbsent(type, () => []);
        tempGrouped[type]!.add(item);
      }

// Step 2: Match actual keys to order keywords (case-insensitive, partial match)
      final matchedKeys = <String, String>{}; // preferredKeyword -> actualKey
      for (var key in tempGrouped.keys) {
        for (var keyword in preferredOrder) {
          if (key.toLowerCase().contains(keyword)) {
            matchedKeys[keyword] = key;
            break;
          }
        }
      }
      // Step 3: Build ordered map
      final grouped = LinkedHashMap<String,
          List<OrderItemsDetailsResponseViewModel>>.fromIterable(
        preferredOrder.where((kw) => matchedKeys.containsKey(kw)),
        key: (kw) => matchedKeys[kw]!,
        value: (kw) => tempGrouped[matchedKeys[kw]!]!,
      );

      final _listGroup = <ItemFooterElement>[];

      grouped.forEach((key, value) {
        // print("2. ${key}");
        if (OrderUtils.prodType(key) == ProductType.Combo) {
          final comboView = _hasValue(key: StkViewKeys.Combo);

          final _comboHeader = (comboView.enableAmount ?? false)
              ? ItemFooterElement(
                  title: 'Combo Items',
                  body2: " ",
                  bold: true,
                  size: 6,
                  doubleUpDivider: true,
                  underline: true,
                )
              : ItemFooterElement(
                  title: 'Combo Items',
                  // body2: " ",
                  bold: true,
                  size: 6,
                  doubleUpDivider: true,
                  underline: true,
                );

          _listGroup.add(_comboHeader);
        } else if (OrderUtils.prodType(key) == ProductType.Half) {
          final itemView = _hasValue(key: StkViewKeys.Item);

          final _itemHeader = (itemView.enableAmount ?? false)
              ? ItemFooterElement(
                  title: key.toLowerCase().contains('quart')
                      ? 'Four Quarter'
                      : 'Half n Half',
                  body2: " ",
                  bold: true,
                  size: 6,
                  doubleUpDivider: true,
                  underline: true,
                )
              : ItemFooterElement(
                  title: key.toLowerCase().contains('quart')
                      ? 'Four Quarter'
                      : 'Half n Half',
                  // body2: " ",
                  bold: true,
                  size: 6,
                  doubleUpDivider: true,
                  underline: true,
                );

          _listGroup.add(_itemHeader);
        }
        _listGroup.addAll(_orderItemList(
          orderItemList: value,
          hasItPrice: itemView.enableAmount ?? false,
          itemSpace: 16,
        ));
      });

      final _itemHeader = (itemView.enableAmount ?? false)
          ? ItemFooterElement(
              title: '${LN.items}($_orderlength)',
              body2: "${LN.qty}.",
              body3: LN.price)
          : ItemFooterElement(
              title: '${LN.items}($_orderlength)', body2: "${LN.qty}.");
      pI.body!.item!.add(
        Item(
          itemHeader: _itemHeader,
          itemBody: _listGroup,
          groupItem: groupItemList,
        ),
      );
    }
    // const _rowLength = 19;

    final comboView = _hasValue(key: StkViewKeys.Combo);
    final hasCoPrice = comboView.enableAmount ?? false;

    if (comboView.isActive &&
        e.setMenuOrderOrderDetailsResponseViewModels != null &&
        e.setMenuOrderOrderDetailsResponseViewModels!.isNotEmpty) {
      final items = <ItemFooterElement>[];

      for (int i = 0;
          i < e.setMenuOrderOrderDetailsResponseViewModels!.length;
          i++) {
        final a = e.setMenuOrderOrderDetailsResponseViewModels![i];

        if ((a.status?.isNotEmpty ?? false) &&
            (a.status!.toLowerCase().contains('hold') ||
                a.status!.toLowerCase().contains('cancel')))
          items.add(ItemFooterElement(
            title: ' ${a.status} ',
            isReverseText: true,
            size: 2,
          ));

        final qty = double.tryParse(a.quantity ?? '1') ?? 1;

        items.add(ItemFooterElement(
          isFirstLine: true,
          title: //'${i + 1}. ' +
              a.setMenuName ?? '',
          body2: "${qty.toInt()}",
          body3: hasCoPrice ? "$_curSym${a.price}" : null,
          bold: true,
          size: 3,
        ));
        // _items.add(ItemFooterElement(title: "", body3: ""));

        if (a.orderItemsDetailsResponseViewModels != null &&
            a.orderItemsDetailsResponseViewModels!.isNotEmpty) {
          for (int v = 0;
              v < a.orderItemsDetailsResponseViewModels!.length;
              v++) {
            final b = a.orderItemsDetailsResponseViewModels![v];
            // String _itemName = "";

            // if (b.itemName!.length < _rowLength) {
            //   _itemName = b.itemName ?? '';
            // } else {
            //   for (int i = 0;
            //       i <= (b.itemName!.length / _rowLength).round();
            //       i++) {
            //     int _length = b.itemName!.length;
            //     String _space = "";
            //     if (b.itemName!.length > ((i + 1) * _rowLength)) {
            //       _length = (i + 1) * _rowLength;
            //       _space = " ";
            //     }
            //     // print(
            //     //     "Item length : ${b.itemName?.length} ::::  ${i * _rowLength} < $_length ");
            //     if (i * _rowLength < _length) {
            //       _itemName +=
            //           b.itemName!.substring(i * _rowLength, _length) + _space;
            //     }
            //   }
            // }
            // if (b.itemName!.length > 31) {
            //   _itemName = b.itemName!.substring(0, 31) +
            //       "\n      " +
            //       b.itemName!.substring(31, b.itemName!.length);
            // } else {
            //   _itemName = b.itemName ?? '';
            // }

            items.add(ItemFooterElement(
              title: "+ ${b.itemName}",
              size: 2,
              bold: true,
            ));
            if ((double.tryParse(b.quantity ?? '') ?? 0) == 0.5)
              items.add(ItemFooterElement(
                title: " (${LN.half})",
                size: 2,
                bold: true,
              ));

            final _ingrList =
                b.modifiers?.whereModiType3(ModifierType.rawingre);

            if (_ingrList?.isNotEmpty ?? false) {
              // _items.add(ItemFooterElement(title: " ", body3: " "));
              items.add(ItemFooterElement(
                title: "${_ingrList?.first.labelName ?? LN.removeIngredients}:",
                bold: true,
                size: 2,
                underline: true,
              ));
              for (final d in _ingrList!)
                items.add(ItemFooterElement(
                  title: "- ${d.modifierName ?? ''}",
                  bold: true,
                  size: 1,
                ));
            }

            final modiView = _hasValue(key: StkViewKeys.Modifier);

            if (modiView.isActive && (b.modifiers?.isNotEmpty ?? false)) {
              String labelName = "";

              for (final c
                  in b.modifiers!.whereModiType3(ModifierType.modifier)) {
                if (labelName != c.labelName) {
                  labelName = c.labelName ?? '';
                  // _items.add(ItemFooterElement(title: " ", body3: " "));
                  items.add(ItemFooterElement(
                    title: labelName,
                    // body2: _hasCoPrice ? " " : null,
                    body3: " ",
                    size: 2,
                    bold: true,
                  ));
                }

                items.add(ItemFooterElement(
                  title: " + ${c.modifierName ?? ''}",
                  body2: c.quantity.inDouble.formatDouble,
                  body3: hasCoPrice && (modiView.enableAmount ?? false)
                      ? (_curSym + (c.totalModifierPrice ?? ''))
                      : null,
                  size: 1,
                  bold: true,
                ));
              }
            }

            // if (v != a.orderItemsDetailsResponseViewModels!.length - 1) {
            //   _items.add(ItemFooterElement(title: "", body3: ""));
            // }
          }
        }
        if (a.description?.isNotEmpty ?? false) {
          items.add(ItemFooterElement(
            title: "${LN.description}:",
            bold: true,
            underline: true,
          ));
          items.add(ItemFooterElement(
            title: a.description,
            bold: true,
          ));
        }
        if (i != e.setMenuOrderOrderDetailsResponseViewModels!.length - 1) {
          items.add(ItemFooterElement(title: "", body3: ""));
        }
      }
      final comboHeader = (comboView.enableAmount ?? false)
          ? ItemFooterElement(
              title:
                  '${LN.setMenuItems}(${e.setMenuOrderOrderDetailsResponseViewModels!.length})',
              body2: "${LN.qty}.",
              body3: LN.price)
          : ItemFooterElement(
              title:
                  '${LN.setMenuItems}(${e.setMenuOrderOrderDetailsResponseViewModels!.length})',
              body2: "${LN.qty}.");

      pI.body!.item!.add(Item(
        itemHeader: comboHeader,
        itemBody: items,
      ));
    }

    final deliView = _hasValue(key: StkViewKeys.DeliveryAmount);
    final disView = _hasValue(key: StkViewKeys.DiscountAmount);
    final holiView = _hasValue(key: StkViewKeys.HolidaySurChargeAmount);
    final creditView = _hasValue(key: StkViewKeys.CreditCardSurChargeAmount);
    final tipView = _hasValue(key: StkViewKeys.TipAmount);
    final taxView = _hasValue(key: StkViewKeys.TaxAmount);

    final hasOneFooterVal = deliView.isActive ||
        disView.isActive ||
        holiView.isActive ||
        creditView.isActive ||
        tipView.isActive ||
        taxView.isActive;

    final _taxType = OrderUtils.getTaxType(e.taxExclusiveInclusiveType);

    if (hasOneFooterVal) {
      pI.body!.footer = [
        if ((taxView.enableAmount ?? false) && _taxType == TaxType.Exclusive)
          _subTotal(e: e, curSym: _curSym),
        //
        if (deliView.isActive &&
            e.deliveryAmountWithTax.hasAmount &&
            (deliView.enableAmount ?? false))
          Footer(
            title: LN.deliAmt,
            body1: _curSym + (e.deliveryAmountWithTax ?? '0.00'),
          ),
        //
        if (disView.isActive && (disView.enableAmount ?? false)) ...[
          if (_taxType == TaxType.Inclusive && e.discountWithTax.hasAmount)
            Footer(
              title: LN.discount,
              body1: _curSym + (e.discountWithTax ?? '0.00'),
            )
          else if (_taxType == TaxType.Exclusive && e.discount.hasAmount)
            Footer(
              title: LN.discount,
              body1: _curSym + (e.discount ?? '0.00'),
            )
        ],
        //
        if (holiView.isActive &&
            e.publicHolidaySurChargeWithTax.hasAmount &&
            (holiView.enableAmount ?? false))
          Footer(
            title: "Surcharge", // LN.publicHolidaySc,
            body1: _curSym + (e.publicHolidaySurChargeWithTax ?? '0.00'),
          ),
        //
        if (creditView.isActive &&
            e.creditCardSurchargeAmountWithTax.hasAmount &&
            (creditView.enableAmount ?? false))
          Footer(
            title: LN.creditCardSurcharge,
            body1: _curSym + (e.creditCardSurchargeAmountWithTax ?? '0.00'),
          ),
        //
        if (tipView.isActive &&
            e.tipAmount.hasAmount &&
            (tipView.enableAmount ?? false))
          Footer(
            title: LN.tip,
            body1: _curSym + (e.tipAmount ?? ""),
          ),
        //
        if (taxView.isActive) ...[
          if (e.tax.hasAmount &&
              (taxView.enableAmount ?? false) &&
              (_taxType != TaxType.NoTax))
            Footer(
              title: (_taxType == TaxType.Inclusive ? "${LN.included} " : "") +
                  LN.tax,
              body1: _curSym + (e.tax ?? '0.00'),
            ),
          //
          if (e.totalAmount.hasAmount && (taxView.enableAmount ?? false))
            Footer(
              title: LN.total,
              body1: _curSym + (e.totalAmount ?? '0.00'),
            )
        ]
      ];
    }

    // print('printing model created');
    return pI;
  }

  static List<ItemFooterElement> _orderItemList({
    List<OrderItemsDetailsResponseViewModel>? orderItemList,
    required bool hasItPrice,
    double? itemSpace,
  }) {
    final items = <ItemFooterElement>[];

    if (orderItemList?.isNotEmpty ?? false) {
      for (int i = 0; i < orderItemList!.length; i++) {
        final a = orderItemList[i];

        final _prodType = OrderUtils.prodType(a.productType);
        final _prodPriceType = OrderUtils.productPriceType(a.productPriceType);

        final _isDeal = _prodType == ProductType.Combo &&
            _prodPriceType == ProductPriceType.MakeYourOwn;

        final _oneItem = <ItemFooterElement>[];

        final _qty = (double.tryParse(a.quantity ?? '1') ?? 1).round();

        _oneItem.add(ItemFooterElement(
          isFirstLine: true,
          title: (a.itemName ?? ''),
          body2: "$_qty",
          body3: hasItPrice && !_isDeal
              ? (a.price == null || a.price!.isEmpty
                  ? null
                  : "$_curSym${a.price}")
              : null,
          bold: true,
          size: 3,
        ));

        if ((a.status?.isNotEmpty ?? false) &&
            (a.status!.toLowerCase().contains('hold') ||
                a.status!.toLowerCase().contains('cancel')))
          _oneItem.add(ItemFooterElement(
            title: ' ${a.status} ',
            isReverseText: true,
            size: 2,
          ));

        if (a.preparationType?.isNotEmpty ?? false)
          _oneItem.add(ItemFooterElement(
            title: ' ${a.preparationType} ',
            // isReverseText: true,
            size: 2,
          ));

        final _spiceList = a.modifiers?.whereModiType3(ModifierType.spice);

        if (_spiceList?.isNotEmpty ?? false) {
          // _oneItem.add(ItemFooterElement(title: " ", body3: " "));
          _oneItem.add(ItemFooterElement(
            title: "${_spiceList?.first.labelName ?? LN.spice}:",
            bold: true,
            size: 2,
            underline: true,
          ));
          _oneItem.add(ItemFooterElement(
            title: "+ ${_spiceList?.first.modifierName ?? ''}",
            bold: true,
          ));
        }

        final _ingrList = a.modifiers?.whereModiType3(ModifierType.rawingre);

        if (_ingrList?.isNotEmpty ?? false) {
          // _oneItem.add(ItemFooterElement(title: " ", body3: " "));
          _oneItem.add(ItemFooterElement(
            title: "${_ingrList?.first.labelName ?? LN.removeIngredients}:",
            bold: true,
            size: 2,
            underline: true,
          ));
          for (final c in _ingrList!)
            _oneItem.add(ItemFooterElement(
              title: "- ${c.modifierName ?? ''}",
              // body2: hasItPrice ? " " : null,
              // body3: " ",
              bold: true,
              size: 1,
            ));
        }

        final modiView = _hasValue(key: StkViewKeys.Modifier);
        final _hasModiPrice = modiView.enableAmount ?? false;

        final _modiList =
            _prodType == ProductType.Combo || _prodType == ProductType.Half
                ? a.modifiers
                : a.modifiers?.whereModiType3(ModifierType.modifier);

        if (modiView.isActive && _modiList != null && _modiList.isNotEmpty) {
          String _labelName = "";
          for (final b in _modiList) {
            if (_labelName != b.labelName //&& _prodType != ProductType.Combo
                ) {
              _labelName = b.labelName ?? '';
              _oneItem.add(ItemFooterElement(
                title: _prodType == ProductType.Combo
                    ? "> $_labelName"
                    : "* $_labelName",
                body3: " ",
                size: 2,
                bold: true,
                underline: true,
              ));
            }
            final _hideModiPrice = (b.quantity?.inDouble ?? 0) == 1 &&
                (b.totalModifierPrice?.inDouble ?? 0) == 0;

            final _currentQty =
                (double.tryParse(a.originalQuantity ?? (a.quantity ?? '1')) ??
                        1)
                    .round();

            final _modiQty = (_currentQty == 1
                    ? b.quantity.inDouble
                    : (b.quantity?.inDouble ?? 0) / _currentQty)
                .formatDouble;
            final _modiName = _currentQty == 1
                ? (b.modifierName ?? '')
                : '${b.modifierName ?? ''}(each)';

            _oneItem.add(ItemFooterElement(
              title: "  + $_modiName",
              body2: _hideModiPrice ? null : _modiQty,
              body3: hasItPrice && !_hideModiPrice
                  ? (_hasModiPrice
                      ? (_curSym + (b.totalModifierPrice ?? ''))
                      : null)
                  : null,
              size: 1,
              bold: true,
            ));

            if (b.isCancelled ?? false)
              _oneItem.add(ItemFooterElement(
                title: ' ${LN.canceled} ',
                isReverseText: true,
                size: 2,
              ));

            if (b.modifierItemsModifierViewModels?.isNotEmpty ?? false) {
              final _deepSpiceList = b.modifierItemsModifierViewModels
                  ?.whereModiType3(ModifierType.spice);

              if (_deepSpiceList?.isNotEmpty ?? false) {
                // _oneItem.add(ItemFooterElement(title: " ", body3: " "));
                _oneItem.add(ItemFooterElement(
                  title: "${_deepSpiceList?.first.labelName ?? LN.spice}:",
                  bold: true,
                  size: 2,
                  underline: true,
                ));
                _oneItem.add(ItemFooterElement(
                  title: "+ ${_deepSpiceList?.first.modifierName ?? ''}",
                  bold: true,
                ));
              }

              final _deepIngrList = b.modifierItemsModifierViewModels
                  ?.whereModiType3(ModifierType.rawingre);

              if (_deepIngrList?.isNotEmpty ?? false) {
                // _oneItem.add(ItemFooterElement(title: " ", body3: " "));
                _oneItem.add(ItemFooterElement(
                  title:
                      "${_deepIngrList?.first.labelName ?? LN.removeIngredients}:",
                  bold: true,
                  size: 2,
                  underline: true,
                ));
                for (final c in _deepIngrList!)
                  _oneItem.add(ItemFooterElement(
                    title: "- ${c.modifierName ?? ''}",
                    // body2: hasItPrice ? " " : null,
                    // body3: " ",
                    bold: true,
                    size: 1,
                  ));
              }

              final _deepModifier = b.modifierItemsModifierViewModels
                  ?.whereModiType3(ModifierType.modifier);

              if (_deepModifier != null) {
                String _labelName2 = "";
                for (final c in _deepModifier) {
                  if (_labelName2 != c.labelName) {
                    _labelName2 = c.labelName ?? '';
                    _oneItem.add(ItemFooterElement(
                      title: "  * $_labelName2",
                      body3: " ",
                      size: 2,
                      bold: true,
                      underline: true,
                    ));
                  }

                  final _deepModiQty = (_currentQty == 1
                          ? c.quantity.inDouble
                          : (c.quantity?.inDouble ?? 0) / _currentQty)
                      .formatDouble;
                  final _deepModiName = _currentQty == 1
                      ? (c.modifierName ?? '')
                      : '${c.modifierName ?? ''}(each)';

                  _oneItem.add(ItemFooterElement(
                    title: "    + $_deepModiName",
                    body2: (c.totalModifierPrice.inDouble != 0)
                        ? _deepModiQty
                        : " ",
                    body3: hasItPrice
                        ? (_hasModiPrice && (c.totalModifierPrice.inDouble != 0)
                            ? (_curSym + (c.totalModifierPrice ?? ''))
                            : null)
                        : null,
                    size: 1,
                    bold: true,
                  ));

                  if (c.isCancelled ?? false)
                    _oneItem.add(ItemFooterElement(
                      title: ' ${LN.canceled} ',
                      isReverseText: true,
                      size: 2,
                    ));

                  final _doubleDeepIngrList = c.modifierItemsModifierViewModels
                      ?.whereModiType3(ModifierType.rawingre);

                  if (_doubleDeepIngrList?.isNotEmpty ?? false) {
                    // _oneItem.add(ItemFooterElement(title: " ", body3: " "));
                    _oneItem.add(ItemFooterElement(
                      title:
                          "${_doubleDeepIngrList?.first.labelName ?? LN.removeIngredients}:",
                      bold: true,
                      size: 2,
                      underline: true,
                    ));
                    for (final e in _doubleDeepIngrList!)
                      _oneItem.add(ItemFooterElement(
                        title: "- ${e.modifierName ?? ''}",
                        // body2: hasItPrice ? " " : null,
                        // body3: " ",
                        bold: true,
                        size: 1,
                      ));
                  }

                  final _doubleDeepModifier = c.modifierItemsModifierViewModels
                      ?.whereModiType3(ModifierType.modifier);

                  if (_doubleDeepModifier != null) {
                    String _labelName3 = "";
                    for (final d in _doubleDeepModifier) {
                      if (_labelName3 != d.labelName) {
                        _labelName3 = d.labelName ?? '';
                        _oneItem.add(ItemFooterElement(
                          title: "  * $_labelName3",
                          body3: " ",
                          size: 2,
                          bold: true,
                          underline: true,
                        ));
                      }

                      final _doubleDeepModiQty = (_currentQty == 1
                              ? d.quantity.inDouble
                              : (d.quantity?.inDouble ?? 0) / _currentQty)
                          .formatDouble;
                      final _doubleDeepModiName = _currentQty == 1
                          ? (d.modifierName ?? '')
                          : '${d.modifierName ?? ''}(each)';

                      _oneItem.add(ItemFooterElement(
                        title: "    + $_doubleDeepModiName",
                        body2: _doubleDeepModiQty,
                        body3: hasItPrice
                            ? (_hasModiPrice &&
                                    (d.totalModifierPrice.inDouble != 0)
                                ? (_curSym + (d.totalModifierPrice ?? ''))
                                : null)
                            : null,
                        size: 1,
                        bold: true,
                      ));

                      if (d.isCancelled ?? false)
                        _oneItem.add(ItemFooterElement(
                          title: ' ${LN.canceled} ',
                          isReverseText: true,
                          size: 2,
                        ));
                    }
                  }
                }
              }
            }
            if (_isDeal) {
              _oneItem.add(ItemFooterElement(
                  title: "", body3: "", itemSpace: itemSpace));
            }
          }
        }

        if (a.description?.isNotEmpty ?? false) {
          _oneItem.add(ItemFooterElement(
            title: "${LN.description}:",
            bold: true,
            underline: true,
          ));
          _oneItem.add(ItemFooterElement(
            title: a.description,
            bold: true,
          ));
        }

        if (a.updatedItemMessage?.isNotEmpty ?? false)
          _oneItem.add(ItemFooterElement(
            title: ' ${a.updatedItemMessage} ',
            isReverseText: true,
            size: 2,
          ));

        _oneItem
            .add(ItemFooterElement(title: "", body3: "", itemSpace: itemSpace));

        items.addAll(_oneItem);
      }
    }

    return items;
  }

  static List<Footer>? headerList(PrintingDetailsResponseViewModel e) {
    final channelView = _hasValue(key: StkViewKeys.Channel);
    final deliveryPickUpDateView =
        _hasValue(key: StkViewKeys.DeliveryPickUpDate);
    final customerNameView = _hasValue(key: StkViewKeys.CustomerName);
    final tableNumberView = _hasValue(key: StkViewKeys.TableNumber);
    final orderTypeView = _hasValue(key: StkViewKeys.OrderType);
    final serverView = _hasValue(key: StkViewKeys.Server);

    final customerPhoneNumberView =
        _hasValue(key: StkViewKeys.CustomerPhoneNumber);
    final noOfCustomerOnTableView =
        _hasValue(key: StkViewKeys.NoOfCustomerOnTable);
    final paymentMethodView = _hasValue(key: StkViewKeys.PaymentMethod);
    final orderNumberView = _hasValue(key: StkViewKeys.OrderNumber);
    final servedByView = _hasValue(key: StkViewKeys.ServedBy);
    final deliveryLocationView = _hasValue(key: StkViewKeys.DeliveryLocation);

    final dataList = [
      if (tableNumberView.isActive &&
          (e.tableNumber?.isNotEmpty ?? false) &&
          e.tableNumber?.toLowerCase() != 'n/a' &&
          !GlobalCVP.isRetailStore)
        Footer(
          title: "${e.tableNumber}",
          bold: true,
          style: tableNumberView.fontStyle,
          size: tableNumberView.fontSize ?? 5,
          sortOrder: tableNumberView.sortOrder,
        ),
      if ((e.tabName?.isNotEmpty ?? false) && !GlobalCVP.isRetailStore)
        Footer(
          title: "${e.tabName}",
          bold: true,
          // style: docketNumberView.fontStyle,
          size: 4,
          // sortOrder: docketNumberView.sortOrder,
        ),
      // if ( //docketNumberView.isActive &&
      // (e.docketNumber != null && e.docketNumber != 0) &&
      //     !GlobalCVP.isRetailStore)
      //   Footer(
      //     title: "${e.docketNumber}",
      //     bold: true,
      //     // style: docketNumberView.fontStyle,
      //     // size: docketNumberView.fontSize ?? 5,
      //     // sortOrder: docketNumberView.sortOrder,
      //   ),
      if (orderTypeView.isActive &&
          (e.orderType?.isNotEmpty ?? false) &&
          e.orderType?.toLowerCase() != 'n/a')
        Footer(
          title: "${LN.orderType}: ${e.orderType}",
          bold: true,
          style: orderTypeView.fontStyle,
          size: orderTypeView.fontSize ?? 3,
          sortOrder: orderTypeView.sortOrder,
        ),
      if (orderNumberView.isActive)
        Footer(
          title: "${LN.orderNo} ${e.orderNumber}",
          bold: true,
          style: orderNumberView.fontStyle,
          size: orderNumberView.fontSize ?? 1,
          sortOrder: orderNumberView.sortOrder,
        ),
      if (serverView.isActive && e.posName != null && e.posName!.isNotEmpty)
        Footer(
          title: "${LN.server}: ${e.posName}",
          bold: true,
          style: serverView.fontStyle,
          size: serverView.fontSize ?? 1,
          sortOrder: serverView.sortOrder,
        ),
      if (channelView.isActive && e.channel != null && e.channel!.isNotEmpty)
        Footer(
          title: "${LN.channel}: ${e.channel}",
          bold: true,
          style: channelView.fontStyle,
          size: channelView.fontSize ?? 1,
          sortOrder: channelView.sortOrder,
        ),
      if (servedByView.isActive && e.servedBy != null && e.servedBy!.isNotEmpty)
        Footer(
          title: "${LN.servedBy}: ${e.servedBy}",
          bold: true,
          style: servedByView.fontStyle,
          size: servedByView.fontSize ?? 1,
          sortOrder: servedByView.sortOrder,
        ),
      if (paymentMethodView.isActive && (e.paymentMethod?.isNotEmpty ?? false))
        Footer(
          title: "${LN.paymentMethod}: ${e.paymentMethod}",
          bold: true,
          style: paymentMethodView.fontStyle,
          size: paymentMethodView.fontSize ?? 1,
          sortOrder: paymentMethodView.sortOrder,
        ),
      if (customerNameView.isActive && (e.customerName?.isNotEmpty ?? false))
        Footer(
          title: ((e.customerName?.isNotEmpty ?? false)
              ? "${LN.customer}: ${e.customerName}"
              : ""),
          bold: true,
          style: customerNameView.fontStyle,
          size: customerNameView.fontSize ?? 2,
          sortOrder: customerNameView.sortOrder,
        ),
      if (deliveryPickUpDateView.isActive &&
          (e.pickupDeliveryDate?.isNotEmpty ?? false) &&
          e.pickupDeliveryDate?.toLowerCase() != 'n/a')
        Footer(
          title: "${LN.picDeliDate}: ${e.pickupDeliveryDate}",
          bold: true,
          style: deliveryPickUpDateView.fontStyle,
          size: deliveryPickUpDateView.fontSize ?? 2,
          sortOrder: deliveryPickUpDateView.sortOrder,
        ),
      if (customerPhoneNumberView.isActive &&
          (e.customerPhoneNumber?.isNotEmpty ?? false))
        Footer(
          title: "${LN.phoneNumber}: ${e.customerPhoneNumber}",
          bold: true,
          style: customerPhoneNumberView.fontStyle,
          size: customerPhoneNumberView.fontSize ?? 2,
          sortOrder: customerPhoneNumberView.sortOrder,
        ),
      if (noOfCustomerOnTableView.isActive &&
          (e.noOfCustomerOnTable?.isNotEmpty ?? false))
        Footer(
          title: "${LN.noOfCustomers}: ${e.noOfCustomerOnTable}",
          bold: true,
          style: noOfCustomerOnTableView.fontStyle,
          size: noOfCustomerOnTableView.fontSize ?? 3,
          sortOrder: noOfCustomerOnTableView.sortOrder,
        ),
      if (deliveryLocationView.isActive &&
          (e.deliveryLocation?.isNotEmpty ?? false) &&
          e.deliveryLocation?.toLowerCase() != 'n/a') ...[
        Footer(
          title: "${LN.deliveryAdd}: ${e.deliveryLocation!}",
          bold: true,
          style: deliveryLocationView.fontStyle,
          size: deliveryLocationView.fontSize ?? 2,
          sortOrder: deliveryLocationView.sortOrder,
        ),
      ],
    ];

    dataList.sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0));

    return dataList;
  }

  static List<PosThermalPrintTypeSetupResponseModel>? _ptptsrm;
  static String _curSym = "";

  static PosThermalPrintTypeSetupResponseModel _hasValue(
      {required StkViewKeys key}) {
    if (_ptptsrm?.any((e) => e.name?.toLowerCase() == key.name.toLowerCase()) ??
        false) {
      return _ptptsrm!
          .firstWhere((e) => e.name?.toLowerCase() == key.name.toLowerCase());
    }
    return PosThermalPrintTypeSetupResponseModel();
  }

  static Footer _subTotal(
      {required PrintingDetailsResponseViewModel e, required String curSym}) {
    if (e.orderItemsDetailsResponseViewModels == null) return Footer();

    double _value = 0;
    for (final a in e.orderItemsDetailsResponseViewModels!) {
      _value += double.tryParse(a.price ?? '0.0') ?? 0;
    }
    for (final b in e.setMenuOrderOrderDetailsResponseViewModels!) {
      _value += double.tryParse(b.price ?? '0.0') ?? 0;
    }
    return Footer(
      title: LN.subTotal,
      body1: curSym + _value.roundToNString(),
    );
  }
}

enum SendToKitReceiptType { Normal, Waiter }

enum StkViewKeys {
  Item,
  Combo,
  Modifier,
  DeliveryAmount,
  DiscountAmount,
  HolidaySurChargeAmount,
  CreditCardSurChargeAmount,
  TipAmount,
  TaxAmount,
  //
  Channel,
  DeliveryPickUpDate,
  CustomerName,
  TableNumber,
  OrderType,
  Server,
  CustomerPhoneNumber,
  NoOfCustomerOnTable,
  PaymentMethod,
  OrderNumber,
  ServedBy,
  DeliveryLocation,
}

// class _StkPrintStatus {
//   bool isAllScanned;
//   // bool isStreamClosed;
//   bool isIpPrinterScanned;

//   _StkPrintStatus({
//     this.isAllScanned = false,
//     // this.isStreamClosed = true,
//     this.isIpPrinterScanned = true,
//   });
// }
