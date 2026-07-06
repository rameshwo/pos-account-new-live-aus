import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/setting/store/store_pro_v2.dart';
import 'package:pos_account/widgets/input/color_pick_sec.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../../general/common/common_header.dart';
import 'widgets/store_card.dart';

class ColorStoreV2 extends StatefulWidget {
  final PageController pageController;
  const ColorStoreV2({super.key, required this.pageController});

  @override
  State<ColorStoreV2> createState() => _ColorStoreV2State();
}

class _ColorStoreV2State extends State<ColorStoreV2> {
  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() {
    final _storePro = Provider.of<StoreProV2>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _storePro.getAddSec();
      _storePro.getStoreColorData();
    });
  }

  @override
  void dispose() {
    storePro.loading = true;
    super.dispose();
  }

  late StoreProV2 storePro;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    storePro = Provider.of<StoreProV2>(context);
    return Processing(
      loading: storePro.updateLoadColorSet ||
          storePro.loading ||
          storePro.resetLoadColorSet,
      child: Column(
        children: [
          CommonHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      widget.pageController.jumpToPage(0);
                    },
                    icon: Icon(Icons.arrow_back)),
                Text(
                  "Color Settings",
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontFamily: kFontFMedium,
                  ),
                ),
                Spacer(),
                // if (GlobalCVP.viewWidget.viewStorec)
                LoadButton(
                  vPad: 10,
                  hPad: 4,
                  loading: storePro.updateLoadColorSet,
                  btnText: "Update",
                  loadingText: "Updating",
                  onsave: storePro.updateLoadColorSet
                      ? null
                      : () {
                          FocusScope.of(context).unfocus();
                          storePro.updateStoreColor();
                        },
                ),
                SizedBox(width: size.getW(12)),
              ],
            ),
          ),
          SizedBox(
            height: size.getH(12),
          ),
          Expanded(
              child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.getH(12),
                        ),
                        if (storePro.storeColorData?.themeColorAddViewModels !=
                            null)
                          StoreCardUI(
                              title: 'Color Settings',
                              iconData: Icons.credit_card,
                              trail: [
                                Spacer(),
                                LoadButton(
                                  hPad: 4,
                                  vPad: 8,
                                  textColor: kSecondaryColor,
                                  btnColor: Colors.white,
                                  fontSize: 14,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: kSecondaryColor.withOpacity(0.2),
                                      ),
                                      borderRadius:
                                          BorderRadiusGeometry.circular(5)),
                                  btnText: "Reset Colors",
                                  loading: storePro.resetLoadColorSet,
                                  loadingText: "Resetting",
                                  onsave: () {
                                    storePro.resetStoreColor();
                                  },
                                ),
                              ],
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ...List.generate(
                                        storePro
                                            .storeColorData!
                                            .themeColorAddViewModels!
                                            .length, (index) {
                                      final _data = storePro.storeColorData!
                                          .themeColorAddViewModels![index];
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            top: size.getH(24.0)),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.2,
                                              child: TitleTextForm(
                                                isReq: false,
                                                title: "Color Name",
                                                textCltr: _data.name,
                                                hintText: '',
                                                borderColor: Colors.black38,
                                                borderRadius: 5,
                                                hPad: 16,
                                                errH: 0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.getW(48),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.2,
                                              child: TitleTextForm(
                                                isReq: false,
                                                title: "Display Name",
                                                textCltr: _data.displayName,
                                                hintText: '',
                                                borderColor: Colors.black38,
                                                borderRadius: 5,
                                                hPad: 16,
                                                errH: 0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.getW(48),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.2,
                                              child: _colorSec(
                                                size,
                                                title: "Color Code",
                                                textCltr: _data.value,
                                                color: Utils.colorFromHex(
                                                    _data.value.text),
                                                onColorChanged: (val) {
                                                  // prodCat.foTextcolor = val;
                                                  _data.value.text =
                                                      Utils.hexCode(val);
                                                  storePro.notify;
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.getW(48),
                                            ),
                                            Material(
                                              color: Colors.red.shade700,
                                              type: MaterialType.circle,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                onTap: () {
                                                  storePro.removeColor(
                                                      index: index);
                                                },
                                                child: Icon(
                                                  Icons.remove,
                                                  size: size.getS(36),
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                                    SizedBox(
                                      height: size.getH(24),
                                    ),
                                    LoadButton(
                                      width: 300,
                                      hPad: 4,
                                      vPad: 8,
                                      textColor: kSecondaryColor,
                                      btnColor: Colors.white,
                                      fontSize: 14,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: kSecondaryColor
                                                .withOpacity(0.2),
                                          ),
                                          borderRadius:
                                              BorderRadiusGeometry.circular(5)),
                                      btnText: "Add Color",
                                      icon: Padding(
                                        padding: EdgeInsets.only(
                                            right: size.getW(12)),
                                        child: Icon(
                                          Icons.add,
                                          color: kSecondaryColor,
                                          size: size.getS(22),
                                        ),
                                      ),
                                      onsave: () {
                                        storePro.addColor();
                                      },
                                    ),
                                  ]))
                      ])))
        ],
      ),
    );
  }

  Widget _colorSec(
    Ssize size, {
    required String title,
    required TextEditingController textCltr,
    required Color color,
    required Function(Color color) onColorChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: size.getS(18),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: size.getH(8)),
        ColorPickerSection(
          textCltr: textCltr,
          selectedColor: color,
          onColorChanged: onColorChanged,
          colorSize: 24,
        )
      ],
    );
  }
}
