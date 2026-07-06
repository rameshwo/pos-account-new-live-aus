import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/table_layout/all_table_lay_res.dart';

class AllTableLaySec extends StatelessWidget {
  final Ssize size;
  final AllTableLayRes? allTableLayRes;
  final Function()? createNew;
  final Function(int)? onTabTable;

  const AllTableLaySec(
      {super.key,
      required this.size,
      this.allTableLayRes,
      this.createNew,
      this.onTabTable});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: size.getH(12),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(kSecondaryColor)),
              onPressed: createNew,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: size.getS(24),
                  ),
                  SizedBox(
                    width: size.getW(4),
                  ),
                  Text(
                    LN.creatNewLayout,
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
        ),
        SizedBox(
          height: size.getH(12),
        ),
        if (allTableLayRes != null &&
            allTableLayRes!.data != null &&
            allTableLayRes!.data!.isNotEmpty)
          Wrap(
              spacing: size.getW(10),
              runSpacing: size.getH(12),
              children: List.generate(
                  allTableLayRes!.data!.length,
                  (index) => Card(
                        // color: kSecondaryColor.withAlpha(200),
                        // shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: SizedBox(
                          width: size.width / 2.7, //size.getW(200),
                          // height: size.getH(200),
                          child: InkWell(
                            onTap: onTabTable == null
                                ? null
                                : () => onTabTable!(index),
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.getH(24.0),
                                  horizontal: size.getW(24)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    allTableLayRes!
                                            .data![index].tableLocationName ??
                                        '',
                                    style: TextStyle(
                                      fontSize: size.getS(24),
                                      fontFamily: kFontFMedium,
                                      // color: kSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )))
      ],
    );
  }
}
