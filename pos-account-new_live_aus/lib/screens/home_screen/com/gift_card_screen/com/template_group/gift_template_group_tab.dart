import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/gift_card/gift_card_template_group_pro.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'gift_card_template_group_dia.dart';

class GiftCardTempGroupTab extends StatefulWidget {
  const GiftCardTempGroupTab({super.key});

  @override
  State<GiftCardTempGroupTab> createState() => _GiftCardCusImageTabState();
}

class _GiftCardCusImageTabState extends State<GiftCardTempGroupTab> {
  GiftCardTemplatePro? _giftCardTemplatePro;
  String? curSym;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    curSym = await SharedPrefs.curSym;
    setState(() {});
    _giftCardTemplatePro =
        Provider.of<GiftCardTemplatePro>(context, listen: false);

    _giftCardTemplatePro?.getAllGiftCardTemplate();
  }

  void showDia({required Ssize size}) {
    showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [AddGiftCardTemplateGroupDia()],
            ));
  }

  void paginate(int page) {
    _giftCardTemplatePro?.getAllGiftCardTemplate(page: page);
  }

  @override
  void dispose() {
    _giftCardTemplatePro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    final pro = Provider.of<GiftCardTemplatePro>(context);
    return Processing(
      backColor: Colors.white,
      loading: pro.pageLoad,
      align: Alignment.topLeft,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(12), vertical: size.getH(0)),
          child: SmartRefresher(
            controller: pro.refreshCltr,
            enablePullUp: true,
            onLoading: () {
              paginate(pro.pageIndex + 1);
            },
            onRefresh: () {
              paginate(1);
            },
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.red),
                            padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: size.getW(16),
                                    vertical:
                                        size.getH(size.isDesktop ? 16 : 8)))),
                        onPressed: () => showDia(size: size),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              size: size.getS(25),
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: size.getW(8),
                            ),
                            Text(
                              LN.createNew,
                              style: TextStyle(
                                fontSize: size.getS(16),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        )),
                  ),
                  SizedBox(height: size.getH(12)),

                  // SizedBox(
                  //   height: size.getH(24),
                  // ),
                  if (!pro.pageLoad && (pro.cardImageList.isEmpty))
                    NoItemsSec(size: size, title: LN.noImgFound)
                  else
                    Wrap(
                      spacing: size.getW(4),
                      runSpacing: size.getH(4),
                      children:
                          List.generate(pro.cardImageList.length, (index) {
                        final cardImage = pro.cardImageList[index];
                        return SizedBox(
                          height: size.getH(150),
                          width: size.getW(220),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                margin: EdgeInsets.symmetric(
                                    vertical: size.getH(12),
                                    horizontal: size.getW(12)),
                                padding: EdgeInsets.symmetric(
                                    vertical: size.getH(12),
                                    horizontal: size.getW(12)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: size.getH(4),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text.rich(
                                          TextSpan(
                                            text: cardImage.name ?? LN.na,
                                            style: TextStyle(
                                              fontSize: size.getS(16),
                                              color: Colors.black,
                                              fontFamily: kFontFMedium,
                                            ),
                                          ),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: pro.pageLoad
                                          ? null
                                          : () => pro
                                                  .editImage(cardImage.id ?? "")
                                                  .then((value) {
                                                if (value ?? false)
                                                  showDia(size: size);
                                                pro.notify;
                                              }),
                                      // onPressed: () {
                                      //   showDia(size: size);
                                      // },
                                      style: ButtonStyle(
                                          side: WidgetStateProperty.all(
                                              BorderSide(color: Colors.red)),
                                          shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          padding: WidgetStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  horizontal: size.getW(32)))),
                                      child: Text(
                                        LN.edit,
                                        style: TextStyle(
                                          fontSize: size.getS(18),
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                right: size.getW(2),
                                top: size.getH(2),
                                child: (cardImage.isActive ?? false)
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: Colors.green.withAlpha(255),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.getW(8),
                                            vertical: size.getH(4)),
                                        child: Text(
                                          LN.active,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.getS(14)),
                                        ))
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.red.withAlpha(50),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.getW(8),
                                            vertical: size.getH(4)),
                                        child: Text(
                                          LN.inActive,
                                          style: TextStyle(
                                              color: Colors.red.shade700,
                                              fontSize: size.getS(14)),
                                        )),
                              )
                            ],
                          ),
                        );
                      }),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
