import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/setting/store/store_pro_v2.dart';
import 'package:pos_account/widgets/cus_expansion_tile.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';

class OtherTab extends StatelessWidget {
  const OtherTab({super.key});

  @override
  Widget build(BuildContext context) {
    final storePro = Provider.of<StoreProV2>(context);
    final size = Ssize(context);
    return Card(
      child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.getH(12),
              ),
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: Card(
                  color: kBackgroundColor,
                  child: CusExpansionTile(
                    backgroundColor: kBackgroundColor,
                    tilePadding: EdgeInsets.symmetric(horizontal: size.getW(8)),
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: size.getW(12)),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      "Channel Notes",
                      style: TextStyle(
                        fontSize: size.getS(18),
                        color: Colors.black,
                      ),
                    ),
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: kSecondaryColor,
                            size: size.getS(18),
                          ),
                          SizedBox(width: size.getW(4)),
                          Text(
                            'Add specific notes for each channel. These notes will be displayed to customers when they interact with your store through these channels.',
                            style: TextStyle(
                              fontSize: size.getS(14),
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                      ...List.generate(storePro.channelNotesList.length, (i) {
                        return Padding(
                          padding: EdgeInsets.only(top: size.getH(12)),
                          child: TitleTextForm(
                            title: " ${storePro.channelNotesList[i].name}",
                            isReq: false,
                            pWidth: 1,
                            maxLines: 2,
                            preTitleIcon: Icon(
                              Icons.comment_outlined,
                              size: size.getS(20),
                            ),
                            textCltr: storePro.channelNotesList[i].noteCltr,
                          ),
                        );
                      }),
                      SizedBox(
                        height: size.getH(24),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.getH(12),
                child: Divider(),
              ),
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: Card(
                  color: kBackgroundColor,
                  child: CusExpansionTile(
                    backgroundColor: kBackgroundColor,
                    tilePadding: EdgeInsets.symmetric(horizontal: size.getW(8)),
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: size.getW(12)),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      "Social Media",
                      style: TextStyle(
                        fontSize: size.getS(18),
                        color: Colors.black,
                      ),
                    ),
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: kSecondaryColor,
                            size: size.getS(18),
                          ),
                          SizedBox(width: size.getW(4)),
                          Text(
                            'Add specific notes for each channel. These notes will be displayed to customers when they interact with your store through these channels.',
                            style: TextStyle(
                              fontSize: size.getS(14),
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                      ...List.generate(storePro.socialMediaList.length, (i) {
                        return Padding(
                          padding: EdgeInsets.only(top: size.getH(12)),
                          child: Row(
                            children: [
                              TitleTextForm(
                                title: " ${storePro.socialMediaList[i].name}",
                                isReq: false,
                                preTitleIcon: Icon(
                                  Icons.link,
                                  size: size.getS(20),
                                ),
                                textCltr: storePro.socialMediaList[i].linkCltr,
                              ),
                              SizedBox(width: size.getW(48)),
                              Column(
                                children: [
                                  Text(
                                    "Status",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: kFontFMedium,
                                        fontSize: size.getS(16)),
                                  ),
                                  SwitchAdap(
                                    size: size,
                                    value: storePro.socialMediaList[i].isActive,
                                    onChanged: (val) {
                                      storePro.socialMediaList[i].isActive =
                                          val;
                                      storePro.notify;
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(
                        height: size.getH(24),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.getH(12),
                child: Divider(),
              ),
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: Card(
                  color: kBackgroundColor,
                  child: CusExpansionTile(
                    backgroundColor: kBackgroundColor,
                    tilePadding: EdgeInsets.symmetric(horizontal: size.getW(8)),
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: size.getW(12)),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      "Delivery Offer",
                      style: TextStyle(
                        fontSize: size.getS(18),
                        color: Colors.black,
                      ),
                    ),
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: kSecondaryColor,
                            size: size.getS(18),
                          ),
                          SizedBox(width: size.getW(4)),
                          Text(
                            'Configure delivery offers and promotions for your customers. Set free delivery thresholds and discount percentages.',
                            style: TextStyle(
                              fontSize: size.getS(14),
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: size.getH(12)),
                      TitleTextForm(
                        title: " Free Delivery Message",
                        hintText: 'eg. Free delivery on orders over \$50!',
                        isReq: false,
                        pWidth: 1,
                        preTitleIcon: Icon(
                          Icons.message_outlined,
                          size: size.getS(20),
                        ),
                        textCltr: storePro.freeDeliMessageCltr,
                      ),
                      SizedBox(height: size.getH(12)),
                      Row(
                        children: [
                          Expanded(
                            child: TitleTextForm(
                              title: " Free Delivery Discount Percentage",
                              hintText: 'eg. 100 for full discount',
                              isReq: false,
                              pWidth: 1,
                              preTitleIcon: Icon(
                                Icons.comment_outlined,
                                size: size.getS(20),
                              ),
                              textCltr: storePro.freeDeliDiscountPerCltr,
                              textInputType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: size.getW(24)),
                          Expanded(
                            child: TitleTextForm(
                              title: " Free Delivery Max Amount Threshold",
                              hintText: 'eg. 50 for orders over \$50',
                              isReq: false,
                              pWidth: 1,
                              preTitleIcon: Icon(
                                Icons.attach_money_rounded,
                                size: size.getS(20),
                              ),
                              textCltr: storePro.freeDeliMaxAmtThresoldCltr,
                              textInputType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.getH(24),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.getH(12),
                child: Divider(),
              ),
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: Card(
                  color: kBackgroundColor,
                  child: CusExpansionTile(
                    backgroundColor: kBackgroundColor,
                    tilePadding: EdgeInsets.symmetric(horizontal: size.getW(8)),
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: size.getW(12)),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      "Scheduler",
                      style: TextStyle(
                        fontSize: size.getS(18),
                        color: Colors.black,
                      ),
                    ),
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: kSecondaryColor,
                            size: size.getS(18),
                          ),
                          SizedBox(width: size.getW(4)),
                          Text(
                            'Configure and manage scheduled jobs. Set daily tasks, pick a specific execution time, and toggle job activation with ease.',
                            style: TextStyle(
                              fontSize: size.getS(14),
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                      if (storePro
                              .editGeneral?.scheduleReportJobAddViewModels !=
                          null)
                        ...List.generate(
                            storePro.editGeneral!
                                .scheduleReportJobAddViewModels!.length, (i) {
                          final _sche = storePro
                              .editGeneral!.scheduleReportJobAddViewModels![i];
                          return Padding(
                            padding: EdgeInsets.only(top: size.getH(12)),
                            child: Row(
                              children: [
                                TitleTextForm(
                                  title: "Name",
                                  pWidth: 0.20,
                                  isReq: false,
                                  textCltr: _sche.name,
                                ),
                                SizedBox(width: size.getW(24)),
                                TitleTextForm(
                                  title: "Time",
                                  pWidth: 0.20,
                                  isReq: false,
                                  textCltr: TextEditingController(
                                    text: _sche.time,
                                  ),
                                  readOnly: true,
                                  suffixIcon: Icon(
                                    Icons.watch_later_outlined,
                                    size: size.getS(20),
                                  ),
                                  suffixIconWidth: 40,
                                  onTap: () {
                                    Utils.timePick(context).then((_time) {
                                      if (_time == null) return;

                                      _sche.time =
                                          '${_time.hour.toString().padLeft(2, '0')}:'
                                          '${_time.minute.toString().padLeft(2, '0')}';
                                      storePro.notify;
                                    });
                                  },
                                ),
                                SizedBox(width: size.getW(48)),
                                Column(
                                  children: [
                                    Text(
                                      "Status",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: kFontFMedium,
                                          fontSize: size.getS(16)),
                                    ),
                                    SwitchAdap(
                                      size: size,
                                      value: _sche.isActive ?? false,
                                      onChanged: (val) {
                                        _sche.isActive = val;
                                        storePro.notify;
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      SizedBox(
                        height: size.getH(24),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
