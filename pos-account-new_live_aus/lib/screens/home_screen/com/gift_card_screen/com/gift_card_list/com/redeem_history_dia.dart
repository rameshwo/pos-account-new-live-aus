import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/gift_card/gift_card_list_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

class RedeemHistoryDia extends StatefulWidget {
  final String giftId;
  const RedeemHistoryDia({super.key, required this.giftId});

  @override
  State<RedeemHistoryDia> createState() => _RedeemHistoryDiaState();
}

class _RedeemHistoryDiaState extends State<RedeemHistoryDia> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  GiftCardListPro? _rpo;

  void getData() {
    _rpo = Provider.of<GiftCardListPro>(context, listen: false);
    _rpo?.getRedeemHistory(widget.giftId);
  }

  @override
  void dispose() {
    _rpo?.diaClear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final pro = Provider.of<GiftCardListPro>(context);
    return Processing(
      loading: pro.diaLoad,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.14,
          minHeight: size.height / 5,
        ),
        width: size.width / 1.4,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.getH(12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LN.redeemHistory,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontFamily: kFontFMedium,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        size: size.getS(24),
                      ))
                ],
              ),
              Divider(
                color: Colors.black54,
              ),
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.getH(12), horizontal: size.getW(16)),
                    child: Wrap(
                      spacing: size.getW(12),
                      runSpacing: size.getH(24),
                      children: [
                        _listTile(
                          size,
                          title: LN.giftCardNo,
                          subTitle: pro.giftRedeemHistory?.giftCardCode,
                        ),
                        _listTile(
                          size,
                          title: LN.amount,
                          subTitle: pro.curSym +
                              (pro.giftRedeemHistory?.amount ?? ''),
                        ),
                        _listTile(
                          size,
                          title: LN.senderName,
                          subTitle: pro.giftRedeemHistory?.senderName,
                        ),
                        _listTile(
                          size,
                          title: LN.receiverName,
                          subTitle: pro.giftRedeemHistory?.receiverName,
                        ),
                        _listTile(
                          size,
                          title: LN.remainAmt,
                          subTitle: pro.curSym +
                              (pro.giftRedeemHistory?.remainingAmount ?? ''),
                        ),
                        _listTile(
                          size,
                          title: LN.purDate,
                          subTitle: pro.giftRedeemHistory?.purchasedDate,
                        ),
                        _listTile(
                          size,
                          title: LN.expiryDate,
                          subTitle: pro.giftRedeemHistory?.expiryDate,
                        ),
                        _listTile(
                          size,
                          title: LN.status,
                          subTitle: pro.giftRedeemHistory?.status,
                          status: pro.giftRedeemHistory?.statusEnum == "4" ||
                              pro.giftRedeemHistory?.statusEnum ==
                                  "PaymentCompleted",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Divider(
              //   color: Colors.black54,
              // ),
              SizedBox(
                height: size.getH(12),
              ),
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.getH(24.0), horizontal: size.getW(12)),
                    child: Table(
                      children: [
                        TableRow(children: [
                          _tableData(size, title: LN.redeemBy, isHeader: true),
                          _tableData(size, title: LN.redeemAmt, isHeader: true),
                          _tableData(size,
                              title: LN.redeemDate, isHeader: true),
                        ]),
                        if (pro.giftRedeemHistory
                                    ?.giftCardReedemSummaryDetails !=
                                null &&
                            pro.giftRedeemHistory!.giftCardReedemSummaryDetails!
                                .isNotEmpty)
                          ...List.generate(
                            pro.giftRedeemHistory!.giftCardReedemSummaryDetails!
                                .length,
                            (index) => TableRow(children: [
                              _tableData(
                                size,
                                title: pro
                                        .giftRedeemHistory!
                                        .giftCardReedemSummaryDetails![index]
                                        .customerName ??
                                    "",
                              ),
                              _tableData(
                                size,
                                title: pro.curSym +
                                    (pro
                                            .giftRedeemHistory!
                                            .giftCardReedemSummaryDetails![
                                                index]
                                            .spendAmount ??
                                        ""),
                              ),
                              _tableData(
                                size,
                                title: pro
                                        .giftRedeemHistory!
                                        .giftCardReedemSummaryDetails![index]
                                        .reedemDate ??
                                    "",
                              ),
                            ]),
                          )
                        else
                          TableRow(children: [
                            _tableData(
                              size,
                              title: "",
                            ),
                            _tableData(
                              size,
                              title: LN.noRecord,
                            ),
                            _tableData(
                              size,
                              title: "",
                            ),
                          ]),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.getH(12),
              ),
              if (pro.giftRedeemHistory?.statusEnum != null &&
                  pro.giftRedeemHistory?.statusEnum != "DeActive")
                Row(
                  children: [
                    LoadButton(
                      btnText: LN.deactivate,
                      btnColor: Colors.red,
                      vPad: 8,
                      loading: pro.deactivateLoad,
                      onsave: () {
                        pro.deactivateRedeem(widget.giftId).then((value) {
                          if (value) {
                            pro.getRedeemHistory(widget.giftId);
                            pro.getData(page: pro.pageIndex);
                          }
                        });
                      },
                    ),
                    LoadButton(
                      btnText: LN.cancel,
                      vPad: 8,
                      btnColor: Colors.transparent,
                      textColor: Colors.black,
                      onsave: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              SizedBox(
                height: size.getH(48),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _tableData(
    Ssize size, {
    required String title,
    bool isHeader = false,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          size.getW(8), 0, size.getW(8), size.getH(isHeader ? 16 : 12)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: size.getS(16),
          fontWeight: isHeader ? FontWeight.bold : null,
        ),
      ),
    );
  }

  Widget _listTile(
    Ssize size, {
    String? title,
    String? subTitle,
    bool? status,
  }) {
    return SizedBox(
      width: size.getW(224),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title,
              style: TextStyle(
                fontSize: size.getS(16),
                fontFamily: kFontFBold,
                color: Colors.black,
              ),
            ),
          SizedBox(
            height: size.getH(4),
          ),
          if (status != null && subTitle != null)
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: status
                      ? Colors.green.withAlpha(50)
                      : Colors.red.withAlpha(50)),
              padding: EdgeInsets.symmetric(
                  vertical: size.getH(8), horizontal: size.getW(12)),
              child: Text(
                subTitle,
                style: TextStyle(
                  fontSize: size.getS(16),
                  color: status ? Colors.green.shade700 : Colors.red.shade700,
                ),
              ),
            )
          else if (subTitle != null)
            SelectableText(
              subTitle,
              style: TextStyle(
                fontSize: size.getS(16),
                fontFamily: kFontFMedium,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}
