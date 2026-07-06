import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/pos_device/printer_setting_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/pos_setting/com/printing_setup/printer/printer_product_set.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/switch_adap.dart';

class PrinterTypeSec extends StatelessWidget {
  const PrinterTypeSec({
    super.key,
    required this.size,
    required this.pro,
    required this.printerIndex,
  });

  final Ssize size;
  final PrinterSettingPro pro;
  final int printerIndex;

  @override
  Widget build(BuildContext context) {
    if (pro.addSec == null)
      return Container();
    else
      return Padding(
        padding: EdgeInsets.only(bottom: size.getH(12)),
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(color: kSecondaryColor.withAlpha(60)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      color: kSecondaryColor,
                      // height: size.getH(144),
                      padding: EdgeInsets.symmetric(vertical: size.getH(8)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.getW(12),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white, //amber.shade200,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(size.getS(12)),
                            child: Icon(
                              Icons.print_rounded,
                              color: kSecondaryColor,
                              size: size.getS(32),
                            ),
                          ),
                          SizedBox(
                            width: size.getW(12),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pro.addSec?.posPrinters?[printerIndex].name ??
                                      '',
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    fontFamily: kFontFRegular,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    pro.addSec?.posPrinters?[printerIndex]
                                            .value ??
                                        '',
                                    // "IP Address: 192.168.1.82 | Port: 9100",
                                    style: TextStyle(
                                      fontSize: size.getS(14),
                                      fontFamily: kFontFRegular,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: size.getH(8),
                                ),
                                Text(
                                  LN.paperSize,
                                  style: TextStyle(
                                    fontSize: size.getS(14),
                                    fontFamily: kFontFBold,
                                    color: Colors.white,
                                  ),
                                ),
                                Flexible(
                                  child: Wrap(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Checkbox(
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              value: pro
                                                          .getCat(printerIndex)
                                                          ?.paperSize !=
                                                      null &&
                                                  (pro
                                                          .getCat(printerIndex)
                                                          ?.paperSize!
                                                          .contains('80') ??
                                                      false),
                                              activeColor: kPrimaryColor,
                                              checkColor: Colors.white,
                                              side: BorderSide(
                                                  color: Colors.white),
                                              onChanged: (val) {
                                                // pro.paperSizeList[printerIndex] =
                                                //     '80mm';
                                                pro
                                                    .getCat(printerIndex)
                                                    ?.paperSize = '80mm';
                                                pro.notify;
                                              }),
                                          InkWell(
                                            onTap: () {
                                              // pro.paperSizeList[printerIndex] =
                                              //     '80mm';
                                              pro
                                                  .getCat(printerIndex)
                                                  ?.paperSize = '80mm';
                                              pro.notify;
                                            },
                                            child: Text(
                                              "80mm",
                                              style: TextStyle(
                                                fontSize: size.getS(14),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: size.getW(8),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Checkbox(
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              value: pro
                                                          .getCat(printerIndex)
                                                          ?.paperSize !=
                                                      null &&
                                                  (pro
                                                          .getCat(printerIndex)
                                                          ?.paperSize!
                                                          .contains('50') ??
                                                      false),
                                              activeColor: kPrimaryColor,
                                              checkColor: Colors.white,
                                              side: BorderSide(
                                                  color: Colors.white),
                                              onChanged: (val) {
                                                // pro.paperSizeList[printerIndex] =
                                                //     '50mm';
                                                pro
                                                    .getCat(printerIndex)
                                                    ?.paperSize = '50mm';
                                                pro.notify;
                                              }),
                                          InkWell(
                                            onTap: () {
                                              // pro.paperSizeList[printerIndex] =
                                              //     '50mm';
                                              pro
                                                  .getCat(printerIndex)
                                                  ?.paperSize = '50mm';
                                              pro.notify;
                                            },
                                            child: Text(
                                              "50mm",
                                              style: TextStyle(
                                                fontSize: size.getS(14),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.getW(8),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 5,
                  child: Container(
                    // color: kSecondaryColor.withAlpha(60),
                    // height: size.getH(144),
                    // height: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: size.getW(16), vertical: size.getH(12)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            // alignment: WrapAlignment.spaceBetween,
                            runAlignment: WrapAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            runSpacing: size.getW(20),
                            spacing: size.getW(12),

                            children: [
                              if (pro.addSec!.cateogoryTypes != null)
                                ...List.generate(
                                  pro.addSec!.cateogoryTypes!.length,
                                  (index) => _switchTextWithColumn(
                                      title: pro
                                          .addSec!.cateogoryTypes![index].value,
                                      value: pro.addSec!.cateogoryTypes![index]
                                                  .id !=
                                              null &&
                                          (pro
                                                  .getCat(printerIndex)
                                                  ?.categoryTypeIds
                                                  ?.contains(pro
                                                      .addSec!
                                                      .cateogoryTypes![index]
                                                      .id!) ??
                                              false),
                                      onChanged: (val) {
                                        final catIds = pro
                                            .getCat(printerIndex)
                                            ?.categoryTypeIds;

                                        if (catIds != null &&
                                            pro.addSec!.cateogoryTypes![index]
                                                    .id !=
                                                null) {
                                          pro
                                              .getCat(printerIndex)
                                              ?.categoryTypeIds ??= [];
                                          if (val) {
                                            pro
                                                .getCat(printerIndex)
                                                ?.categoryTypeIds
                                                ?.add(pro
                                                    .addSec!
                                                    .cateogoryTypes![index]
                                                    .id!);
                                          } else {
                                            pro
                                                .getCat(printerIndex)
                                                ?.categoryTypeIds
                                                ?.removeWhere((e) =>
                                                    e ==
                                                    pro
                                                        .addSec!
                                                        .cateogoryTypes![index]
                                                        .id!);
                                          }
                                        }
                                        pro.notify;
                                      }),
                                ),
                              // _switchTextWithColumn(
                              //   title: LN.setMenuKit,
                              //   value:
                              //       pro.getCat(printerIndex)?.printSetMenuKit,
                              //   onChanged: (val) {
                              //     pro.editData?.printerCategoryTypeAddViewModels
                              //         ?.forEach((e) {
                              //       e.printSetMenuKit = false;
                              //     });

                              //     pro.getCat(printerIndex)?.printSetMenuKit =
                              //         val;
                              //     pro.notify;
                              //   },
                              // ),
                              _switchTextWithColumn(
                                title: LN.printInvoice,
                                value: pro.getCat(printerIndex)?.printInvoice,
                                onChanged: (val) {
                                  pro.getCat(printerIndex)?.printInvoice = val;
                                  pro.notify;
                                },
                              ),
                              if (GlobalCVP.eftPosEnable)
                                _switchTextWithColumn(
                                  title: LN.printEftSign,
                                  value: pro
                                      .getCat(printerIndex)
                                      ?.printEftPosSignature,
                                  onChanged: (val) {
                                    pro
                                        .getCat(printerIndex)
                                        ?.printEftPosSignature = val;
                                    pro.notify;
                                  },
                                ),
                              if (GlobalCVP.eftPosEnable)
                                _switchTextWithColumn(
                                  title: LN.printEftLogs,
                                  value:
                                      pro.getCat(printerIndex)?.printEftPosLog,
                                  onChanged: (val) {
                                    pro.getCat(printerIndex)?.printEftPosLog =
                                        val;
                                    pro.notify;
                                  },
                                ),
                              _switchTextWithColumn(
                                title: LN.invoicePrintCusCopy,
                                value: pro
                                        .getCat(printerIndex)
                                        ?.printBillCustomerCopy ??
                                    false,
                                onChanged: (p0) {
                                  pro
                                      .getCat(printerIndex)
                                      ?.printBillCustomerCopy = p0;
                                  pro.notify;
                                },
                              ),
                              _switchTextWithColumn(
                                title: LN.orderPrintCopy,
                                value:
                                    pro.getCat(printerIndex)?.orderPrintCopy ??
                                        false,
                                onChanged: (p0) {
                                  pro.getCat(printerIndex)?.orderPrintCopy = p0;
                                  pro.notify;
                                },
                              ),
                              // _switchTextWithColumn(
                              //   title: "Open Cash Drawer",
                              //   value:
                              //       pro.getCat(printerIndex)?.openCashRegister ?? false,
                              //   onChanged: (p0) {
                              //     pro.getCat(printerIndex)?.openCashRegister = p0;
                              //     pro.notify;
                              //   },
                              // ),
                              _switchTextWithColumn(
                                title: LN.printEodSum,
                                value:
                                    pro.getCat(printerIndex)?.printEodSummary ??
                                        false,
                                onChanged: (p0) {
                                  pro.editData?.printerCategoryTypeAddViewModels
                                      ?.forEach((e) {
                                    e.printEodSummary = false;
                                  });

                                  pro.getCat(printerIndex)?.printEodSummary =
                                      p0;
                                  pro.notify;
                                },
                              ),
                            ],
                          ),
                        ),
                        if (GlobalCVP.isHospitality)
                          LoadButton(
                            btnText: "Assign Product",
                            hPad: 0,
                            vPad: 8,
                            onsave: () {
                              showDialog(
                                  context: context,
                                  builder: (builder) => SimpleDialog(
                                        backgroundColor: Colors.white,
                                        titlePadding: EdgeInsets.zero,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        children: [
                                          PrinterProductSet(
                                            printerAddSec: pro.addSec,
                                            printerIndex: printerIndex,
                                          )
                                        ],
                                      ));
                            },
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: kSecondaryColor,
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            btnColor: Colors.white,
                            textColor: kSecondaryColor,

                            // width: 140,
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }

  Widget _switchTextWithColumn({
    String? title,
    bool? value,
    Function(bool)? onChanged,
  }) {
    return SizedBox(
      width: size.getW(180),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchAdap(
            size: size,
            value: value ?? false,
            activeColor: kSecondaryColor,
            onChanged: onChanged,
            height: 36,
          ),
          Expanded(
            child: Text(
              title ?? '',
              style: TextStyle(
                fontSize: size.getS(15),
                color: Colors.black,
                fontFamily: kFontFMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
