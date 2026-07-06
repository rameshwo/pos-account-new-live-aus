import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/gift_card/gift_card_template_group_pro.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

import '../../../items/tabs/setting_tab/com/general/common/add_new_sec_without_image.dart';

class AddGiftCardTemplateGroupDia extends StatefulWidget {
  const AddGiftCardTemplateGroupDia({super.key});

  @override
  State<AddGiftCardTemplateGroupDia> createState() =>
      _AddGiftCardImageDiaState();
}

class _AddGiftCardImageDiaState extends State<AddGiftCardTemplateGroupDia> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final pro = Provider.of<GiftCardTemplatePro>(context);
    return Processing(
      loading: false,
      child: SizedBox(
        height: size.height / 1.6,
        width: size.width / 1.2,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.getH(24), horizontal: size.getW(12)),
            child: AddNewSectionWithoutImage(
              tableTitle: LN.giftCardTemplateGroup,
              tableList: pro.tableData,
              getStatus: pro.activeStatus,
              setStatus: (p0) {
                pro.activeStatus = p0;
                pro.notify;
              },
              onAdd: pro.isSaving
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        await pro.addUpdate();
                      }
                    },
              isNew: pro.editId.isEmpty,
              onCancel: () {
                pro.clear();
                pro.notify;
              },
            ),
          ),
        ),
      ),
    );
  }
}
