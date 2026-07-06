import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/integration/integration_pro.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';

class ConnectSection extends StatefulWidget {
  final IntegrationPro intePro;
  final Ssize size;
  const ConnectSection({
    super.key,
    required this.intePro,
    required this.size,
  });

  @override
  State<ConnectSection> createState() => _ConnectSectionState();
}

class _ConnectSectionState extends State<ConnectSection> {
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
    return Processing(
      loading: widget.intePro.accountLoad,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TitleTextForm(
                title:
                    "${widget.intePro.selectedAccount?.name ?? ''} ${LN.clientId}",
                isReq: true,
                hintText: LN.enterClientId,
                textCltr: widget.intePro.cIdCltr,
                borderColor: Colors.black12,
                pWidth: 1,
              ),
              SizedBox(
                height: widget.size.getH(12),
              ),
              TitleTextForm(
                title:
                    "${widget.intePro.selectedAccount?.name ?? ''} ${LN.clientSecret}",
                isReq: true,
                hintText: LN.enClientSec,
                textCltr: widget.intePro.cSecretCltr,
                borderColor: Colors.black12,
                pWidth: 1,
              ),
              SizedBox(
                height: widget.size.getH(12),
              ),
              if (GlobalCVP.viewWidget.viewAddConnectXeroTabSaveButton)
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
    );
  }
}
