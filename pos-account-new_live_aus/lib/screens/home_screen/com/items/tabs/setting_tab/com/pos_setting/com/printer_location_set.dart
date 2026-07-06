import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/pos_device/pos_printer/printer_location.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/pos_device/location_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/add_new_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/general_set.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/pos_setting/com/bluetooth_printer_set.dart';
import 'package:pos_account/services/printer/bluetooth/bluetooth_service.dart';
import 'package:pos_account/services/printer/printer_enum.dart';
import 'package:pos_account/services/printer/printer_service.dart';
import 'package:pos_account/services/printer/usb/usb_service.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'package:thermal_printer_plus/thermal_printer.dart';

import 'usb_printer_set.dart';

class PrinterLocationSet extends StatefulWidget {
  final PageController pageController;

  const PrinterLocationSet({super.key, required this.pageController});

  @override
  State<PrinterLocationSet> createState() => _PrinterLocationSetState();
}

class _PrinterLocationSetState extends State<PrinterLocationSet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  POSPLocationPro? _prov;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    setData();
    super.initState();
  }

  setData() async {
    _prov = Provider.of<POSPLocationPro>(context, listen: false);
    if (_prov != null) {
      _prov!.init();
      _prov!.getAddSectionData();
      await _prov!.getData(page: 1);
    }
  }

  paginate(int page) {
    if (_prov != null) {
      _prov!.loading = true;
      _prov!.notify;
      _prov!.getData(page: page);
    }
  }

  @override
  void dispose() {
    _prov?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final prov = Provider.of<POSPLocationPro>(context);
    return Processing(
      loading: prov.loading,
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTabRow(
              addTitle: "Add Printer Location",
              viewTitle: "Printer Location List",
              tabController: _tabController,
              pageController: widget.pageController,
              onTap: (int i) {
                if (i == 0) {
                  prov.clear();
                }
                Future.delayed(Duration(milliseconds: 300), () {
                  if (i == 0) {
                    prov.getData();
                  }
                });
              },
            ),
            SizedBox(
              height: size.getH(6),
            ),
            Expanded(
                child: TabBarView(controller: _tabController, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: size.getW(400),
                    child: TextFormWidget(
                      isReq: false,
                      vPad: 10,
                      prefixIcon: Icon(
                        Icons.search,
                        size: size.getS(32),
                      ),
                      borderRadius: 5,
                      borderColor: Colors.black12,
                      cltr: prov.searchCltr,
                      hintText: LN.search,
                      onChanged: (p0) {
                        if (p0 == null) return;

                        Utils.handleSearch(callback: () async {
                          prov.loading = true;
                          prov.notify;
                          prov.getData();
                        });
                      },
                      suffixIcon: prov.searchCltr.text.isEmpty
                          ? null
                          : InkWell(
                              onTap: () {
                                prov.searchCltr.clear();
                                prov.getData();
                                prov.notify;
                              },
                              child: Icon(
                                Icons.close,
                                size: size.getS(28),
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: size.getH(6),
                  ),
                  if (prov.loading ||
                      prov.getTableList.tableDataList.isNotEmpty)
                    Flexible(
                      child: SingleChildScrollView(
                        child: TableData(
                          showDeleteBtn:
                              GlobalCVP.viewWidget.viewPrinterBulkDelete,
                          tableData: prov.getTableList,
                          popUpMenuItems: (int _) => [
                            //  if (!prov.getTableList.tableDataList[_].itemList[1]
                            //   .contains(':'))
                            LN.connect,
                            if (GlobalCVP.viewWidget.viewPrinterEdit) LN.edit,
                            if (GlobalCVP.viewWidget.viewPrinterDelete)
                              LN.delete,
                          ],
                          deleteItem: (items) {
                            showDialog(
                                context: context,
                                builder: (builder) => ConfirmDialog(
                                      title: items.length > 1
                                          ? "${items.length} ${LN.printerLocations}"
                                          : "${items[0].name}",
                                      onDelete: () async {
                                        prov.deleteData(dataList: items);
                                        return null;
                                      },
                                    ));
                          },
                          selectItem: (count) {
                            prov.setCountSelected = count;
                          },
                          paginate: paginate,
                          total: prov.getAllRes?.total,
                          page: prov.getPage,
                          onAction: prov.loading
                              ? null
                              : (p0, moreFun) async {
                                  // if (prov.addSecData == null ||
                                  //     prov.addSecData!.departments == null) return;
                                  if (moreFun == MoreFun.Edit) {
                                    await prov.getEditData(id: p0.id!);
                                    if (prov.editData == null) return;
                                    if (prov.posPrinterAddSec?.printerTypes
                                            ?.any((e) =>
                                                e.id?.toLowerCase() ==
                                                prov.editData?.printerTypeId
                                                    ?.toLowerCase()) ??
                                        false) {
                                      prov.printerTypeIndex = prov
                                          .posPrinterAddSec!.printerTypes!
                                          .indexWhere((e) =>
                                              e.id?.toLowerCase() ==
                                              prov.editData?.printerTypeId
                                                  ?.toLowerCase());
                                      prov.setPrintTypeEnum();
                                      prov.init();
                                    }
                                    prov.tableData[0].tableCltr.text =
                                        prov.editData!.name ?? '';
                                    prov.tableData[1].tableCltr.text =
                                        prov.editData!.description ?? '';
                                    prov.tableData[2].tableCltr.text =
                                        prov.editData!.ipAddress ?? '';
                                    prov.tableData[3].tableCltr.text =
                                        prov.editData!.port ?? '';

                                    prov.itemId = prov.editData!.id ?? "";
                                    prov.setActiveStatus =
                                        prov.editData!.isActive ?? false;
                                    // prov.printerType =
                                    //     (prov.editData?.isBluetoothPrinter ?? false)
                                    //         ? PrinterType.Bluetooth
                                    //         : PrinterType.Ethernet;
                                    // if (prov.posPrinterAddSec?.printerTypes?.any((e) =>
                                    //         e.id?.toLowerCase() ==
                                    //         prov.editData?.printerTypeId?.toLowerCase()) ??
                                    //     false) {
                                    //   prov.printerTypeIndex =
                                    //       prov.posPrinterAddSec?.printerTypes?.indexWhere((e) =>
                                    //           e.id?.toLowerCase() ==
                                    //           prov.editData?.printerTypeId?.toLowerCase());
                                    // }

                                    _tabController.animateTo(1);
                                    Future.delayed(Duration(milliseconds: 500),
                                        () {
                                      prov.notify;
                                    });
                                    // prov.setDefault = prov.editData!.isDefault ?? false;
                                    // prov.setSIndex = prov.addSecData!.departments!
                                    //     .indexWhere((e) => e.id == prov.editData!.departmentId);
                                  } else if (moreFun == MoreFun.Connect) {
                                    Loading.dialog(context);

                                    await prov.getEditData(id: p0.id!);
                                    if (prov.editData == null) {
                                      Navigator.pop(context);
                                      return;
                                    }

                                    String? printerTypeValue;
                                    if (prov.posPrinterAddSec?.printerTypes
                                            ?.any((e) =>
                                                e.id?.toLowerCase() ==
                                                prov.editData?.printerTypeId
                                                    ?.toLowerCase()) ??
                                        false) {
                                      printerTypeValue = prov
                                          .posPrinterAddSec?.printerTypes
                                          ?.firstWhere((e) =>
                                              e.id?.toLowerCase() ==
                                              prov.editData?.printerTypeId
                                                  ?.toLowerCase())
                                          .value;
                                    }
                                    if (printerTypeValue ==
                                        PrinterTypeEnum.Bluetooth.name) {
                                      BluetoothService.setConnect(PrinterDevice(
                                          name: prov.editData?.name ?? '',
                                          address:
                                              prov.editData?.ipAddress ?? ''));
                                      Navigator.pop(context);
                                      return;
                                    } else if (printerTypeValue ==
                                        PrinterTypeEnum.USB.name) {
                                      UsbService.connect(
                                          device: PrinterDevice(
                                        vendorId: prov.editData?.ipAddress,
                                        productId: prov.editData?.port,
                                        name: prov.editData?.name ?? '',
                                      ));
                                      Navigator.pop(context);
                                      return;
                                    } else {
                                      final status =
                                          await PrinterService.checkDevice(
                                        ip: prov.editData?.ipAddress,
                                        port: int.tryParse(
                                                prov.editData?.port ??
                                                    '9100') ??
                                            9100,
                                        doPrint: false,
                                      );
                                      if (Loading.loadDiaOn) {
                                        Navigator.of(context).pop();
                                      }
                                      await Future.delayed(
                                          Duration(milliseconds: 400));
                                      _showPrinterConnected(
                                        status: status,
                                        title: status == null
                                            ? LN.printerNotFound
                                            : status
                                                ? LN.printerIsConnected
                                                : LN.printerNotConnected,
                                      );
                                    }
                                  }
                                },
                        ),
                      ),
                    )
                  else
                    Center(
                      child: NoItemsSec(
                          size: size,
                          title: 'No printers have been added yet.'),
                    )
                ],
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: AddNewSection(
                    showSaveBtn: GlobalCVP.viewWidget.viewPrinterSaveButton,
                    tableTitle: LN.posPrinter,
                    tableList: prov.tableData,
                    statusClass: [
                      StatusClass(
                          activeText: LN.active,
                          getStatus: prov.getActiveStatus,
                          inActiveText: LN.inActive,
                          setStatus: (val) {
                            prov.setActiveStatus = val;
                          }),
                      // StatusClass(
                      //     activeText: LN.isBluetoothDevice,
                      //     getStatus: prov.printerType == PrinterType.Bluetooth,
                      //     inActiveText: LN.isBluetoothDevice,
                      //     changeColor: false,
                      //     setStatus: (val) {
                      //       if (val) prov.printerType = PrinterType.Bluetooth;
                      //       prov.init(isTableDataUpdate: false);
                      //       prov.notify;
                      //     }),
                    ],
                    onAdd: prov.loading
                        ? null
                        : () async {
                            // if (prov.addSecData == null ||
                            //     prov.addSecData!.departments == null ||
                            //     prov.getSIndex == null) return;

                            if (_formKey.currentState!.validate()) {
                              final printerTypeId = prov.printerTypeIndex !=
                                          null &&
                                      prov.posPrinterAddSec?.printerTypes !=
                                          null
                                  ? (prov
                                      .posPrinterAddSec
                                      ?.printerTypes?[prov.printerTypeIndex!]
                                      .id)
                                  : null;

                              await prov.addUpData(dataList: [
                                PrinterLocationReq(
                                  id: prov.itemId,
                                  // departmentId: prov.addSecData!
                                  //     .departments![prov.getSIndex!].id,
                                  name: prov.tableData[0].tableCltr.text,
                                  description: prov.tableData[1].tableCltr.text,
                                  ipAddress: prov.tableData[2].tableCltr.text,
                                  port: prov.tableData[3].tableCltr.text,
                                  isActive: prov.getActiveStatus,
                                  isBluetoothPrinter: prov.printerType ==
                                      PrinterTypeEnum.Bluetooth,
                                  printerTypeId: printerTypeId,
                                  // isDefault: prov.getDefault,
                                )
                              ]);
                            }
                          },
                    onCancel: () {
                      prov.clear();
                      prov.notify;
                    },
                    isNew: prov.itemId.isEmpty ? true : false,
                    newWidHeight: 0,
                    newWidget: Row(
                      children: [
                        SizedBox(
                          width: size.getW(300),
                          child: GSTextSection(
                            title: LN.printerType,
                            isReq: true,
                            indexVal: prov.printerTypeIndex,
                            list: prov.posPrinterAddSec?.printerTypes == null
                                ? []
                                : prov.posPrinterAddSec!.printerTypes!
                                    .map((e) => e.name ?? '')
                                    .toList(),
                            onChanged: (int? val) {
                              prov.printerTypeIndex = val;
                              prov.setPrintTypeEnum();

                              prov.init();
                              prov.notify;
                            },
                            hintText: LN.choosePrintType,
                          ),
                        ),
                        Spacer(),
                        UsbPrinterSet(
                          onScanDone: (p0) {
                            if (p0 != null) {
                              prov.printerType = PrinterTypeEnum.USB;
                              prov.setPrinterType();
                              prov.init();

                              prov.tableData[0].tableCltr.text = p0.name;
                              prov.tableData[2].tableCltr.text =
                                  p0.vendorId ?? '';
                              prov.tableData[3].tableCltr.text =
                                  p0.productId ?? '';

                              prov.notify;
                            }
                          },
                        ),
                        SizedBox(
                          width: size.getW(12),
                        ),
                        BluetoothPrinterSetup(
                          onScanDone: (p0) {
                            if (p0 != null) {
                              prov.printerType = PrinterTypeEnum.Bluetooth;
                              prov.setPrinterType();
                              prov.init();

                              prov.tableData[0].tableCltr.text = p0.name;
                              prov.tableData[2].tableCltr.text =
                                  p0.address ?? '';

                              prov.notify;
                            }
                          },
                        ),
                        SizedBox(
                          width: size.getW(24),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ])),
          ],
        ),
      ),
    );
  }

  void _showPrinterConnected({bool? status, String title = ""}) {
    MsgDia.show(
      CUS_CTX,
      headerAnimation: false,
      diaType: status == null || !status ? DiaType.warning : DiaType.success,
      title: title,
      desc: status == null || !status ? LN.pleaseTryAgain : null,
      autoHideSecond: 2,
    );
  }
}
