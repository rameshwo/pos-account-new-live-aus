import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/switch_adap.dart';

class RawIngreSec extends StatelessWidget {
  final Function()? remove;
  final Animation<double> animation;
  final RawIngre? rawIngre;
  final NewProductPro? pro;
  const RawIngreSec({
    super.key,
    this.remove,
    required this.animation,
    this.rawIngre,
    this.pro,
  });

  void onChanged(bool isSmaller, {String? factor}) {
    final _factor = factor?.inDouble ?? 1;
    if (isSmaller) {
      final gram = rawIngre?.qtySmallCltr.text.inDouble ?? 0;
      rawIngre?.qtyLargeCltr.text = (gram / _factor).formatDoubleN(digit: 3);
    } else {
      final kilo = rawIngre?.qtyLargeCltr.text.inDouble ?? 0;
      rawIngre?.qtySmallCltr.text = (kilo * _factor).formatDoubleN(digit: 3);
    }
    if (pro != null) pro!.notify;
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _rawIngre = pro?.addSecRes?.rawLooseIngredients != null &&
            rawIngre?.ingreIndex != null
        ? (pro?.addSecRes?.rawLooseIngredients?[rawIngre!.ingreIndex!])
        : null;
    return SizeTransition(
      sizeFactor: animation,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: TitleDropDown(
              isDense: true,
              errH: 0,
              vPad: 4,
              isReq: true,
              borderColor: Colors.black54,
              borderRadius: 5,
              hintText: "Choose Raw Ingredients",
              list: pro?.addSecRes?.rawLooseIngredients == null
                  ? []
                  : pro?.addSecRes?.rawLooseIngredients
                          ?.map((e) => e.name ?? '')
                          .toSet()
                          .toList() ??
                      [],
              indexVal: rawIngre?.ingreIndex,
              title: 'Ingredients',
              onChanged: (val) {
                if (val == null) return;
                rawIngre?.ingreIndex = val;
                rawIngre?.nameCltr.text =
                    pro?.addSecRes?.rawLooseIngredients?[val].name ?? '';
                if (pro != null) pro!.notify;
              },
            ),
          ),
          SizedBox(
            width: size.getW(18),
          ),
          Expanded(
            flex: 2,
            child: TitleTextForm(
              isDense: true,
              errH: 0,
              isReq: true,
              borderColor: Colors.black54,
              borderRadius: 5,
              title: 'Name',
              textCltr: rawIngre == null
                  ? TextEditingController()
                  : rawIngre!.nameCltr,
              hintText: 'Name',
            ),
          ),
          if (rawIngre?.ingreIndex != null) ...[
            SizedBox(
              width: size.getW(18),
            ),
            Expanded(
              flex: 2,
              child: TitleTextForm(
                isDense: true,
                errH: 0,
                isReq: false,
                borderColor: Colors.black54,
                borderRadius: 5,
                title: _rawIngre?.minMeasurementName ?? 'Name',
                textCltr: rawIngre == null
                    ? TextEditingController()
                    : rawIngre!.qtySmallCltr,
                hintText: _rawIngre?.minMeasurementName ?? '',
                onChanged: (val) {
                  onChanged(true, factor: _rawIngre?.maxToMinConversionFactor);
                },
                textInputType: TextInputType.number,
              ),
            ),
            SizedBox(
              width: size.getW(18),
            ),
            Expanded(
              flex: 2,
              child: TitleTextForm(
                isDense: true,
                errH: 0,
                isReq: false,
                borderColor: Colors.black54,
                borderRadius: 5,
                title: _rawIngre?.maxMeasurementName ?? 'Name',
                textCltr: rawIngre == null
                    ? TextEditingController()
                    : rawIngre!.qtyLargeCltr,
                hintText: _rawIngre?.maxMeasurementName ?? "",
                onChanged: (val) {
                  onChanged(false, factor: _rawIngre?.maxToMinConversionFactor);
                },
                textInputType: TextInputType.number,
              ),
            )
          ],
          SizedBox(
            width: size.getW(18),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "Status",
                  style: TextStyle(
                    fontSize: size.getS(18),
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SwitchAdap(
                  size: size,
                  value: rawIngre?.status ?? false,
                  onChanged: (p) {
                    rawIngre!.status = p;
                    if (pro != null) pro!.notify;
                  },
                ),
              ],
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: InkWell(
              onTap: remove,
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
          Expanded(
              flex: rawIngre?.ingreIndex != null ? 1 : 5, child: Container()),
          SizedBox(
            width: size.getW(18 * (rawIngre?.ingreIndex != null ? 2 : 4)),
          ),
        ],
      ),
    );
  }
}
