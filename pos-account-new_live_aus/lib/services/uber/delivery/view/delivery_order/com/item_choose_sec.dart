import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/services/uber/delivery/provider/delivery_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';

class ItemChooseSec extends StatelessWidget {
  const ItemChooseSec({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final deliPro = Provider.of<DeliveryPro>(context);
    final selectedBox =
        deliPro.boxList.firstWhere((e) => e.id == deliPro.boxId);
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(
          horizontal: size.getW(24), vertical: size.getH(12)),
      children: [
        Row(
          children: [
            Text(
              LN.chooseItems,
              style: TextStyle(
                fontSize: size.getS(22),
                fontFamily: kFontFMedium,
              ),
            ),
            Spacer(),
            IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close))
          ],
        ),
        SizedBox(height: size.getH(12)),
        Wrap(
          spacing: size.getW(24),
          runSpacing: size.getH(16),
          children: [
            ...List.generate(deliPro.orderItemList.length, (index) {
              final isSelected = deliPro.orderItemList[index].isSelected;
              final unSelected = deliPro.boxList.any((a) => a.itemList
                      .any((b) => b.id == deliPro.orderItemList[index].id)) &&
                  !selectedBox.itemList
                      .any((c) => c.id == deliPro.orderItemList[index].id);
              return InkWell(
                onTap: unSelected
                    ? null
                    : () {
                        deliPro.orderItemList[index].isSelected =
                            !deliPro.orderItemList[index].isSelected;
                        deliPro.notify;
                      },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                      color: unSelected
                          ? Colors.grey.shade100
                          : isSelected
                              ? kSecondaryColor.withAlpha(40)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: unSelected
                              ? Colors.grey.shade300
                              : isSelected
                                  ? kSecondaryColor.withAlpha(60)
                                  : Colors.grey.shade600)),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getW(24), vertical: size.getH(8)),
                  child: Text(
                    deliPro.orderItemList[index].title ?? '',
                    style: TextStyle(
                      fontSize: size.getS(18),
                      color: unSelected
                          ? Colors.grey.shade400
                          : isSelected
                              ? Colors.teal.shade600
                              : Colors.black,
                    ),
                  ),
                ),
              );
            })
          ],
        ),
        SizedBox(height: size.getH(24)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LoadButton(
              btnText: LN.clear,
              btnColor: Colors.red.shade700,
              onsave: () {
                deliPro.orderItemList.forEach((e) {
                  e.isSelected = false;
                });
                deliPro.notify;
              },
            ),
            SizedBox(width: size.getW(24)),
            LoadButton(
              btnText: LN.save,
              onsave: () {
                selectedBox.itemList.clear();
                if (deliPro.orderItemList.any((e) => e.isSelected)) {
                  final allSelected =
                      deliPro.orderItemList.where((e) => e.isSelected).toList();

                  selectedBox.itemList.addAll(allSelected);

                  selectedBox.quantity = "1";

                  selectedBox.price = allSelected
                      .fold<double>(
                          0, (pV, e) => pV + (e.totalPrice?.inDouble ?? 0))
                      .roundToNString();

                  final _taxValue = allSelected.fold<double>(
                      0, (pV, e) => pV + (e.taxValue?.inDouble ?? 0));

                  final _qty = allSelected.fold<double>(
                      0, (pV, e) => pV + (e.quantity?.inDouble ?? 0));

                  selectedBox.taxValue = (_taxValue / _qty).roundToNString();
                }
                deliPro.notify;
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }
}
