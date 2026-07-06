import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/services/uber/delivery/provider/delivery_pro.dart';
import 'package:pos_account/screens/home_screen/com/variance/selective_tab.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:provider/provider.dart';

import '../../../../../../ln.dart';
import 'item_choose_sec.dart';

class ItemBoxSec extends StatefulWidget {
  const ItemBoxSec({super.key});

  @override
  State<ItemBoxSec> createState() => _ItemBoxSecState();
}

class _ItemBoxSecState extends State<ItemBoxSec> with TickerProviderStateMixin {
  // late TabController _tabController;

  // late DeliveryPro _dPro;

  // @override
  // void initState() {
  //   _dPro = Provider.of<DeliveryPro>(context, listen: false);
  //   _setTabCltr();
  //   super.initState();
  // }

  // _setTabCltr() {
  //   _tabController = TabController(length: _dPro.boxList.length, vsync: this);
  // }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final deliPro = Provider.of<DeliveryPro>(context);
    final size = Ssize(context);
    final selectedBox = deliPro.boxList.any((e) => e.id == deliPro.boxId)
        ? deliPro.boxList.firstWhere((e) => e.id == deliPro.boxId)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              LN.addBox,
              style: TextStyle(
                fontSize: size.getS(18),
                fontFamily: kFontFMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () {
                deliPro.addNewBox();
                // _setTabCltr();
                deliPro.notify;
              },
              borderRadius: BorderRadius.circular(100),
              highlightColor: kPrimaryColor.withAlpha(60),
              child: Container(
                  margin: EdgeInsets.all(size.getS(12)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kSecondaryColor,
                  ),
                  padding: EdgeInsets.all(size.getS(2)),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: size.getS(24),
                  )),
            )
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: [
                  ...List.generate(
                    deliPro.boxList.length,
                    (index) {
                      final isDefault =
                          deliPro.boxList[index].id == deliPro.boxId;
                      return Padding(
                        padding: EdgeInsets.only(right: size.getW(4)),
                        child: SelectiveTab(
                          title: deliPro.boxList[index].title,
                          isDefault: isDefault,
                          onTap: () {
                            deliPro.boxId = deliPro.boxList[index].id;

                            deliPro.notify;

                            // _tabController.animateTo(index,
                            //     curve: Curves.linearToEaseOut,
                            //     duration: Duration(milliseconds: 800));
                          },
                          trail: deliPro.boxList.length <= 1
                              ? null
                              : Padding(
                                  padding: EdgeInsets.only(left: size.getW(12)),
                                  child: InkWell(
                                    onTap: () {
                                      if (isDefault) {
                                        if (index > 0)
                                          deliPro.boxId =
                                              deliPro.boxList[index - 1].id;
                                        else
                                          deliPro.boxId =
                                              deliPro.boxList[index + 1].id;
                                      }
                                      deliPro.boxList.removeAt(index);
                                      // _setTabCltr();
                                      deliPro.notify;
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: isDefault
                                          ? Colors.white
                                          : Colors.black,
                                      size: size.getS(25),
                                    ),
                                  ),
                                ),
                        ),
                      );
                    },
                  )
                ],
              )),
        ),
        SizedBox(height: size.getH(12)),
        if (selectedBox != null)
          _boxWidget(context, selectedBox: selectedBox, deliveryPro: deliPro)
        // SizedBox(
        //   height: size.getH(240),
        //   child: TabBarView(
        //       physics: NeverScrollableScrollPhysics(),
        //       controller: _tabController,
        //       children: [
        //         ...List.generate(
        //           _deliPro.boxList.length,
        //           (index) {
        //             return _boxWidget(context,
        //                 selectedBox: _deliPro.boxList[index],
        //                 deliveryPro: _deliPro);
        //           },
        //         )
        //       ]),
        // )
      ],
    );
  }

  Widget _boxWidget(
    BuildContext context, {
    required final ItemBoxModel selectedBox,
    required DeliveryPro deliveryPro,
  }) {
    final selectedBox0 = selectedBox;
    final size = Ssize(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(text: selectedBox0.title, children: [
                    TextSpan(
                      text: "  (${LN.tapBoxToAdd})",
                      style: TextStyle(
                        fontSize: size.getS(16),
                        color: Colors.black87,
                      ),
                    )
                  ]),
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontFamily: kFontFMedium,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    selectedBox0.mustUpRight = !selectedBox0.mustUpRight;
                    deliveryPro.notify;
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: selectedBox0.mustUpRight,
                        onChanged: (val) {
                          selectedBox0.mustUpRight = val ?? false;
                          deliveryPro.notify;
                        },
                        visualDensity: VisualDensity.compact,
                        activeColor: kSecondaryColor,
                      ),
                      Text(
                        LN.mustBeUpright,
                        style: TextStyle(
                          fontSize: size.getS(18),
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: size.width * 0.09),
              ],
            ),
            SizedBox(
              height: size.getH(8),
            ),
            InkWell(
              onTap: () async {
                deliveryPro.orderItemList.forEach((e) {
                  if (selectedBox.itemList.any((f) => f.id == e.id)) {
                    e.isSelected = true;
                  } else {
                    e.isSelected = false;
                  }
                });
                await showDialog(
                    context: context,
                    builder: (_) {
                      return ItemChooseSec();
                    });

                deliveryPro.orderItemList.forEach((e) {
                  e.isSelected = false;
                });
              },
              child: Container(
                width: size.width * 0.765,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey.shade600,
                    )),
                constraints: BoxConstraints(minHeight: size.getH(100)),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(
                    vertical: size.getW(8), horizontal: size.getW(8)),
                child: Wrap(
                  spacing: size.getW(10),
                  runSpacing: size.getH(8),
                  children: [
                    ...List.generate(
                        selectedBox.itemList.length,
                        (index) => Container(
                              decoration: BoxDecoration(
                                  color: kSecondaryColor.withAlpha(40),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: kSecondaryColor.withAlpha(60))),
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.getW(16),
                                  vertical: size.getH(4)),
                              child: Text(
                                selectedBox.itemList[index].title ?? '',
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  color: Colors.teal.shade600,
                                ),
                              ),
                            ))
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: size.getH(24)),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: size.getW(24),
          children: [
            TitleDropDown(
              title: LN.size,
              isReq: true,
              list: DeliSizeEnum.values.map((e) => e.name).toList(),
              pWidth: 0.1,
              borderColor: Colors.black45,
              vPad: 8,
              indexVal: selectedBox0.sizeIndex,
              onChanged: (val) {
                selectedBox0.sizeIndex = val;
                deliveryPro.notify;
              },
              errH: 0,
            ),
            TitleTextForm(
              borderColor: Colors.black45,
              pWidth: 0.1,
              textCltr: selectedBox0.weightCltr,
              title: LN.weightGram,
              vPad: 10,
              textInputType: TextInputType.number,
              errH: 0,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LN.dimensionCm,
                  style: TextStyle(
                    fontSize: size.getS(18),
                  ),
                ),
                SizedBox(
                  height: size.getH(8),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: size.width * 0.06,
                      child: TextFormWidget(
                        cltr: selectedBox0.lengthCltr,
                        hintText: LN.length,
                        borderColor: Colors.black45,
                        vPad: 10,
                        textInputType: TextInputType.number,
                        errH: 0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.getW(9)),
                      child: Text(
                        "X",
                        style: TextStyle(
                            fontSize: size.getS(28), color: Colors.black45),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.06,
                      child: TextFormWidget(
                        cltr: selectedBox0.heightCltr,
                        hintText: LN.height,
                        borderColor: Colors.black45,
                        vPad: 10,
                        textInputType: TextInputType.number,
                        errH: 0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.getW(9)),
                      child: Text(
                        "X",
                        style: TextStyle(
                            fontSize: size.getS(28), color: Colors.black45),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.06,
                      child: TextFormWidget(
                        cltr: selectedBox0.depthCltr,
                        hintText: LN.depth,
                        borderColor: Colors.black45,
                        vPad: 10,
                        textInputType: TextInputType.number,
                        errH: 0,
                      ),
                    )
                  ],
                ),
              ],
            ),
            if (selectedBox0.quantity != null)
              _statusShow(size,
                  title: "${LN.quantity} : ",
                  value: selectedBox0.quantity ?? ''),
            if (selectedBox0.price != null)
              _statusShow(size,
                  title: "${LN.price} : ",
                  value: "${deliveryPro.curSym}${selectedBox0.price ?? ''}"),
          ],
        ),
      ],
    );
  }

  Widget _statusShow(
    Ssize size, {
    required String title,
    required String value,
  }) {
    return Container(
      width: size.width * 0.12,
      decoration: BoxDecoration(
          color: kSecondaryColor.withAlpha(40),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: kSecondaryColor.withAlpha(60))),
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(2), vertical: size.getH(4)),
      child: Text.rich(
        TextSpan(text: title, children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: size.getS(20),
              fontFamily: kFontFMedium,
              color: kPrimaryColor,
            ),
          )
        ]),
        style: TextStyle(
          fontSize: size.getS(18),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
