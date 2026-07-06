import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'com/price_v.dart';

class PriceSectionDia extends StatefulWidget {
  final String productId;
  const PriceSectionDia({super.key, required this.productId});

  @override
  State<PriceSectionDia> createState() => _PriceSectionDiaState();
}

class _PriceSectionDiaState extends State<PriceSectionDia>
    with SingleTickerProviderStateMixin {
  List<Tab>? _kTabs;
  TabController? _tabCltr;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    final pro = Provider.of<NewProductPro>(context, listen: false);
    await pro.editProductPrice(productId: widget.productId);
    if (pro.priceData == null) return;

    _kTabs = List<Tab>.generate(pro.priceData!.length,
        (index) => Tab(child: Text(pro.priceData?[index].channelName ?? '')));

    _setData(pro);
    pro.notify;

    _tabCltr = TabController(length: _kTabs!.length, vsync: this);
  }

  _setData(NewProductPro pro) {
    pro.priceData?.forEach((a) {
      a.productVariationsPriceViewModel?.forEach((b) {
        b.priceCltr = TextEditingController(text: b.price);
        b.disPriceCltr = TextEditingController(text: b.discountPrice);
        b.disPercentCltr = TextEditingController(text: b.discountPercentage);
        b.newPriceCltr = TextEditingController(text: b.discountedPrice);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final pro = Provider.of<NewProductPro>(context);

    return Processing(
      loading: pro.priceLoad,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.3,
          minHeight: size.height / 5,
        ),
        padding: EdgeInsets.symmetric(horizontal: size.getW(16)),
        // width: size.getW(685),
        child: (_kTabs == null || _tabCltr == null)
            ? SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: size.getH(8),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LN.updatePrice,
                        style: TextStyle(
                          fontSize: size.getS(21),
                          // fontFamily: ,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close))
                    ],
                  ),
                  Divider(
                    color: Colors.black54,
                    thickness: 0.6,
                  ),
                  // InfoMessageSec(
                  //     message:
                  //         "Variable Price mode applies exclusively to the POS channel."),
                  TabBar(
                    tabs: _kTabs!,
                    controller: _tabCltr,
                    indicatorColor: kPrimaryColor,
                    labelColor: kPrimaryColor,
                    indicatorWeight: size.getW(2.0),
                    labelStyle: TextStyle(
                      fontSize: size.getS(20),
                      fontFamily: kFontFMedium,
                    ),
                    indicator: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    labelPadding:
                        EdgeInsets.symmetric(horizontal: size.getW(12)),
                    indicatorPadding: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    unselectedLabelColor: Colors.black,
                    onTap: (value) {
                      pro.notify;
                    },
                  ),
                  Divider(
                    color: Colors.black54,
                    thickness: 0.6,
                  ),
                  Flexible(
                    child: PriceVariention(
                        size: size,
                        index: _tabCltr!.index,
                        pro: pro,
                        tabName:
                            pro.priceData?[_tabCltr?.index ?? 0].channelName),
                  )
                ],
              ),
      ),
    );
  }
}
