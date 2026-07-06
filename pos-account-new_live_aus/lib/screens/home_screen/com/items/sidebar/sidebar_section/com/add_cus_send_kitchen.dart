import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/text_formatter.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/booking/all_customer.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/home_screen/com/dialogs/cus_list_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/com/price_update_dia.dart';
import 'package:pos_account/widgets/cus_expansion_tile.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/dropdown_with_text_form.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/auto_complete_text_field.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

class AddCusOnSentToKit extends StatefulWidget {
  final bool isFromFloor;

  const AddCusOnSentToKit({this.isFromFloor = false, super.key});

  @override
  State<AddCusOnSentToKit> createState() => _AddCusOnSentToKitState();
}

class _AddCusOnSentToKitState extends State<AddCusOnSentToKit> {
  // final textCltr = TextEditingController();
  void load() {
    if (mounted) setState(() {});
  }

  bool _isFieldEmpty = false;
  final _formKey = GlobalKey<FormState>();

  void onTapDeli(PlaceOrderPro placePro, int index) {
    placePro.selectedCusDeliveryIndex = index;
    placePro.notify;
    final data = placePro.cusDeliveryData[index];
    placePro.getDeliveryAmount(
      id: data.id,
      userId: data.userId,
      lat: data.latitude,
      long: data.longitude,
      address: data.deliveryLocation,
    );
  }

