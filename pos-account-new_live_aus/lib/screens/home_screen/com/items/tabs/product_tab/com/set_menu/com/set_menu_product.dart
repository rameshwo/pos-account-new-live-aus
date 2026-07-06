import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/text_formatter.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/product/setmenu/prod_by_prod_res.dart';
import 'package:pos_account/providers/product/set_menu_pro.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';

class SetMenuProducts extends StatelessWidget {
  final TabController? tabCltr;
  final ScrollController childScrollCltr;
  final bool isChildScrolling;
  final Function() onTapCat;
  const SetMenuProducts({
    super.key,
    this.tabCltr,
    required this.childScrollCltr,
    required this.isChildScrolling,
    required this.onTapCat,
  });

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

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final setMenuPro = Provider.of<SetMenuPro>(context);
    final variationList = tabCltr != null
        ? (setMenuPro.productList?[tabCltr!.index].productVariations ?? [])
            .where((e) => setMenuPro.searcCltr.text.isEmpty
                    ? true
                    : (e.name?.toLowerCase().contains(
                            setMenuPro.searcCltr.text.toLowerCase()) ??
                        true)
                //     ||
                // (e.barcodeNumber?.toLowerCase().contains(
                //         setMenuPro.searcCltr.text.toLowerCase()) ??
                //     true)
                )
            .toList()
        : <PrinterProductVariation>[];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.getH(18.0)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LN.selectItemsSetMenu,
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          if (setMenuPro.productList?.isNotEmpty ?? false)
            DefaultTabController(
              length: setMenuPro.productList!.length,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: size.getH(40),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                    ),
                    child: TabBar(
                      indicatorWeight: 0,
                      tabs: List.generate(
                          setMenuPro.productList!.length,
                          (index) => _tabWidget(size,
                              title:
                                  setMenuPro.productList![index].categoryName)),
                      indicatorColor: Colors.transparent,
                      labelColor: Colors.white,
                      controller: tabCltr,
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
                      onTap: (i) => onTapCat(),
                    ),
                  ),
                  if (tabCltr != null)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: size.getH(12)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.getW(300),
                              child: TextFormWidget(
                                vPad: 10,
                                borderColor: Colors.black26,
                                cltr: setMenuPro
                                    .prodCatDesList[tabCltr!.index].desCltr,
                                hintText: LN.description,
                                isReq: false,
                              ),
                            ),
                            SizedBox(width: size.getW(12)),
                            SizedBox(
                              width: size.getW(300),
                              child: TextFormWidget(
                                vPad: 10,
                                borderColor: Colors.black26,
                                cltr: setMenuPro
                                    .prodCatDesList[tabCltr!.index].countCltr,
                                hintText: 'Max Item Count',
                                textInputType: TextInputType.number,
                                validator: (val) {
                                  if (val == null || val.isEmpty) return null;
                                  final _count = double.tryParse(val) ?? 0;
                                  if (_count >
                                      setMenuPro.productList![tabCltr!.index]
                                          .productVariations!.length)
                                    return "Max count is greater than product list";
                                  else
                                    return null;
                                },
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              width: size.getW(400),
                              child: TextFormWidget(
                                suffixIcon:
                                    Icon(Icons.search, size: size.getS(28)),
                                vPad: 10,
                                borderColor: Colors.black26,
                                isReq: false,
                                cltr: setMenuPro.searcCltr,
                                hintText: 'Search for products',
                                onChanged: (val) => setMenuPro.notify(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.getH(12)),
                        if (variationList.isNotEmpty)
                          SizedBox(
                            height: size.getH(580),
                            child: GridView.count(
                              controller: childScrollCltr,
                              crossAxisCount: size.isProt ? 5 : 6,
                              childAspectRatio: 0.7,
                              shrinkWrap: true,
                              physics: isChildScrolling
                                  ? BouncingScrollPhysics()
                                  : NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 10,
                              children: [
                                ...List.generate(
                                    variationList.length,
                                    (j) => SetMenuItemCard(
                                          itemData: variationList[j],
                                          onTap: () {
                                            setMenuPro
                                                    .productList![tabCltr!.index]
                                                    .productVariations![j]
                                                    .isSelected =
                                                !setMenuPro
                                                    .productList![
                                                        tabCltr!.index]
                                                    .productVariations![j]
                                                    .isSelected;
                                            setMenuPro.notify();
                                          },
                                        ))
                              ],
                            ),
                          )
                        else
                          SizedBox(
                              height: 600,
                              child:
                                  NoItemsSec(size: size, title: LN.noProducts))
                      ],
                    )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class SetMenuItemCard extends StatefulWidget {
  final PrinterProductVariation itemData;
  final Function()? onTap;
  const SetMenuItemCard({super.key, required this.itemData, this.onTap});

  @override
  State<SetMenuItemCard> createState() => _SetMenuItemCardState();
}

class _SetMenuItemCardState extends State<SetMenuItemCard> {
  final _textCltr = TextEditingController();

  void load() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    _textCltr.text = widget.itemData.customStock ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final itemData = widget.itemData;
    final stock = double.tryParse(itemData.stockCount ?? '') ?? 0;
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: itemData.isSelected ? kTempColor : Colors.grey.shade200,
          )),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(15),
        highlightColor: kSecondaryColor.withAlpha(60),
        focusColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.getH(4.0), horizontal: size.getW(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedNetworkImage(
                  imageUrl: itemData.image!,
                  height: size.getS(120),
                  width: size.getS(120),
                  fit: BoxFit.fitWidth,
                  placeholder: ImageError.load,
                  errorWidget: ImageError.text),
              SizedBox(
                height: size.getH(4),
              ),
              Flexible(
                child: Text(itemData.name ?? '',
                    style: TextStyle(
                      fontSize: size.getW(14),
                      color: itemData.isSelected ? kTempColor : Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible),
              ),
              // SizedBox(
              //   height: size.getH(8),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.getH(6),
                ),
                child: Text(
                  "Available Stock : ${stock.round()}",
                  style: TextStyle(
                    fontSize: size.getS(15.5),
                    color: Colors.black,
                  ),
                ),
              ),
              // Spacer(),
              if (stock != 0)
                Flexible(
                  child: TextFormWidget(
                    vPad: 6,
                    errH: 0.7,
                    borderColor: Colors.black26,
                    textInputType: TextInputType.number,
                    initValidate: true,
                    inputFormatters: [NonNegativeTextInputFormatter()],
                    cltr: _textCltr,
                    onChanged: (val) {
                      itemData.customStock = val;
                    },
                    validator: (val) {
                      final data = double.tryParse(val ?? '');
                      final stock = double.tryParse(itemData.stockCount ?? '');
                      if (data == null || stock == null) return null;

                      if (data > stock)
                        return 'Stock is higher';
                      else
                        return null;
                    },
                    hintText: LN.stockCount,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
