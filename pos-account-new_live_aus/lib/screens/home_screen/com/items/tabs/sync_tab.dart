import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/sync/sync_pro.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/title_pop.dart';
import 'package:provider/provider.dart';
import 'setting_tab/com/general/common/common_header.dart';

class SyncTab extends StatefulWidget {
  const SyncTab({super.key});

  @override
  State<SyncTab> createState() => _SyncTabState();
}

class _SyncTabState extends State<SyncTab> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  SyncPro? _newProdPro;

  getData() {
    _newProdPro = Provider.of<SyncPro>(context, listen: false);
    _newProdPro?.getData();
  }

  @override
  void dispose() {
    _newProdPro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final newProdPro = Provider.of<SyncPro>(context);
    return Processing(
      loading: newProdPro.loading,
      align: Alignment.topLeft,
      child: Column(
        children: [
          CommonHeader(
            child: TitlePop(
              title: LN.sync,
              size: size,
              onTap: () {
                GlobalCVP.setMainPage = MainPage.ManagePage;
              },
            ),
          ),
          SizedBox(
            height: size.getH(12),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.getW(16), vertical: size.getH(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.getW(900),
                    child: Text(
                      LN.whereYouCanSync,
                      style: TextStyle(
                        fontFamily: kFontFMedium,
                        fontSize: size.getS(18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.getH(32),
                  ),
                  Row(
                    children: [
                      TitleDropDown(
                        vPad: 16,
                        title: LN.syncFrom,
                        borderColor: Colors.black12,
                        list: newProdPro.syncSecRes == null ||
                                newProdPro.syncSecRes!.channels == null
                            ? []
                            : newProdPro.syncSecRes!.channels!
                                .map((e) => e.value ?? '')
                                .toList(),
                        indexVal: newProdPro.syncFromIndex,
                        onChanged: (p0) {
                          newProdPro.syncFromIndex = p0;
                          newProdPro.notify;
                        },
                      ),
                      SizedBox(
                        width: size.getW(32),
                      ),
                      TitleDropDown(
                        vPad: 16,
                        title: LN.syncTo,
                        borderColor: Colors.black12,
                        list: newProdPro.syncSecRes == null ||
                                newProdPro.syncSecRes!.channels == null
                            ? []
                            : newProdPro.syncSecRes!.channels!
                                .map((e) => e.value ?? '')
                                .toList(),
                        indexVal: newProdPro.syncToIndex,
                        onChanged: (p0) {
                          newProdPro.syncToIndex = p0;
                          newProdPro.notify;
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.getH(32),
                  ),
                  if (GlobalCVP.viewWidget.viewSyncProductTochannelsButton)
                    LoadButton(
                      onsave: newProdPro.syncLoad
                          ? null
                          : () {
                              newProdPro.syncProduct();
                            },
                      loading: newProdPro.syncLoad,
                      btnText: LN.syncNow,
                      width: 180,
                      hPad: 4,
                    ),
                  // ElevatedButton(
                  //     style: ButtonStyle(
                  //         backgroundColor: MaterialStateProperty.all(
                  //             newProdPro.loading ? Colors.grey : kSecondaryColor),
                  //         padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                  //             horizontal: size.getW(32), vertical: size.getH(8)))),
                  //     onPressed: newProdPro.loading
                  //         ? null
                  //         : () {
                  //             newProdPro.syncProduct();
                  //           },
                  //     child: Text(
                  //       LN.syncNow,
                  //       style: TextStyle(
                  //         fontSize: size.getS(16),
                  //         color: Colors.white,
                  //       ),
                  //     )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
