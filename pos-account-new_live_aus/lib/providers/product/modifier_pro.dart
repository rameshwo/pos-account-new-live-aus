import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/model/home/product/modifier/prod_with_variation_res.dart';
import '../../config/utils/order_utils.dart';
import '../../model/common/category.dart';
import '../../model/home/product/gen_barcode/gen_bar_addsec.dart';
import '../../model/home/setting/general/category/restro_table_model.dart';
import '../../repository/handler.dart';
import '../../services/database/shared_pref.dart';

class ModifierPro extends ChangeNotifier {
  void get notify => notifyListeners();

  String curSym = "";

  GenBarAddSec? addSec;
  final categoryList = <Category>[];
  String? selectedCatId;
  bool pageLoad = true;

  int pageIndex = 1;
  final searchProdCltr = TextEditingController();

  AllProdWithVariation? allProdWithVariation;

  Future<void> getAddSec() async {
    curSym = await SharedPrefs.curSym;
    categoryList.clear();

    addSec = await Handler.genBarcodeAddSec();

    if (addSec?.productCategories != null) {
      categoryList
          .addAll(OrderUtils.getCatList(addSec?.productCategories) ?? []);
    }

    pageLoad = false;
    notify;
  }

  void clear() {
    pageLoad = true;
    selectedCatId = null;
    pageIndex = 1;
    searchProdCltr.clear();
    // allProdWithVariation = null;
  }

  static List<String> get _headerList => [
        "             Product",
        "Variations",
        " ",
      ];

  final tableList = RTableData(
    headerList: _headerList,
    hasAction: false,
  );

  void init() {
    tableList.headerList = _headerList;
  }

  Future<void> getData({
    int page = 1,
    required Ssize size,
    required Widget Function(String?, bool isEdit) actionWidget,
  }) async {
    pageIndex = page;

    allProdWithVariation = await Handler.getAllProdWithVars(
      page: page,
      searchKey: searchProdCltr.text,
      catId: selectedCatId ?? '',
    );
    if (allProdWithVariation?.data != null) {
      tableList.tableDataList = [];
      for (final e in allProdWithVariation!.data!) {
        final _totalCount = e.productVariations
            ?.fold<int>(0, (pV, e) => pV + (e.modifierCount ?? 0));
        tableList.tableDataList.add(
          TableDataList<Widget>(
            id: e.id ?? '',
            image: e.imageUrl,
            itemList: [
              SelectableText(e.name ?? '',
                  style: TextStyle(
                    fontSize: size.getS(16),
                  )),
              Row(
                children: e.productVariations!
                    .map(
                      (a) => Container(
                        margin: EdgeInsets.only(right: size.getW(4)),
                        padding: EdgeInsets.symmetric(
                            horizontal: size.getW(8), vertical: size.getH(4)),
                        decoration: BoxDecoration(
                            // color:  kSecondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black26)),
                        child: SelectableText(
                            '${(a.name?.trim().isNotEmpty ?? false) ? a.name! : (e.name ?? '')}${a.modifierCount != null && a.modifierCount != 0 ? ' (${a.modifierCount!})' : ''}',
                            style: TextStyle(
                              fontSize: size.getS(14),
                              // color: kSecondaryColor,
                            )),
                      ),
                    )
                    .toList(),
              ),
            ],
            statusList: [],
            actionWidget: [actionWidget(e.id, (_totalCount ?? 0) > 0)],
          ),
        );
      }
    }

    pageLoad = false;
    notify;
  }
}
