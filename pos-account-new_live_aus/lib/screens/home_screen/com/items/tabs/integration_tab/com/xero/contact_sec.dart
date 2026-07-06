import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/integration/integration_pro.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';

class ContactSection extends StatefulWidget {
  final IntegrationPro intePro;

  final Ssize size;
  const ContactSection({super.key, required this.intePro, required this.size});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    Future.delayed(Duration(milliseconds: 300), () {
      widget.intePro.getAccContactSetting();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Processing(
      loading: widget.intePro.contactLoad,
      align: Alignment.topLeft,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TitleTextForm(
                title: LN.name,
                isReq: true,
                hintText: "",
                textCltr: TextEditingController(
                    text: widget.intePro.accContactSetting?.name ?? ''),
                borderColor: Colors.black12,
                pWidth: 0.33,
                onChanged: (p0) {
                  widget.intePro.accContactSetting?.name = p0;
                },
              ),
              SizedBox(
                height: widget.size.getH(12),
              ),
              LoadButton(
                btnText: LN.save,
                btnColor: kUserColor,
                loading: widget.intePro.contactBtnLoad,
                onsave: () {
                  if (formKey.currentState!.validate()) {
                    widget.intePro.createUpAccContactSetting();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
