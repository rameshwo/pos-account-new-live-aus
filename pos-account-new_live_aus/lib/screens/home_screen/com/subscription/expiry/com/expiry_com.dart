import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/billing_and_subs/billing_subs_plan.dart';

class PlanSection extends StatefulWidget {
  final Ssize size;
  final Function()? buyNow;
  final BillingSubsPlan? subsPlan;
  final bool load;
  final bool showBuyBtn;
  final Function()? onTap;
  final bool isSelected;
  final String? curSym;
  const PlanSection({
    super.key,
    required this.size,
    this.buyNow,
    this.subsPlan,
    this.load = false,
    this.showBuyBtn = true,
    this.onTap,
    this.isSelected = false,
    this.curSym,
  });

  @override
  State<PlanSection> createState() => _PlanSectionState();
}

class _PlanSectionState extends State<PlanSection> {
  final ScrollController _scrollController = ScrollController();

  bool _scrollingDown = true;

  @override
  void initState() {
    super.initState();
    _scroll();
  }

  void _scroll() async {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      if (_scrollingDown) {
        if (_scrollController.hasClients)
          await _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(seconds: 32),
            curve: Curves.linear,
          );
      } else {
        if (_scrollController.hasClients)
          await _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
          );
      }
      _scrollingDown = !_scrollingDown;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = (widget.subsPlan?.numberOfDevicePlanPrices != null &&
            widget.subsPlan!.numberOfDevicePlanPrices!
                .any((e) => e.isDefault ?? false))
        ? widget.subsPlan!.numberOfDevicePlanPrices!
            .firstWhere((e) => e.isDefault ?? false)
        : null;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: widget.isSelected ? kTempColor : Colors.transparent,
          width: 3,
        ),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(10),
        highlightColor: kSecondaryColor.withAlpha(50),
        splashColor: kSecondaryColor.withAlpha(60),
        child: SizedBox(
          width: widget.size.getW(325),
          height: widget.size.getH(700),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: widget.size.getH(12),
                horizontal: widget.size.getW(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? kTempColor
                        : Colors.black.withAlpha(5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: widget.size.getH(8),
                      horizontal: widget.size.getW(12)),
                  child: Text(
                    widget.subsPlan?.subscriptionPlanName ?? '',
                    style: TextStyle(
                      fontSize: widget.size.getS(18),
                      fontFamily: kFontFMedium,
                      color: widget.isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: widget.size.getH(12),
                ),
                if (selected != null) ...[
                  Text(
                    "${widget.curSym ?? ''}${selected.price ?? ''} ${widget.subsPlan?.currencyCode ?? ''}",
                    style: TextStyle(
                      fontSize: widget.size.getS(36),
                      fontFamily: kFontFMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${LN.perMonLoc},\n${LN.per} ${selected.numberOfDevice == null || selected.numberOfDevice == '1' ? LN.device : '${selected.numberOfDevice!} ${LN.devices}'}',
                    style: TextStyle(
                      fontSize: widget.size.getS(16),
                      fontFamily: kFontFMedium,
                      color: Colors.black,
                    ),
                  )
                ],
                // else
                //   SizedBox(
                //     height: size.getH(100),
                //   ),
                SizedBox(
                  height: widget.size.getH(12),
                ),
                Text(
                  LN.includes,
                  style: TextStyle(
                    fontSize: widget.size.getS(18),
                    fontFamily: kFontFMedium,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(
                  height: widget.size.getH(12),
                ),
                if (widget.subsPlan!.planItems != null &&
                    widget.subsPlan!.planItems!.isNotEmpty)
                  Expanded(
                    // height: size.getH(360),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            widget.subsPlan!.planItems!.length,
                            (i) => CheckBoxSection(
                                size: widget.size,
                                title: widget.subsPlan!.planItems![i])),
                      ),
                    ),
                  ),
                Text(
                  LN.integratePosapt,
                  style: TextStyle(
                    fontSize: widget.size.getS(16),
                    fontFamily: kFontFMedium,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: widget.size.getH(11),
                ),
                if (widget.showBuyBtn)
                  SizedBox(
                    width: widget.size.getW(160),
                    child: TextButton(
                      onPressed: widget.buyNow,
                      style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                              vertical: 2, horizontal: widget.size.getW(24))),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.teal)))),
                      child: widget.load
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  LN.loading,
                                  style: TextStyle(
                                    fontSize: widget.size.getS(16),
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: widget.size.getW(12),
                                ),
                                LoadingAnimationWidget.waveDots(
                                  color: Colors.teal,
                                  size: widget.size.getS(24),
                                ),
                              ],
                            )
                          : Text(
                              LN.buyNow,
                              style: TextStyle(
                                  fontSize: widget.size.getS(16),
                                  color: Colors.teal,
                                  fontFamily: kFontFMedium),
                            ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CheckBoxSection extends StatelessWidget {
  final Ssize size;
  final String title;
  final bool isChecked;
  final Function(bool?)? onChanged;
  const CheckBoxSection(
      {super.key,
      required this.size,
      required this.title,
      this.isChecked = true,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
          activeColor: kSecondaryColor,
          // fillColor: WidgetStateProperty.all(kSecondaryColor),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(top: size.getH(12)),
            child: Text(
              title,
              style: TextStyle(
                fontSize: size.getS(16),
                fontFamily: kFontFMedium,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
