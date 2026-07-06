import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/signal_r/place_order_info.dart';
import '../../services/signal_core/utils/stk_event_utils.dart';
import '../../constant/constant.dart';
import '../input/dropdown/drop_down.dart';
import '../load_btn.dart';

class NotifyItem {
  final PlaceOrderInfo? payLoad;
  int? minIndex;
  bool loading;

  NotifyItem({
    this.payLoad,
    this.minIndex,
    this.loading = false,
  });
}

class CusNotifyDia extends StatefulWidget {
  final List<NotifyItem> notifications;

  const CusNotifyDia({
    super.key,
    required this.notifications,
  });

  static bool _isOn = false;

  static final List<NotifyItem> _notifications = [];

  static GlobalKey<_CusNotifyDiaState>? _dialogKey;

  static Future<void> show({
    PlaceOrderInfo? payLoad,
  }) async {
    final item = NotifyItem(
      payLoad: payLoad,
    );

    /// Add new notification
    _notifications.insert(0, item);

    /// Dialog already open → refresh only
    if (_isOn) {
      _dialogKey?.currentState?.refresh();
      return;
    }

    _isOn = true;

    _dialogKey = GlobalKey<_CusNotifyDiaState>();

    Utils.playAlert();

    await showDialog(
      context: CUS_CTX!,
      barrierDismissible: false,
      builder: (_) {
        return CusNotifyDia(
          key: _dialogKey,
          notifications: _notifications,
        );
      },
    );

    _notifications.clear();

    _isOn = false;
  }

  @override
  State<CusNotifyDia> createState() => _CusNotifyDiaState();
}

