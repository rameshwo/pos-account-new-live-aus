import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/orders/order_detail_by_id.dart';
import 'package:pos_account/model/profile/user_add_sec.dart';
import 'package:pos_account/services/uber/delivery/provider/delivery_pro.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/dropdown_with_text_form.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

import 'com/item_box_sec.dart';

class DeliveryOrderDia extends StatefulWidget {
  final OrderDetailById orderDetail;
  const DeliveryOrderDia({super.key, required this.orderDetail});

  @override
  State<DeliveryOrderDia> createState() => _DeliveryOrderDiaState();
}

class _DeliveryOrderDiaState extends State<DeliveryOrderDia> {
  final _formKey = GlobalKey<FormState>();

  void get load {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  late DeliveryPro _dPro;

  void _getData() {
    _dPro = Provider.of<DeliveryPro>(context, listen: false);
    _dPro.getData(widget.orderDetail);
  }

  @override
  void dispose() {
    _dPro.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final deliPro = Provider.of<DeliveryPro>(context);
    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(
          horizontal: size.getW(24), vertical: size.getH(24)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: [
        Processing(
          loading: deliPro.pageLoad,
          child: SizedBox(
            width: size.width / 1.17,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        deliPro.orderDetail?.orderDetailsViewModel
                                ?.orderNumber ??
                            '',
                        style: TextStyle(
                          fontSize: size.getS(20),
                          color: kPrimaryColor,
                          fontFamily: kFontFMedium,
                          fontWeight: FontWeight.bold,
                        ),
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
                  SizedBox(height: size.getH(12)),
                  _inputDetails(size,
                      countries: deliPro.cusAddSec?.countries,
                      title: LN.deliveryDriverPickup,
                      nameCltr: deliPro.pickNameCltr,
                      phoneCltr: deliPro.pickPhoneCltr,
                      phoneCodeIndex: deliPro.pickPhoneCodeIndex,
                      onChangePhone: (val) {
                        deliPro.pickPhoneCodeIndex = val;
                        deliPro.notify;
                      },
                      timeCltr: deliPro.pickTimeCltr,
                      addressCltr: deliPro.pickAddrCltr,
                      noteCltr: deliPro.pickNoteCltr,
                      onTapTime: () {
                        Utils.datePick(context,
                                initDate: deliPro.pickTimeCltr.text.isNotEmpty
                                    ? DateFormat(deliPro.dateFormat)
                                        .parse(deliPro.pickTimeCltr.text)
                                    : null)
                            .then((date) {
                          if (date == null) return;

                          Utils.timePick(context).then((time) {
                            if (time == null) return;

                            final dateTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );

                            // Convert the delivery time to DateTime
                            final deliveryTime =
                                deliPro.deliTimeCltr.text.isNotEmpty
                                    ? DateFormat(deliPro.dateFormat)
                                        .parse(deliPro.deliTimeCltr.text)
                                    : null;

                            if (dateTime.isBefore(DateTime.now())) {
                              showToast(LN.pickupCannotPast);
                              deliPro.pickTimeCltr.clear();
                              return;
                            }

                            if (deliveryTime != null) {
                              // Check if the pickup time is after the delivery time
                              if (deliPro.deliTimeCltr.text.isNotEmpty &&
                                  dateTime.isAfter(deliveryTime)) {
                                showToast(LN.pickupTimeCannotAfter);
                                deliPro.pickTimeCltr.clear();
                                return;
                              }

                              final minPickupTime =
                                  deliveryTime.subtract(Duration(minutes: 10));

                              if (dateTime.isAfter(minPickupTime) &&
                                  dateTime.isBefore(deliveryTime)) {
                                showToast(LN.pickupTimeAtLeast10);
                                deliPro.pickTimeCltr.clear();
                                return;
                              }
                            }

                            deliPro.pickTimeCltr.text =
                                DateFormat(deliPro.dateFormat).format(dateTime);
                          });
                        });
                      }),
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(0, size.getH(24), 0, size.getH(12)),
                    child: Divider(
                      color: Colors.black87,
                      thickness: 0.6,
                    ),
                  ),
                  _inputDetails(size,
                      countries: deliPro.cusAddSec?.countries,
                      title: LN.deliveryCustomer,
                      nameCltr: deliPro.deliNameCltr,
                      phoneCltr: deliPro.deliPhoneCltr,
                      phoneCodeIndex: deliPro.deliPhoneCodeIndex,
                      onChangePhone: (val) {
                        deliPro.deliPhoneCodeIndex = val;
                        deliPro.notify;
                      },
                      timeCltr: deliPro.deliTimeCltr,
                      addressCltr: deliPro.deliAddrCltr,
                      noteCltr: deliPro.deliNoteCltr,
                      onTapTime: () {
                        if (deliPro.deliTimeCltr.text.isNotEmpty)
                          Utils.datePick(context,
                                  initDate: DateFormat(deliPro.dateFormat)
                                      .parse(deliPro.deliTimeCltr.text))
                              .then((date) {
                            if (date == null) return;
                            Utils.timePick(context).then((time) {
                              if (time == null) return;
                              final dateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                              if (dateTime.isBefore(DateTime.now())) {
                                showToast(LN.deliveryCantMadePast);
                                deliPro.deliTimeCltr.clear();
                                return;
                              } else if (deliPro.pickTimeCltr.text.isNotEmpty &&
                                  dateTime.isBefore(
                                      DateFormat(deliPro.dateFormat)
                                          .parse(deliPro.pickTimeCltr.text))) {
                                showToast(
                                    "Delivery time can not be made before pickup time");
                                deliPro.deliTimeCltr.clear();
                                return;
                              }

                              deliPro.deliTimeCltr.text =
                                  DateFormat(deliPro.dateFormat)
                                      .format(dateTime);
                            });
                          });
                      }),
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(0, size.getH(24), 0, size.getH(12)),
                    child: Divider(
                      color: Colors.black87,
                      thickness: 0.6,
                    ),
                  ),
                  ItemBoxSec(),
                  SizedBox(height: size.getH(32)),
                  Row(
                    children: [
                      LoadButton(
                        btnText: LN.createDelivery,
                        width: 200,
                        loading: deliPro.createLoad,
                        onsave: deliPro.createLoad
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  deliPro.createDelivery().then((value) {
                                    if (value ?? false) Navigator.pop(context);
                                  });
                                }
                              },
                      ),
                      SizedBox(
                        width: size.getW(24),
                      ),
                      LoadButton(
                        btnText: LN.cancel,
                        btnColor: Colors.red.shade700,
                        width: 200,
                        onsave: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _inputDetails(
    Ssize size, {
    List<UserAddSecData>? countries,
    required final String title,
    required final TextEditingController nameCltr,
    final int? phoneCodeIndex,
    Function(int?)? onChangePhone,
    required final TextEditingController phoneCltr,
    required final TextEditingController timeCltr,
    required final TextEditingController addressCltr,
    required final TextEditingController noteCltr,
    Function()? onTapTime,
  }) {
    final prefixText1 =
        title.toLowerCase().contains('pick') ? "Pick-Up" : LN.customer;
    final prefixText2 =
        title.toLowerCase().contains('pick') ? "Pick-Up" : LN.delivery;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title ${LN.details}",
          style: TextStyle(
            fontSize: size.getS(18),
            color: kPrimaryColor,
            fontFamily: kFontFMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: size.getH(4),
        ),
        Wrap(
          // crossAxisAlignment: CrossAxisAlignment.start,
          spacing: size.getW(32),
          runSpacing: size.getH(24),
          children: [
            TitleTextForm(
              title: "$prefixText1 ${LN.name}",
              textCltr: nameCltr,
              isReq: true,
              pWidth: 0.24,
            ),
            DropDownWiTextForm(
              title: "$prefixText1 ${LN.number}",
              isReq: true,
              pWidth: 0.24,
              indexVal: phoneCodeIndex,
              list: countries == null
                  ? []
                  : countries
                      .map((e) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              NetworkImageSec(
                                image: e.image,
                                height:
                                    size.isProt ? size.getW(12) : size.getW(16),
                                width:
                                    size.isProt ? size.getW(12) : size.getW(16),
                              ),
                              if (e.additionalValue is String)
                                Flexible(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      e.additionalValue ?? '',
                                      style: TextStyle(
                                        fontSize: size.isProt
                                            ? size.getW(12)
                                            : size.getS(16),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ))
                      .toList(),
              onChanged: onChangePhone,
              textCltr: phoneCltr,
            ),
            TitleTextForm(
              isReq: false,
              pWidth: 0.24,
              title: "$prefixText2 ${LN.time}",
              textCltr: timeCltr,
              suffixIcon: Icon(Icons.calendar_month),
              readOnly: true,
              onTap: onTapTime,
            ),

            TitleTextForm(
              title: "$prefixText2 ${LN.address}",
              textCltr: addressCltr,
              isReq: true,
              readOnly: true,
              pWidth: 0.5,
            ),
            // AutoCompleteText(
            //   pWidth: 0.5,
            //   isReq: true,

            //   title: "Delivery Address",
            //   textCltr: deliPro.deliAddrCltr,
            //   hintText: "Delivery Address",
            //   hasError: deliPro.deliveryIndex == null && _isFieldEmpty,
            //   suffixIcon: deliPro.deliAddrCltr.text.isEmpty
            //       ? null
            //       : InkWell(
            //           onTap: () {
            //             deliPro.deliAddrCltr.clear();
            //           },
            //           child: Icon(Icons.close, size: size.getS(32)),
            //         ),
            //   asyncSuggestions: (String _val) async {
            //     bool _prevData = _isFieldEmpty;

            //     _isFieldEmpty = _val.isEmpty;
            //     if (!_isFieldEmpty && deliPro.deliveryIndex != null) {
            //       deliPro.deliveryIndex = null;
            //       deliPro.notify;
            //     }

            //     if (_prevData != _isFieldEmpty) load;

            //     if (_val.isNotEmpty) {
            //       await deliPro.getPlace(_val);
            //     }
            //     return deliPro.getAutoPlaces?.predictions == null
            //         ? []
            //         : deliPro.getAutoPlaces!.predictions!
            //             .map((e) => e.description ?? '')
            //             .toSet()
            //             .toList();
            //   },
            //   onSubmit: (val) {
            //     if (deliPro.getAutoPlaces!.predictions!
            //         .any((e) => e.description == val)) {
            //       // final _pId = deliPro.getAutoPlaces!.predictions!
            //       //     .firstWhere((e) => e.description == val)
            //       //     .placeId;

            //       // deliPro.getLocation(_pId);
            //     }
            //   },
            // ),

            TitleTextForm(
              title: "$prefixText2 ${LN.notes.toLowerCase()}",
              textCltr: noteCltr,
              isReq: false,
              pWidth: 0.24,
            ),

            // TitleTextForm(
            //   title: "Delivery Seller notes",
            //   textCltr: deliPro.deliSellerNoteCltr,
            //   isReq: false,
            //   pWidth: 0.24,
            // ),
          ],
        ),
      ],
    );
  }
}
