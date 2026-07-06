import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pos_account/config/responsive.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/kitchen/kitchen_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/custom_drawer/com/logo_sec.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'com/kitchen_body.dart';
import 'com/kitchen_header.dart';

class KitchenScreen extends StatefulWidget {
  final CusValuePro cvp;
  final PlaceOrderPro? placeOrderPro;
  const KitchenScreen({
    super.key,
    required this.cvp,
    this.placeOrderPro,
  });

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  KitchenPro? kitPro;

  Timer? _timer;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() {
    kitPro = Provider.of<KitchenPro>(context, listen: false);
    kitPro?.getOrDeSec();
    _timer = Timer.periodic(Duration(seconds: 10), (_) {
      // print('------------');
      kitPro?.getData(autoUpdate: true);
    });
  }

  @override
  void dispose() {
    kitPro?.orderList.clear();
    kitPro?.clear();
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final kitPro = Provider.of<KitchenPro>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: kFlexLeft,
                  child: LogoSection(
                    size: size,
                  ),
                ),
                Expanded(
                    flex: kFlexMiddleProt,
                    child: Column(
                      children: [
                        SizedBox(height: size.getH(8)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Kitchen Display",
                              style: TextStyle(
                                fontSize: size.getS(20),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "(The orders will be refreshed in every 10 seconds)",
                              style: TextStyle(
                                fontSize: size.getS(14),
                                color: kTempColor,
                              ),
                            ),
                            SizedBox(
                              width: size.getW(12),
                            ),
                          ],
                        ),
                        // SizedBox(height: size.getH(8)),
                        // KitchenHeader(kitPro: _kitPro),
                      ],
                    ))
              ],
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: size.getH(Responsive.isDesktop(context) ? 54 : 64)),
                  child: KitchenHeader(kitPro: kitPro),
                ))
          ],
        ),
        // Padding(
        //   padding: EdgeInsets.only(bottom: size.isProt ? size.getH(40) : 0),
        //   child: HeaderSection(
        //     cvp: widget.cvp,
        //     placeOrderPro: widget.placeOrderPro,
        //     showEndDrawer: false,
        //   ),
        // ),

        if (kitPro.loading && kitPro.orderDetailSecRes == null)
          Expanded(child: Loading())
        else ...[
          // SizedBox(height: size.getH(8)),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: size.getS(12.0)),
          //   child: KitchenHeader(kitPro: _kitPro),
          // ),
          SizedBox(height: size.getH(12)),
          Flexible(child: KitchenBody())
        ],
        // Flexible(
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: size.getW(12.0)),
        //     child: Processing(
        //         loading: _kitPro.loading,
        //         align: Alignment.topLeft,
        //         child: NestedScrollView(
        //           floatHeaderSlivers: true,
        //           headerSliverBuilder: (ctx, _) => [
        //             SliverAppBar(
        //               automaticallyImplyLeading: false,
        //               excludeHeaderSemantics: true,
        //               // expandedHeight: size.getH(110),
        //               expandedHeight: SData<double>(data: [
        //                 size.getH(360),
        //                 size.getH(300),
        //                 size.getH(360),
        //                 size.getH(360),
        //                 size.getH(348),
        //                 size.getH(260),
        //                 size.getH(260),
        //                 size.getH(210),
        //                 size.getH(190),
        //               ]).get(context),
        //               backgroundColor: kBackgroundColor,
        //               shadowColor: Colors.transparent,
        //               floating: true,
        //               pinned: true,
        //               actions: [Container()],
        //               title: Row(
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: [
        //                   InkWell(
        //                     onTap: () {
        //                       if (GlobalCVP.getMainPage != MainPage.OrderPage)
        //                         GlobalCVP.setMainPage = MainPage.OrderPage;
        //                     },
        //                     child: Icon(
        //                       Icons.arrow_back,
        //                       size: size.getS(32),
        //                       color: Colors.black,
        //                     ),
        //                   ),
        //                   SizedBox(
        //                     width: size.getW(12),
        //                   ),
        //                   Text(
        //                     "Kitchen Screen",
        //                     style: TextStyle(
        //                       fontSize: size.getS(18),
        //                       // fontFamily: ,
        //                       fontWeight: FontWeight.bold,
        //                       color: Colors.black,
        //                     ),
        //                   ),
        //                   Spacer(),
        //                 ],
        //               ),
        //               flexibleSpace: FlexibleSpaceBar(
        //                 background: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   mainAxisSize: MainAxisSize.min,
        //                   children: [
        //                     SizedBox(
        //                       height: size.getH(50),
        //                     ),
        //                     if (_kitPro.orderDetailSecRes != null)
        //                       Flexible(child: KitchenHeader(kitPro: _kitPro))
        //                   ],
        //                 ),
        //               ),
        //             )
        //           ],
        //           body: KitchenBody(),
        //         )),
        //   ),
        // ),
      ],
    );
  }
}