class _CusNotifyDiaState extends State<CusNotifyDia>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  late List<NotifyItem> _items;

  void refresh() {
    if (!mounted) return;

    final newItem = widget.notifications.first;

    _items.insert(0, newItem);

    _listKey.currentState?.insertItem(
      0,
      duration: Duration(milliseconds: 400),
    );

    setState(() {});
  }

  void removeItem(Ssize size, int index) {
    if (index < 0 || index >= _items.length) return;

    final removedItem = _items[index];

    _items.removeAt(index);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: FadeTransition(
            opacity: animation,
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: size.getH(6),
              ),
              padding: EdgeInsets.all(size.getS(12)),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          removedItem.payLoad?.title ?? '',
                          style: TextStyle(
                            fontSize: size.getS(15),
                            fontFamily: kFontFMedium,
                            fontWeight: FontWeight.bold,
                            color: kSecondaryColor,
                          ),
                        ),
                        Text(
                          removedItem.payLoad?.body ?? '',
                          style: TextStyle(
                            fontSize: size.getS(18),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      duration: Duration(milliseconds: 400),
    );
  }

  void load() {
    if (mounted) setState(() {});
  }

  final _minuteList = [10, 15, 30, 45, 60, 90, 120, 180]; // min
  final _minuteStringList = <String>[];

  @override
  void initState() {
    super.initState();
    for (final a in _minuteList) {
      _minuteStringList.add(Utils.convertMinutesToHours(a.toString(), false));
    }
    _items = List.from(widget.notifications);

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
    Utils.stopAlert();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _reverse() async => await _animationController.reverse();

  ///
  Future<void> _removeWidget() async {
    await Future.delayed(Duration(milliseconds: 0), () {
      Utils.stopAlert();
      Navigator.pop(context);
    });
  }

  bool _sendAllTokitLoad = false;

  int? allMinIndex;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    // final _orderDataList = widget.orderDataList;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _reverse();
        }
      },
      child: SlideTransition(
        position: _offsetAnimation,
        child: SimpleDialog(
          alignment: Alignment.topCenter,
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          children: [
            Container(
              width: size.getW(900),
              constraints:
                  BoxConstraints(minHeight: 0, maxHeight: size.height / 1.05),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(
                  vertical: size.getH(16), horizontal: size.getW(24)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_active,
                        size: size.getS(28),
                        color: kSecondaryColor,
                      ),
                      SizedBox(
                        width: size.getW(12),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "New Order Received",
                                style: TextStyle(
                                  fontSize: size.getS(18),
                                  fontFamily: kFontFMedium,
                                  fontWeight: FontWeight.bold,
                                  color: kSecondaryColor,
                                ),
                              ),
                            ),
                            if (_items.length > 1)
                              LoadButton(
                                btnText: "Send All To Kitchen",
                                btnColor: Colors.white,
                                textColor: kSecondaryColor,
                                vPad: 10,
                                hPad: 4,
                                width: 200,
                                fontSize: 15,
                                loading: _sendAllTokitLoad,
                                loadingText: "Sending",
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusGeometry.circular(25),
                                  side: BorderSide(color: kSecondaryColor),
                                ),
                                onsave: () async {
                                  if (_items.any((a) => a.loading)) return;

                                  _sendAllTokitLoad = true;
                                  load();
                                  for (final a in _items) {
                                    if (a.payLoad != null) {
                                      await StkEventUtils.stkFromPopup(
                                        printInfo: a.payLoad!,
                                        extendTimeInMin: a.minIndex != null &&
                                                _minuteList.length > a.minIndex!
                                            ? _minuteList[a.minIndex!]
                                            : null,
                                      );
                                    }
                                  }
                                  _sendAllTokitLoad = false;
                                  load();
                                  _removeWidget();
                                },
                              ),
                            SizedBox(
                              width: size.getW(24),
                            ),
                            TextButton(
                                onPressed: () {
                                  _removeWidget();
                                },
                                style: ButtonStyle(
                                    side: WidgetStateProperty.all(BorderSide(
                                      color: Colors.black54,
                                    )),
                                    padding: WidgetStateProperty.all(
                                        EdgeInsets.symmetric(
                                            vertical: size.getH(12),
                                            horizontal: size.getW(28)))
                                    // visualDensity: VisualDensity.compact,
                                    ),
                                child: Text(
                                  LN.close,
                                  style: TextStyle(
                                    fontSize: size.getS(15),
                                    fontFamily: kFontFMedium,
                                    color: Colors.black87,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_items.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "For All Items, Extended Pickup/Delivery Time To",
                          style: TextStyle(
                            fontSize: size.getS(14),
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(width: size.getW(12)),
                        SizedBox(
                          width: size.getW(200),
                          child: DropDownList(
                            list: _minuteStringList,
                            indexValue: allMinIndex,
                            borderColor: Colors.black26,
                            vPad: 6,
                            hPad: 12,
                            onChange: (val) {
                              allMinIndex = val;
                              _items.forEach((a) => a.minIndex = val);
                              load();
                            },
                          ),
                        ),
                      ],
                    ),
                  Flexible(
                    child: AnimatedList(
                      key: _listKey,
                      shrinkWrap: true,
                      initialItemCount: _items.length,
                      reverse: true,
                      itemBuilder: (context, index, animation) {
                        final a = _items[index];

                        return SizeTransition(
                          sizeFactor: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                vertical: size.getH(6),
                              ),
                              padding: EdgeInsets.all(size.getS(12)),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.payLoad?.title ?? '',
                                    style: TextStyle(
                                      fontSize: size.getS(15),
                                      fontFamily: kFontFMedium,
                                      fontWeight: FontWeight.bold,
                                      color: kSecondaryColor,
                                    ),
                                  ),
                                  Text(
                                    a.payLoad?.body ?? '',
                                    style: TextStyle(
                                      fontSize: size.getS(18),
                                    ),
                                    maxLines: 3,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Extended Pickup/Delivery Time To",
                                        style: TextStyle(
                                          fontSize: size.getS(14),
                                        ),
                                        maxLines: 3,
                                      ),
                                      SizedBox(width: size.getW(12)),
                                      SizedBox(
                                        width: size.getW(200),
                                        child: DropDownList(
                                          list: _minuteStringList,
                                          indexValue: a.minIndex,
                                          borderColor: Colors.black26,
                                          vPad: 6,
                                          hPad: 12,
                                          onChange: (val) {
                                            a.minIndex = val;
                                            load();
                                          },
                                        ),
                                      ),
                                      Spacer(),
                                      LoadButton(
                                        btnText: "Send To Kitchen",
                                        btnColor: Colors.white,
                                        textColor: kSecondaryColor,
                                        vPad: 8,
                                        hPad: 4,
                                        width: 200,
                                        fontSize: 14,
                                        loading: a.loading,
                                        loadingText: "Sending",
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(25),
                                          side: BorderSide(
                                              color: kSecondaryColor),
                                        ),
                                        onsave: () async {
                                          if (_sendAllTokitLoad) return;

                                          if (a.payLoad == null) return;
                                          a.loading = true;
                                          load();
                                          await StkEventUtils.stkFromPopup(
                                            printInfo: a.payLoad!,
                                            extendTimeInMin:
                                                a.minIndex != null &&
                                                        _minuteList.length >
                                                            a.minIndex!
                                                    ? _minuteList[a.minIndex!]
                                                    : null,
                                          );

                                          a.loading = false;
                                          load();
                                          if (_items.length == 1) {
                                            _removeWidget();
                                          } else {
                                            removeItem(size, index);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
