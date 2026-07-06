import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/profile/user_manage_pro.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';

import '../../general/common/common_header.dart';

class CommissionSetupPage extends StatelessWidget {
  final PageController pageController;
  final UserManagePro pro;
  const CommissionSetupPage({
    required this.pro,
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final name = (pro.allEmployees?.data?.any((e) => e.id == pro.empId) ??
            false)
        ? " for ${pro.allEmployees?.data?.firstWhere((e) => e.id == pro.empId).preferredName ?? ''}"
        : '';
    final size = Ssize(context);
    return Processing(
      loading: pro.loading,
      child: Form(
        key: pro.commFormKey,
        child: Column(
          children: [
            CommonHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        pro.clear();
                        pageController.animateToPage(0,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut);
                      },
                      icon: Icon(Icons.arrow_back, size: size.getS(24))),
                  SizedBox(width: size.getW(8)),
                  Text(
                    "Commission Setup$name",
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
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.getH(8),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: size.getW(48),
                          runSpacing: size.getH(24),
                          children: [
                            TitleDropDown(
                              isReq: true,
                              pWidth: 0.24,
                              borderRadius: 5,
                              list: (pro.commAddSec == null ||
                                      pro.commAddSec!.serviceCommissionTypes ==
                                          null)
                                  ? []
                                  : pro.commAddSec!.serviceCommissionTypes!
                                      .map((e) => e.value ?? '')
                                      .toList(),
                              indexVal: pro.commissionTypeIndex,
                              title: "Service Commission Type",
                              onChanged: (int? p0) {
                                pro.commissionTypeIndex = p0;
                                pro.notify;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.getH(24),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.getH(24.0),
                              horizontal: size.getW(24)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TitleTextForm(
                                    isReq: true,
                                    pWidth: 0.24,
                                    title: "Amount From",
                                    textCltr: pro.commissionPerList[0].fromCltr,
                                    errH: 0,
                                    hintText: '0.00',
                                    prefixText: Text(
                                      "${pro.curSym}",
                                      style: TextStyle(
                                        fontSize: size.getS(16),
                                        color: Colors.black,
                                      ),
                                    ),
                                    textInputType: TextInputType.number,
                                    suffixIcon: pro.commissionPerList[0]
                                            .fromCltr.text.isNotEmpty
                                        ? InkWell(
                                            onTap: () {
                                              pro.commissionPerList[0].fromCltr
                                                  .clear();
                                              pro.notify;
                                            },
                                            child: Icon(Icons.close,
                                                size: size.getS(28)))
                                        : null,
                                  ),
                                  SizedBox(
                                    width: size.getW(30),
                                  ),
                                  TitleTextForm(
                                    pWidth: 0.24,
                                    isReq: true,
                                    title: "Amount To",
                                    hintText: '0.00',
                                    textCltr: pro.commissionPerList[0].toCltr,
                                    errH: 0,
                                    prefixText: Text(
                                      "${pro.curSym}",
                                      style: TextStyle(
                                        fontSize: size.getS(16),
                                        color: Colors.black,
                                      ),
                                    ),
                                    textInputType: TextInputType.number,
                                    suffixIcon: pro.commissionPerList[0].toCltr
                                            .text.isNotEmpty
                                        ? InkWell(
                                            onTap: () {
                                              pro.commissionPerList[0].toCltr
                                                  .clear();
                                              pro.notify;
                                            },
                                            child: Icon(Icons.close,
                                                size: size.getS(28)))
                                        : null,
                                  ),
                                  SizedBox(
                                    width: size.getW(30),
                                  ),
                                  TitleTextForm(
                                    pWidth: 0.14,
                                    isReq: true,
                                    title: "Commission %",
                                    hintText: '0.00',
                                    textCltr: pro.commissionPerList[0].dataCltr,
                                    errH: 0,
                                    textInputType: TextInputType.number,
                                    suffixIcon: pro.commissionPerList[0]
                                            .dataCltr.text.isNotEmpty
                                        ? InkWell(
                                            onTap: () {
                                              pro.commissionPerList[0].dataCltr
                                                  .clear();
                                              pro.notify;
                                            },
                                            child: Icon(Icons.close,
                                                size: size.getS(28)))
                                        : null,
                                  ),
                                  SizedBox(
                                    width: size.getW(48),
                                  ),
                                  Material(
                                    color: kPrimaryColor,
                                    type: MaterialType.circle,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(60),
                                      onTap: pro.addCommissionPer,
                                      child: Icon(
                                        Icons.add,
                                        size: size.getS(48),
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              ...List.generate(pro.commissionPerList.length,
                                  (index) {
                                if (index == 0) return SizedBox.shrink();
                                return Padding(
                                  padding:
                                      EdgeInsets.only(top: size.getH(24.0)),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.24,
                                        child: TextFormWidget(
                                          initValidate: true,
                                          cltr: pro.commissionPerList[index]
                                              .fromCltr,
                                          hintText: '',
                                          borderColor: Colors.black,
                                          borderRadius: 5,
                                          prefix: Text(
                                            "${pro.curSym}",
                                            style: TextStyle(
                                              fontSize: size.getS(16),
                                              color: Colors.black,
                                            ),
                                          ),
                                          vPad: 12,
                                          hPad: 16,
                                          errH: 0,
                                          textInputType: TextInputType.number,
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.getW(30),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.24,
                                        child: TextFormWidget(
                                          initValidate: true,
                                          cltr: pro
                                              .commissionPerList[index].toCltr,
                                          hintText: '',
                                          borderColor: Colors.black,
                                          borderRadius: 5,
                                          prefix: Text(
                                            "${pro.curSym}",
                                            style: TextStyle(
                                              fontSize: size.getS(16),
                                              color: Colors.black,
                                            ),
                                          ),
                                          vPad: 12,
                                          hPad: 16,
                                          errH: 0,
                                          textInputType: TextInputType.number,
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.getW(30),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.14,
                                        child: TextFormWidget(
                                          initValidate: true,
                                          cltr: pro.commissionPerList[index]
                                              .dataCltr,
                                          hintText: '',
                                          borderColor: Colors.black,
                                          borderRadius: 5,
                                          vPad: 12,
                                          hPad: 16,
                                          errH: 0,
                                          textInputType: TextInputType.number,
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.getW(48),
                                      ),
                                      Material(
                                        color: Colors.red.shade700,
                                        type: MaterialType.circle,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          onTap: () {
                                            pro.removeCommissionPer(index);
                                          },
                                          child: Icon(
                                            Icons.remove,
                                            size: size.getS(48),
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                              SizedBox(
                                height: size.getH(24),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IgnorePointer(
                                    ignoring: pro.loading,
                                    child: LoadButton(
                                        loading: pro.updateLoad,
                                        onsave: pro.updateLoad
                                            ? null
                                            : () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                if (pro
                                                    .commFormKey.currentState!
                                                    .validate()) {
                                                  pro.updateCommission();
                                                }
                                              }),
                                  ),
                                  SizedBox(
                                    width: size.getW(24),
                                  ),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red.shade800),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  horizontal: size.getW(48),
                                                  vertical: size.getH(8)))),
                                      onPressed: () {},
                                      child: Text(
                                        LN.cancel,
                                        style: TextStyle(
                                          fontSize: size.getS(16),
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.getH(12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
