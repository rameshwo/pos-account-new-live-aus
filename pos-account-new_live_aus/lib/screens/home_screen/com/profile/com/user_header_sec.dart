import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/profile/profile_pro.dart';
import 'package:pos_account/widgets/image/profile_img_sec.dart';

class UserHeaderSec extends StatelessWidget {
  final ProfilePro pro;
  const UserHeaderSec({super.key, required this.pro});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.getH(16)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.getW(24),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.getW(48)),
              child: ProfileImageSec(
                size: size,
                pickImage: () => pro.getFilePick(),
                filePath: pro.getFilePath,
                radius: 130,
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.getH(24),
                  ),
                  Text(
                    pro.userInfo?.name ?? '',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontFamily: kFontFMedium,
                      fontSize: size.getS(24),
                    ),
                  ),
                  Text(
                    LN.profileAccReadyText,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: size.getS(18),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: size.getW(100),
            ),
          ],
        ),
      ),
    );
  }
}
