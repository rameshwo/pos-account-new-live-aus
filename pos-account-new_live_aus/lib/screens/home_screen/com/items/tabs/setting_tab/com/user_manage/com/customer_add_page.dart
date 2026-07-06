import 'package:flutter/material.dart';
import '../../../../../../../../../config/size_config.dart';
import '../../../../../../../../../config/validator.dart';
import '../../../../../../../../../constant/constant.dart';
import '../../../../../../../../../ln.dart';
import '../../../../../../../../../providers/profile/user_manage_pro.dart';
import '../../../../../../../../../widgets/image/network_image_sec.dart';
import '../../../../../../../../../widgets/input/dropdown/dropdown_with_text_form.dart';
import '../../../../../../../../../widgets/input/dropdown/title_drop_down.dart';
import '../../../../../../../../../widgets/input/text_form/title_text_form.dart';
import '../../../../../../../../../widgets/load_btn.dart';
import '../../../../../../../../../widgets/loading.dart';
import '../../../../../../../../../widgets/switch_adap.dart';
import '../../general/common/common_header.dart';

class CustomerAddPage extends StatefulWidget {
  final PageController pageController;
  final UserManagePro pro;
  const CustomerAddPage({
    super.key,
    required this.pageController,
    required this.pro,
  });

  @override
  State<CustomerAddPage> createState() => _CustomerAddPageState();
}

class _CustomerAddPageState extends State<CustomerAddPage> {
  @override
  void initState() {
    widget.pro.getCustomerData();
    super.initState();
  }

