import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/payment/cus_loyal_res.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';
import 'package:pos_account/providers/booking/table_resv_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/floor_tab/booking_tab/booking_tab.dart';
import 'package:pos_account/services/phone_service/phone_service.dart';
import 'package:provider/provider.dart';

class PhoneDiaSection extends StatelessWidget {
  final Function()? onPop;
  final CusForLoyalityRes? cusData;
  const PhoneDiaSection({
    super.key,
    this.onPop,
    this.cusData,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      width: size.getW(900),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.getH(12)),
            child: Icon(
              Icons.call,
              size: size.getS(24),
              color: kSecondaryColor,
            ),
          ),
          SizedBox(
            width: size.getW(12),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LN.recentIncomingCall,
                style: TextStyle(
                  fontSize: size.getS(15),
                  fontFamily: kFontFMedium,
                  fontWeight: FontWeight.bold,
                  color: kSecondaryColor,
                ),
              ),
              Text.rich(
                TextSpan(
                    text: cusData?.customerName ?? '',
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontFamily: kFontFMedium,
                    ),
                    children: [
                      TextSpan(
                        text: " • ${cusData?.phoneNumber ?? ''}",
                        style: TextStyle(
                          fontSize: size.getS(17),
                          fontFamily: kFontFMedium,
                        ),
                      ),
                      // TextSpan(
                      //   text: " • 4 visits",
                      //   style: TextStyle(
                      //     fontSize: size.getS(15),
                      //     fontFamily: kFontFRegular,
                      //   ),
                      // ),
                    ]),
              ),
              // SizedBox(
              //   height: size.getH(8),
              // ),
              // Container(
              //   padding: EdgeInsets.symmetric(
              //       horizontal: size.getW(12), vertical: size.getH(4)),
              //   decoration: BoxDecoration(
              //     border: Border.all(),
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   child: Text(
              //     "Regular Customer",
              //     style: TextStyle(
              //       fontSize: size.getS(13),
              //       fontFamily: kFontFRegular,
              //     ),
              //   ),
              // )
            ],
          ),
          Spacer(),
          // SizedBox(
          //   width: size.getW(240),
          // ),
          TextButton(
              onPressed: () async {
                if (onPop != null) await onPop!();
                final _tableLayPro =
                    Provider.of<TableResvPro>(context, listen: false);
                _tableLayPro.getData().then((_) {
                  _tableLayPro.setCustomerData(
                      OrderUtils.convertCusForLoyaltyResToCusData(cusData));
                });
                if (CUS_CTX != null)
                  BookingTab.showBookingDia(
                    CUS_CTX!,
                    size: size,
                    scafKey: PhoneService.scaffoldKey,
                    dialogFrom: DialogFrom.PosPage,
                  );
              },
              style: ButtonStyle(
                side: WidgetStateProperty.all(BorderSide(
                  color: kSecondaryColor,
                )),
                // visualDensity: VisualDensity.compact,
              ),
              child: Text(
                LN.createReservation,
                style: TextStyle(
                  fontSize: size.getS(15),
                  fontFamily: kFontFMedium,
                  color: kSecondaryColor,
                ),
              )),
          SizedBox(
            width: size.getW(12),
          ),
          TextButton(
              onPressed: onPop,
              style: ButtonStyle(
                  // visualDensity: VisualDensity.compact,
                  ),
              child: Text(
                LN.dismiss,
                style: TextStyle(
                  fontSize: size.getS(14),
                  fontFamily: kFontFMedium,
                  color: Colors.black54,
                ),
              ))
        ],
      ),
    );
  }
}
