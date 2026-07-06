import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/providers/setting/pos_device/printer_setting_pro.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'kit_assign_product.dart';

const Color PRIMARY_COLOR = kSecondaryColor; // Color(0xFF10B981);

class KitchenDisplayConfiguration extends StatelessWidget {
  final PrinterSettingPro pro;
  const KitchenDisplayConfiguration({super.key, required this.pro});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: size.getW(12), vertical: size.getH(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.getW(24), vertical: size.getH(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(size),
            SizedBox(height: size.getH(12)),
            if (pro.addSec?.posDevices?.isNotEmpty ?? false)
              Expanded(
                child: ListView.separated(
                  itemCount: pro.addSec!.posDevices!.length,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      SizedBox(height: size.getH(12)),
                  itemBuilder: (context, index) {
                    return _buildDisplayCard(
                      size,
                      pro.addSec!.posDevices![index],
                      onAssign: () {
                        showDialog(
                            context: context,
                            builder: (builder) => SimpleDialog(
                                  backgroundColor: Colors.white,
                                  titlePadding: EdgeInsets.zero,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  children: [
                                    KitAssignProduct(
                                      printerAddSec: pro.addSec,
                                      index: index,
                                    )
                                  ],
                                ));
                      },
                    );
                  },
                ),
              )
            else if (!pro.loading)
              Center(
                child: NoItemsSec(
                  size: size,
                  title: "No POS Device Setup",
                  iconHeight: 150,
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Ssize size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.monitor,
                    size: size.getS(24),
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: size.getW(12)),
                  Text(
                    'Kitchen Display Configuration',
                    style: TextStyle(
                      fontSize: size.getS(20),
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.getH(8)),
              Text(
                'Configure what each kitchen display should print. Enable or disable',
                style: TextStyle(
                  fontSize: size.getS(16),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        // LoadButton(
        //   btnText: "Save Configuration",
        //   width: 240,
        //   hPad: 4,
        //   // loading: pro.updateLoad,
        //   onsave: () {
        //     // pro.addUpdatePrinter();
        //   },
        // ),
      ],
    );
  }

  Widget _buildDisplayCard(
    Ssize size,
    TableLocation display, {
    Function()? onAssign,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.getS(16)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.getS(48),
              height: size.getS(48),
              decoration: BoxDecoration(
                color: PRIMARY_COLOR.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.monitor,
                size: size.getS(28),
                color: PRIMARY_COLOR,
              ),
            ),
            SizedBox(width: size.getW(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    display.name ?? '',
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                  ),
                  SizedBox(height: size.getH(8)),
                  Text(
                    'Product Assignment',
                    style: TextStyle(
                      fontSize: size.getS(16),
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[900],
                    ),
                  ),
                  SizedBox(height: size.getH(4)),
                  Text(
                    'Specify which products should print to this printer. Useful for kitchen printers or specialized product categories.',
                    style: TextStyle(
                      fontSize: size.getS(14),
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: size.getH(12)),
                  OutlinedButton.icon(
                    onPressed: onAssign,
                    icon: Icon(Icons.add, size: size.getS(16)),
                    label: Text(
                      'Assign Products',
                      style: TextStyle(fontSize: size.getS(16)),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(16), vertical: size.getH(8)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
