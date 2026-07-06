import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/services/uber/delivery/model/track/deli_track_list.dart';
import 'vertical_stepper.dart';

class DeliverySecTile extends StatelessWidget {
  final DeliTrackData? trackData;
  final Function()? onTap;
  const DeliverySecTile({super.key, this.trackData, this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final orNum = (trackData?.orderNumber?.contains('-') ?? false)
        ? trackData?.orderNumber?.split('-').last
        : '';
    return Container(
      width: size.getW(384),
      height: size.getH(420),
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(8), vertical: size.getH(12)),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(size.getS(8)),
                child: Image.asset(
                  "assets/png/box.png",
                  height: size.getS(40),
                  width: size.getS(40),
                ),
              ),
              SizedBox(width: size.getW(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LN.orderNumber,
                      style: TextStyle(
                        fontSize: size.getS(16),
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      orNum ?? '',
                      style: TextStyle(
                        fontSize: size.getS(18),
                        color: Colors.black,
                        fontFamily: kFontFMedium,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: size.getH(12)),
          _deliSecTile(
            size,
            title: LN.status,
            value: trackData?.trackingStatus ?? '',
            isStatus: true,
            valueColor: Colors.green.shade700,
          ),
          SizedBox(height: size.getH(12)),
          _deliSecTile(
            size,
            title: LN.deliveryAdd,
            value: trackData?.deliveryLocation ?? '',
          ),
          SizedBox(height: size.getH(12)),
          _deliSecTile(
            size,
            title: LN.pickUpTime,
            value: trackData?.pickUpTime ?? '',
          ),
          // Text(
          //   "Status",
          //   style: TextStyle(
          //     fontSize: size.getS(18),
          //     color: Colors.grey.shade600,
          //     fontFamily: kFontFMedium,
          //   ),
          // ),
          SizedBox(height: size.getH(12)),

          Expanded(
            child: (trackData?.orderDeliveryTrackingList?.isNotEmpty ?? false)
                ? SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: size.getS(8)),
                      child: VerticalStepper(
                          dotGap: 60,
                          inActiveColor: kTempColor,
                          activeColor: kTempColor,
                          // reverse: true,
                          steps: List.generate(
                              trackData!.orderDeliveryTrackingList!.length,
                              (index) {
                            final data =
                                trackData!.orderDeliveryTrackingList![index];
                            final isLastIndex =
                                trackData!.orderDeliveryTrackingList!.length -
                                        1 ==
                                    index;
                            return StepTile(
                              title: Text(
                                data.trackingStatusDescription ?? '',
                                style: TextStyle(
                                  fontSize: size.getS(15),
                                  fontFamily: kFontFRegular,
                                ),
                                maxLines: 2,
                              ),
                              iconBackColor:
                                  isLastIndex ? kTempColor : Colors.grey,
                              isActive: isLastIndex,
                            );
                          })),
                    ),
                  )
                : SizedBox(),
          ),
          SizedBox(height: size.getH(12)),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(kPrimaryColor),
            ),
            onPressed: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LN.viewDetails,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: kFontFMedium,
                      fontSize: size.getS(16)),
                ),
                SizedBox(width: size.getW(12)),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: size.getS(16),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Row _deliSecTile(
    Ssize size, {
    required String title,
    required String value,
    bool isStatus = false,
    Color valueColor = Colors.black,
    Widget? button,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: size.getS(18),
            color: Colors.grey.shade700,
            fontFamily: kFontFMedium,
          ),
        ),
        SizedBox(width: size.getW(12)),
        Expanded(
            child: Align(
          alignment: Alignment.centerRight,
          child: button ??
              (isStatus
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(12), vertical: size.getH(4)),
                      decoration: BoxDecoration(
                        color: valueColor.withAlpha(50),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: size.getS(16),
                          color: valueColor,
                          fontFamily: kFontFMedium,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    )
                  : Text(
                      value,
                      style: TextStyle(
                        fontSize: size.getS(16),
                        color: valueColor,
                        fontFamily: kFontFMedium,
                      ),
                      textAlign: TextAlign.right,
                    )),
        )),
      ],
    );
  }
}
