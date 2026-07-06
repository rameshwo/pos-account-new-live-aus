import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

class NotificationPopup extends StatelessWidget {
  final VoidCallback? onEnable;

  const NotificationPopup({
    super.key,
    this.onEnable,
  });

  static Future<void> show(BuildContext context,
      {VoidCallback? onEnable}) async {
    return await showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return SimpleDialog(
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            children: [
              NotificationPopup(
                onEnable: onEnable,
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      width: size.getW(500),
      padding: EdgeInsets.symmetric(
          horizontal: size.getS(28), vertical: size.getS(24)),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, size: size.getS(32)),
              // padding: EdgeInsets.zero,
              // constraints: const BoxConstraints(),
            ),
          ),

          // Bell icon
          Container(
            width: size.getS(64),
            height: size.getS(64),
            margin: EdgeInsets.only(bottom: size.getH(16)),
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications,
              size: size.getS(40),
              color: kSecondaryColor,
            ),
          ),

          // Title
          Text(
            'Enable Notifications',
            style: TextStyle(
              fontSize: size.getS(24),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: size.getH(8)),

          // Description
          Text(
            'Allow notifications to stay updated with important information.',
            style: TextStyle(
              fontSize: size.getS(16),
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: size.getH(32)),

          // Buttons
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: size.getH(48),
                child: ElevatedButton(
                  onPressed: onEnable,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSecondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Enable Notifications',
                    style: TextStyle(
                      fontSize: size.getS(16),
                      fontFamily: kFontFMedium,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.getH(12)),
              SizedBox(
                width: double.infinity,
                height: size.getH(48),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Maybe Later',
                    style: TextStyle(
                      fontSize: size.getS(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
