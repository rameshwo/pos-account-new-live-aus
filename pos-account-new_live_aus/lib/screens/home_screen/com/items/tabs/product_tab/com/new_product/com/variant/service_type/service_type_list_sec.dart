import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/screens/home_screen/com/cus_button_tabs.dart';
import 'package:pos_account/widgets/cus_expansion_tile.dart';
import 'package:provider/provider.dart';

import '../add_icon_b.dart';
import 'service_type_sec.dart';

class ServiceTypeListSec extends StatelessWidget {
  final Ssize size;
  final String title;
  final Function()? onAdd;
  final List<ServiceType> serviceTypeList;
  final int vIndex;
  final Function(int)? remove;
  final GlobalKey<AnimatedListState> serviceTypeKey;

  ServiceTypeListSec({
    super.key,
    required this.size,
    required this.title,
    this.onAdd,
    required this.serviceTypeList,
    required this.vIndex,
    this.remove,
  }) : serviceTypeKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final newProdPro = Provider.of<NewProductPro>(context);
    final defaultType = newProdPro.ppvList[vIndex].serviceTypeDefault;
    return Container(
      // width: newProdPro.editData == null
      //     ? MediaQuery.of(context).size.width * 0.5
      //     : MediaQuery.of(context).size.width,
      // margin: EdgeInsets.only(
      //   top: size.getH(0),
      // ),
      decoration: BoxDecoration(
          color: kBackgroundColor, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(
          vertical: size.getH(8), horizontal: size.getW(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: CusExpansionTile(
              initiallyExpanded: true,
              // assignFunction: (val) {
              //   newProdPro.serviceTypeExFun = val;
              // },
              // onExpansionChanged: (val) => newProdPro.serviceTypeExpand = val,
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                "Service Items",
                style: TextStyle(
                  fontSize: size.getS(18),
                  color: Colors.black,
                ),
              ),
              children: [
// SizedBox(height: size.getH(12)),
                _infoWidget(
                    title:
                        "If the service is gender specific please choose below"),
                CusButtonTabs(
                  kTabs: newProdPro.serviceTypeDefault,
                  unSelectedColor: Colors.white,
                  selectedColor: kSecondaryColor,
                  selectedColorOpacity: 1,
                  selectedTextColor: Colors.white,
                  fontSize: 14,
                  size: size,
                  selectedIndex: newProdPro.ppvList.isNotEmpty &&
                          newProdPro.serviceTypeDefault
                              .any((e) => e == defaultType)
                      ? newProdPro.serviceTypeDefault
                          .indexWhere((e) => e == defaultType)
                      : null,
                  onTap: (p0) {
                    if (newProdPro.ppvList[vIndex].serviceTypeDefault ==
                        newProdPro.serviceTypeDefault[p0])
                      newProdPro.ppvList[vIndex].serviceTypeDefault = null;
                    else
                      newProdPro.ppvList[vIndex].serviceTypeDefault =
                          newProdPro.serviceTypeDefault[p0];
                    newProdPro.notify;
                  },
                ),
                _infoWidget(
                    title:
                        "If you want to add other service please enter below"),
                Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: title,
                        style: TextStyle(
                          fontSize: size.getS(18),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.getW(18),
                    ),
                    AddIconB(
                      size: size,
                      onTap: onAdd,
                    )
                  ],
                ),
                serviceTypeList.isEmpty
                    ? Container()
                    : AnimatedList(
                        key: newProdPro.serviceTypeKeyList[vIndex],
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        initialItemCount: serviceTypeList.length,
                        itemBuilder: (ctx, i, animation) {
                          if (i < serviceTypeList.length) {
                            return ServiceTypeSec(
                              animation: animation,
                              remove: remove == null ? null : () => remove!(i),
                              serviceType: serviceTypeList[i],
                            );
                          } else {
                            return Container();
                          }
                        }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _infoWidget({required String title}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: size.getH(12)),
      decoration: BoxDecoration(
        color: Colors.blue.withAlpha(50),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(12), vertical: size.getH(4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.info, color: Colors.blue, size: size.getS(20)),
          SizedBox(width: size.getW(12)),
          Text(
            title,
            style: TextStyle(
              fontSize: size.getS(14),
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
