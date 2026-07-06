import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/pos_device/pos_device/all_pos_device.dart';
import 'package:pos_account/providers/setting/pos_device/pos_device_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/add_new_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/general_set.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:pos_account/widgets/paginate_sec.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../model/ui_model/screen_time_model.dart';
import 'pos_device_qr_dia.dart';

class PosDeviceSet extends StatefulWidget {
  final PageController pageController;

  const PosDeviceSet({super.key, required this.pageController});

  @override
  State<PosDeviceSet> createState() => _PosDeviceSetState();
}

class _PosDeviceSetState extends State<PosDeviceSet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  PosDevicePro? _prov;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    setData();
    super.initState();
  }

  setData() async {
    _prov = Provider.of<PosDevicePro>(context, listen: false);
    if (_prov != null) {
      _prov!.init();
      _prov!.getAddSec();
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

  final List<Map<String, String>> posList = const [
    {
      "title": "New Tab",
      "id": "c5bf960bc21f99a0",
    },
    {
      "title": "Mx Pos",
      "id": "fe497d8eba9b6d45",
    },
    {
      "title": "Live Playstored",
      "id": "f40343a1c518abf2",
    },
    {
      "title": "Play Stored Kiosk",
      "id": "8c14b32add3ad4cf",
    },
  ];

  @override
  void dispose() {
    _prov?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final prov = Provider.of<PosDevicePro>(context);

    return Processing(
      loading: prov.loading,
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTabRow(
              addTitle: "Add POS Device",
              viewTitle: "POS Device List",
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
            // add update section
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.getW(12)),
                      child: SizedBox(
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
                    ),
                    SizedBox(
                      height: size.getH(6),
                    ),
                    if (prov.loading ||
                        (prov.allPosDevices?.data?.isNotEmpty ?? false))
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...List.generate(prov.groupedData.length, (i) {
                                return POSDeviceCard(
                                    size: size,
                                    groupData: prov.groupedData[i],
                                    onAction:
                                        (String key, PosDeviceData device) {
                                      if (key == LN.edit) {
                                        prov.itemId = device.id ?? '';
                                        prov.getEditData().then((val) {
                                          if (val ?? false) {
                                            _tabController.animateTo(1);
                                            Future.delayed(
                                                Duration(milliseconds: 500),
                                                () {
                                              prov.notify;
                                            });
                                          }
                                        });
                                      } else if (key == LN.genQr) {
                                        prov.generateQr(
                                            deviceId: device.deviceIdentifier);
                                      } else if (key == LN.viewQr) {
                                        if (device.imageUrl?.isNotEmpty ??
                                            false) {
                                          PosDeviceQrShow.showQRDia(
                                              ctx: context,
                                              diaName: LN.posDeviceQr,
                                              title: device
                                                      .posDeviceNameOrLocation ??
                                                  '',
                                              image: device.imageUrl ?? '');
                                        } else {
                                          IfException.showMessage(
                                              message: LN.npQrFound);
                                          return;
                                        }
                                      }
                                    });
                              }),
                              SizedBox(
                                height: size.getH(24),
                              ),
                            ],
                          ),
                        ),
                      )

                    // Flexible(
                    //   child: SingleChildScrollView(
                    // child:
                    //  TableData(
                    //       popUpMenuItems: (int _) => [
                    //         LN.edit,
                    //         LN.genQr,
                    //         LN.viewQr,

                    //       ],
                    //       tableData: prov.tableList,

                    //       selectItem: (count) {
                    //         prov.selectedCount = count;
                    //         prov.notify;
                    //       },
                    //       paginate: paginate,
                    //       total: prov.allPosDevices?.total,
                    //       page: prov.pageIndex,
                    //       onAction: prov.loading
                    //           ? null
                    //           : (p0, moreFun) {
                    //               final device = (prov.allPosDevices?.data
                    //                           ?.any((e) =>
                    //                               e.id?.toLowerCase() ==
                    //                               p0.id?.toLowerCase()) ??
                    //                       false)
                    //                   ? prov.allPosDevices?.data?.firstWhere(
                    //                       (e) =>
                    //                           e.id?.toLowerCase() ==
                    //                           p0.id?.toLowerCase())
                    //                   : null;

                    //               if (moreFun == MoreFun.Edit) {
                    //                 prov.itemId = p0.id ?? '';
                    //                 prov.getEditData().then((val) {
                    //                   if (val ?? false) {
                    //                     _tabController.animateTo(1);
                    //                     Future.delayed(
                    //                         Duration(milliseconds: 500), () {
                    //                       prov.notify;
                    //                     });
                    //                   }
                    //                 });
                    //               }
                    //               // else if (moreFun == MoreFun.Connect) {
                    //               //   prov.updateDeviceForPos(id: p0.id);
                    //               // }
                    //               else if (moreFun == MoreFun.Generate) {
                    //                 if (device != null) {
                    //                   prov.generateQr(
                    //                       deviceId: device.deviceIdentifier);
                    //                 }
                    //               } else if (moreFun == MoreFun.View) {
                    //                 if (device?.imageUrl?.isNotEmpty ??
                    //                     false) {
                    //                   PosDeviceQrShow.showQRDia(
                    //                       ctx: context,
                    //                       diaName: LN.posDeviceQr,
                    //                       title: device
                    //                               ?.posDeviceNameOrLocation ??
                    //                           '',
                    //                       image: device?.imageUrl ?? '');
                    //                 } else {
                    //                   showToast(LN.npQrFound);
                    //                   return;
                    //                 }
                    //               }
                    //             },
                    //     ),
                    //   ),
                    // )
                    else
                      Center(
                        child: NoItemsSec(
                            size: size,
                            title: 'No POS devices have been added yet.'),
                      ),
                    if (prov.allPosDevices?.data?.isNotEmpty ?? false)
                      PaginateButton(
                        total: prov.allPosDevices?.total ?? 0,
                        pageSize: 50,
                        pageIndex: prov.pageIndex,
                        next: () => paginate(prov.pageIndex + 1),
                        prev: () => paginate(prov.pageIndex - 1),
                      ),
                  ],
                ),
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: size.getH(24)),
                      child: AddNewSection(
                        tableTitle: LN.posDevices,
                        tableList: prov.tableData,
                        onAdd: prov.loading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await prov.addUpdate();
                                }
                              },
                        statusClass: [
                          StatusClass(
                              activeText: LN.active,
                              getStatus: prov.isActive,
                              inActiveText: LN.inActive,
                              setStatus: (val) {
                                prov.isActive = val;
                                prov.notify;
                              }),
                          // StatusClass(
                          //     activeText: "Default",
                          //     getStatus: prov.isDefault,
                          //     inActiveText: "Default",
                          //     setStatus: (val) {
                          //       prov.isDefault = val;
                          //       prov.notify;
                          //     }),
                        ],
                        isNew: prov.itemId.isEmpty,
                        newWidget: SizedBox(
                          width: size.getW(300),
                          child: GSTextSection(
                            title: "Device Type",
                            isReq: false,
                            indexVal: prov.posDeviceIndex,
                            list: prov.posDeviceAddSec?.posDeviceTypes == null
                                ? []
                                : prov.posDeviceAddSec!.posDeviceTypes!
                                    .map((e) => e.value ?? '')
                                    .toList(),
                            onChanged: (int? val) {
                              prov.posDeviceIndex = val;
                              prov.clearOnChangeDevice();
                              prov.notify;
                            },
                            hintText: "Select Device Type",
                          ),
                        ),
                        // newWidget: Wrap(
                        //   spacing: size.getW(size.isProt ? 24 : 24),
                        //   runSpacing: size.getH(16),
                        //   crossAxisAlignment: WrapCrossAlignment.start,
                        //   children: [
                        //     SizedBox(
                        //       width: size.getW(300),
                        //       child: GSTextSection(
                        //         title: LN.department,
                        //         isReq: true,
                        //         indexVal: prov.departmentIndex,
                        //         list: prov.posDeviceAddSec?.departments == null
                        //             ? []
                        //             : prov.posDeviceAddSec!.departments!
                        //                 .map((e) => e.value ?? '')
                        //                 .toList(),
                        //         onChanged: (int? val) {
                        //           prov.departmentIndex = val;
                        //           prov.notify;
                        //         },
                        //         hintText: LN.chooseDepartment,
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: size.getW(300),
                        //       child: GSTextSection(
                        //         title: LN.table,
                        //         isReq: false,
                        //         indexVal: prov.tableIndex,
                        //         list: prov.posDeviceAddSec?.tables == null
                        //             ? []
                        //             : prov.posDeviceAddSec!.tables!
                        //                 .map((e) => e.value ?? '')
                        //                 .toList(),
                        //         onChanged: (int? val) {
                        //           prov.tableIndex = val;
                        //           prov.notify;
                        //         },
                        //         hintText: LN.chooseTable,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        bottomWidget: _posDeviceBody(size, prov: prov),
                        onCancel: () {
                          prov.clear();
                          prov.notify;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget? _posDeviceBody(
    Ssize size, {
    required PosDevicePro prov,
  }) {
    Widget _printerNCashRegister() {
      return Card(
        margin: EdgeInsets.only(top: size.getH(16)),
        color: Colors.grey.shade50,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.all(size.getS(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.print_outlined, size: size.getS(25)),
                  SizedBox(width: size.getW(12)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Printer & Cash Register",
                        style: TextStyle(
                          fontSize: size.getS(16),
                          // fontFamily: kFontFMedium,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Configure printer settings and cash drawer access for this device",
                        style: TextStyle(
                          fontSize: size.getS(14),
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              // InfoMessageSec(
              //     message:
              //         "Please check below settings if you want to do invoice printing or open cash register from this pos device individually."),
              SizedBox(height: size.getH(12)),
              SizedBox(
                width: size.getW(400),
                child: GSTextSection(
                    title: LN.printer,
                    isReq: false,
                    indexVal: prov.printerIndex,
                    list: prov.posDeviceAddSec?.posPrinters == null
                        ? []
                        : prov.posDeviceAddSec!.posPrinters!
                            .map((e) => e.name ?? '')
                            .toList(),
                    onChanged: (int? val) {
                      prov.printerIndex = val;
                      prov.notify;
                    },
                    hintText: "Select Printers",
                    sufIcon: InkWell(
                        onTap: () {
                          prov.printerIndex = null;
                          prov.notify;
                        },
                        child: Icon(Icons.close, size: size.getS(24)))),
              ),
            ],
          ),
        ),
      );
    }

    Widget _posControlAndPermission() {
      return Card(
        margin: EdgeInsets.only(top: size.getH(16)),
        color: Colors.grey.shade50,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.all(size.getS(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    size: size.getS(25),
                    // color: kSecondaryColor,
                  ),
                  SizedBox(width: size.getW(12)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pos Device Controls and Permissions",
                        style: TextStyle(
                          fontSize: size.getS(16),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Define what this employee can do in the system by assigning appropriate roles.",
                        style: TextStyle(
                          fontSize: size.getS(14),
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: size.getH(12)),
              Wrap(
                spacing: size.getW(24),
                runSpacing: size.getH(12),
                children: [
                  if (prov.isPosDevice)
                    SizedBox(
                      width: size.getW(400),
                      child: GSTextSection(
                          title: "POS Default Screen",
                          isReq: false,
                          indexVal: prov.posDefaultScreenIndex,
                          list: prov.posDeviceAddSec?.posDefaultScreens == null
                              ? []
                              : prov.posDeviceAddSec!.posDefaultScreens!
                                  .map((e) => e.name ?? '')
                                  .toList(),
                          onChanged: (int? val) {
                            prov.posDefaultScreenIndex = val;
                            prov.notify;
                          },
                          hintText: "Select default screen",
                          sufIcon: InkWell(
                              onTap: () {
                                prov.posDefaultScreenIndex = null;
                                prov.notify;
                              },
                              child: Icon(Icons.close, size: size.getS(24)))),
                    ),
                  SizedBox(
                    width: size.getW(400),
                    child: GSTextSection(
                        title: "Screen Saver Log Interval",
                        isReq: false,
                        indexVal: prov.screenSaverIndex,
                        list: ScreenTimeOut.map((e) => e.title).toList(),
                        onChanged: (int? val) {
                          prov.screenSaverIndex = val;
                          prov.notify;
                        },
                        hintText: "Select interval",
                        sufIcon: InkWell(
                            onTap: () {
                              prov.screenSaverIndex = null;
                              prov.notify;
                            },
                            child: Icon(Icons.close, size: size.getS(24)))),
                  ),
                  if (prov.isPosDevice)
                    Padding(
                      padding: EdgeInsets.all(size.getS(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enable Pin-Code PopUp Screen",
                            style: TextStyle(
                              fontSize: size.getS(16),
                              fontFamily: kFontFMedium,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: size.getH(6),
                          ),
                          SwitchAdap(
                            size: size,
                            value: prov.enableLoginPinCode,
                            onChanged: (val) {
                              prov.enableLoginPinCode = val;
                              prov.notify;
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      );
    }

    if (prov.isPosDevice)
      return Padding(
        padding: EdgeInsets.only(top: size.getH(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.zero,
              color: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: EdgeInsets.all(size.getS(24)),
                child: Row(
                  children: [
                    Icon(Icons.devices, size: size.getS(25)),
                    SizedBox(width: size.getW(12)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Main POS Device",
                              style: TextStyle(
                                fontSize: size.getS(16),
                                // fontFamily: kFontFMedium,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: size.getW(12)),
                            SwitchAdap(
                              size: size,
                              value: prov.isMainDevice,
                              onChanged: (val) {
                                prov.isMainDevice = val;
                                prov.notify;
                              },
                            ),
                          ],
                        ),
                        Text(
                          "Enable this device as main pos to receive realtime notification, automatic and fast print. If configured as main pos this device should always open and have power turned off.",
                          style: TextStyle(
                            fontSize: size.getS(14),
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            _printerNCashRegister(),
            SizedBox(
              height: size.getH(16),
            ),
            Card(
              margin: EdgeInsets.zero,
              color: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: EdgeInsets.all(size.getS(24)),
                child: Row(
                  children: [
                    Icon(Icons.point_of_sale, size: size.getS(25)),
                    SizedBox(width: size.getW(12)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Open Cash Register",
                              style: TextStyle(
                                fontSize: size.getS(16),
                                // fontFamily: kFontFMedium,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: size.getW(12)),
                            SwitchAdap(
                              size: size,
                              value: prov.openCashRegister,
                              onChanged: (val) {
                                prov.openCashRegister = val;
                                prov.notify;
                              },
                            ),
                          ],
                        ),
                        Text(
                          "Enable this device to open the cash register",
                          style: TextStyle(
                            fontSize: size.getS(14),
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            _posControlAndPermission(),
            SizedBox(
              height: size.getH(16),
            ),
            // Card(
            //   margin: EdgeInsets.zero,
            //   child: Padding(
            //     padding: EdgeInsets.all(size.getS(16)),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         // InfoMessageSec(
            //         //     message:
            //         //         "Please select product categories to be used in this device."),
            //         Theme(
            //           data: ThemeData().copyWith(
            //               dividerColor: Colors.transparent),
            //           child: CusExpansionTile(
            //             title: Text(
            //               "Set Product Categories",
            //               style: TextStyle(
            //                 fontSize: size.getS(16),
            //                 fontFamily: kFontFMedium,
            //                 color: Colors.black,
            //               ),
            //             ),
            //             controlAffinity:
            //                 ListTileControlAffinity.leading,
            //             tilePadding: EdgeInsets.zero,
            //             childrenPadding: EdgeInsets.zero,
            //             onExpansionChanged: (val) {
            //               prov.categoryExpanded = val;
            //               prov.notify;
            //             },
            //             children: [
            //               SizedBox(height: size.getH(12)),
            //               if (prov.posDeviceAddSec != null &&
            //                   (prov
            //                           .posDeviceAddSec!
            //                           .productCategories
            //                           ?.isNotEmpty ??
            //                       false))
            //                 Wrap(
            //                   spacing: size.getW(24),
            //                   runSpacing: size.getH(16),
            //                   crossAxisAlignment:
            //                       WrapCrossAlignment.start,
            //                   children: prov.posDeviceAddSec!
            //                       .productCategories!
            //                       .map(
            //                         (e) => InkWell(
            //                           onTap: () {
            //                             prov.onSelectCategory(
            //                                 e);
            //                           },
            //                           child: Container(
            //                             width: size.getW(200),
            //                             decoration:
            //                                 BoxDecoration(
            //                               color: prov
            //                                       .selectedCategoryList
            //                                       .any((element) =>
            //                                           element
            //                                               .productCategoryId ==
            //                                           e.id)
            //                                   ? kSecondaryColor
            //                                   : Colors.white,
            //                               border: Border.all(
            //                                   color: prov
            //                                           .selectedCategoryList
            //                                           .any((element) =>
            //                                               element
            //                                                   .productCategoryId ==
            //                                               e.id)
            //                                       ? kSecondaryColor
            //                                       : Colors.grey
            //                                           .shade300),
            //                               borderRadius:
            //                                   BorderRadius
            //                                       .circular(5),
            //                             ),
            //                             height: 50,
            //                             child: Center(
            //                               child: Text(
            //                                 e.name ?? '',
            //                                 style: TextStyle(
            //                                   fontSize:
            //                                       size.getS(16),
            //                                   color: prov
            //                                           .selectedCategoryList
            //                                           .any((element) =>
            //                                               element
            //                                                   .productCategoryId ==
            //                                               e.id)
            //                                       ? Colors.white
            //                                       : Colors
            //                                           .black,
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       )
            //                       .toList(),
            //                 ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    else if (prov.isKioskDevice)
      return Padding(
        padding: EdgeInsets.only(top: size.getH(24)),
        child: Column(
          children: [
            _printerNCashRegister(),
            _posControlAndPermission(),
          ],
        ),
      );
    else
      return null;
  }
}

// Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.all(size.getS(16)),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.tv_outlined, size: size.getS(25)),
//                             SizedBox(width: size.getW(12)),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Kitchen Display Permission",
//                                   style: TextStyle(
//                                     fontSize: size.getS(16),
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 Text(
//                                   "Assign the POS device as Kitchen Display",
//                                   style: TextStyle(
//                                     fontSize: size.getS(14),
//                                     color: Colors.black54,
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                         SizedBox(height: size.getH(12)),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Is Kitchen Display ?",
//                               style: TextStyle(
//                                 fontSize: size.getS(16),
//                                 fontFamily: kFontFMedium,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             SizedBox(
//                               height: size.getH(12),
//                             ),
//                             SwitchAdap(
//                               size: size,
//                               value: prov.isKitchenDisplay,
//                               onChanged: (val) {
//                                 prov.isKitchenDisplay = val;
//                                 prov.notify;
//                               },
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 )

class POSDeviceCard extends StatelessWidget {
  final Ssize size;
  final Map<String, List<PosDeviceData>?> groupData;
  final Function(String, PosDeviceData) onAction;
  const POSDeviceCard(
      {super.key,
      required this.size,
      required this.groupData,
      required this.onAction});

  @override
  Widget build(BuildContext context) {
    final _data = groupData.entries.isNotEmpty
        ? groupData.entries.first.value ?? <PosDeviceData>[]
        : <PosDeviceData>[];
    final _deviceType =
        groupData.entries.isNotEmpty ? groupData.entries.first.key : "";
    if (_data.isEmpty)
      return SizedBox.shrink();
    else
      return Container(
        margin: EdgeInsets.all(size.getS(12)),
        padding: EdgeInsets.symmetric(
            horizontal: size.getW(18), vertical: size.getH(8)),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F5F7),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.black26,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _deviceType,
                  style: TextStyle(
                    fontSize: size.getS(20),
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E2430),
                  ),
                ),
                SizedBox(width: size.getW(8)),
                Text(
                  "(${_data.length})",
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.getH(8)),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: size.getW(12),
                mainAxisSpacing: size.getH(12),
                mainAxisExtent: 150,
              ),
              itemBuilder: (context, index) {
                // final item = posList[index];

                return _PosCard(
                  title: _data[index].posDeviceNameOrLocation ?? '',
                  id: _data[index].deviceIdentifier ?? '',
                  size: size,
                  iconData: _deviceType.toLowerCase().contains('kiosk')
                      ? Icons.phone_android_outlined
                      : _deviceType.toLowerCase().contains('kitchen')
                          ? Icons.fastfood_outlined
                          : Icons.desktop_windows_outlined,
                  isActive: _data[index].isActive ?? false,
                  onAction: (String val) => onAction(val, _data[index]),
                );
              },
            ),
          ],
        ),
      );
  }
}

class _PosCard extends StatelessWidget {
  final String title;
  final String id;
  final Ssize size;
  final IconData iconData;
  final bool isActive;
  final Function(String) onAction;
  const _PosCard({
    required this.title,
    required this.id,
    required this.size,
    this.iconData = Icons.desktop_windows_outlined,
    this.isActive = false,
    required this.onAction,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size.getS(8)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE4E7EC),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.getS(48),
                height: size.getS(48),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  iconData,
                  color: Color(0xFF6B7280),
                  size: size.getS(25),
                ),
              ),
              SizedBox(width: size.getW(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: size.getS(16),
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: size.getH(4)),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "ID: ",
                            style: TextStyle(
                              color: Color(0xFF98A2B3),
                              fontSize: size.getS(15),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: id,
                            style: TextStyle(
                              color: Color(0xFF667085),
                              fontSize: size.getS(15),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.getH(8)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.getW(12),
                        vertical: size.getH(8),
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFFEAF9E7)
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isActive
                              ? const Color(0xFFB7E3AE)
                              : Colors.red.shade100,
                        ),
                      ),
                      child: Text(
                        isActive ? "Active" : "InActive",
                        style: TextStyle(
                          color: isActive
                              ? Color(0xFF4DA12C)
                              : Colors.red.shade700,
                          fontWeight: FontWeight.w700,
                          fontSize: size.getH(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(100),
                itemBuilder: (BuildContext context) {
                  return [
                    LN.edit,
                    LN.genQr,
                    LN.viewQr,
                  ].map((a) {
                    return PopupMenuItem(
                        value: a,
                        child: Text(
                          a,
                          style: TextStyle(fontSize: size.getS(16)),
                        ));
                  }).toList();
                },
                onSelected: (String val) => onAction(val),
                child: Container(
                  width: size.getS(48),
                  height: size.getS(48),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF6F5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF46B7B0),
                    size: size.getS(25),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
