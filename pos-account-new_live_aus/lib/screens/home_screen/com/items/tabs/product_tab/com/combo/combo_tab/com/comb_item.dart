import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/product/combo/combo_pack_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';

enum ActionEnum { Edit, Delete, PriceUpdate }

class ComboItemSection extends StatelessWidget {
  const ComboItemSection({
    super.key,
    required this.combo,
    required this.size,
    required this.action,
  });

  final ComboPackData combo;
  final Ssize size;
  final Function(ActionEnum) action;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              color: Colors.grey.shade100,
              child: NetworkImageSec(
                image: combo.image,
                height: 124,
                width: 284,
                boxFit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: size.getH(4)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.getW(8)),
              child: Text(
                combo.name ?? '',
                style: TextStyle(
                  fontSize: size.getS(18),
                  color: Colors.black,
                  fontFamily: kFontFMedium,
                ),
                // textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: size.getH(4)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.getW(8)),
            child: Row(
              children: [
                if (combo.status ?? false)
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(1),
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(8), vertical: size.getH(4)),
                      child: Text(
                        LN.active,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: size.getS(14)),
                      ))
                else
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(8), vertical: size.getH(4)),
                      child: Text(
                        LN.inActive,
                        style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: size.getS(14)),
                      )),
                Spacer(),
                InkWell(
                  onTap: () => action(ActionEnum.Edit),
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(size.getS(6)),
                    child: Icon(
                      Icons.edit_note_rounded,
                      size: size.getS(28),
                      color: kSecondaryColor,
                    ),
                  ),
                ),
                SizedBox(width: size.getW(12)),
                InkWell(
                  onTap: () => action(ActionEnum.Delete),
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(size.getS(6)),
                    child: Icon(
                      Icons.delete_outline,
                      size: size.getS(28),
                      color: Colors.red.shade800,
                    ),
                  ),
                ),
                SizedBox(width: size.getW(12)),
                InkWell(
                  onTap: () => action(ActionEnum.PriceUpdate),
                  borderRadius: BorderRadius.circular(200),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.getW(12), vertical: size.getH(4)),
                    child: Text(
                      GlobalCVP.storeInfo?.currencySymbol ?? "\$",
                      style: TextStyle(
                        fontSize: size.getS(20),
                        color: kSecondaryColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: size.getH(8)),
        ],
      ),
    );
  }
}
