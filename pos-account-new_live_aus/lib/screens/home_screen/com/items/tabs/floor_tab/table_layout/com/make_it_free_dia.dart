import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/booking/table_status_update_req.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';
import 'package:pos_account/providers/booking/table_arrange_pro.dart';
import 'package:provider/provider.dart';

class MakeItFreeDia extends StatelessWidget {
  final List<TableStatusUpdateReq> model;
  final Function(List<TableStatusUpdateReq>) onDone;
  const MakeItFreeDia({super.key, required this.model, required this.onDone});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final taPro = Provider.of<TableArrangePro>(context);
    final _allowYes = model.any((e) => e.selected);
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
                LN.makeTableFree,
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
                "Select the tables to make it free.",
                style: TextStyle(
                  fontSize: size.getS(16),
                  fontFamily: kFontFMedium,
                  color: Colors.black,
                ),
              ),
              if (model.any((a) => a.orderId?.isNotEmpty ?? false))
                Container(
                  margin:
                      EdgeInsets.only(top: size.getH(12), bottom: size.getH(4)),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getW(12), vertical: size.getH(6)),
                  decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(40)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info,
                        size: size.getS(25),
                        color: Colors.red.shade700,
                      ),
                      SizedBox(width: size.getW(12)),
                      Expanded(
                        child: Text(
                          "You have already an order associated with tables. Click 'Yes' to make it free.",
                          style: TextStyle(
                            fontSize: size.getS(14),
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: size.getH(16),
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
                itemCount: model.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      model[index].selected = !model[index].selected;
                      taPro.notify;
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: size.getH(8), right: size.getW(8)),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: model[index].selected
                                  ? kSecondaryColor
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: model[index].selected
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
                                  model[index].name ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: size.getS(18),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: kFontFMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (model[index].selected)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: size.getS(24),
                              height: size.getS(24),
                              decoration: BoxDecoration(
                                color: kSecondaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
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
                height: size.getH(24),
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
                          LN.no,
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
                            backgroundColor:
                                _allowYes ? Colors.green.shade700 : Colors.grey,
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
                                final _newModel = <TableStatusUpdateReq>[];
                                for (final b in model) {
                                  if (b.selected) {
                                    _newModel.add(b
                                      ..status = FloorTblStatus.Available.name);
                                  }
                                }

                                Navigator.pop(context);
                                Future.delayed(Duration(milliseconds: 200), () {
                                  onDone(_newModel);
                                });
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
      ],
    );
  }
}
