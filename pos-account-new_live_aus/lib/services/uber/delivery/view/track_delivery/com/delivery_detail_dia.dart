import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/services/uber/delivery/provider/deli_tracking_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import '../../../../../../ln.dart';
import 'vertical_stepper.dart';

class DeliveyDetailDia extends StatelessWidget {
  final DeliTrackPro dTrcPro;
  const DeliveyDetailDia({super.key, required this.dTrcPro});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final data = dTrcPro.trackDetailRes;
    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(
          horizontal: size.getW(16), vertical: size.getH(16)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: [
        SizedBox(
          width: size.width / 1.17,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data?.orderNumber ?? '',
                        style: TextStyle(
                          fontSize: size.getS(20),
                          color: kPrimaryColor,
                          fontFamily: kFontFMedium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Text(
                      //   "Status: Completed",
                      //   style: TextStyle(
                      //     fontSize: size.getS(18),
                      //     color: Colors.black87,
                      //     fontFamily: kFontFMedium,
                      //   ),
                      // ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close))
                ],
              ),
              Divider(
                color: Colors.black87,
                thickness: 0.6,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data?.courierInfo != null) ...[
                          SizedBox(height: size.getH(16)),
                          _detail(size,
                              title: LN.courierDetails,
                              lastWidget: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all(Colors.white),
                                    // shadowColor: WidgetStateProperty.all(Colors.white),
                                    shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.black54),
                                            borderRadius:
                                                BorderRadius.circular(10)))),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.delivery_dining_outlined,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: size.getW(12)),
                                    Text(
                                      LN.trackDelivery,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: kFontFMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              firstWidget: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.black45,
                                          )),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.person_outline,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.getW(12),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data?.courierInfo?.data?.courier
                                                ?.name ??
                                            '',
                                        style: TextStyle(
                                          fontSize: size.getS(18),
                                          fontFamily: kFontFMedium,
                                        ),
                                      ),
                                      Builder(builder: (context) {
                                        final rating = data?.courierInfo?.data
                                                ?.courier?.rating?.inDouble ??
                                            0;
                                        final hasDeci =
                                            rating - rating.floor() > 0;
                                        final unrate = (5 - rating).floor();
                                        return Row(
                                          children: [
                                            ...List.generate(
                                                rating.floor(),
                                                (index) => Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    )),
                                            if (hasDeci)
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                            ...List.generate(
                                                unrate.floor(),
                                                (index) => Icon(
                                                      Icons
                                                          .star_border_outlined,
                                                      color: Colors.grey,
                                                    )),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                              list: [
                                _TitleValue(
                                    title: LN.phoneNumber,
                                    value: data?.courierInfo?.data?.courier
                                            ?.phoneNumber ??
                                        '',
                                    valueWidget: Icon(Icons.call_outlined)),
                                _TitleValue(
                                    title: LN.vehicleType,
                                    value: data?.courierInfo?.data?.courier
                                            ?.vehicleType ??
                                        ''),
                              ]),
                          SizedBox(height: size.getH(16)),
                          Divider(
                            color: Colors.black87,
                            thickness: 0.6,
                          ),
                        ],
                        // SizedBox(height: size.getH(16)),
                        // Divider(
                        //   color: Colors.black87,
                        //   thickness: 0.6,
                        // ),
                        // _detail(
                        //   size,
                        //   title: "Store Details",
                        //   list: [
                        //     _TitleValue(title: "Store Name", value: "Hanuman"),
                        //     _TitleValue(title: "Phone", value: "+16283337630"),
                        //     _TitleValue(
                        //         title: "Address",
                        //         value: "2200 Market St, San Francisco, CA 94114, US"),
                        //     _TitleValue(title: "Pick-Up Time", value: "na"),
                        //     _TitleValue(title: "Store Notes", value: "na"),
                        //   ],
                        // ),

                        ...[
                          _detail(
                            size,
                            title: "Delivery Details",
                            list: [
                              _TitleValue(
                                  title: LN.recipient,
                                  value: data?.deliveryName ?? ''),
                              _TitleValue(
                                  title: LN.phone,
                                  value: data?.deliveryPhoneNumber ?? ''),
                              _TitleValue(
                                  title: LN.address,
                                  value: data?.deliveryLocation ?? ''),
                              _TitleValue(
                                  title: LN.pickUpTime,
                                  value: data?.pickUpTime ?? ''),
                              _TitleValue(
                                  title: LN.deliveryTime,
                                  value: data?.deliveryTime ?? ''),
                              _TitleValue(
                                  title: LN.deliveryNotes,
                                  value: data?.deliveryDropOffNotes ?? ''),
                            ],
                          ),
                          SizedBox(height: size.getH(16)),
                          Divider(
                            color: Colors.black87,
                            thickness: 0.6,
                          ),
                        ],
                        if (data?.deliveryItems?.isNotEmpty ?? false) ...[
                          _detail(
                            size,
                            title: LN.itemDetails,
                            width: 150,
                            list: [
                              _TitleValue(
                                  title: LN.itemName,
                                  value: data?.deliveryItems?.first.name ?? ''),
                              _TitleValue(
                                  title: LN.quantity,
                                  value:
                                      "${data?.deliveryItems?.first.quantity ?? ''}"),
                              _TitleValue(
                                  title: LN.price,
                                  value:
                                      "${dTrcPro.curSym}${data?.deliveryItems?.first.price ?? ''}"),
                              _TitleValue(
                                  title: LN.size,
                                  value: data?.deliveryItems?.first.size ?? ''),
                              _TitleValue(
                                  title: LN.dimension,
                                  value:
                                      "${data?.deliveryItems?.first.dimensions?.length} X ${data?.deliveryItems?.first.dimensions?.height} X ${data?.deliveryItems?.first.dimensions?.depth}"),
                              _TitleValue(
                                  title: LN.weight,
                                  value:
                                      "${data?.deliveryItems?.first.weight ?? ''} gram"),
                              _TitleValue(
                                  title: LN.mustBeUpright,
                                  value: (data?.deliveryItems?.first
                                              .mustBeUpright ??
                                          false)
                                      ? LN.yes
                                      : LN.no),
                            ],
                          ),
                          ...List.generate(
                              (data?.deliveryItems?.length ?? 0) - 1, (i) {
                            final item = data?.deliveryItems?[i + 1];
                            return Column(
                              children: [
                                Divider(
                                  color: Colors.black54,
                                  thickness: 0.6,
                                ),
                                _detail(
                                  size,
                                  width: 150,
                                  list: [
                                    _TitleValue(
                                      title: LN.itemName,
                                      value: item?.name ?? '',
                                    ),
                                    _TitleValue(
                                      title: LN.quantity,
                                      value: "${item?.quantity ?? ''}",
                                    ),
                                    _TitleValue(
                                      title: LN.price,
                                      value:
                                          "${dTrcPro.curSym}${item?.price ?? ''}",
                                    ),
                                    _TitleValue(
                                      title: LN.size,
                                      value: item?.size ?? '',
                                    ),
                                    _TitleValue(
                                      title: LN.dimension,
                                      value:
                                          "${item?.dimensions?.length} X ${item?.dimensions?.height} X ${item?.dimensions?.depth}",
                                    ),
                                    _TitleValue(
                                      title: LN.weight,
                                      value: "${item?.weight ?? ''} gram",
                                    ),
                                    _TitleValue(
                                      title: LN.mustBeUpright,
                                      value: (item?.mustBeUpright ?? false)
                                          ? LN.yes
                                          : LN.no,
                                    ),
                                  ],
                                )
                              ],
                            );
                          }),
                          SizedBox(height: size.getH(16)),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  Expanded(
                      flex: 4,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: size.getS(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LN.deliveryStatus,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: kFontFMedium,
                                  fontSize: size.getS(18),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              SizedBox(height: size.getH(16)),
                              VerticalStepper(
                                  dotGap: 60,
                                  inActiveColor: kTempColor,
                                  activeColor: kTempColor,
                                  // reverse: true,
                                  steps: List.generate(
                                      data!.orderDeliveryTrackingList!.length,
                                      (index) {
                                    final trackData =
                                        data.orderDeliveryTrackingList![index];
                                    final isLastIndex =
                                        data.orderDeliveryTrackingList!.length -
                                                1 ==
                                            index;
                                    return StepTile(
                                      title: Text(
                                        trackData.trackingStatusDescription ??
                                            '',
                                        style: TextStyle(
                                          fontSize: size.getS(15),
                                          fontFamily: kFontFRegular,
                                        ),
                                        maxLines: 2,
                                      ),
                                      iconBackColor: isLastIndex
                                          ? kTempColor
                                          : Colors.grey,
                                      isActive: isLastIndex,
                                    );
                                  })),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
              Divider(
                color: Colors.black87,
                thickness: 0.6,
              ),
              _detail(
                size,
                title: LN.amount,
                width: 150,
                list: [
                  _TitleValue(
                      title: LN.totalPrice,
                      value: "${dTrcPro.curSym}${data.totalPrice ?? ''}"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LoadButton(
                    btnText: LN.close,
                    width: 160,
                    btnColor: Colors.red.shade700,
                    hPad: 4,
                    onsave: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: size.getW(16)),
                  LoadButton(
                    btnText: LN.completeDelivery,
                    width: 300,
                    hPad: 4,
                    onsave: () {},
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _detail(
    Ssize size, {
    double width = 260,
    String? title,
    Widget? firstWidget,
    Widget? lastWidget,
    List<_TitleValue>? list,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title,
            style: TextStyle(
              fontSize: size.getS(16),
              fontFamily: kFontFMedium,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
          SizedBox(height: size.getH(12))
        ],
        Wrap(
          runSpacing: size.getH(8),
          spacing: size.getW(12),
          children: [
            if (firstWidget != null)
              SizedBox(
                width: size.getW(width),
                child: firstWidget,
              ),
            if (list != null)
              ...List.generate(
                  list.length,
                  (index) => SizedBox(
                        width: size.getW(width),
                        child: _titleValue2(
                          size,
                          title: list[index].title,
                          value: list[index].value,
                          preValWidget: list[index].valueWidget,
                        ),
                      )),
            if (lastWidget != null)
              SizedBox(
                width: size.getW(width),
                child: lastWidget,
              ),
          ],
        )
      ],
    );
  }

  Widget _titleValue2(
    Ssize size, {
    final String? title,
    required final String value,
    Widget? preValWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title,
            style: TextStyle(
              fontSize: size.getS(18),
              fontFamily: kFontFMedium,
              color: Colors.black54,
            ),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (preValWidget != null) preValWidget,
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: size.getS(18),
                  fontFamily: kFontFMedium,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TitleValue {
  final String? title;
  final String value;
  final Widget? valueWidget;

  _TitleValue({this.title, required this.value, this.valueWidget});
}
