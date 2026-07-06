import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import '../../show_status.dart';
import 'status_switch.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.title,
    required this.status,
    required this.description,
    required this.dateTime,
    required this.readStatus,
    this.onChanged,
    this.onTap,
  });

  final String title;
  final String status;
  final String description;
  final String dateTime;
  final bool readStatus;
  final Function(bool)? onChanged;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: size.getH(10),
      ),
      child: Card(
          elevation: 4,
          color: Colors.white,
          shadowColor: Colors.grey[200],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onTap: onTap,
            contentPadding: EdgeInsets.symmetric(
                vertical: size.getH(20), horizontal: size.getW(20)),
            leading: CircleAvatar(
              radius: size.getS(24),
              child: Icon(
                Icons.notifications_active,
                size: size.getS(32),
              ),
            ),
            title: _title(
              size: size,
              title: title,
              status: status,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: TextStyle(
                    fontSize: size.getS(16),
                    fontFamily: kFontFRegular,
                  ),
                ),
                Text(
                  dateTime,
                  style: TextStyle(
                    fontSize: size.getS(16),
                    fontFamily: kFontFRegular,
                  ),
                ),
              ],
            ),
            trailing: SizedBox(
              // color: Colors.blue,
              width: 160,
              child: StatusSwitch(
                status: readStatus,
                title: 'Mark As Read',
                onChanged: onChanged,
              ),
            ),
          )),
    );
  }

  Widget _title({
    required Ssize size,
    required String title,
    required String status,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.getH(10)),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: size.getS(18),
              fontFamily: kFontFMedium,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: size.getW(12),
          ),
          if (status.isNotEmpty)
            ShowStatus(
              title: status,
              size: size,
            )
          // Cont
        ],
      ),
    );
  }
}
