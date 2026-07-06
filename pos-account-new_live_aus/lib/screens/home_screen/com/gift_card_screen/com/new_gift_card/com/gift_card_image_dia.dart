import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/gift_card/new_gift_card_pro.dart';
import 'package:pos_account/screens/home_screen/com/gift_card_screen/com/widget/image_sec.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';

class GiftCardImageDia extends StatefulWidget {
  const GiftCardImageDia({super.key});

  @override
  State<GiftCardImageDia> createState() => _GiftCardImageDiaState();
}

class _GiftCardImageDiaState extends State<GiftCardImageDia>
    with SingleTickerProviderStateMixin {
  TabController? _tabCltr;

  String? selectedImagePath = "";
  String? selectedImageAmt = "";
  final _scrollCltr2 = ScrollController();

  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData() {
    final pro = Provider.of<NewGiftCardPro>(context, listen: false);
    selectedImagePath = pro.selectedGiftCardImage;

    if (pro.addSec?.giftCardTemplatesLists != null) {
      _tabCltr = TabController(
          length: pro.addSec!.giftCardTemplatesLists!.length, vsync: this);
    }
  }

  @override
  void dispose() {
    if (_tabCltr != null) _tabCltr!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final pro = Provider.of<NewGiftCardPro>(context);

    if (pro.addSec?.giftCardTemplatesLists == null)
      return Container();
    else {
      final giftCardList = pro.addSec!.giftCardTemplatesLists!;
      return Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.14,
          minHeight: size.height / 5,
        ),
        width: size.width / 1.4,
        child: DefaultTabController(
          length: giftCardList.length,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.getH(24),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LN.giftCards,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      // fontFamily: ,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                      ))
                ],
              ),
              SizedBox(
                height: size.getH(8),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: size.getH(40),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                      ),
                      child: TabBar(
                        tabAlignment: TabAlignment.start,
                        indicatorWeight: 0,
                        tabs: List.generate(
                            pro.addSec!.giftCardTemplatesLists!.length,
                            (index) => _tabWidget(size,
                                title: pro.addSec!
                                    .giftCardTemplatesLists![index].type)),
                        indicatorColor: Colors.transparent,
                        labelColor: Colors.white,
                        controller: _tabCltr,
                        isScrollable: true,
                        indicator: BoxDecoration(
                          color: kPrimaryColor,
                        ),
                        labelStyle: TextStyle(
                          fontSize: size.getS(16),
                          fontFamily: kFontFMedium,
                        ),
                        labelPadding: EdgeInsets.zero,
                        indicatorPadding: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        unselectedLabelColor: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.getW(8),
                  ),
                  PopupMenuButton(
                    tooltip: LN.showGiftCard,
                    itemBuilder: (_) {
                      final list = pro.addSec!.giftCardTemplatesLists!;
                      return [
                        PopupMenuItem(
                          padding: EdgeInsets.zero,
                          height: 0,
                          enabled: false,
                          child: SizedBox(
                            height:
                                list.length > 10 ? 400.0 : (40.0 * list.length),
                            width: double.infinity,
                            child: Scrollbar(
                              controller: _scrollCltr2,
                              thumbVisibility: true,
                              trackVisibility: true,
                              thickness: 4,
                              child: SingleChildScrollView(
                                controller: _scrollCltr2,
                                child: Column(
                                  children: List.generate(list.length, (i) {
                                    return Container(
                                      width: double.infinity,
                                      color: _tabCltr?.index == i
                                          ? kTempColor
                                          : null,
                                      child: InkWell(
                                        onTap: () {
                                          _tabCltr!.animateTo(i);

                                          final val = list
                                              .getRange(0, i)
                                              .fold<double>(
                                                  0,
                                                  (pV, nV) =>
                                                      pV +
                                                      (nV.type?.length ?? 0));

                                          _scrollCltr2.animateTo(
                                              (i * 12) + val * 8.4,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut);
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: size.getH(8),
                                              horizontal: size.getW(12)),
                                          child: Text(
                                            list[i].type.toString(),
                                            style: TextStyle(
                                              fontSize: size.getS(18),
                                              color: _tabCltr?.index == i
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontFamily: kFontFMedium,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        )
                      ];
                    },
                    child: Icon(Icons.more_vert),
                  )
                ],
              ),
              if (_tabCltr != null)
                Flexible(
                    child: TabBarView(
                        controller: _tabCltr,
                        physics: BouncingScrollPhysics(),
                        children: List<Widget>.generate(
                            giftCardList.length,
                            (i) => SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Wrap(
                                    children: [
                                      if (giftCardList[i]
                                              .giftCardTemplateImages !=
                                          null)
                                        ...List.generate(
                                            giftCardList[i]
                                                .giftCardTemplateImages!
                                                .length, (j) {
                                          final imageList = giftCardList[i]
                                              .giftCardTemplateImages![j];
                                          final selected =
                                              pro.selectedGiftCardId ==
                                                  imageList.id;
                                          return GiftImageSec(
                                            isSelected: selected,
                                            imageUrl: imageList.image,
                                            onTap: () {
                                              pro.selectedGiftCardId =
                                                  imageList.id;
                                              selectedImagePath =
                                                  imageList.image;
                                              selectedImageAmt =
                                                  imageList.additionalValue ??
                                                      '';
                                              pro.notify;
                                            },
                                          );
                                        })
                                    ],
                                  ),
                                )))),
              Divider(
                color: Colors.black54,
              ),
              LoadButton(
                btnText: LN.confirm,
                btnColor: kPrimaryColor,
                onsave: () {
                  if (pro.selectedGiftCardId == null &&
                      (selectedImagePath?.isEmpty ?? true)) {
                    showToast(LN.plzSelectGiftCard);
                  } else {
                    pro.selectedGiftCardImage = selectedImagePath;
                    pro.giftCardAmountCltr.text = selectedImageAmt ?? "";
                    pro.notify;
                    Navigator.pop(context);
                  }
                },
              ),
              SizedBox(
                height: size.getH(24),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _tabWidget(Ssize size, {String? title}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: size.getW(16),
      ),
      child: Tab(
        iconMargin: EdgeInsets.zero,
        child: Text(
          title ?? '',
        ),
      ),
    );
  }
}
