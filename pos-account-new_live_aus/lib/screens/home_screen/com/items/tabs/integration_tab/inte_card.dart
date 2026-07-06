import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/integration/acc_integ_add_sec.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';

class IntegrationCard extends StatelessWidget {
  const IntegrationCard({
    super.key,
    required this.size,
    this.title,
    this.onTap,
  });

  final Ssize size;
  final AccountingPlatForm? title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: size.getW(Platform.isIOS ? 600 : 700),
        height: size.getH(170),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.getH(12.0), horizontal: size.getW(4)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: NetworkImageSec(
                image: title?.image,
                height: 80,
                boxFit: BoxFit.contain,
              )),
              SizedBox(
                width: size.getW(16),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title?.name ?? '',
                      style: TextStyle(
                        fontSize: size.getS(24),
                        fontFamily: kFontFMedium,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.getH(4)),
                      child: Text(
                        title?.description ?? '',
                        style: TextStyle(
                          fontSize: size.getS(16),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.getH(12),
                    ),
                    if (GlobalCVP.viewWidget.viewXeroGetStartedButton)
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(kUserColor),
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                              padding: WidgetStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: size.getW(24),
                                      vertical: size.getH(8)))),
                          onPressed: onTap,
                          child: Text(
                            LN.getStarted,
                            style: TextStyle(
                              fontSize: size.getS(16),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                  ],
                ),
              ),
              SizedBox(
                width: size.getW(12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
