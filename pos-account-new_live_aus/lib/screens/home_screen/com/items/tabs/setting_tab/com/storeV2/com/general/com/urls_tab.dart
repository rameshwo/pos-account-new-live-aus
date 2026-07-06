import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart' show LN;
import 'package:pos_account/providers/setting/store/store_pro_v2.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:provider/provider.dart';
import '../../widgets/store_card.dart';

class UrlTab extends StatelessWidget {
  const UrlTab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final storePro = Provider.of<StoreProV2>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          StoreCardUI(
              title: "URL Section",
              iconData: Icons.location_on_outlined,
              child: Padding(
                padding: EdgeInsets.only(top: size.getH(12)),
                child: GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: size.getW(24),
                    mainAxisSpacing: size.getH(16),
                    childAspectRatio: 9,
                  ),
                  children: [
                    TitleTextForm(
                      title: "Online URL",
                      preTitleIcon: Padding(
                        padding: EdgeInsets.only(right: size.getW(8)),
                        child: Icon(
                          Icons.link,
                          size: size.getS(25),
                        ),
                      ),
                      pWidth: 0.20,
                      isReq: false,
                      textCltr: storePro.onlineUrlCltr,
                      textInputType: TextInputType.url,
                      suffix: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                    text: storePro.onlineUrlCltr.text))
                                .then((_) => IfException.showMessage(
                                    message: LN.copiedToClip));
                          },
                          child: Icon(
                            Icons.copy_outlined,
                            size: size.getS(22),
                          )),
                    ),
                    TitleTextForm(
                      title: LN.webUrl,
                      preTitleIcon: Padding(
                        padding: EdgeInsets.only(right: size.getW(8)),
                        child: Icon(
                          Icons.link,
                          size: size.getS(25),
                        ),
                      ),
                      pWidth: 0.20,
                      isReq: false,
                      textCltr: storePro.webUrlCltr,
                      textInputType: TextInputType.url,
                      suffix: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                    text: storePro.webUrlCltr.text))
                                .then((_) => IfException.showMessage(
                                    message: LN.copiedToClip));
                          },
                          child: Icon(
                            Icons.copy_outlined,
                            size: size.getS(22),
                          )),
                    ),
                    TitleTextForm(
                      title: "Blog URL",
                      preTitleIcon: Padding(
                        padding: EdgeInsets.only(right: size.getW(8)),
                        child: Icon(
                          Icons.link,
                          size: size.getS(25),
                        ),
                      ),
                      pWidth: 0.20,
                      isReq: false,
                      textCltr: storePro.blogUrlCltr,
                      textInputType: TextInputType.url,
                      suffix: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                    text: storePro.blogUrlCltr.text))
                                .then((_) => IfException.showMessage(
                                    message: LN.copiedToClip));
                          },
                          child: Icon(
                            Icons.copy_outlined,
                            size: size.getS(22),
                          )),
                    ),
                    TitleTextForm(
                      title: "Booking URL",
                      preTitleIcon: Padding(
                        padding: EdgeInsets.only(right: size.getW(8)),
                        child: Icon(
                          Icons.link,
                          size: size.getS(25),
                        ),
                      ),
                      pWidth: 0.20,
                      isReq: false,
                      textCltr: storePro.bookingUrlCltr,
                      textInputType: TextInputType.url,
                      suffix: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                    text: storePro.bookingUrlCltr.text))
                                .then((_) => IfException.showMessage(
                                    message: LN.copiedToClip));
                          },
                          child: Icon(
                            Icons.copy_outlined,
                            size: size.getS(22),
                          )),
                    ),
                    TitleTextForm(
                      title: "QR Order URL",
                      preTitleIcon: Padding(
                        padding: EdgeInsets.only(right: size.getW(8)),
                        child: Icon(
                          Icons.link,
                          size: size.getS(25),
                        ),
                      ),
                      pWidth: 0.20,
                      isReq: false,
                      textCltr: storePro.qrUrlCltr,
                      textInputType: TextInputType.url,
                      suffix: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                    text: storePro.qrUrlCltr.text))
                                .then((_) => IfException.showMessage(
                                    message: LN.copiedToClip));
                          },
                          child: Icon(
                            Icons.copy_outlined,
                            size: size.getS(22),
                          )),
                    ),
                    TitleTextForm(
                      title: "Tracking URL",
                      preTitleIcon: Padding(
                        padding: EdgeInsets.only(right: size.getW(8)),
                        child: Icon(
                          Icons.link,
                          size: size.getS(25),
                        ),
                      ),
                      pWidth: 0.20,
                      isReq: false,
                      textCltr: storePro.trackingUrlCltr,
                      textInputType: TextInputType.url,
                      suffix: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                    text: storePro.trackingUrlCltr.text))
                                .then((_) => IfException.showMessage(
                                    message: LN.copiedToClip));
                          },
                          child: Icon(
                            Icons.copy_outlined,
                            size: size.getS(22),
                          )),
                    ),
                    TitleTextForm(
                      title: "Menu QR URL",
                      preTitleIcon: Padding(
                        padding: EdgeInsets.only(right: size.getW(8)),
                        child: Icon(
                          Icons.link,
                          size: size.getS(25),
                        ),
                      ),
                      pWidth: 0.20,
                      isReq: false,
                      textCltr: storePro.menuQrUrlCltr,
                      textInputType: TextInputType.url,
                      suffix: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                    text: storePro.menuQrUrlCltr.text))
                                .then((_) => IfException.showMessage(
                                    message: LN.copiedToClip));
                          },
                          child: Icon(
                            Icons.copy_outlined,
                            size: size.getS(22),
                          )),
                    ),
                    TitleTextForm(
                      title: "Signage URL",
                      preTitleIcon: Padding(
                        padding: EdgeInsets.only(right: size.getW(8)),
                        child: Icon(
                          Icons.link,
                          size: size.getS(25),
                        ),
                      ),
                      pWidth: 0.20,
                      isReq: false,
                      textCltr: storePro.sinageUrlCltr,
                      textInputType: TextInputType.url,
                      suffix: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                    text: storePro.sinageUrlCltr.text))
                                .then((_) => IfException.showMessage(
                                    message: LN.copiedToClip));
                          },
                          child: Icon(
                            Icons.copy_outlined,
                            size: size.getS(22),
                          )),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
