import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/ui_model/store_ui_model.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/store/store_pro_v2.dart';
import 'package:pos_account/widgets/input/dropdown/drop_down.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';
import '../../general/common/common_header.dart';

class OpenHourStoreV2 extends StatefulWidget {
  final PageController pageController;
  const OpenHourStoreV2({super.key, required this.pageController});

  @override
  State<OpenHourStoreV2> createState() => _OpenHourStoreV2State();
}

class _OpenHourStoreV2State extends State<OpenHourStoreV2> {
  late StoreProV2 storePro;

  List<String> _copyOpenHourValues(List<OpenHoursModel> target,
      List<OpenHoursModel> source, bool isDeleted) {
    for (int j = 0; j < source.length; j++) {
      if (j < target.length) {
        target[j].openTime = source[j].openTime;
        target[j].closeTime = source[j].closeTime;
        target[j].isOpen = source[j].isOpen;
      } else {
        target.add(OpenHoursModel(
          openTime: source[j].openTime,
          closeTime: source[j].closeTime,
          isOpen: source[j].isOpen,
        ));
      }
    }
    final removedIds = <String>[];
    if (target.length > source.length) {
      if (isDeleted) {
        for (int k = source.length; k < target.length; k++) {
          if (target[k].id.isNotEmpty) removedIds.add(target[k].id);
        }
      }
      target.removeRange(source.length, target.length);
    }
    return removedIds;
  }

  void onSelectPickAll(bool? val, bool isDeleted) {
    storePro.pickSelectAll = val ?? false;
    if (storePro.pickSelectAll) {
      for (int i = 0; i < storePro.pickHourList.length; i++) {
        final a = storePro.pickHourList[i];
        if (i != 0) {
          final removedIds = _copyOpenHourValues(
              a.openHourList, storePro.pickHourList[0].openHourList, isDeleted);
          if (isDeleted) {
            storePro.deletedPickIds.addAll(removedIds);
          }
        }
      }
    }

    storePro.notify;
  }

