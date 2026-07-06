import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/payment/cus_loyal_res.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/phone_service/local_server.dart';
import 'com/customer_detail_sec.dart';

class IncomingCallDia extends StatelessWidget {
  final Function()? onAccept;
  final Function()? onPop;
  final CusForLoyalityRes? cusData;
  const IncomingCallDia({
    super.key,
    this.onPop,
    this.onAccept,
    this.cusData,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      width: size.getW(900),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(
          vertical: size.getH(16), horizontal: size.getW(24)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.call,
            size: size.getS(24),
          ),
          SizedBox(
            width: size.getW(12),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (cusData?.line != null)
                Text(
                  "${LN.line} ${int.tryParse(cusData!.line!)}",
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontFamily: kFontFMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Text(
                LN.incomingCall,
                style: TextStyle(
                  fontSize: size.getS(15),
                  fontFamily: kFontFMedium,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text.rich(
                TextSpan(
                    text: (cusData?.customerName?.isNotEmpty ?? false)
                        ? "${cusData!.customerName} • "
                        : "",
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontFamily: kFontFMedium,
                    ),
                    children: [
                      TextSpan(
                        text: cusData?.phoneNumber ?? '',
                        style: TextStyle(
                          fontSize: size.getS(17),
                          fontFamily: kFontFMedium,
                        ),
                      ),
                    ]),
              ),
            ],
          ),
          Spacer(),
          TextButton(
              onPressed: onAccept,
              style: ButtonStyle(
                  side: WidgetStateProperty.all(BorderSide(
                    color: kSecondaryColor,
                  )),
                  padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                      vertical: size.getH(12), horizontal: size.getW(28)))
                  // visualDensity: VisualDensity.compact,
                  ),
              child: Text(
                LN.accept,
                style: TextStyle(
                  fontSize: size.getS(15),
                  fontFamily: kFontFMedium,
                  color: kSecondaryColor,
                ),
              )),
          SizedBox(
            width: size.getW(24),
          ),
          TextButton(
              onPressed: onPop,
              style: ButtonStyle(
                  // visualDensity: VisualDensity.compact,
                  ),
              child: Text(
                LN.decline,
                style: TextStyle(
                  fontSize: size.getS(14),
                  fontFamily: kFontFMedium,
                  color: Colors.black54,
                ),
              ))
        ],
      ),
    );
  }
}

class SlideInDialog extends StatefulWidget {
  final List<CusForLoyalityRes>? cusDataList;
  final Function()? onUpdate;
  const SlideInDialog({super.key, this.cusDataList, this.onUpdate});

  @override
  _SlideInDialogState createState() => _SlideInDialogState();
}

class _SlideInDialogState extends State<SlideInDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, -1.0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linearToEaseOut,
    ));

    // Start the animation when the widget is first built
    _animationController.forward();
  }

  @override
  void dispose() async {
    // _cusHisPro.clear();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _reverse() async => await _animationController.reverse();

  // double _dragStartY = 0.0;

  ///
  Future<void> _removeWidget({final String? phoneNumber}) async {
    if (phoneNumber == null || widget.onUpdate == null) return;

    final phoneData =
        phoneNumber.replaceAll("+", "").replaceAll("-", "").trim();

    if (widget.cusDataList != null &&
        widget.cusDataList!.any(
            (e) => e.phoneNumber?.toLowerCase() == phoneData.toLowerCase())) {
      widget.cusDataList!.removeWhere(
          (e) => e.phoneNumber?.toLowerCase() == phoneData.toLowerCase());
    }
    widget.onUpdate!();

    await Future.delayed(Duration(milliseconds: 300), () {
      widget.onUpdate!();

      if (widget.cusDataList!.isEmpty) {
        Navigator.pop(context);
      }
    });
  }

  Future<void> _addRecentCalls({String? number, bool isAccept = false}) async {
    if (number == null) return;
    await Handler.addRecentCalls(phone: number, isAccept: isAccept);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _reverse();
        }
      },
      child: SlideTransition(
        position: _offsetAnimation,
        child: GestureDetector(
          onVerticalDragDown: (details) {
            // _dragStartY = details.localPosition.dy;
          },
          onVerticalDragUpdate: (details) async {
            // double dragDelta = details.localPosition.dy + _dragStartY;
            // double screenHeight = MediaQuery.of(context).size.height;
            // final _dragDistance = dragDelta / screenHeight;

            // _animationController.value = _dragDistance.clamp(0.0, 1.0);
          },
          onVerticalDragEnd: (details) async {
            // if (_animationController.value < 0.5) {
            //   await _reverse();
            //   Navigator.pop(context);
            // } else {
            //   _animationController.forward();
            // }
          },
          child: SimpleDialog(
            alignment: Alignment.topCenter,
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            //  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            // shape:
            //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            children: [
              if (widget.cusDataList != null)
                ...List.generate(widget.cusDataList!.length, (i) {
                  return Column(
                    children: [
                      IncomingCallDia(
                        cusData: widget.cusDataList![i],
                        onPop: () async {
                          // Navigator.pop(context);
                          _addRecentCalls(
                              number: widget.cusDataList?[i].phoneNumber,
                              isAccept: false);
                          if (widget.cusDataList!.length == 1) await _reverse();
                          _removeWidget(
                              phoneNumber: widget.cusDataList![i].phoneNumber);
                        },
                        onAccept: () async {
                          // close on other device
                          LocalServer.sendData(
                              number: widget.cusDataList?[i].phoneNumber);
                          _addRecentCalls(
                              number: widget.cusDataList?[i].phoneNumber,
                              isAccept: true);
                          if (widget.cusDataList!.length == 1) await _reverse();
                          final cusdata = widget.cusDataList![i];
                          await _removeWidget(
                              phoneNumber: widget.cusDataList![i].phoneNumber);

                          CustomerDetailSection.showDia(cusData: cusdata);
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
