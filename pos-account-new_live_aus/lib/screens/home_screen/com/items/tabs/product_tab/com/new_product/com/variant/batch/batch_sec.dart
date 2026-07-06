import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:provider/provider.dart';

class VariantBatchSection extends StatelessWidget {
  final Function()? remove;
  final Animation<double> animation;
  final Batch? batch;

  const VariantBatchSection(
      {super.key, this.remove, required this.animation, this.batch});

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<NewProductPro>(context);
    final size = Ssize(context);
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.getH(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Divider(
            //   color: Colors.black38,
            // ),
            // SizedBox(
            //   height: size.getH(4),
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Batch Number",
                        style: TextStyle(
                          fontSize: size.getS(14),
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: size.getH(6),
                      ),
                      TextFormWidget(
                          isDense: true,
                          isReq: false,
                          errH: 0,
                          borderColor: Colors.black54,
                          borderRadius: 5,
                          cltr: batch == null
                              ? TextEditingController()
                              : batch!.batchNoCltr,
                          hintText: ""),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.getW(18),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Stock Count",
                        style: TextStyle(
                          fontSize: size.getS(14),
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: size.getH(6),
                      ),
                      TextFormWidget(
                        readOnly: batch?.isEdit ?? false,
                        fillColor: (batch?.isEdit ?? false)
                            ? Colors.grey[200]!
                            : Colors.white,
                        isDense: true,
                        errH: 0,
                        // validator: (val) {
                        //   if (batch?.batchNoCltr.text.isNotEmpty ?? false) {
                        //     if (val == null || val.isEmpty) {
                        //       return "Stock Count is required";
                        //     }
                        //   }
                        //   return null;
                        // },
                        isReq: false,
                        borderColor: Colors.black54,
                        borderRadius: 5,
                        cltr: batch == null
                            ? TextEditingController()
                            : batch!.stockCountCltr,
                        hintText: "",
                        textInputType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.getW(18),
                ),
                Visibility(
                  visible: batch?.isEdit ?? false,
                  child: Expanded(
                      child: TitleTextForm(
                    title: LN.runningStock,
                    readOnly: batch?.isEdit ?? false,
                    fillColor: (batch?.isEdit ?? false)
                        ? Colors.grey[200]!
                        : Colors.white,
                    isDense: true,
                    errH: 0,
                    isReq: false,
                    borderColor: Colors.black54,
                    borderRadius: 5,
                    textCltr: batch == null
                        ? TextEditingController()
                        : batch!.runningStockCltr ?? TextEditingController(),
                    hintText: "",
                    textInputType: TextInputType.number,
                  )),
                ),
                SizedBox(
                  width: size.getW(18),
                ),
                Expanded(
                  child: TitleTextForm(
                    title: LN.expiryDate,
                    isDense: true,
                    isReq: false,
                    readOnly: true,
                    errH: 0,
                    borderColor: Colors.black54,
                    borderRadius: 5,
                    textCltr: TextEditingController(
                      text: batch == null
                          ? ""
                          : batch!.batchExpiryCltr.text.split(" ")[0],
                    ),
                    hintText: LN.chooseDate,
                    textInputType: TextInputType.text,
                    suffixIcon: Icon(Icons.calendar_month_outlined),
                    suffixIconWidth: 36,
                    // hintStyle: TextStyle(fontSize: size.getS(14)),
                    onTap: () async {
                      final dateFormat = await SharedPrefs.dateFormat;
                      Utils.datePick(context,
                              initDate: batch == null
                                  ? null
                                  : batch!.batchExpiryCltr.text.isEmpty
                                      ? null
                                      : DateFormat(dateFormat)
                                          .parse(batch!.batchExpiryCltr.text))
                          .then((date) {
                        if (date == null) return;
                        batch!.batchExpiryCltr.text =
                            DateFormat(dateFormat).format(date);
                        pro.notify;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: size.getW(18),
                ),
                Visibility(
                  visible: batch?.isEdit ?? false ? false : true,
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.zero,
                    shadowColor: Colors.grey[200],
                    color: kIconBackColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: InkWell(
                      onTap: remove,
                      child: Padding(
                        padding: EdgeInsets.all(size.getW(11.0)),
                        child: SvgPicture.asset(
                          "assets/svg/icons/Delete.svg",
                          width: size.getW(17),
                          height: size.getW(18),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Visibility(
              visible: batch?.isEdit ?? false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.getH(15),
                  ),
                  Container(
                    padding: EdgeInsets.all(size.getW(5)),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 25, 163, 175).withAlpha(70),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: size.getW(8),
                          ),
                          Text(
                            "Do You Want To Add The Additional Stock On This Product Variance ?  ",
                            style: TextStyle(
                              fontSize: size.getS(14),
                              color: Colors.white,
                              fontFamily: kFontFMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.getH(7),
                  ),
                  Text(
                    "Additional Stock",
                    style: TextStyle(
                      fontSize: size.getS(14),
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: size.getH(4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormWidget(
                          readOnly: false,
                          isDense: true,
                          errH: 0,
                          isReq: false,
                          borderColor: Colors.black54,
                          borderRadius: 5,
                          cltr: batch == null
                              ? TextEditingController()
                              : batch!.addStockCltr ?? TextEditingController(),
                          hintText: "",
                          textInputType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        width: size.getW(18),
                      ),
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.zero,
                        shadowColor: Colors.grey[200],
                        color: kIconBackColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: InkWell(
                          onTap: () {
                            batch!.addStockCltr?.text = "";
                            pro.notify;
                          },
                          child: Padding(
                            padding: EdgeInsets.all(size.getW(6.0)),
                            child: SvgPicture.asset(
                              "assets/svg/icons/Delete.svg",
                              width: size.getW(17),
                              height: size.getW(18),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.getW(18),
                      ),
                      Expanded(
                        flex: 4,
                        child: SizedBox(
                          width: size.getW(18),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
