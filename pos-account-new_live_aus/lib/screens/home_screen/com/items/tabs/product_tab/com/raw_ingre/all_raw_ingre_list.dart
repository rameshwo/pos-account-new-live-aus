import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/product_tab/com/raw_ingre/raw_history_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../../../../constant/constant.dart';
import '../../../../../../../../model/home/product/all_raw_ingredient_response.dart';

class AllRawIngredients extends StatefulWidget {
  final Function()? onEdit;
  final TabController tabController;
  const AllRawIngredients(
      {super.key, required this.tabController, this.onEdit});

  @override
  State<AllRawIngredients> createState() => _AllRawIngredientsState();
}

class _AllRawIngredientsState extends State<AllRawIngredients> {
  NewProductPro? _newProdPro;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _newProdPro = Provider.of<NewProductPro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
  }

  getData() {
    if (_newProdPro != null) _newProdPro!.getAllRawIngreList(page: 1);
  }

  paginate(int page) {
    if (_newProdPro != null) {
      _newProdPro!.getAllRawIngreList(page: page).then((value) {
        _refreshController.loadComplete();
        _refreshController.refreshCompleted();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _newProdPro?.clearRawListSec();
  }

  showAllRawIngreHistory(String? name, String? unit) {
    return showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                RawHistoryDia(
                  onEdit: () {},
                  ingreName: name ?? "",
                  unit: unit ?? '',
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final newProdPro = Provider.of<NewProductPro>(context);
    return Processing(
      loading: newProdPro.rawIngreLoad,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.01, vertical: size.height * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
              child: SizedBox(
                width: size.width / 3,
                child: TextFormWidget(
                  isReq: false,
                  prefixIcon: Icon(
                    Icons.search,
                    size: size.getS(32),
                  ),
                  borderRadius: 5,
                  borderColor: Colors.black12,
                  cltr: newProdPro.rawSearchCltr,
                  hintText: "${LN.search} ${LN.rawIngre}",
                  onChanged: (String? val) {
                    Utils.handleSearch(
                        callback: () async {
                          newProdPro.rawIngreLoad = true;
                          newProdPro.notify;
                          newProdPro.getAllRawIngreList(page: 1);
                        },
                        millisecond: 2000);
                  },
                  suffixIcon: InkWell(
                      onTap: () {
                        if (newProdPro.rawSearchCltr.text.isEmpty) return;
                        newProdPro.rawSearchCltr.clear();
                        newProdPro.rawIngreLoad = true;
                        newProdPro.notify;
                        newProdPro.getAllRawIngreList(page: 1);
                      },
                      child: Icon(Icons.close)),
                ),
              ),
            ),
            Expanded(
                child: SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    onRefresh: () {
                      newProdPro.rawIngreLoad = true;
                      newProdPro.notify;
                      paginate(1);
                    },
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
                      children: [
                        SizedBox(
                          height: size.getH(12),
                        ),
                        newProdPro.rawIngreTableList.tableDataList.isEmpty &&
                                !newProdPro.rawIngreLoad
                            ? NoItemsSec(
                                size: size,
                                title: "${LN.no} ${LN.rawIngre}",
                              )
                            : TableData(
                                paginate: paginate,
                                tableData: newProdPro.rawIngreTableList,
                                total: newProdPro.allRawIngreRes?.total ?? 0,
                                page: newProdPro.getRawPage,
                                pageSize: newProdPro.getRawIngrePageSize,
                                sortColumnIndex: 1,
                                popUpMenuItems: (int _) =>
                                    [LN.edit, 'Stock History'],
                                onAction: (p0, p1) async {
                                  if (newProdPro.rawIngreLoad) return;
                                  if (p1 == MoreFun.Edit) {
                                    if (p0.id == null) return;

                                    newProdPro.loading = true;
                                    newProdPro.clear();
                                    newProdPro.notify;
                                    newProdPro.editRawIngreId = p0.id!;
                                    newProdPro.getEditRawData().then((val) {
                                      if (val ?? false) {
                                        widget.tabController.animateTo(1);
                                        Future.delayed(
                                            Duration(milliseconds: 500), () {
                                          newProdPro.notify;
                                        });
                                      }
                                    });
                                  } else if (p1 == MoreFun.StockHistory) {
                                    if (p0.id == null) return;
                                    newProdPro.loading = true;
                                    final data = newProdPro.allRawIngreRes?.data
                                                ?.where(
                                                  (element) =>
                                                      element.id == p0.id,
                                                )
                                                .isNotEmpty ==
                                            true
                                        ? newProdPro.allRawIngreRes!.data!
                                            .where(
                                              (element) => element.id == p0.id,
                                            )
                                            .first
                                        : RawIngredientData();
                                    newProdPro.clear();
                                    newProdPro.notify;
                                    newProdPro.editRawIngreId = p0.id!;
                                    newProdPro
                                            .rawHisWastagePercentageCltr.text =
                                        data.wastagePercentage.toString();

                                    showAllRawIngreHistory(
                                      p0.name,
                                      data.unitOfMeasurement,
                                    );
                                  }
                                  newProdPro.notify;
                                })
                      ],
                    ))),
            SizedBox(
              height: size.getH(24),
            ),
          ],
        ),
      ),
    );
  }
}
