import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';

class ItemPriceView extends StatelessWidget {
  final Ssize size;
  final String? curSym;
  final String? priceAfterDiscount;
  final String? initPrice;
  final double fontRatio;
  final String? title;
  final bool bold;
  final List<Color> textColors;
  const ItemPriceView({
    super.key,
    required this.size,
    this.priceAfterDiscount,
    this.initPrice,
    this.curSym,
    this.fontRatio = 1,
    this.title,
    this.bold = true,
    this.textColors = const [Colors.black, Colors.red],
  });

  @override
  Widget build(BuildContext context) {
    // final _showDiscount = priceAfterDiscount?.inDouble != null &&
    //     priceAfterDiscount?.inDouble != 0 &&
    //     priceAfterDiscount?.inDouble != initPrice.inDouble;
    final _showDiscount = priceAfterDiscount?.inDouble != null &&
        priceAfterDiscount.inDouble != initPrice.inDouble;
    return Align(
      alignment: Alignment.topCenter,
      child: Text.rich(
        TextSpan(
          text: "",
          children: [
            if (title != null)
              TextSpan(
                text: title,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  overflow: TextOverflow.visible,
                  fontSize: size.getS(13.5 * fontRatio),
                  fontFamily: kFontFMedium,
                  fontWeight: FontWeight.normal,
                ),
              ),
            if (_showDiscount)
              TextSpan(
                text: "${curSym ?? ''}$priceAfterDiscount ",
                style: TextStyle(
                  decoration: TextDecoration.none,
                  overflow: TextOverflow.visible,
                ),
              ),
            TextSpan(
              text: "${curSym ?? ''}$initPrice",
              style: (_showDiscount)
                  ? TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: size.getS(14 * fontRatio),
                      color: textColors.last, // Colors.red,
                      overflow: TextOverflow.visible,
                    )
                  : null,
            )
          ],
        ),
        style: TextStyle(
          fontSize: size.getS(16 * fontRatio),
          fontFamily: kFontFMedium,
          fontWeight: bold ? FontWeight.bold : null,
          color: textColors.first, // Colors.black,
        ),
        // maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// class ItemTimerView extends StatefulWidget {
//   final Ssize size;
//   final PromDiscount promDiscount;
//   final bool showMessage;
//   final Function()? refresh;
//   const ItemTimerView({
//     super.key,
//     required this.size,
//     required this.promDiscount,
//     this.showMessage = false,
//     this.refresh,
//   });

//   @override
//   State<ItemTimerView> createState() => _ItemTimerViewState();
// }

// class _ItemTimerViewState extends State<ItemTimerView> {
//   Timer? _timer;

//   String? _getTime() {
//     final d = Duration(seconds: _time);
//     if (d.inSeconds >= 0) {
//       String twoDigits(int n) => n.toString().padLeft(2, '0');
//       String twoDigitHours = twoDigits(d.inHours);
//       String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
//       String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
//       return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
//     }
//     return null;
//   }

//   int _time = 0;
//   int _offerRunTime = 0;

//   void _periodicRefresh() {
//     _time = widget.promDiscount.offerStartsIn?.inSeconds ?? 0;
//     _offerRunTime = widget.promDiscount.offerEndsIn?.inSeconds ?? 0;
//     _timer = Timer.periodic(Duration(seconds: 1), (_) {
//       if (_time == 0) {
//         if (widget.refresh != null) widget.refresh!();
//       }

//       if (_time >= 0) {
//         _time -= 1;
//       } else if (_offerRunTime >= 0) {
//         _offerRunTime -= 1;
//       } else if (_timer != null) {
//         if (widget.refresh != null) widget.refresh!();
//         _timer!.cancel();
//       }

//       _show = true;

//       if (mounted) setState(() {});
//     });
//   }

//   bool _show = false;

//   @override
//   void initState() {
//     _periodicRefresh();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     if (_timer != null) _timer!.cancel();
//     _show = false;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = widget.size;
//     // print("_time : $_time | _offerRunTime: $_offerRunTime");

//     if (!_show) return SizedBox.shrink();

//     final offerStartsIn = _getTime();
//     final isOfferRunning = _offerRunTime >= 0 && _time <= 0;

//     if (_time > 300) return SizedBox.shrink();

//     return Container(
//       margin: EdgeInsets.only(top: size.getH(6)),
//       padding: EdgeInsets.symmetric(
//           horizontal: size.getW(8), vertical: size.getH(2)),
//       decoration: BoxDecoration(
//           color: isOfferRunning
//               ? Colors.green.withAlpha(60)
//               : Colors.red.withAlpha(60),
//           borderRadius: BorderRadius.circular(5)),
//       child: Text.rich(
//         TextSpan(
//           text: isOfferRunning ? "Offer available" : "Offer available in",
//           children: [
//             if (!isOfferRunning && offerStartsIn != null)
//               TextSpan(
//                 text: "\n$offerStartsIn",
//                 style: TextStyle(
//                   fontSize: size.getS(15),
//                   fontFamily: kFontFMedium,
//                   height: 1.1,
//                 ),
//               ),
//           ],
//         ),
//         style: TextStyle(
//           fontSize: size.getS(isOfferRunning ? 15 : 13),
//           color: isOfferRunning ? Colors.green.shade800 : Colors.red.shade800,
//           fontWeight: FontWeight.bold,
//         ),
//         maxLines: 2,
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }
