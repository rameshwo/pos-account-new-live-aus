import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/integration/integration_pro.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';

import '../../../setting_tab/com/general/common/common_header.dart';

class UberDeliSet extends StatefulWidget {
  final Function() onBack;
  final IntegrationPro intePro;
  const UberDeliSet({
    super.key,
    required this.onBack,
    required this.intePro,
  });

  @override
  State<UberDeliSet> createState() => _UberDeliSetState();
}

class _UberDeliSetState extends State<UberDeliSet> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    Future.delayed(Duration(milliseconds: 300), () {
      widget.intePro.getAcPlatIntegConn();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Processing(
      loading: widget.intePro.accountLoad,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CommonHeader(
              child: Row(
                children: [
                  IconButton(
                      onPressed: widget.onBack,
                      icon: Icon(Icons.arrow_back, size: size.getS(24))),
                  SizedBox(width: size.getW(8)),
                  Text(
                    widget.intePro.selectedAccount?.name ?? '',
                    style: TextStyle(
                      fontSize: size.getS(18),
                      // fontFamily: ,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.getH(8)),
            SizedBox(
              height: size.getH(740),
              child: Card(
                margin: EdgeInsets.symmetric(
                    horizontal: size.getW(12), vertical: size.getH(0)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.getW(24), vertical: size.getH(12)),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.getH(12),
                          ),
                          TitleTextForm(
                            title: "Uber Customer ID",
                            isReq: true,
                            hintText: LN.enterClientId,
                            textCltr: widget.intePro.cusIdCltr,
                            borderColor: Colors.black12,
                            pWidth: 1,
                          ),
                          SizedBox(
                            height: size.getH(12),
                          ),
                          TitleTextForm(
                            title: "Uber ${LN.clientId}",
                            isReq: true,
                            hintText: LN.enterClientId,
                            textCltr: widget.intePro.cIdCltr,
                            borderColor: Colors.black12,
                            pWidth: 1,
                          ),
                          SizedBox(
                            height: size.getH(12),
                          ),
                          TitleTextForm(
                            title: "Uber ${LN.clientSecret}",
                            isReq: true,
                            hintText: LN.enClientSec,
                            textCltr: widget.intePro.cSecretCltr,
                            borderColor: Colors.black12,
                            pWidth: 1,
                          ),
                          SizedBox(
                            height: size.getH(24),
                          ),
                          LoadButton(
                            btnText: LN.save,
                            btnColor: kUserColor,
                            loading: widget.intePro.updateLoad,
                            onsave: () {
                              if (formKey.currentState!.validate())
                                widget.intePro.updateConnect();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
