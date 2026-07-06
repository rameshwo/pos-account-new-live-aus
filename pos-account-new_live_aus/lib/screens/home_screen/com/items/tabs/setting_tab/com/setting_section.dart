import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import '../../../../../../../config/size_config.dart';
import '../../../../../../../constant/constant.dart';
import '../../../../../../../widgets/title_pop.dart';
import 'general/common/common_header.dart';

class SettingSection extends StatelessWidget {
  final Function(int) onTap;
  final List<SettingCardWidget> cardList;
  const SettingSection(
      {super.key, required this.onTap, required this.cardList});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonHeader(
            child: TitlePop(
              title: LN.settings,
              size: size,
              onTap: () {
                GlobalCVP.setMainPage = MainPage.ManagePage;
              },
            ),
          ),
          SizedBox(
            height: size.getH(8),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
            child: Wrap(
              spacing: size.getW(12),
              runSpacing: size.getH(12),
              children: List.generate(
                cardList.length,
                (index) => SettingCard(
                  title: cardList[index].title,
                  asset: cardList[index].asset,
                  subTitle: cardList[index].subTitle,
                  onTap: () => onTap(cardList[index].id),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingCard extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? asset;
  final Function()? onTap;
  const SettingCard(
      {super.key, required this.title, this.subTitle, this.onTap, this.asset});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: size.width / 3.3,
        height: size.getH(200),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.getH(24.0), horizontal: size.getW(24)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (asset?.isNotEmpty ?? false) ...[
                  if (asset!.contains('.svg'))
                    Padding(
                      padding: EdgeInsets.only(right: size.getW(16)),
                      child: SvgPicture.asset(
                        asset!,
                        width: size.getW(40),
                        height: size.getW(40),
                      ),
                    )
                  else if (asset!.contains('.png'))
                    Padding(
                      padding: EdgeInsets.only(right: size.getW(16)),
                      child: Image.asset(
                        asset!,
                        width: size.getW(40),
                        height: size.getW(40),
                      ),
                    )
                ],
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: size.getS(24),
                          fontFamily: kFontFMedium,
                          color: Colors.black,
                        ),
                      ),

                      // SizedBox(
                      //   height: size.getH(12),
                      // ),
                      if (subTitle != null)
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(top: size.getH(8)),
                            child: Text(
                              subTitle!,
                              style: TextStyle(
                                fontSize: size.getS(17),
                                color: Colors.black,
                              ),
                              // overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingCardWidget {
  final int id;
  final String title;
  final String subTitle;
  final String asset;
  final Widget screenWidget;

  SettingCardWidget({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.asset,
    required this.screenWidget,
  });
}
