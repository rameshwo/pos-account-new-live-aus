import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/store/store_pro.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';

class StoreLoyality extends StatelessWidget {
  // final StorePro storePro;
  final void Function()? cancel;
  const StoreLoyality({
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
                    TitleTextForm(
                      pWidth: 0.24,
                      isReq: false,
                      title: LN.maxClaimPoints,
                      textCltr: storePro.maxClaimPointsCltr,
                      textInputType: TextInputType.number,
                    ),
                    TitleTextForm(
                      pWidth: 0.24,
                      isReq: false,
                      title: LN.maxClaimAmt,
                      textCltr: storePro.maxClaimAmountCltr,
                      textInputType: TextInputType.number,
                      prefixText: Text(
                        "${storePro.curSym}",
                        style: TextStyle(
                          fontSize: size.getS(16),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       "Enable unit price to unit amount",
                    //       style: TextStyle(
                    //         fontSize: size.getS(18),
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: size.getH(8),
                    //     ),
                    //     SwitchAdap(
                    //       size: size,
                    //       value: storePro.enableUnitPrice,
                    //       onChanged: (val) {
                    //         storePro.enableUnitPrice = val;
                    //         storePro.notify();
                    //       },
                    //     ),
                    //   ],
                    // )
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
                    Text(
                      LN.amtSpent,
                      style: TextStyle(
                        fontSize: size.getS(22),
                        color: Colors.black,
                        fontFamily: kFontFMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: size.getH(8),
                    ),
                    Text(
                      LN.rewardCusAmtSpent,
                      style: TextStyle(
                        fontSize: size.getS(16),
                        color: Colors.black54,
                        fontFamily: kFontFMedium,
                      ),
                    ),
                    SizedBox(
                      height: size.getH(24),
                    ),
                    Wrap(
                      spacing: size.getW(48),
                      runSpacing: size.getH(24),
                      children: [
                        TitleTextForm(
                          pWidth: 0.24,
                          title: LN.eveTimeCusSpnt,
                          isReq: false,
                          textCltr: storePro.cusSpendAmountCltr,
                          errH: 0,
                          textInputType: TextInputType.number,
                          prefixText: Text(
                            "${storePro.curSym}",
                            style: TextStyle(
                              fontSize: size.getS(16),
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: size.getW(48),
                        // ),
                        TitleTextForm(
                          pWidth: 0.24,
                          title: LN.cusEarn,
                          isReq: false,
                          textCltr: storePro.cusEarnPointsCltr,
                          errH: 0,
                          textInputType: TextInputType.number,
                          suffixIcon: Text(LN.point),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LN.isActive,
                              style: TextStyle(
                                fontSize: size.getS(18),
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: size.getH(8),
                            ),
                            SwitchAdap(
                              size: size,
                              value: storePro.cusSpendEarnEnable,
                              onChanged: (val) {
                                storePro.cusSpendEarnEnable = val;
                                storePro.notify();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Card(
          //   shape:
          //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //   child: SizedBox(
          //     width: double.infinity,
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(
          //           vertical: size.getH(24.0), horizontal: size.getW(24)),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Row(
          //             crossAxisAlignment: CrossAxisAlignment.end,
          //             children: [
          //               TitleTextForm(
          //                 pWidth: 0.24,
          //                 title: LN.amtFrom,
          //                 isReq: false,
          //                 textCltr: storePro.claimAmountList[0].fromCltr,
          //                 errH: 0,
          //                 textInputType: TextInputType.number,
          //               ),
          //               SizedBox(
          //                 width: size.getW(48),
          //               ),
          //               TitleTextForm(
          //                 pWidth: 0.24,
          //                 title: LN.amtTo,
          //                 isReq: false,
          //                 textCltr: storePro.claimAmountList[0].toCltr,
          //                 errH: 0,
          //                 textInputType: TextInputType.number,
          //               ),
          //               SizedBox(
          //                 width: size.getW(48),
          //               ),
          //               TitleTextForm(
          //                 pWidth: 0.1,
          //                 title: LN.points,
          //                 isReq: false,
          //                 textCltr: storePro.claimAmountList[0].dataCltr,
          //                 errH: 0,
          //                 textInputType: TextInputType.number,
          //               ),
          //               SizedBox(
          //                 width: size.getW(48),
          //               ),
          //               Material(
          //                 color: kPrimaryColor,
          //                 type: MaterialType.circle,
          //                 child: InkWell(
          //                   borderRadius: BorderRadius.circular(60),
          //                   onTap: storePro.addClaimAP,
          //                   child: Icon(
          //                     Icons.add,
          //                     size: size.getS(48),
          //                     color: Colors.white,
          //                   ),
          //                 ),
          //               )
          //             ],
          //           ),
          //           ...List.generate(storePro.claimAmountList.length, (index) {
          //             if (index == 0) return SizedBox.shrink();
          //             return Padding(
          //               padding: EdgeInsets.only(top: size.getH(24.0)),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.end,
          //                 children: [
          //                   SizedBox(
          //                     width: size.width * 0.24,
          //                     child: TextFormWidget(
          //                       cltr: storePro.claimAmountList[index].fromCltr,
          //                       hintText: '',
          //                       borderColor: Colors.black,
          //                       borderRadius: 5,
          //                       vPad: 12,
          //                       hPad: 16,
          //                       errH: 0,
          //                       textInputType: TextInputType.number,
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: size.getW(48),
          //                   ),
          //                   SizedBox(
          //                     width: size.width * 0.24,
          //                     child: TextFormWidget(
          //                       cltr: storePro.claimAmountList[index].toCltr,
          //                       hintText: '',
          //                       borderColor: Colors.black,
          //                       borderRadius: 5,
          //                       vPad: 12,
          //                       hPad: 16,
          //                       errH: 0,
          //                       textInputType: TextInputType.number,
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: size.getW(48),
          //                   ),
          //                   SizedBox(
          //                     width: size.width * 0.1,
          //                     child: TextFormWidget(
          //                       cltr: storePro.claimAmountList[index].dataCltr,
          //                       hintText: '',
          //                       borderColor: Colors.black,
          //                       borderRadius: 5,
          //                       vPad: 12,
          //                       hPad: 16,
          //                       errH: 0,
          //                       textInputType: TextInputType.number,
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: size.getW(48),
          //                   ),
          //                   Material(
          //                     color: Colors.red.shade700,
          //                     type: MaterialType.circle,
          //                     child: InkWell(
          //                       borderRadius: BorderRadius.circular(60),
          //                       onTap: () {
          //                         storePro.removeClaimAP(index: index);
          //                       },
          //                       child: Icon(
          //                         Icons.remove,
          //                         size: size.getS(48),
          //                         color: Colors.white,
          //                       ),
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             );
          //           }),

          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: size.getH(24),
          ),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     if (GlobalCVP.viewWidget.viewStoreLoyaltyTabSaveButton)
          //       LoadButton(
          //         loading: storePro.updateLoad,
          //         onsave: storePro.updateLoad
          //             ? null
          //             : () => storePro.addData(context),
          //       ),
          //     SizedBox(
          //       width: size.getW(24),
          //     ),
          //     if (GlobalCVP.viewWidget.viewStoreLoyaltyTabCancelButton)
          //       ElevatedButton(
          //           style: ButtonStyle(
          //               backgroundColor:
          //                   MaterialStateProperty.all(Colors.red.shade800),
          //               padding: MaterialStateProperty.all(EdgeInsets.symmetric(
          //                   horizontal: size.getW(48),
          //                   vertical: size.getH(8)))),
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
          // ),
          SizedBox(
            height: size.getH(12),
          ),
        ],
      ),
    );
  }
}
