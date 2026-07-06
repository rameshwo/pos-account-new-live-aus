import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/generate_barcode_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/dropdown/tree_dropdown/tree_dropdown.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:pos_account/widgets/refresh_btn.dart';
import 'package:provider/provider.dart';

import 'dialog/barcode_bulk_view.dart';

class ProductSecGenBarCode extends StatefulWidget {
  const ProductSecGenBarCode({super.key});

  @override
  State<ProductSecGenBarCode> createState() => _ProductSecGenBarCodeState();
}

class _ProductSecGenBarCodeState extends State<ProductSecGenBarCode> {
  @override
  void initState() {
    super.initState();
    _genBarPro = Provider.of<GenBarcodePro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setUp();
    });
  }

  GenBarcodePro? _genBarPro;

  void setUp() {
    _genBarPro?.init();
    _genBarPro?.getBarcodeSec();
    _genBarPro?.getData();
  }

  @override
  void dispose() {
    _genBarPro?.productClear();
    super.dispose();
  }

  void paginate(int page) {
    _genBarPro!.pageLoad = true;
    _genBarPro!.notify;
    _genBarPro!.getData(page: page);
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final genPro = Provider.of<GenBarcodePro>(context);
    return Processing(
      loading: genPro.pageLoad,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: size.getW(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: size.getH(24)),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: size.getW(16),
              runSpacing: size.getH(16),
              children: [
                TreeDropWidget(
                  isReq: false,
                  vPad: 10,
                  width: size.width * 0.20,
                  dialogWidth: size.width / 2,
                  mode: Mode.DIALOG,
                  selectedColor: kSecondaryColor,
                  title: LN.category,
                  borderColor: Colors.black12,
                  hintText: LN.chooseCategory,
                  categoryList: genPro.categoryList,
                  selectedId: genPro.selectedCatId,
                  onChanged: (p0) {
                    genPro.selectedCatId = p0;
                    genPro.pageLoad = true;
                    genPro.notify;
                    genPro.getData(page: 1);
                  },
                ),
                TitleDropDown(
                  title: LN.brand,
                  hintText: LN.chooseBrand,
                  isReq: false,
                  pWidth: 0.20,
                  borderColor: Colors.black12,
                  indexVal: genPro.brandIndex,
                  list: genPro.barcodeAddSec?.brands == null
                      ? []
                      : genPro.barcodeAddSec!.brands!
                          .map((e) => e.name ?? '')
                          .toList(),
                  onChanged: (int? i) {
                    genPro.brandIndex = i;
                    genPro.pageLoad = true;
                    genPro.notify;
                    genPro.getData(page: 1);
                  },
                ),
                TitleDropDown(
                  title: "Product Type",
                  hintText: "Choose Product Type",
                  isReq: false,
                  pWidth: 0.20,
                  borderColor: Colors.black12,
                  indexVal: genPro.productTypeIndex,
                  list: genPro.barcodeAddSec?.productTypes == null
                      ? []
                      : genPro.barcodeAddSec!.productTypes!
                          .map((e) => e.name ?? '')
                          .toList(),
                  onChanged: (int? i) {
                    genPro.productTypeIndex = i;
                    genPro.pageLoad = true;
                    genPro.notify;
                    genPro.getData(page: 1);
                  },
                ),
                TitleTextForm(
                  title: LN.search,
                  pWidth: 0.20,
                  isReq: false,
                  vPad: 10,
                  hintText: LN.search,
                  borderRadius: 5,
                  borderColor: Colors.black12,
                  textCltr: genPro.searchProdCltr,
                  suffixIcon: genPro.searchProdCltr.text.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            genPro.searchProdCltr.clear();
                            genPro.pageLoad = true;
                            genPro.notify;
                            genPro.getData(page: 1);
                          },
                          child: Icon(
                            Icons.close,
                            size: size.getS(32),
                          ),
                        )
                      : Icon(
                          Icons.search,
                          size: size.getS(32),
                        ),
                  onChanged: (p0) {
                    Utils.handleSearch(callback: () async {
                      genPro.pageLoad = true;
                      genPro.notify;
                      await genPro.getData(page: 1);
                    });
                  },
                ),
                RefreshBtn(
                  size: size,
                  onTap: genPro.pageLoad
                      ? null
                      : () {
                          genPro.pageLoad = true;
                          genPro.selectedCatId = null;
                          genPro.brandIndex = null;
                          genPro.productTypeIndex = null;
                          genPro.searchProdCltr.clear();
                          genPro.notify;
                          genPro.getData(page: 1);
                        },
                )
              ],
            ),
            SizedBox(height: size.getH(12)),
            _bulkGenBtn(size, context, genPro: genPro),
            if (genPro.tableList.tableDataList.isEmpty && !genPro.pageLoad)
              Align(
                alignment: Alignment.topCenter,
                child: NoItemsSec(
                  size: size,
                  title: LN.noProductFound,
                ),
              )
            else
              TableData(
                showDeleteBtn: false,
                tableData: genPro.tableList,
                paginate: paginate,
                total: genPro.barCodeTypeList?.total,
                page: genPro.pageIndex,
                selectItem: (v) {
                  genPro.notify;
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _bulkGenBtn(
    Ssize size,
    BuildContext context, {
    required GenBarcodePro genPro,
  }) {
    final isOpen = !genPro.pageLoad &&
        genPro.tableList.tableDataList.any((e) => e.selected);

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0,
            child: child,
          ),
        );
      },
      child: isOpen
          ? Padding(
              padding: EdgeInsets.only(bottom: size.getH(12)),
              child: ElevatedButton(
                  key: ValueKey('button'),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          vertical: size.getH(10), horizontal: size.getW(12))),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                          color: isOpen ? kSecondaryColor : Colors.black26,
                        ),
                      ))),
                  onPressed: isOpen
                      ? () async {
                          await genPro.getBulkBarCode(
                              type: BarCodeType.Product);
                          await showDialog(
                              context: context,
                              builder: (builder) => SimpleDialog(
                                    backgroundColor: kBackgroundColor,
                                    titlePadding: EdgeInsets.zero,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 24),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    children: [
                                      BulkBarCodeView(),
                                    ],
                                  ));
                          genPro.bulkBarCode = null;
                        }
                      : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.print_outlined,
                        size: size.getS(24),
                        color: isOpen ? kSecondaryColor : Colors.black26,
                      ),
                      SizedBox(width: size.getW(12)),
                      Text(
                        "Bulk Barcode Generate",
                        style: TextStyle(
                          fontSize: size.getS(18),
                          fontWeight: FontWeight.bold,
                          color: isOpen ? kSecondaryColor : Colors.black26,
                        ),
                      ),
                    ],
                  )),
            )
          : SizedBox(
              key: ValueKey('empty'), // Unique key to trigger switch
              height: 0,
            ),
    );
  }
}
