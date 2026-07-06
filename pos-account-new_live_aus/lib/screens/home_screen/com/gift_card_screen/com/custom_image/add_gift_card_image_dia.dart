import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/gift_card/gift_card_image_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/add_new_sec_w_image.dart';
import 'package:pos_account/services/image/image_service.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

class AddGiftCardImageDia extends StatefulWidget {
  final Function() callBack;

  const AddGiftCardImageDia({
    super.key,
    required this.callBack,
  });

  @override
  State<AddGiftCardImageDia> createState() => _AddGiftCardImageDiaState();
}

class _AddGiftCardImageDiaState extends State<AddGiftCardImageDia> {
  final _formKey = GlobalKey<FormState>();

  GiftCardImagePro? _giftCardImagePro;
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    _giftCardImagePro = Provider.of<GiftCardImagePro>(context, listen: false);
  }

  @override
  void dispose() {
    _giftCardImagePro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final pro = Provider.of<GiftCardImagePro>(context);
    return Processing(
      loading: pro.giftCardImageAddSec == null,
      child: SizedBox(
        height: size.height / 1.6,
        width: size.width / 1.2,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.getH(24), horizontal: size.getW(12)),
            child: AddNewSectionWImage(
              callBack: widget.callBack,
              tableTitle: LN.giftCardImg,
              tableList: pro.tableData,
              getStatus: pro.activeStatus,
              setStatus: (p0) {
                pro.activeStatus = p0;
                pro.notify;
              },
              imageUrl: pro.customGiftCardImagePath,
              uploadImage: () {
                if (pro.customGiftCardImagePath != null &&
                    pro.customGiftCardImagePath!.isNotEmpty) {
                  pro.customGiftCardImagePath = null;
                  pro.notify;
                } else
                  ImageService.filePick().then((value) {
                    pro.customGiftCardImagePath = value;
                    pro.notify;
                  });
              },
              onAdd: pro.isSaving
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        await pro
                            .addUpdate()
                            .then((value) => widget.callBack());
                      }
                    },
              isNew: pro.editId.isEmpty,
              onCancel: () {
                pro.clear();
                pro.notify;
              },
              newWidget: SizedBox(
                width: size.getW(300),
                child: TitleDropDown(
                  isReq: true,
                  borderColor: Colors.black54,
                  // hintText: LN.template,
                  hintText: "Template Group",
                  // pWidth: 0.21,
                  // title: LN.template,
                  title: "Template Group",
                  list: pro.giftCardImageAddSec?.giftCardTemplates == null
                      ? []
                      : pro.giftCardImageAddSec!.giftCardTemplates!
                          .map((e) => e.value ?? "")
                          .toList(),
                  indexVal: pro.templateIndex,
                  onChanged: (p0) {
                    pro.templateIndex = p0;
                    pro.notify;
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
