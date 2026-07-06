import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/general/barcode_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';

import '../../general_set.dart';

class BarCodeSet extends StatefulWidget {
  final PageController pageController;
  const BarCodeSet({super.key, required this.pageController});

  @override
  State<BarCodeSet> createState() => _BarCodeSetState();
}

class _BarCodeSetState extends State<BarCodeSet>
    with SingleTickerProviderStateMixin {
  BarcodePro? _barcodePro;

  // final _scrollCltr = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _barcodePro = Provider.of<BarcodePro>(context, listen: false);
    _barcodePro?.init();
    _barcodePro?.getAddSec();
    _barcodePro?.getData();
    super.initState();
  }

  paginate(int page) {
    if (_barcodePro != null) {
      _barcodePro!.pageLoad = true;
      _barcodePro!.notify;
      _barcodePro!.getData(page: page);
    }
  }

  @override
  void dispose() {
    _barcodePro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final pro = Provider.of<BarcodePro>(context);
    return Processing(
      loading: pro.pageLoad,
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTabRow(
              addTitle: "Add Barcode Type",
              viewTitle: "Barcode Type List",
              tabController: _tabController,
              pageController: widget.pageController,
            ),
            SizedBox(
              height: size.getH(12),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: TableData(
                      popUpMenuItems: (int _) => [
                        LN.edit,
                      ],
                      showDeleteBtn: false,
                      tableData: pro.tableList,
                      paginate: paginate,
                      total: pro.barCodeTypeList?.total,
                      page: pro.pageIndex,
                      onAction: (p0, moreFun) {
                        if (p0.id == null) return;

                        if (pro.editData(p0.id ?? '') ?? false) {
                          _tabController.animateTo(1);
                          Future.delayed(Duration(milliseconds: 500), () {
                            pro.notify;
                          });
                        }
                      },
                    ),
                  ),
                  if (pro.editBarData != null) ...[
                    Row(
                      children: [
                        TitleDropDown(
                          pWidth: 0.24,
                          title: LN.barCodeType,
                          list: pro.barCodeTypeAddSec?.barCodeTypes == null
                              ? []
                              : pro.barCodeTypeAddSec!.barCodeTypes!
                                  .map((e) => e.value ?? '')
                                  .toList(),
                          borderColor: Colors.black26,
                          indexVal: pro.barcodeTypeIndex,
                          onChanged: (p0) {
                            pro.barcodeTypeIndex = p0;
                            pro.notify;
                          },
                        ),
                        SizedBox(
                          width: size.getW(48),
                        ),
                        Column(
                          children: [
                            Text(
                              LN.defaultText,
                              style: TextStyle(
                                fontSize: size.getS(18),
                                color: Colors.black,
                              ),
                            ),
                            SwitchAdap(
                              size: size,
                              value: pro.editBarData?.isDefault ?? false,
                              onChanged: (p0) {
                                if (pro.editBarData == null) return;
                                pro.editBarData!.isDefault = p0;
                                pro.notify;
                              },
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.getH(16),
                    ),
                    Row(
                      children: [
                        LoadButton(
                          btnText: LN.save,
                          vPad: 8,
                          btnColor: kPrimaryColor,
                          onsave: () {
                            pro.updateData();
                          },
                        ),
                        SizedBox(
                          width: size.getW(12),
                        ),
                        LoadButton(
                          btnText: LN.cancel,
                          vPad: 8,
                          btnColor: Colors.red,
                          onsave: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.getH(12),
                    ),
                    Divider()
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
