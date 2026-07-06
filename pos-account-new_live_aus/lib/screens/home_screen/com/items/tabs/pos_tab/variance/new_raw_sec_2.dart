import 'package:flutter/material.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:provider/provider.dart';

import '../../../../../../../config/size_config.dart';
import '../../../../../../../constant/constant.dart';
import '../../../../../../../model/home/menu/place_order/pos_res/com/feature_product.dart';
import '../../../../../../../widgets/load_btn.dart';

class RawIngreSec2 extends StatefulWidget {
  final String title;
  final List<ModifierItem>? modifierItems;
  final Function() onUpdate;
  final Function()? onSave;
  const RawIngreSec2(
      {super.key,
      required this.title,
      this.modifierItems,
      required this.onUpdate,
      this.onSave});

  @override
  State<RawIngreSec2> createState() => _RawIngreSec2State();
}

class _RawIngreSec2State extends State<RawIngreSec2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _placePro = Provider.of<PlaceOrderPro>(context);
    final size = Ssize(context);
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: size.getS(18),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.black45,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children:
                              List.generate(widget.modifierItems!.length, (j) {
                            final _isActive =
                                widget.modifierItems![j].isActive ?? false;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    widget.modifierItems![j].isActive =
                                        !_isActive;
                                    widget.onUpdate();
                                    _placePro.notify;
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.getW(16),
                                        vertical: size.getH(12)),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          Text(
                                            widget.modifierItems![j]
                                                    .productName ??
                                                '',
                                            style: TextStyle(
                                              fontSize: size.getS(18),
                                              color: _isActive
                                                  ? Colors.black45
                                                  : Colors.black,
                                              fontFamily: kFontFMedium,
                                              fontStyle: _isActive
                                                  ? FontStyle.italic
                                                  : null,
                                              decoration: _isActive
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          if (_isActive)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: size.getW(12)),
                                              child: Text(
                                                'x',
                                                style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                  fontSize: size.getW(18),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (widget.modifierItems!.length - 1 != j)
                                  const Divider(
                                    color: Colors.black26,
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.getH(12),
          ),
          Padding(
            padding: EdgeInsets.all(size.getS(8)),
            child: LoadButton(
                width: double.infinity,
                btnText: "Confirm",
                fontSize: 16,
                // vPad: 20,
                onsave: widget.onSave ??
                    () {
                      Navigator.pop(context);
                    }),
          ),
        ],
      ),
    );
  }
}
