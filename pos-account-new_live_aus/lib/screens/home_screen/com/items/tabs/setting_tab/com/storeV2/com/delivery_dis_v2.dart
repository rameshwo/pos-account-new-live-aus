import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../providers/setting/store/store_pro_v2.dart';
import '../../../../../../../../../widgets/input/dropdown/title_drop_down.dart';
import '../../general/common/common_header.dart';
import 'widgets/store_card.dart';

class DeliveryStoreV2 extends StatefulWidget {
  final PageController pageController;
  const DeliveryStoreV2({super.key, required this.pageController});

  @override
  State<DeliveryStoreV2> createState() => _DeliveryStoreV2State();
}

class _DeliveryStoreV2State extends State<DeliveryStoreV2> {
  late StoreProV2 storePro;

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() {
    final _storePro = Provider.of<StoreProV2>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _storePro.getAddSec();
      _storePro.getDeliDisData();
    });
  }

  @override
  void dispose() {
    storePro.loading = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    storePro = Provider.of<StoreProV2>(context);
    return Processing(
      loading: storePro.loading || storePro.updateLoadDeliDis,
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
                  "Delivery Settings",
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontFamily: kFontFMedium,
                  ),
                ),
                Spacer(),
                if (GlobalCVP.viewWidget.viewStoreDeliveryTabSaveButton)
                  LoadButton(
                    vPad: 10,
                    hPad: 4,
                    loading: storePro.updateLoadDeliDis,
                    btnText: "Update",
                    loadingText: "Updating",
                    onsave: storePro.updateLoadDeliDis
                        ? null
                        : () {
                            FocusScope.of(context).unfocus();
                            storePro.updateDeliDis();
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
                StoreCardUI(
                  title: 'Delivery Settings',
                  iconData: Icons.delivery_dining_outlined,
                  child: Padding(
                    padding: EdgeInsets.only(top: size.getH(12)),
                    child: Row(
                      children: [
                        TitleDropDown(
                          isReq: false,
                          pWidth: 0.24,
                          borderRadius: 5,
                          list: (storePro.storeRes == null ||
                                  storePro.storeRes!.distanceKmsMiles == null)
                              ? []
                              : storePro.storeRes!.distanceKmsMiles!
                                  .map((e) => e.value ?? '')
                                  .toList(),
                          indexVal: storePro.distanceTypeIndex,
                          title: LN.distanceType,
                          onChanged: (int? p0) {
                            storePro.distanceTypeIndex = p0;
                            storePro.notify;
                          },
                        ),
                        SizedBox(
                          width: size.getW(48),
                        ),
                        SizedBox(
                          width: size.getW(260),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Enable Uber Delivery",
                                  style: TextStyle(
                                    fontSize: size.getS(18),
                                    color: Colors.black,
                                  )),
                              SizedBox(
                                width: size.getW(16),
                              ),
                              SwitchAdap(
                                size: size,
                                value: storePro.enableUberDelivery,
                                activeColor: kPrimaryColor,
                                onChanged: (val) {
                                  storePro.enableUberDelivery = val;
                                  storePro.notify;
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.getH(24),
                ),
                StoreCardUI(
                  title: 'Delivery Distance Cost',
                  iconData: Icons.delivery_dining_outlined,
                  child: Padding(
                    padding: EdgeInsets.only(top: size.getH(12)),
                    child: Column(
                      children: [
                        ...List.generate(storePro.distanceAmountList.length,
                            (index) {
                          return Padding(
                            padding: EdgeInsets.only(top: size.getH(24.0)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: size.width * 0.2,
                                  child: TitleTextForm(
                                    isReq: false,
                                    title: LN.distanceFrom,
                                    textCltr: storePro
                                        .distanceAmountList[index].fromCltr,
                                    hintText: '',
                                    borderColor: Colors.black38,
                                    borderRadius: 5,
                                    // vPad: 12,
                                    hPad: 16,
                                    errH: 0,
                                    textInputType: TextInputType.number,
                                  ),
                                ),
                                SizedBox(
                                  width: size.getW(48),
                                ),
                                SizedBox(
                                  width: size.width * 0.2,
                                  child: TitleTextForm(
                                    isReq: false,
                                    title: LN.distanceTo,
                                    textCltr: storePro
                                        .distanceAmountList[index].toCltr,
                                    hintText: '',
                                    borderColor: Colors.black38,
                                    borderRadius: 5,
                                    // vPad: 12,
                                    hPad: 16,
                                    errH: 0,
                                    textInputType: TextInputType.number,
                                  ),
                                ),
                                SizedBox(
                                  width: size.getW(48),
                                ),
                                SizedBox(
                                  width: size.width * 0.2,
                                  child: TitleTextForm(
                                    isReq: false,
                                    title: LN.price,
                                    textCltr: storePro
                                        .distanceAmountList[index].dataCltr,
                                    hintText: '',
                                    borderColor: Colors.black38,
                                    borderRadius: 5,
                                    // vPad: 12,
                                    hPad: 16,
                                    errH: 0,
                                    textInputType: TextInputType.number,
                                  ),
                                ),
                                SizedBox(
                                  width: size.getW(48),
                                ),
                                Material(
                                  color: Colors.red.shade700,
                                  type: MaterialType.circle,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(60),
                                    onTap: () {
                                      storePro.removeDistAmount(index: index);
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
                                color: kSecondaryColor.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadiusGeometry.circular(5)),
                          btnText: "Add Delivery Distance",
                          icon: Padding(
                            padding: EdgeInsets.only(right: size.getW(12)),
                            child: Icon(
                              Icons.add,
                              color: kSecondaryColor,
                              size: size.getS(22),
                            ),
                          ),
                          onsave: () {
                            storePro.addDistAmount();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