  Function()? exFunction;
  bool isExpand = false;

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    final _placePro = Provider.of<PlaceOrderPro>(context, listen: false);
    if (widget.isFromFloor || _placePro.isDelivery || _placePro.isPickUp) {
      isExpand = true;
      load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final placePro = Provider.of<PlaceOrderPro>(context);

    // final _additionVal = placePro
    //     .listOrderType?[placePro.orderTypeIndex].additionalValue
    //     ?.toLowerCase();

    final _isDelivery = placePro.isDelivery;

    final _isPickUp = placePro.isPickUp;

    final _floraa = !widget.isFromFloor && placePro.isDine;

    return Processing(
      loading: placePro.loadOnAddCus,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.14,
          minHeight: size.height / 5,
        ),
        width: size.width / 1.2,
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
                    LN.addCustomer,
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
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        spacing: size.getW(24),
                        runSpacing: size.getH(24),
                        children: [
                          if (_floraa)
                            TitleTextForm(
                              isReq: false,
                              title: "No. of Customers",
                              hintText: "0",
                              pWidth: 0.24,
                              borderColor: Colors.black26,
                              textCltr: placePro.noOfCustomer,
                              textInputType: TextInputType.number,
                              inputFormatters: [
                                NonNegativeTextInputFormatter()
                              ],
                              readOnly: true,
                              onTap: () {
                                PriceUpdateDia.showDia<int>(
                                  context,
                                  title: LN.noOfCustomers,
                                  number: placePro.noOfCustomer.text.inDouble,
                                  max: 1000,
                                ).then((value) {
                                  placePro.noOfCustomer.text =
                                      value.formatDouble;
                                  placePro.notify;
                                });
                              },
                            ),
                          TitleTextForm(
                            pWidth: 0.24,
                            isReq: _isDelivery || _isPickUp,
                            title: LN.cusName,
                            textCltr: placePro.cusNameCltr,
                            borderColor: Colors.black26,
                            suffix: InkWell(
                              onTap: () =>
                                  CustomerList.show(context).then((value) {
                                if (value != null && value is CusData) {
                                  final _val = value;
                                  placePro.clearCusData();
                                  placePro.setCustomerData(_val);
                                  placePro.getCusDeliveryAddress(
                                      id: _val.id, name: _val.name);
                                  if (!isExpand && exFunction != null) {
                                    exFunction!();
                                    load();
                                  }
                                }
                              }),
                              child: Icon(
                                Icons.search,
                                size: size.getS(24),
                              ),
                            ),
                          ),
                          if (!_floraa)
                            DropDownWiTextForm(
                              title: LN.phoneNumber,
                              isReq: _isDelivery,
                              pWidth: 0.24,
                              vPad: 10,
                              borderColor: Colors.black26,
                              indexVal: placePro.phoneCodeIndex,
                              list: placePro.customerAddSecRes?.countries ==
                                      null
                                  ? []
                                  : placePro.customerAddSecRes!.countries!
                                      .map((e) => Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              NetworkImageSec(
                                                image: e.image,
                                                height: size.isProt
                                                    ? size.getW(12)
                                                    : size.getW(16),
                                                width: size.isProt
                                                    ? size.getW(12)
                                                    : size.getW(16),
                                              ),
                                              if (e.additionalValue is String)
                                                Flexible(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      e.additionalValue,
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
                              onChanged: (p0) {
                                placePro.phoneCodeIndex = p0;
                                placePro.notify;
                              },
                              textCltr: placePro.cusPhoneCltr,
                            ),
                          if (!_floraa)
                            TitleTextForm(
                              title: LN.email,
                              textCltr: placePro.cusEmailCltr,
                              isReq: false,
                              pWidth: 0.24,
                              vPad: 12,
                              borderColor: Colors.black26,
                              validator: emailValidator,
                              textInputType: TextInputType.emailAddress,
                            ),
                        ],
                      ),
                      SizedBox(
                        height: size.getH(24),
                      ),

                      // Padding(
                      //   padding:
                      //       EdgeInsets.symmetric(vertical: size.getH(12)),
                      //   child: Divider(
                      //     color: Colors.black54,
                      //   ),
                      // ),
                      if (_floraa)
                        LoadButton(
                          width: 200,
                          hPad: 2,
                          btnText: "Add more Details",
                          btnColor: isExpand
                              ? kSecondaryColor.withOpacity(0.5)
                              : kSecondaryColor,
                          onsave: () {
                            if (exFunction != null) {
                              exFunction!();
                              load();
                            }
                          },
                        ),
                      Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: Colors.transparent),
                        child: CusExpansionTile(
                          initiallyExpanded: isExpand,
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          onExpansionChanged: (val) => isExpand = val,
                          assignFunction: (val) {
                            exFunction = val;
                          },
                          expandedAlignment: Alignment.topLeft,
                          children: [
                            if (_floraa) SizedBox(height: size.getH(12)),
                            Wrap(
                              spacing: size.getW(24),
                              runSpacing: size.getH(24),
                              children: [
                                if (_floraa)
                                  DropDownWiTextForm(
                                    title: LN.phoneNumber,
                                    isReq: _isDelivery,
                                    pWidth: 0.24,
                                    vPad: 10,
                                    borderColor: Colors.black26,
                                    indexVal: placePro.phoneCodeIndex,
                                    list: placePro
                                                .customerAddSecRes?.countries ==
                                            null
                                        ? []
                                        : placePro.customerAddSecRes!.countries!
                                            .map((e) => Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    NetworkImageSec(
                                                      image: e.image,
                                                      height: size.isProt
                                                          ? size.getW(12)
                                                          : size.getW(16),
                                                      width: size.isProt
                                                          ? size.getW(12)
                                                          : size.getW(16),
                                                    ),
                                                    if (e.additionalValue
                                                        is String)
                                                      Flexible(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            e.additionalValue,
                                                            style: TextStyle(
                                                              fontSize: size
                                                                      .isProt
                                                                  ? size
                                                                      .getW(12)
                                                                  : size
                                                                      .getS(16),
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ],
                                                ))
                                            .toList(),
                                    onChanged: (p0) {
                                      placePro.phoneCodeIndex = p0;
                                      placePro.notify;
                                    },
                                    textCltr: placePro.cusPhoneCltr,
                                  ),
                                if (_floraa)
                                  TitleTextForm(
                                    title: LN.email,
                                    textCltr: placePro.cusEmailCltr,
                                    isReq: false,
                                    pWidth: 0.24,
                                    vPad: 12,
                                    borderColor: Colors.black26,
                                    validator: emailValidator,
                                    textInputType: TextInputType.emailAddress,
                                  ),
                                SearchTitleDropDown(
                                  pWidth: 0.24,
                                  title: LN.country,
                                  vPad: 10,
                                  isReq: false,
                                  borderColor: Colors.black26,
                                  list: placePro.customerAddSecRes?.countries ==
                                          null
                                      ? []
                                      : placePro.customerAddSecRes!.countries!
                                          .map((e) => e.name ?? '')
                                          .toList(),
                                  indexVal: placePro.countryIndex,
                                  onChanged: (p0) {
                                    placePro.countryIndex = p0;
                                    placePro.phoneCodeIndex = p0;
                                    placePro.notify;
                                  },
                                ),
                                TitleTextForm(
                                  title: LN.postalCode,
                                  borderColor: Colors.black26,
                                  textCltr: placePro.cusPostalCodeCltr,
                                  isReq: false,
                                  pWidth: 0.24,
                                  vPad: 12,
                                  textInputType: TextInputType.number,
                                ),
                                TitleDropDown(
                                  pWidth: 0.24,
                                  title: LN.customerType,
                                  hintText: LN.customerType,
                                  isReq: false,
                                  vPad: 10,
                                  borderColor: Colors.black26,
                                  list: placePro.customerAddSecRes
                                              ?.customerType ==
                                          null
                                      ? []
                                      : placePro
                                          .customerAddSecRes!.customerType!
                                          .map((e) => e.name ?? '')
                                          .toList(),
                                  indexVal: placePro.customerTypeIndex,
                                  onChanged: (p0) {
                                    placePro.customerTypeIndex = p0;
                                    placePro.notify;
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.getH(12),
                      ),

                      SizedBox(width: size.getW(12)),
                      if (_isDelivery)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Divider(color: Colors.black26),
                            // Padding(
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: size.getW(12)),
                            //   child: Text(
                            //     "Delivery Details",
                            //     style: TextStyle(
                            //       fontSize: size.getS(20),
                            //       color: Colors.black,
                            //       fontFamily: kFontFMedium,
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: size.getH(12),
                            ),
                            Wrap(
                              spacing: size.getW(24),
                              runSpacing: size.getW(24),
                              children: [
                                SizedBox(
                                  width: size.getW(800),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AutoCompleteText(
                                        pWidth: 0.5,
                                        vPad: 12,
                                        isReq:
                                            placePro.selectedCusDeliveryIndex ==
                                                null,
                                        title: LN.deliveryAdd,
                                        textCltr: placePro.addressCltr,
                                        hintText: LN.deliveryAdd,
                                        borderColor: Colors.black26,
                                        hasError:
                                            placePro.selectedCusDeliveryIndex ==
                                                    null &&
                                                _isFieldEmpty,
                                        suffixIcon: placePro
                                                .addressCltr.text.isEmpty
                                            ? null
                                            : InkWell(
                                                onTap: () {
                                                  placePro.addressCltr.clear();
                                                },
                                                child: Icon(Icons.close,
                                                    size: size.getS(32)),
                                              ),
                                        asyncSuggestions: (String _val) async {
                                          bool _prevData = _isFieldEmpty;

                                          _isFieldEmpty = _val.isEmpty;
                                          if (!_isFieldEmpty &&
                                              placePro.selectedCusDeliveryIndex !=
                                                  null) {
                                            placePro.selectedCusDeliveryIndex =
                                                null;
                                            placePro.notify;
                                          }

                                          if (_prevData != _isFieldEmpty)
                                            load();

                                          if (_val.isNotEmpty) {
                                            await placePro.getPlace(_val);
                                          }
                                          return placePro.getAutoPlaces
                                                      ?.predictions ==
                                                  null
                                              ? []
                                              : placePro
                                                  .getAutoPlaces!.predictions
                                                  .map((e) => e.fullText)
                                                  .toSet()
                                                  .toList();
                                        },
                                        onSubmit: (val) {
                                          if (placePro
                                                  .getAutoPlaces?.predictions
                                                  .any((e) =>
                                                      e.fullText == val) ??
                                              false) {
                                            final _pId = placePro
                                                .getAutoPlaces!.predictions
                                                .firstWhere(
                                                    (e) => e.fullText == val)
                                                .placeId;

                                            placePro.getLocation(_pId,
                                                address: val);
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: size.getH(12),
                                      ),
                                      ...List.generate(
                                          placePro.cusDeliveryData.length,
                                          (index) => Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Transform.scale(
                                                    scale: 1.2,
                                                    child: Radio(
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                      activeColor:
                                                          kSecondaryColor,
                                                      value: index ==
                                                          placePro
                                                              .selectedCusDeliveryIndex,
                                                      groupValue: true,
                                                      onChanged: (val) =>
                                                          onTapDeli(
                                                              placePro, index),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: InkWell(
                                                      onTap: () => onTapDeli(
                                                          placePro, index),
                                                      child: Text(
                                                        placePro
                                                                .cusDeliveryData[
                                                                    index]
                                                                .deliveryLocation ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.getS(16),
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                    ],
                                  ),
                                ),
                                if (placePro.addressCltr.text.isNotEmpty ||
                                    placePro.selectedCusDeliveryIndex != null)
                                  TitleTextForm(
                                    title: LN.deliAmt,
                                    textCltr: placePro.delivertAmtCltr,
                                    isReq: false,
                                    borderColor: Colors.black26,
                                    pWidth: 0.24,
                                    textInputType: TextInputType.number,
                                    inputFormatters: [
                                      NonNegativeTextInputFormatter()
                                    ],
                                    prefixText: Text(
                                      placePro.curSym ?? '',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: size.getS(16)),
                                    ),
                                  ),
                              ],
                            ),

                            // SizedBox(
                            //   width: size.getW(32),
                            // ),

                            SizedBox(
                              height: size.getH(12),
                            ),
                            Wrap(
                              spacing: size.getW(24),
                              runSpacing: size.getW(24),
                              children: [
                                TitleTextForm(
                                  isReq: false,
                                  pWidth: 0.24,
                                  title: LN.deliveryTime,
                                  textCltr: placePro.dateTimeCltr,
                                  borderColor: Colors.black26,
                                  readOnly: true,
                                  onTap: () {
                                    Utils.datePick(context).then((_date) {
                                      if (_date == null) return;
                                      Utils.timePick(context).then((_time) {
                                        if (_time == null) return;
                                        final _dateTime = DateTime(
                                          _date.year,
                                          _date.month,
                                          _date.day,
                                          _time.hour,
                                          _time.minute,
                                        );
                                        if (_dateTime
                                            .isBefore(DateTime.now())) {
                                          showToast(LN.deliveryCantMadePast);
                                          placePro.dateTimeCltr.clear();
                                          return;
                                        }

                                        placePro.dateTimeCltr.text =
                                            DateFormat(placePro.dateFormat)
                                                .format(_dateTime);
                                      });
                                    });
                                  },
                                ),
                                TitleTextForm(
                                  title: LN.deliveryNotes,
                                  textCltr: placePro.deliNoteCltr,
                                  borderColor: Colors.black26,
                                  isReq: false,
                                  pWidth: 0.24,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.getH(12),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: size.getH(24),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (placePro.deliveryDisRes?.distanceInKm != null ||
                      placePro.deliveryDisRes?.distanceInMile != null)
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                        "${LN.deliveryDistance} : ${placePro.deliveryDisRes?.distanceInKm ?? '0'} Km / ${placePro.deliveryDisRes?.distanceInMile ?? '0'} Miles",
                        style: TextStyle(
                          fontSize: size.getS(18),
                          color: Colors.black,
                        ),
                      ),
                    ),
                  Spacer(),
                  LoadButton(
                    btnText: LN.clear,
                    btnColor: Colors.red.shade600,
                    onsave: () {
                      placePro.clearCusData();
                      placePro.notify;
                      // Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  LoadButton(
                    btnText: LN.langModelContinue,
                    onsave: () {
                      if (!_isDelivery && !_isPickUp) {
                        Navigator.of(context).pop(true);
                      } else if (_formKey.currentState?.validate() ?? false) {
                        if (_isPickUp ||
                            placePro.addressCltr.text.isNotEmpty ||
                            placePro.selectedCusDeliveryIndex != null) {
                          Navigator.of(context).pop(true);
                        } else {
                          _isFieldEmpty = true;
                          load();
                        }
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: size.getH(12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
