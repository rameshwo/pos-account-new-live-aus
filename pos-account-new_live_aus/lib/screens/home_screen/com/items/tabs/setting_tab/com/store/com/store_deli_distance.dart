import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/store/store_pro.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';

class StoreDeliDistance extends StatelessWidget {
  // final StorePro storePro;
  final void Function()? cancel;
  const StoreDeliDistance({
    super.key,
    // required this.storePro,
    this.cancel,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final storePro = Provider.of<StorePro>(context);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.getH(12),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: size.getH(24.0), horizontal: size.getW(24)),
                child: Wrap(
                  spacing: size.getW(48),
                  runSpacing: size.getH(24),
                  children: [
                    TitleDropDown(
                      isReq: false,
                      pWidth: 0.24,
                      borderRadius: 5,
                      list: (storePro.storeRes == null ||
                              storePro.storeRes!.distanceKmsMiles == null)
                          ? []
                          : storePro.storeRes!.distanceKmsMiles!
                              .map((e) => e.value ?? '')
                              .toList(),
                      indexVal: storePro.distanceTypeIndex,
                      title: LN.distanceType,
                      onChanged: (int? p0) {
                        storePro.distanceTypeIndex = p0;
                        storePro.notify();
                      },
                    ),
                    // if (GlobalCVP.viewWidget(
                    //     Strings.ViewCreateUberDeliveryButton))
                    SizedBox(
                      width: size.getW(260),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Enable Uber Delivery",
                              style: TextStyle(
                                fontSize: size.getS(18),
                                color: Colors.black,
                              )),
                          SizedBox(
                            width: size.getW(16),
                          ),
                          SwitchAdap(
                            size: size,
                            value: storePro.enableUberDelivery,
                            activeColor: kPrimaryColor,
                            onChanged: (val) {
                              storePro.enableUberDelivery = val;
                              storePro.notify();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.getH(24),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: size.getH(24.0), horizontal: size.getW(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TitleTextForm(
                          isReq: false,
                          pWidth: 0.24,
                          title: LN.distanceFrom,
                          textCltr: storePro.distanceAmountList[0].fromCltr,
                          errH: 0,
                          textInputType: TextInputType.number,
                          suffixIcon: storePro.distanceAmountList[0].fromCltr
                                  .text.isNotEmpty
                              ? InkWell(
                                  onTap: () {
                                    storePro.distanceAmountList[0].fromCltr
                                        .clear();
                                    storePro.notify();
                                  },
                                  child: Icon(Icons.close, size: size.getS(28)))
                              : null,
                        ),
                        SizedBox(
                          width: size.getW(48),
                        ),
                        TitleTextForm(
                          pWidth: 0.24,
                          isReq: false,
                          title: LN.distanceTo,
                          textCltr: storePro.distanceAmountList[0].toCltr,
                          errH: 0,
                          textInputType: TextInputType.number,
                          suffixIcon: storePro
                                  .distanceAmountList[0].toCltr.text.isNotEmpty
                              ? InkWell(
                                  onTap: () {
                                    storePro.distanceAmountList[0].toCltr
                                        .clear();
                                    storePro.notify();
                                  },
                                  child: Icon(Icons.close, size: size.getS(28)))
                              : null,
                        ),
                        SizedBox(
                          width: size.getW(48),
                        ),
                        TitleTextForm(
                          pWidth: 0.1,
                          isReq: false,
                          title: LN.amount,
                          textCltr: storePro.distanceAmountList[0].dataCltr,
                          errH: 0,
                          textInputType: TextInputType.number,
                          prefixText: Text(
                            "${storePro.curSym}",
                            style: TextStyle(
                              fontSize: size.getS(16),
                              color: Colors.black,
                            ),
                          ),
                          suffixIcon: storePro.distanceAmountList[0].dataCltr
                                  .text.isNotEmpty
                              ? InkWell(
                                  onTap: () {
                                    storePro.distanceAmountList[0].dataCltr
                                        .clear();
                                    storePro.notify();
                                  },
                                  child: Icon(Icons.close, size: size.getS(28)))
                              : null,
                        ),
                        SizedBox(
                          width: size.getW(48),
                        ),
                        Material(
                          color: kPrimaryColor,
                          type: MaterialType.circle,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(60),
                            onTap: storePro.addDistAmount,
                            child: Icon(
                              Icons.add,
                              size: size.getS(48),
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    ...List.generate(storePro.distanceAmountList.length,
                        (index) {
                      if (index == 0) return SizedBox.shrink();
                      return Padding(
                        padding: EdgeInsets.only(top: size.getH(24.0)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: size.width * 0.24,
                              child: TextFormWidget(
                                cltr:
                                    storePro.distanceAmountList[index].fromCltr,
                                hintText: '',
                                borderColor: Colors.black,
                                borderRadius: 5,
                                vPad: 12,
                                hPad: 16,
                                errH: 0,
                                textInputType: TextInputType.number,
                              ),
                            ),
                            SizedBox(
                              width: size.getW(48),
                            ),
                            SizedBox(
                              width: size.width * 0.24,
                              child: TextFormWidget(
                                cltr: storePro.distanceAmountList[index].toCltr,
                                hintText: '',
                                borderColor: Colors.black,
                                borderRadius: 5,
                                vPad: 12,
                                hPad: 16,
                                errH: 0,
                                textInputType: TextInputType.number,
                              ),
                            ),
                            SizedBox(
                              width: size.getW(48),
                            ),
                            SizedBox(
                              width: size.width * 0.1,
                              child: TextFormWidget(
                                cltr:
                                    storePro.distanceAmountList[index].dataCltr,
                                hintText: '',
                                borderColor: Colors.black,
                                borderRadius: 5,
                                vPad: 12,
                                hPad: 16,
                                errH: 0,
                                textInputType: TextInputType.number,
                              ),
                            ),
                            SizedBox(
                              width: size.getW(48),
                            ),
                            Material(
                              color: Colors.red.shade700,
                              type: MaterialType.circle,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(60),
                                onTap: () {
                                  storePro.removeDistAmount(index: index);
                                },
                                child: Icon(
                                  Icons.remove,
                                  size: size.getS(48),
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                    SizedBox(
                      height: size.getH(24),
                    ),
                    // Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     if (GlobalCVP.viewWidget.viewStoreDeliveryTabSaveButton)
                    //       LoadButton(
                    //         loading: storePro.updateLoad,
                    //         onsave: storePro.updateLoad
                    //             ? null
                    //             : () => storePro.addData(context),
                    //       ),
                    //     SizedBox(
                    //       width: size.getW(24),
                    //     ),
                    //     if (GlobalCVP
                    //         .viewWidget.viewStoreDeliveryTabCancelButton)
                    //       ElevatedButton(
                    //           style: ButtonStyle(
                    //               backgroundColor: MaterialStateProperty.all(
                    //                   Colors.red.shade800),
                    //               padding: MaterialStateProperty.all(
                    //                   EdgeInsets.symmetric(
                    //                       horizontal: size.getW(48),
                    //                       vertical: size.getH(8)))),
                    //           onPressed: cancel,
                    //           child: Text(
                    //             LN.cancel,
                    //             style: TextStyle(
                    //               fontSize: size.getS(16),
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           )),
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.getH(12),
          ),
        ],
      ),
    );
  }
}
