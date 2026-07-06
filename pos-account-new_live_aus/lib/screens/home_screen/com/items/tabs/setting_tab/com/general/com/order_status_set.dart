import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/general/order_status_pro.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';

import '../common/common_header.dart';

class OrderStatusSet extends StatefulWidget {
  final PageController pageController;

  const OrderStatusSet({super.key, required this.pageController});

  @override
  State<OrderStatusSet> createState() => _OrderStatusSetState();
}

class _OrderStatusSetState extends State<OrderStatusSet> {
  OrderStatusPro? _orderStatusProInit;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() {
    _orderStatusProInit = Provider.of<OrderStatusPro>(context, listen: false);
    _orderStatusProInit?.getData();
  }

  @override
  void dispose() {
    _orderStatusProInit?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _orderStatusPro = Provider.of<OrderStatusPro>(context);
    return Processing(
      loading: _orderStatusPro.pageLoad,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonHeader(
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      widget.pageController.jumpToPage(0);
                    },
                    icon: Icon(Icons.arrow_back)),
                Text(
                  "Manage Order Status",
                  style: TextStyle(
                    fontSize: size.getS(18),
                    // fontFamily: ,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                LoadButton(
                  vPad: 10,
                  hPad: 4,
                  loading: _orderStatusPro.buttonLoad,
                  btnText: "Update",
                  loadingText: "Updating",
                  onsave: _orderStatusPro.buttonLoad
                      ? null
                      : () {
                          FocusScope.of(context).unfocus();
                          _orderStatusPro.updateData();
                        },
                ),
                SizedBox(width: size.getW(24)),
              ],
            ),
          ),
          SizedBox(
            height: size.getH(6),
          ),
          Container(
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(
                horizontal: size.getW(24), vertical: size.getH(8)),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: kSecondaryColor, size: size.getS(25)),
                SizedBox(width: size.getW(24)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Manage Order Status",
                      style: TextStyle(
                        fontSize: size.getS(18),
                        fontFamily: kFontFMedium,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Configure the order status used in the POS.",
                      style: TextStyle(
                        fontSize: size.getS(14),
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.getH(12),
          ),
          if (_orderStatusPro.allOrderStatusList?.isNotEmpty ?? false)
            Flexible(
              child: Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(24), vertical: size.getH(16)),
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 6,
                        shrinkWrap: true,
                        mainAxisSpacing: size.getH(12),
                        crossAxisSpacing: size.getW(24),
                        children: List.generate(
                            _orderStatusPro.allOrderStatusList!.length,
                            (index) {
                          return _cardSection(size,
                              nameCltr: _orderStatusPro
                                      .allOrderStatusList![index].name ??
                                  TextEditingController(),
                              orderCltr: _orderStatusPro
                                      .allOrderStatusList![index].sortOrder ??
                                  TextEditingController(),
                              isActive: _orderStatusPro
                                      .allOrderStatusList![index].isActive ??
                                  false, onChanged: (val) {
                            _orderStatusPro
                                .allOrderStatusList![index].isActive = !val;
                            _orderStatusPro.notify;
                          });
                        }),
                      )),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _cardSection(
    Ssize size, {
    required TextEditingController nameCltr,
    required TextEditingController orderCltr,
    bool isActive = false,
    Function(bool)? onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black26)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.getW(24), vertical: size.getH(16)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleTextForm(
              title: LN.name,
              pWidth: 0.15,
              textCltr: nameCltr,
              borderColor: Colors.black54,
              readOnly: true,
              fillColor: Colors.grey.shade200,
            ),
            SizedBox(width: size.getW(24)),
            TitleTextForm(
              title: LN.sortOrder,
              isReq: true,
              pWidth: 0.15,
              borderColor: Colors.black54,
              textCltr: orderCltr,
            ),
            SizedBox(width: size.getW(24)),
            InkWell(
              onTap: () {
                if (onChanged != null) onChanged(isActive);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LN.isActive,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: SwitchAdap(
                      size: size,
                      value: isActive,
                      activeColor: kSecondaryColor,
                      onChanged: (_) {},
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
