import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/integration/integration_pro.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';

class AcMappingSecion extends StatefulWidget {
  final Ssize size;
  final IntegrationPro intePro;
  // final ScrollController parentScrollCltr;
  const AcMappingSecion({
    super.key,
    required this.size,
    required this.intePro,
    // required this.parentScrollCltr,
  });

  @override
  State<AcMappingSecion> createState() => _AcMappingSecionState();
}

class _AcMappingSecionState extends State<AcMappingSecion> {
  final _formKey = GlobalKey<FormState>();

  // final _childScrollCltr = ScrollController();
  // ScrollPhysics _physics = ScrollPhysics();

  @override
  void initState() {
    super.initState();
    getData();
    // _childScrollCltr.addListener(childScrollListener);
    // widget.parentScrollCltr.addListener(mainScrollListener);
  }

  getData() {
    Future.delayed(Duration(milliseconds: 300), () {
      widget.intePro.getChartOfAccInte();
    });
  }

  // void mainScrollListener() {
  //   if (!widget.parentScrollCltr.hasClients ||
  //       widget.parentScrollCltr.position.outOfRange) return;

  //   if (!_childScrollCltr.hasClients || _childScrollCltr.position.outOfRange)
  //     return;

  //   if ((widget.parentScrollCltr.offset <=
  //               widget.parentScrollCltr.position.minScrollExtent &&
  //           _childScrollCltr.offset <=
  //               _childScrollCltr.position.minScrollExtent) ||
  //       (widget.parentScrollCltr.offset >=
  //               widget.parentScrollCltr.position.maxScrollExtent &&
  //           _childScrollCltr.offset >=
  //               _childScrollCltr.position.maxScrollExtent)) {
  //     _physics = ScrollPhysics();
  //     load();
  //   }
  // }

  // void childScrollListener() {
  //   if (widget.parentScrollCltr.offset <=
  //           widget.parentScrollCltr.position.minScrollExtent &&
  //       widget.parentScrollCltr.offset >=
  //           widget.parentScrollCltr.position.maxScrollExtent) return;

  //   if (!_childScrollCltr.hasClients || _childScrollCltr.position.outOfRange)
  //     return;

  //   if (_childScrollCltr.offset >= _childScrollCltr.position.maxScrollExtent ||
  //       _childScrollCltr.offset <= _childScrollCltr.position.minScrollExtent) {
  //     _physics = NeverScrollableScrollPhysics();
  //     load();
  //   }
  // }

  void load() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Processing(
      loading: widget.intePro.chartLoad,
      align: Alignment.topLeft,
      child: SizedBox(
        width: double.infinity,
        child: widget.intePro.charAccMapping == null
            ? SizedBox.shrink()
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: widget.size.getW(400),
                            child: Text(
                              LN.name,
                              style: TextStyle(
                                fontSize: widget.size.getS(18),
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: widget.size.getW(48),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: widget.size.getW(400),
                            child: Text(
                              LN.code,
                              style: TextStyle(
                                fontSize: widget.size.getS(18),
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: widget.size.getH(12),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        // controller: _childScrollCltr,
                        // physics: _physics,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...List.generate(
                                widget.intePro.charAccMapping!.length,
                                (index) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: SizedBox(
                                            width: widget.size.getW(400),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: widget.size.getH(12)),
                                              child: TextFormWidget(
                                                cltr: TextEditingController(
                                                    text: widget
                                                        .intePro
                                                        .charAccMapping![index]
                                                        .name),
                                                hintText: "",
                                                readOnly: true,
                                                isReq: false,
                                                borderColor: Colors.black38,
                                                borderRadius: 8,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: widget.size.getW(48),
                                        ),
                                        Flexible(
                                          child: SizedBox(
                                            width: widget.size.getW(400),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: widget.size.getH(12)),
                                              child: TextFormWidget(
                                                cltr: widget
                                                    .intePro
                                                    .charAccMapping![index]
                                                    .codes,
                                                hintText: "",
                                                isReq: true,
                                                borderColor: Colors.black38,
                                                borderRadius: 8,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                            SizedBox(
                              height: widget.size.getH(12),
                            ),
                            if (GlobalCVP
                                .viewWidget.viewChartOfAccountSaveButton)
                              LoadButton(
                                btnText: LN.save,
                                btnColor: kUserColor,
                                loading: widget.intePro.updateLoad,
                                onsave: () {
                                  if (_formKey.currentState!.validate())
                                    widget.intePro.updateAccMapping();
                                },
                              ),
                            SizedBox(
                              height: widget.size.getH(16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
