import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';

class ServiceTypeSec extends StatelessWidget {
  final Function()? remove;
  final Animation<double> animation;
  final ServiceType? serviceType;
  const ServiceTypeSec({
    super.key,
    this.remove,
    required this.animation,
    this.serviceType,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.getH(0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.getH(4),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormWidget(
                    isDense: true,
                    // vPad: 6,
                    errH: 0,
                    // validator: (val) {
                    //   if (batch?.batchNoCltr.text.isNotEmpty ?? false) {
                    //     if (val == null || val.isEmpty) {
                    //       return "Stock Count is required";
                    //     }
                    //   }
                    //   return null;
                    // },
                    isReq: false,
                    borderColor: Colors.black54,
                    borderRadius: 5,
                    cltr: serviceType == null
                        ? TextEditingController()
                        : serviceType!.typeCltr,
                    hintText: "Service Type",
                    hintStyle: TextStyle(color: Colors.black45),
                  ),
                ),
                SizedBox(
                  width: size.getW(18),
                ),
                Card(
                  elevation: 4,
                  margin: EdgeInsets.zero,
                  shadowColor: Colors.grey[200],
                  color: kIconBackColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: InkWell(
                    onTap: remove,
                    child: Padding(
                      padding: EdgeInsets.all(size.getW(6.0)),
                      child: SvgPicture.asset(
                        "assets/svg/icons/Delete.svg",
                        width: size.getW(17),
                        height: size.getW(18),
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 2, child: Container()),
                SizedBox(
                  width: size.getW(18 * 2),
                ),
              ],
            ),
            Divider(
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
