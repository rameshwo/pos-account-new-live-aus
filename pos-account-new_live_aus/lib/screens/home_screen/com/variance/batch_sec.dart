import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/date_format_keys.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';

class BatchSection extends StatelessWidget {
  final List<ProductVariationBatchStock> batchList;
  final Function() onUpdate;
  final String? dateFormat;
  final bool isBatch;
  const BatchSection({
    super.key,
    required this.batchList,
    required this.onUpdate,
    this.dateFormat,
    this.isBatch = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(8.0), vertical: size.getH(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                    text: "Batch Stocks",
                    style: TextStyle(
                      fontSize: size.getS(18),
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                    children: [
                      if (!isBatch)
                        TextSpan(
                          text: " (Stock will be deducted based on FIFO)",
                          style: TextStyle(
                            fontSize: size.getS(16),
                            color: kSecondaryColor,
                            fontFamily: kFontFRegular,
                          ),
                        )
                    ]),
              ),
              SizedBox(height: size.getH(4)),
              Wrap(
                spacing: size.getW(24),
                runSpacing: size.getH(12),
                children: List.generate(batchList.length, (index) {
                  bool isExpired = false;
                  String expireDate = "";

                  if (batchList[index].expiryDate?.isNotEmpty ?? false) {
                    try {
                      isExpired = GET_DATE_FORMAT(dateFormat ?? '')
                              .parse(batchList[index].expiryDate ?? '')
                              .difference(DateTime.now())
                              .inDays <
                          0;
                    } catch (e) {
                      //
                    }

                    expireDate =
                        batchList[index].expiryDate?.split(' ').first ?? '';
                  } else {
                    isExpired = false;
                  }

                  return InkWell(
                    onTap: () {
                      batchList.forEach((e) {
                        e.isActive = false;
                      });

                      batchList[index].isActive = true;
                      onUpdate();
                    },
                    child: Container(
                      width: size.getW(200),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: batchList[index].isActive
                                  ? kSecondaryColor
                                  : isExpired
                                      ? Colors.red.shade700
                                      : Colors.grey.shade600),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: batchList[index].isActive
                                    ? kSecondaryColor
                                    : isExpired
                                        ? Colors.red.shade700
                                        : Colors.grey.shade600,
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.symmetric(
                                horizontal: size.getW(12),
                                vertical: size.getH(8)),
                            child: Text(
                              'Batch : ${batchList[index].batchNumber ?? ''}',
                              style: TextStyle(
                                fontSize: size.getS(16),
                                color: Colors.white,
                                fontFamily: kFontFMedium,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (batchList[index].stockCount?.isNotEmpty ?? false)
                            Text(
                              'Stock : ${batchList[index].stockCount ?? ''}',
                              style: TextStyle(
                                fontSize: size.getS(16),
                                color: batchList[index].isActive
                                    ? Colors.black
                                    : Colors.black54,
                                fontFamily: kFontFMedium,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if (expireDate.isNotEmpty)
                            Text(
                              'Expiry Date : $expireDate',
                              style: TextStyle(
                                fontSize: size.getS(16),
                                color: isExpired && batchList[index].isActive
                                    ? Colors.red.shade700
                                    : batchList[index].isActive
                                        ? Colors.black
                                        : Colors.black54,
                                fontFamily: kFontFMedium,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if ((batchList[index].stockCount?.isNotEmpty ??
                                  false) &&
                              batchList[index].stockCount!.inDouble <= 0)
                            _status(size, title: 'Out of Stock')
                          else if (isExpired)
                            _status(size, title: 'Expired'),
                          SizedBox(
                            height: size.getH(4),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: size.getH(12)),
            ],
          ),
        ),
      ),
    );
  }

  Container _status(Ssize size, {required String title}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red.shade700, borderRadius: BorderRadius.circular(25)),
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(12), vertical: size.getH(4)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: size.getS(12),
          color: Colors.white,
          fontFamily: kFontFMedium,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
