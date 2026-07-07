import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/table_id_name.dart';
import 'package:pos_account/providers/booking/table_arrange_pro.dart';
import 'package:provider/provider.dart';

class MergeConfirmDialog extends StatelessWidget {
  final List<TableIdName> tableList;
  const MergeConfirmDialog({
    super.key,
    required this.tableList,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final taPro = Provider.of<TableArrangePro>(context);
    final _allowYes = tableList.any((e) => e.selected);
    return SimpleDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: size.height / 1.14,
              minHeight: size.height / 5,
            ),
            width: size.width / 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Merge Table & Place Order",
                  style: TextStyle(
                    fontSize: size.getS(22),
                    fontFamily: kFontFMedium,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: size.getH(6),
                ),
                Text(
                  "Please make sure if you want to merge all the selected tables",
                  style: TextStyle(
                    fontSize: size.getS(16),
                    fontFamily: kFontFMedium,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "(Unselect the tables if you want to unmerge)",
                  style: TextStyle(
                    fontSize: size.getS(15),
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  height: size.getH(32),
                ),
                Flexible(
                    child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 9,
                  ),
                  shrinkWrap: true,
                  itemCount: tableList.length,
                  itemBuilder: (context, index) {
                    final _hasMergeId =
                        tableList[index].mergeId?.isNotEmpty ?? false;
                    return GestureDetector(
                      onTap: _hasMergeId
                          ? null
                          : () {
                              tableList[index].selected =
                                  !tableList[index].selected;
                              taPro.notify;
                            },
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: size.getH(8), right: size.getW(8)),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _hasMergeId
                                    ? kSecondaryColor.withOpacity(0.5)
                                    : tableList[index].selected
                                        ? kSecondaryColor
                                        : Colors.grey.shade400,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: tableList[index].selected
                                  ? kSecondaryColor.withOpacity(0.1)
                                  : Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: size.getW(12)),
                                Expanded(
                                  child: Text(
                                    tableList[index].name ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: size.getS(18),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: kFontFMedium,
                                        color: _hasMergeId
                                            ? Colors.black45
                                            : Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (tableList[index].selected)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: size.getS(_hasMergeId ? 120 : 24),
                                height: size.getS(24),
                                padding: _hasMergeId
                                    ? EdgeInsets.symmetric(
                                        horizontal: size.getW(12),
                                        vertical: size.getH(2))
                                    : null,
                                decoration: BoxDecoration(
                                  color: _hasMergeId
                                      ? Colors.red.shade700
                                      : kSecondaryColor,
                                  shape: _hasMergeId
                                      ? BoxShape.rectangle
                                      : BoxShape.circle,
                                  borderRadius: _hasMergeId
                                      ? BorderRadius.circular(20)
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: _hasMergeId
                                    ? Text(
                                        "Occupied",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.getS(14)),
                                      )
                                    : Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: size.getS(16),
                                      ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                )),
                SizedBox(
                  height: size.getH(36),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(),
                                  borderRadius: BorderRadius.circular(5)),
                              textStyle: TextStyle(
                                // fontSize: size.getS(15),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.getW(48),
                                  vertical: size.getH(12))),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            LN.cancel,
                            style: TextStyle(
                              fontSize: size.getS(18),
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                    SizedBox(
                      width: size.getS(12),
                    ),
                    Expanded(
                      child: TextButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: _allowYes
                                  ? Colors.green.shade700
                                  : Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.getW(48),
                                  vertical: size.getH(12))),
                          onPressed: _allowYes
                              ? () {
                                  final _newModel = tableList.where((b) => b.selected).toList();
                                  Navigator.pop(context, _newModel);
                                }
                              : () {},
                          child: Text(
                            LN.yes,
                            style: TextStyle(
                              fontSize: size.getS(18),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.getH(12),
                ),
              ],
            ),
          )
        ]);
  }
}