  @override
  void dispose() {
    widget.pro.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    return Processing(
      loading: widget.pro.loading,
      align: Alignment.topLeft,
      child: Form(
        key: widget.pro.formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonHeader(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          widget.pageController.jumpToPage(0);
                          widget.pro.clear();
                        },
                        icon: Icon(Icons.arrow_back, size: size.getS(24))),
                    SizedBox(width: size.getW(8)),
                    Text(
                      widget.pro.userId.isNotEmpty
                          ? "Update Customer Information"
                          : LN.addCustomer,
                      style: TextStyle(
                        fontSize: size.getS(18),
                        // fontFamily: ,ph
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.getH(8)),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.getH(12.0), horizontal: size.getW(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          spacing: size.getW(32),
                          runSpacing: size.getH(16),
                          children: [
                            TitleTextForm(
                              title: LN.fullName,
                              isReq: true,
                              hintText: LN.fullName,
                              textCltr: widget.pro.nameCltr,
                              borderColor: Colors.black12,
                              pWidth: 0.24,
                            ),
                            DropDownWiTextForm(
                              title: LN.phoneNumber,
                              isReq: true,
                              borderColor: Colors.black12,
                              indexVal: widget.pro.phoneCodeIndex,
                              list: widget.pro.customerAddSecRes == null ||
                                      widget.pro.customerAddSecRes!.countries ==
                                          null
                                  ? []
                                  : widget.pro.customerAddSecRes!.countries!
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
                              onChanged: (p0) {
                                widget.pro.phoneCodeIndex = p0;
                                widget.pro.notify;
                              },
                              textCltr: widget.pro.phoneCltr,
                            ),
                            TitleTextForm(
                              title: LN.email,
                              isReq: false,
                              hintText: LN.emailAddress,
                              textCltr: widget.pro.emailCltr,
                              borderColor: Colors.black12,
                              readOnly:
                                  (widget.pro.cusInfo?.hasUserCreatedAccount ??
                                      false),
                              fillColor:
                                  (widget.pro.cusInfo?.hasUserCreatedAccount ??
                                          false)
                                      ? Colors.grey.shade200
                                      : Colors.white,
                              pWidth: 0.24,
                              validator: emailValidator,
                              suffix: (widget
                                          .pro.cusInfo?.hasUserCreatedAccount ??
                                      false)
                                  ? Tooltip(
                                      message:
                                          "This account is created by customer with email and password,\nAdmin cannot change this customer's email.",
                                      textStyle:
                                          TextStyle(fontSize: size.getS(15)),
                                      child: Icon(
                                        Icons.info,
                                        color: Colors.grey,
                                        size: size.getS(25),
                                      ),
                                    )
                                  : null,
                            ),
                            SearchTitleDropDown(
                              title: LN.country,
                              isReq: true,
                              list: widget.pro.customerAddSecRes?.countries ==
                                      null
                                  ? []
                                  : widget.pro.customerAddSecRes!.countries!
                                      .map((e) => e.name ?? '')
                                      .toList(),
                              indexVal: widget.pro.countryIndex,
                              onChanged: (p0) {
                                widget.pro.countryIndex = p0;
                                widget.pro.phoneCodeIndex = p0;
                                widget.pro.stateIndex = null;
                                widget.pro.cityIndex = null;
                                // widget.pro.suburbIndex = null;
                                widget.pro.notify;
                              },
                              borderColor: Colors.black12,
                              pWidth: 0.24,
                            ),
                            TitleTextForm(
                              title: LN.postalCode,
                              isReq: true,
                              hintText: "",
                              textCltr: widget.pro.postalCltr,
                              borderColor: Colors.black12,
                              pWidth: 0.24,
                            ),
                            TitleDropDown(
                              isReq: true,
                              title: LN.customerType,
                              list: widget.pro.customerAddSecRes == null ||
                                      widget.pro.customerAddSecRes!
                                              .customerType ==
                                          null
                                  ? []
                                  : widget.pro.customerAddSecRes!.customerType!
                                      .map((e) => e.name ?? '')
                                      .toList(),
                              indexVal: widget.pro.customerTypeIndex,
                              onChanged: (p0) {
                                widget.pro.customerTypeIndex = p0;
                                widget.pro.notify;
                              },
                              borderColor: Colors.black12,
                              pWidth: 0.24,
                            ),
                            TitleDropDown(
                              isReq: true,
                              title: "Customer Group",
                              list: widget.pro.customerAddSecRes == null ||
                                      widget.pro.customerAddSecRes!
                                              .customerGroups ==
                                          null
                                  ? []
                                  : widget
                                      .pro.customerAddSecRes!.customerGroups!
                                      .map((e) => e.name ?? '')
                                      .toList(),
                              indexVal: widget.pro.cusGroupIndex,
                              onChanged: (p0) {
                                widget.pro.cusGroupIndex = p0;
                                widget.pro.notify;
                              },
                              borderColor: Colors.black12,
                              pWidth: 0.24,
                            ),
                            SizedBox(
                              width: size.width * 0.24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Marketing Promotion Allowed",
                                      style: TextStyle(
                                        fontSize: size.getS(18),
                                        color: Colors.black,
                                      )),
                                  SizedBox(
                                    height: size.getH(12),
                                  ),
                                  SwitchAdap(
                                      height: 32,
                                      size: size,
                                      value: widget.pro.isMarketingPromotion,
                                      onChanged: (val) {
                                        widget.pro.isMarketingPromotion = val;
                                        widget.pro.notify;
                                      }),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(LN.enableLoyal,
                                      style: TextStyle(
                                        fontSize: size.getS(18),
                                        color: Colors.black,
                                      )),
                                  SizedBox(
                                    height: size.getH(12),
                                  ),
                                  SwitchAdap(
                                      height: 32,
                                      size: size,
                                      value: widget.pro.enableLoyality,
                                      onChanged: (val) {
                                        widget.pro.enableLoyality = val;
                                        widget.pro.notify;
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.getH(24),
                        ),
                        Row(
                          children: [
                            // if (GlobalCVP.viewWidget.viewAddUserTabSaveButton)
                            IgnorePointer(
                              ignoring: widget.pro.loading,
                              child: LoadButton(
                                btnText: LN.save,
                                btnColor: kUserColor,
                                loading: widget.pro.updateLoad,
                                onsave: () async {
                                  FocusScope.of(context).unfocus();
                                  if (widget.pro.formKey.currentState!
                                      .validate()) {
                                    final status =
                                        await widget.pro.addUpCustomer();
                                    if (status) {
                                      widget.pro.clear();
                                      widget.pro.notify;
                                      widget.pageController.jumpToPage(0);
                                      widget.pro.getAllCustomers(page: 1);
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: size.getW(12),
                            ),
                            if (widget.pro.cusId.isNotEmpty)
                              //   &&  (GlobalCVP.viewWidget.viewAddUserTabCancelButton)
                              LoadButton(
                                btnText: LN.cancel,
                                btnColor: Colors.red.shade600,
                                onsave: () {
                                  widget.pro.clear();
                                  widget.pageController.jumpToPage(0);
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
