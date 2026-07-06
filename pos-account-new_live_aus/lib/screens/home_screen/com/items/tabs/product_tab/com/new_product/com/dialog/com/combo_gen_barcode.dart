import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/generate_barcode_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';

import 'dialog/barcode_bulk_view.dart';

class ComboGenBarCode extends StatefulWidget {
  const ComboGenBarCode({super.key});

  @override
  State<ComboGenBarCode> createState() => _ComboGenBarCodeState();
}

class _ComboGenBarCodeState extends State<ComboGenBarCode> {
  @override
  void initState() {
    super.initState();
    setUp();
  }

  GenBarcodePro? _genBarPro;

  void setUp() {
    _genBarPro = Provider.of<GenBarcodePro>(context, listen: false);
    _genBarPro?.init_2();
    _genBarPro?.getData_2();
  }

  @override
  void dispose() {
    _genBarPro?.comboClear();
    super.dispose();
  }

  void paginate(int page) {
    _genBarPro!.pageLoad_2 = true;
    _genBarPro!.notify;
    _genBarPro!.getData_2(page: page);
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final genPro = Provider.of<GenBarcodePro>(context);

    return Processing(
      loading: genPro.pageLoad_2,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.getH(24)),
            _bulkGenBtn(size, context, genPro: genPro),
            SizedBox(height: size.getH(24)),
            if (genPro.tableList_2.tableDataList.isEmpty && !genPro.pageLoad_2)
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
                tableData: genPro.tableList_2,
                paginate: paginate,
                total: genPro.barCodeTypeList_2?.total,
                page: genPro.pageIndex_2,
                selectItem: (v) {
                  genPro.notify;
                },
              ),
          ],
        ),
      ),
    );
  }

  ElevatedButton _bulkGenBtn(
    Ssize size,
    BuildContext context, {
    required GenBarcodePro genPro,
  }) {
    final isOpen = !genPro.pageLoad_2 &&
        genPro.tableList_2.tableDataList.any((e) => e.selected);
    return ElevatedButton(
        style: ButtonStyle(
            padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                vertical: size.getH(6), horizontal: size.getW(12))),
            backgroundColor: WidgetStateProperty.all(Colors.white),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: isOpen ? kSecondaryColor : Colors.black26,
              ),
            ))),
        onPressed: isOpen
            ? () async {
                await genPro.getBulkBarCode(type: BarCodeType.Combo);
                await showDialog(
                    context: context,
                    builder: (builder) => SimpleDialog(
                          backgroundColor: kBackgroundColor,
                          titlePadding: EdgeInsets.zero,
                          contentPadding: EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
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
        ));
  }
}
