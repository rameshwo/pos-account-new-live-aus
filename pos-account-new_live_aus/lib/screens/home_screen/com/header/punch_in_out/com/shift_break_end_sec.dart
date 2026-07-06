// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:pos_account/config/responsive.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/date_format_keys.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/dashboard/punch_pro.dart';
import 'package:pos_account/screens/home_screen/com/cus_button_tabs.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'start_shift_sec.dart';

class ShiftUpdateSec extends StatefulWidget {
  final PunchPro punchPro;
  final Function() back;
  const ShiftUpdateSec({super.key, required this.punchPro, required this.back});

  @override
  State<ShiftUpdateSec> createState() => _ShiftUpdateSecState();
}

class _ShiftUpdateSecState extends State<ShiftUpdateSec> {
  final _pageCltr = PageController();
  int? _selectedTab;
  String? _breakId;

  void load() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _selectedTab = null;
    _pageCltr.dispose();
    super.dispose();
  }

  String _timeFormat(String? time) {
    if (time == null || time.isEmpty)
      return '';
    else
      return CAL_TIME_FORMAT
          .format(GET_DATE_FORMAT(widget.punchPro.dateFormat).parse(time));
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final kTabString = <String>[LN.takeBreak, LN.endShift];
    // final _selectedTextColor = ;
    //  final _uSselectedTextColor = ;
    //  final _selectedBackColor = ;
    //  final _uSselectedBackColor = ;
    final double _c = Responsive.isDesktop(context) ? 77.77 : 94;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SizeTransition(
              sizeFactor: animation,
              child: child,
            );
          },
          child:
              (widget.punchPro.shiftStatus?.takenBreaks?.isNotEmpty ?? false) &&
                      _selectedTab == null
                  ? Column(
                      key: ValueKey("124_$_selectedTab"),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.getH(24)),
                        Text(
                          LN.breakTaken,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: kFontFMedium,
                            fontSize: size.getS(20),
                          ),
                        ),
                        ...List.generate(
                            widget.punchPro.shiftStatus!.takenBreaks!.length,
                            (index) {
                          final _break =
                              widget.punchPro.shiftStatus!.takenBreaks![index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StartShiftSec.fadeBack(
                                size,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        _break.name ?? '',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: kFontFMedium,
                                          fontSize: size.getS(18),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "${_timeFormat(_break.start ?? '')} - ${_timeFormat(_break.end ?? '')}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: kFontFMedium,
                                          fontSize: size.getS(18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: size.getH(4)),
                            ],
                          );
                        })
                      ],
                    )
                  : Container(
                      alignment: Alignment.topLeft,
                      key: ValueKey("125_$_selectedTab"),
                    ),
        ),
        SizedBox(height: size.getH(24)),
        CusButtonTabs(
          kTabs: kTabString,
          size: size,
          selectedIndex: _selectedTab,
          selectedColor: Colors.red.shade700, // kSecondaryColor,
          selectedColorOpacity: 1,
          selectedTextColor: Colors.white,
          unSelectedTextColor: Colors.red.shade700,
          fontSize: 20,
          onTap: (p0) {
            if (_selectedTab == p0) {
              _selectedTab = null;
              _breakId = null;
              load();
              _pageCltr
                  .animateToPage(0,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut)
                  .then((value) => load());
              return;
            }
            if (_selectedTab != 1 && p0 == 1) {
              final startTime =
                  widget.punchPro.shiftStatus?.checkInTime?.isNotEmpty ?? false
                      ? GET_DATE_FORMAT(widget.punchPro.dateFormat)
                          .parse(widget.punchPro.shiftStatus?.checkInTime ?? '')
                      : null;
              if (startTime != null &&
                  DateTime.now().difference(startTime).abs().inSeconds <
                      15 * 60) {
                MsgDia.show(
                  context,
                  title: "Warning",
                  diaType: DiaType.warning,
                  desc: LN.endShiftWarning,
                  onOkay: () {
                    _selectedTab = p0;
                    _breakId = null;
                    load();
                    _pageCltr
                        .animateToPage(p0 + 1,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut)
                        .then((value) => load());
                  },
                  btnOkColor: kSecondaryColor,
                  autoHideSecond: 3,
                );
                return;
              }
            }
            _selectedTab = p0;
            _breakId = null;
            load();
            _pageCltr
                .animateToPage(p0 + 1,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut)
                .then((value) => load());
          },
        ),
        SizedBox(
          height: _pageCltr.hasClients
              ? (_pageCltr.page == 1
                  ? size.getH(2 * _c +
                      _c *
                          (widget.punchPro.shiftStatus?.storeBreaks?.length ??
                              1))
                  : _pageCltr.page == 2
                      ? size.getH(180)
                      : size.getH(50))
              : size.getH(50),
          child: PageView(
            controller: _pageCltr,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              Container(),
              _breakSection(size),
              _endShift(size),
            ],
          ),
        ),
        if (_pageCltr.hasClients && _pageCltr.page == 1) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LoadButton(
                btnText: LN.cancel,
                btnColor: Colors.white,
                textColor: Colors.red,
                width: 200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.red)),
                onsave: widget.punchPro.pageLoad
                    ? null
                    : () {
                        _selectedTab = null;
                        _breakId = null;
                        load();
                        _pageCltr.animateToPage(0,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut);
                      },
              ),
              SizedBox(width: size.getW(16)),
              LoadButton(
                loading: widget.punchPro.buttonLoad,
                btnText: LN.startBreak,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 200,
                hPad: 4,
                onsave: widget.punchPro.pageLoad
                    ? null
                    : () async {
                        // if (_breakId == null) {
                        //   showToast(LN.pleaseSelectBreak);
                        //   return;
                        // }
                        await widget.punchPro.startBreak(breakId: _breakId);
                        _breakId = null;
                        load();
                      },
              ),
            ],
          ),
          SizedBox(height: size.getH(24)),
        ] else if (_pageCltr.hasClients && _pageCltr.page == 2)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: LoadButton(
                  btnText: LN.cancel,
                  btnColor: Colors.white,
                  textColor: Colors.red,
                  width: 200,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.red)),
                  onsave: widget.punchPro.pageLoad
                      ? null
                      : () {
                          _selectedTab = null;
                          _breakId = null;
                          load();
                          _pageCltr.animateToPage(0,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut);
                        },
                ),
              ),
              SizedBox(width: size.getW(16)),
              Flexible(
                child: LoadButton(
                  loading: widget.punchPro.buttonLoad,
                  btnText: LN.endShift,
                  btnColor: Colors.red.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: 200,
                  hPad: 4,
                  onsave: widget.punchPro.pageLoad
                      ? null
                      : () {
                          final _isEarlyEnd =
                              (widget.punchPro.shiftStatus?.isShiftInToday ??
                                      false) &&
                                  (widget.punchPro.shiftStatus?.shiftEndTime
                                          ?.isNotEmpty ??
                                      false) &&
                                  GET_DATE_FORMAT(widget.punchPro.dateFormat)
                                          .parse(widget.punchPro.shiftStatus
                                                  ?.shiftEndTime ??
                                              '')
                                          .difference(DateTime.now())
                                          .inSeconds >
                                      15 * 60;

                          showDialog(
                              context: context,
                              builder: (_) {
                                return ConfirmDialog(
                                  title: _isEarlyEnd
                                      ? LN.earlyEndShift
                                      : LN.endShift,
                                  subTitle: _isEarlyEnd
                                      ? LN.doYouWantConfirmEarlier
                                      : LN.doYouWantConfirmEndShift,
                                  actionText: LN.confirm,
                                  cancelText: LN.cancel,
                                  onDelete: () async {
                                    widget.punchPro.checkOut();
                                    return true;
                                  },
                                  bottomRightWidget: _isEarlyEnd
                                      ? ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      kTempColor),
                                              padding: MaterialStateProperty
                                                  .all(EdgeInsets.symmetric(
                                                      horizontal: size.getW(12),
                                                      vertical: size.getH(8)))),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            widget.punchPro
                                                .checkOut(isComplete: false);
                                          },
                                          child: Text(
                                            LN.iWillBeBack,
                                            style: TextStyle(
                                              fontSize: size.getS(15),
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ))
                                      : null,
                                );
                              });
                        },
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _breakSection(Ssize size) {
    final punchPro = widget.punchPro;
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: size.getH(24)),
          // StartShiftSec.fadeBack(size,
          //     child: TimeDateSec(
          //       background: Colors.transparent,
          //       fontRatio: 0.45,
          //       isCenterAlign: false,
          //     )),
          SizedBox(height: size.getH(24)),
          Text(
            LN.selectBreaks,
            style: TextStyle(
              color: Colors.black,
              fontFamily: kFontFMedium,
              fontSize: size.getS(18),
              // height: 1,
            ),
          ),
          if (punchPro.shiftStatus?.storeBreaks?.isNotEmpty ?? false)
            ...List.generate(punchPro.shiftStatus!.storeBreaks!.length,
                (index) {
              final _break = punchPro.shiftStatus!.storeBreaks![index];
              final _isSelected = _breakId == _break.id;
              return SizedBox(
                width: size.getW(600),
                child: ListTile(
                  // minLeadingWidth: 40,
                  horizontalTitleGap: 0,
                  leading: Icon(
                    Icons.coffee,
                    color: _isSelected ? Colors.white : Colors.black54,
                    size: size.getS(32),
                  ),
                  title: Text(
                    (_break.name ?? '') +
                        (_break.isPaid! ? ' (${LN.paid})' : ' (${LN.unpaid})'),
                    style: TextStyle(
                      color: _isSelected ? Colors.white : Colors.black,
                      fontFamily: kFontFMedium,
                      fontSize: size.getS(20),
                      // height: 1,
                    ),
                  ),
                  subtitle: Text(
                    punchPro.shiftStatus?.shiftBreaks?.any((e) =>
                                e.name?.toLowerCase() ==
                                _break.name?.toLowerCase()) ??
                            false
                        ? LN.scheduled
                        : LN.unscheduled,
                    style: TextStyle(
                      color: _isSelected ? Colors.white : Colors.black54,
                      fontSize: size.getS(16),
                    ),
                  ),
                  onTap: () {
                    _breakId = _break.id;
                    load();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor:
                      _isSelected ? kSecondaryColor.withAlpha(200) : null,
                  trailing: Checkbox(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    activeColor: _isSelected ? Colors.white : kSecondaryColor,
                    checkColor: _isSelected ? kSecondaryColor : Colors.white,
                    value: _isSelected,
                    onChanged: (val) {
                      _breakId = _break.id;
                      load();
                    },
                  ),
                ),
              );
            })
          else
            Text(
              LN.noBreaksAvailable,
              style: TextStyle(
                color: Colors.black,
                fontFamily: kFontFMedium,
                fontSize: size.getS(18),
                // height: 1,
              ),
            ),
          SizedBox(height: size.getH(12)),
          TextFormWidget(
            borderColor: Colors.white,
            maxLines: 3,
            cltr: punchPro.noteCltr,
            hintText: LN.addNote,
          ),
          SizedBox(height: size.getH(32)),
        ],
      ),
    );
  }

  Widget _endShift(Ssize size) {
    final punchPro = widget.punchPro;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: size.getH(24)),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(top: size.getH(24)),
            child: TextFormWidget(
                borderColor: Colors.white,
                maxLines: 5,
                cltr: punchPro.noteCltr,
                hintText: LN.addNote),
          ),
        ),
        SizedBox(height: size.getH(32)),
        // Flexible(
        //   child: Padding(
        //     padding: EdgeInsets.only(top: size.getH(48)),
        //     child:
        //   ),
        // )
      ],
    );
  }
}
