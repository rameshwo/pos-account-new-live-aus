import 'package:flutter/material.dart';
import 'package:pos_account/providers/product/manage_prod_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../config/size_config.dart';
import '../../../../../../../../constant/constant.dart';
import '../../../../../../../../widgets/title_pop.dart';
import '../../../setting_tab/com/general/common/common_header.dart';
import 'com/menu_body.dart';

class ManageMenuScreen extends StatelessWidget {
  final Function() onBack;
  const ManageMenuScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final manageProdPro = Provider.of<ManageProdPro>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonHeader(
          child: Row(
            children: [
              Expanded(
                child: TitlePop(
                  title: "Manage Menu",
                  size: size,
                  onTap: onBack,
                ),
              ),
              LoadButton(
                btnText: "Save Menu",
                vPad: 6,
                loading: manageProdPro.updateButtonLoad,
                loadingText: "Updating",
                btnColor: manageProdPro.sortedDataList
                        .any((a) => a.isCatSorted || a.isProdSorted)
                    ? kSecondaryColor
                    : Colors.grey.shade400,
                onsave: () {
                  manageProdPro.updateOrder();
                },
              )
            ],
          ),
        ),
        // SizedBox(
        //   height: size.getH(6),
        // ),
        Container(
          margin: EdgeInsets.all(size.getS(4)),
          padding: EdgeInsets.all(size.getS(16)),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7F6), // light gray background
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon circle
              Container(
                padding: EdgeInsets.all(size.getS(8)),
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F4F1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  color: Color(0xFF2BAE9E),
                  size: size.getS(22),
                ),
              ),

              SizedBox(width: size.getW(12)),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Organize Your Menu Layout",
                      style: TextStyle(
                        fontSize: size.getS(16),
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: size.getH(4)),
                    Text(
                      "Drag and drop categories and products to control how they appear in your POS. Create a structured and efficient menu layout for faster operations.",
                      style: TextStyle(
                        fontSize: size.getS(14),
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Flexible(child: MenuBody()),
      ],
    );
  }
}
