import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/services/uber/delivery/provider/deli_tracking_pro.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../ln.dart';
import 'com/deli_sec_tile.dart';
import 'com/delivery_detail_dia.dart';

class TrackDeliveryView extends StatefulWidget {
  const TrackDeliveryView({super.key});

  @override
  State<TrackDeliveryView> createState() => _TrackDeliveryViewState();
}

class _TrackDeliveryViewState extends State<TrackDeliveryView> {
  late DeliTrackPro _dTPro;
  final refreshCltr = RefreshController(initialRefresh: false);

  Timer? _timer;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() {
    _dTPro = Provider.of<DeliTrackPro>(context, listen: false);
    _dTPro.getData();
    // _timer = Timer.periodic(Duration(seconds: 25), (_) {
    //   // print('------------');
    //   _dTPro.getTrackList(autoUpdate: true);
    // });
  }

  @override
  void dispose() {
    _dTPro.clearTrack();
    refreshCltr.dispose();
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final dTrcPro = Provider.of<DeliTrackPro>(context);
    return Processing(
      loading: dTrcPro.pageLoad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  if (GlobalCVP.getMainPage != MainPage.OrderPage)
                    GlobalCVP.setMainPage = MainPage.OrderPage;
                },
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: EdgeInsets.all(size.getW(12)),
                  child: Icon(
                    Icons.arrow_back,
                    size: size.getS(28),
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                LN.trackDelivery,
                style: TextStyle(
                  fontSize: size.getS(18),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          if (dTrcPro.deliTrackStatus?.deliveryTrackingStatus != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
              child: Wrap(
                spacing: size.getW(12.0),
                runSpacing: size.getH(12),
                children: List.generate(
                  dTrcPro.deliTrackStatus!.deliveryTrackingStatus!.length,
                  (index) => ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              dTrcPro.deliveryStatusIndex == index
                                  ? kSecondaryColor
                                  : Colors.white),
                          padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                              horizontal: size.getW(12),
                              vertical: size.getH(4)))),
                      onPressed: dTrcPro.pageLoad
                          ? null
                          : () {
                              dTrcPro.deliveryStatusIndex = index;
                              dTrcPro.pageLoad = true;
                              dTrcPro.notify;
                              dTrcPro.getTrackList();
                            },
                      child: Text(
                        dTrcPro.deliTrackStatus!.deliveryTrackingStatus![index]
                                .name ??
                            '',
                        style: TextStyle(
                          fontSize: size.getS(16),
                          color: dTrcPro.deliveryStatusIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ),
            ),
          Flexible(
            child: SmartRefresher(
                controller: refreshCltr,
                enablePullUp: true,
                onLoading: () {
                  dTrcPro
                      .getTrackList(page: dTrcPro.pageIndex + 1)
                      .then((value) => refreshCltr.loadComplete());
                },
                onRefresh: () {
                  dTrcPro
                      .getTrackList(page: 1)
                      .then((value) => refreshCltr.refreshCompleted());
                },
                child: dTrcPro.orderList.isEmpty && !dTrcPro.pageLoad
                    ? NoItemsSec(size: size, title: LN.noDeliveryOrderFound)
                    : SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            horizontal: size.getW(12), vertical: size.getH(12)),
                        child: Wrap(
                          spacing: size.getW(16),
                          runSpacing: size.getH(16),
                          children: [
                            ...List.generate(
                              dTrcPro.orderList.length,
                              (index) => DeliverySecTile(
                                trackData: dTrcPro.orderList[index],
                                onTap: () async {
                                  dTrcPro.pageLoad = true;
                                  dTrcPro.notify;
                                  final status = await dTrcPro.getTrackDetail(
                                      trackId: dTrcPro.orderList[index].id);
                                  if (status)
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return DeliveyDetailDia(
                                            dTrcPro: dTrcPro,
                                          );
                                        }).then((value) {
                                      dTrcPro.trackDetailRes = null;
                                    });

                                  dTrcPro.pageLoad = false;
                                  dTrcPro.notify;
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
          )
        ],
      ),
    );
  }
}