  void onSelectDeliAll(bool? val, bool isDeleted) {
    storePro.deliSelectAll = val ?? false;
    if (storePro.deliSelectAll) {
      for (int i = 0; i < storePro.deliveryHourList.length; i++) {
        final a = storePro.deliveryHourList[i];
        if (i != 0) {
          final removedIds = _copyOpenHourValues(a.openHourList,
              storePro.deliveryHourList[0].openHourList, isDeleted);
          if (isDeleted) {
            storePro.deletedDeliIds.addAll(removedIds);
          }
        }
      }
    }
    storePro.notify;
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() {
    final _storePro = Provider.of<StoreProV2>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _storePro.getAddSec();
      _storePro.getOpenHourData();
    });
  }

  @override
  void dispose() {
    storePro.loading = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    storePro = Provider.of<StoreProV2>(context);
    return Processing(
      loading: storePro.updateLoadOpenHour,
      child: Column(
        children: [
          CommonHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      widget.pageController.jumpToPage(0);
                    },
                    icon: Icon(Icons.arrow_back)),
                Text(
                  LN.openingHours,
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontFamily: kFontFMedium,
                  ),
                ),
                Spacer(),
                if (GlobalCVP.viewWidget.viewStoreOpeningTabSaveButton)
                  LoadButton(
                    vPad: 10,
                    hPad: 4,
                    loading: storePro.updateLoadOpenHour,
                    btnText: "Update",
                    loadingText: "Updating",
                    onsave: storePro.updateLoadOpenHour
                        ? null
                        : () {
                            FocusScope.of(context).unfocus();
                            storePro.updateOpenHour();
                          },
                  ),
                SizedBox(width: size.getW(12)),
              ],
            ),
          ),
          SizedBox(
            height: size.getH(12),
          ),
          Expanded(
              child: storePro.loading
                  ? Loading()
                  : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.getH(12),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: size.getH(12.0),
                                        horizontal: size.getW(16)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              LN.openingHours,
                                              style: TextStyle(
                                                fontSize: size.getS(20),
                                                fontFamily: kFontFRegular,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Spacer(),
                                            Checkbox(
                                              value: storePro.pickSelectAll,
                                              onChanged: (val) =>
                                                  onSelectPickAll(val, false),
                                            ),
                                            InkWell(
                                              onTap: () => onSelectPickAll(
                                                  !storePro.pickSelectAll,
                                                  false),
                                              child: Text(
                                                LN.changeAll,
                                                style: TextStyle(
                                                  fontSize: size.getS(16),
                                                  fontFamily: kFontFRegular,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(
                                        //   height: size.getH(12),
                                        // ),
                                        // _STOHTitle(size: size),
                                        if (storePro.openHourData
                                                ?.pickUpHoursAddViewModels !=
                                            null)
                                          ...List.generate(
                                            storePro.pickHourList.length,
                                            (index) {
                                              final disable =
                                                  storePro.pickSelectAll &&
                                                      index != 0;
                                              return Opacity(
                                                opacity: disable ? 0.5 : 1,
                                                child: _STOHTile(
                                                  size: size,
                                                  openWeek: storePro
                                                      .pickHourList[index],
                                                  timeRanges: storePro
                                                      .storeRes?.timeRanges,
                                                  onChange: (
                                                      {String? deletedId}) {
                                                    if (disable) return;

                                                    if (deletedId?.isNotEmpty ??
                                                        false) {
                                                      storePro.deletedPickIds
                                                          .add(deletedId!);
                                                    }

                                                    // storePro.notify();
                                                    onSelectPickAll(
                                                        storePro.pickSelectAll,
                                                        deletedId?.isNotEmpty ??
                                                            false);

                                                    return;
                                                  },
                                                ),
                                              );
                                            },
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: size.getH(12.0),
                                        horizontal: size.getW(16)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              LN.deliveryHours,
                                              style: TextStyle(
                                                fontSize: size.getS(20),
                                                fontFamily: kFontFRegular,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Spacer(),
                                            Checkbox(
                                              value: storePro.deliSelectAll,
                                              onChanged: (val) =>
                                                  onSelectPickAll(val, false),
                                            ),
                                            InkWell(
                                              onTap: () => onSelectDeliAll(
                                                  !storePro.deliSelectAll,
                                                  false),
                                              child: Text(
                                                LN.changeAll,
                                                style: TextStyle(
                                                  fontSize: size.getS(16),
                                                  fontFamily: kFontFRegular,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(
                                        //   height: size.getH(12),
                                        // ),
                                        // _STOHTitle(size: size),
                                        if (storePro.openHourData
                                                ?.deliveryHoursAddViewModels !=
                                            null)
                                          ...List.generate(
                                              storePro.deliveryHourList.length,
                                              (index) {
                                            final disable =
                                                storePro.deliSelectAll &&
                                                    index != 0;
                                            return Opacity(
                                              opacity: disable ? 0.5 : 1,
                                              child: _STOHTile(
                                                size: size,
                                                openWeek: storePro
                                                    .deliveryHourList[index],
                                                timeRanges: storePro
                                                    .storeRes?.timeRanges,
                                                onChange: (
                                                    {String? deletedId}) {
                                                  if (disable) return;

                                                  if (deletedId?.isNotEmpty ??
                                                      false) {
                                                    storePro.deletedDeliIds
                                                        .add(deletedId!);
                                                  }

                                                  // storePro.notify();

                                                  onSelectDeliAll(
                                                      storePro.deliSelectAll,
                                                      deletedId?.isNotEmpty ??
                                                          false);

                                                  return;
                                                },
                                              ),
                                            );
                                          })
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.getH(24),
                          ),
                          SizedBox(
                            height: size.getH(12),
                          ),
                        ],
                      ),
                    ))
        ],
      ),
    );
  }
}

class _STOHTile extends StatelessWidget {
  const _STOHTile({
    required this.size,
    // required this.openingHours,
    this.onChange,
    // this.onTap,
    this.timeRanges,
    required this.openWeek,
  });

  final Ssize size;
  final OpenWeekModel openWeek;
  // final HoursSettingsAddViewModel openingHours;
  final List<TableLocation>? timeRanges;
  // final Function({required bool isOpenType, required int timeIndex})? onTap;
  final Function({String? deletedId})? onChange;

  @override
  Widget build(BuildContext context) {
    final openHourList = openWeek.openHourList;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: DottedBorder(
        borderType: BorderType.RRect,
        padding: EdgeInsets.symmetric(
            vertical: size.getH(6), horizontal: size.getW(4)),
        color: Colors.black45,
        radius: Radius.circular(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              child: Text(
                openWeek.weekName,
                style: TextStyle(
                  fontSize: size.getS(18),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4),
                    child: Text(
                      'Open Time',
                      style: TextStyle(
                        fontSize: size.getS(18),
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Text(
                    'Close Time',
                    style: TextStyle(
                      fontSize: size.getS(18),
                      // fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )),
                Expanded(
                    child: Center(
                  child: Text(
                    'Open',
                    style: TextStyle(
                      fontSize: size.getS(18),
                      // fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )),
                SizedBox(width: size.getW(100)),
              ],
            ),
            ...List.generate(openHourList.length, (i) {
              return Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: DropDownList(
                        list: timeRanges == null || timeRanges!.isEmpty
                            ? []
                            : timeRanges!.map((e) => e.value ?? '').toList(),
                        vPad: 6,
                        errH: 0,
                        indexValue: openHourList[i].openTime.isEmpty ||
                                timeRanges == null
                            ? null
                            : timeRanges!.indexWhere(
                                (e) => e.value == openHourList[i].openTime),
                        onChange: (p0) {
                          if (p0 == null) return;
                          openHourList[i].openTime =
                              timeRanges?[p0].value ?? '';
                          onChange!();
                          // if (onTap != null)
                          //   onTap!(isOpenType: true, timeIndex: p0);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: DropDownList(
                        list: timeRanges == null || timeRanges!.isEmpty
                            ? []
                            : timeRanges!.map((e) => e.value ?? '').toList(),
                        vPad: 6,
                        errH: 0,
                        indexValue: openHourList[i].closeTime.isEmpty ||
                                timeRanges == null
                            ? null
                            : timeRanges!.indexWhere(
                                (e) => e.value == openHourList[i].closeTime),
                        onChange: (p0) {
                          if (p0 == null) return;
                          openHourList[i].closeTime =
                              timeRanges?[p0].value ?? '';
                          onChange!();
                          // if (onTap != null)
                          //   onTap!(isOpenType: false, timeIndex: p0);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: SwitchAdap(
                      size: size,
                      height: 32,
                      value: openHourList[i].isOpen,
                      onChanged: (val) {
                        openHourList[i].isOpen = val;
                        onChange!();
                      },
                      activeColor: kSecondaryColor,
                    ),
                  ),
                  Row(
                    children: [
                      if (openHourList.length > 1)
                        InkWell(
                          onTap: () {
                            final deletedId = openHourList[i].id;
                            openHourList.removeAt(i);
                            onChange!(deletedId: deletedId);
                          },
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                              padding: EdgeInsets.all(size.getS(4)),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.withAlpha(60),
                              ),
                              child: Icon(Icons.delete_outline,
                                  color: Colors.red.shade700,
                                  size: size.getS(28))),
                        )
                      else
                        SizedBox(width: size.getW(36)),
                      SizedBox(width: size.getW(16)),
                      if (i == 0)
                        InkWell(
                          onTap: () {
                            openHourList.add(OpenHoursModel(
                              closeTime: '',
                              openTime: '',
                            ));
                            onChange!();
                          },
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                              padding: EdgeInsets.all(size.getS(4)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kSecondaryColor,
                              ),
                              child: Icon(Icons.add,
                                  color: Colors.white, size: size.getS(28))),
                        )
                      else
                        SizedBox(width: size.getW(36)),
                      SizedBox(width: size.getW(16)),
                    ],
                  )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
