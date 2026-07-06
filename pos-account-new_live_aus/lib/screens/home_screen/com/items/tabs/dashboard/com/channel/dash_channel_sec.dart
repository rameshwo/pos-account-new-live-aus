import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/dashboard/dashboard_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/dashboard/dashboard_pro.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import '../../../../../../../../ln.dart';
import 'dialogs/config_channel_dia.dart';

class DashChannelSec extends StatefulWidget {
  final DashboardPro dashPro;
  const DashChannelSec({
    super.key,
    required this.dashPro,
  });

  @override
  State<DashChannelSec> createState() => _DashChannelSecState();
}

class _DashChannelSecState extends State<DashChannelSec> {
  Future<void> _onConfigure(
    BuildContext context, {
    required bool isConnect,
    required AvailiableChannel channel,
  }) async {
    await widget.dashPro.getChannelFiterSec(channel.id);
    await showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              backgroundColor: Colors.white,
              titlePadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                ConfigChannelDia(
                  channel: channel,
                  isConnect: isConnect,
                ),
              ],
            ));
  }

  final ScrollController _scrollController = ScrollController();

  bool _scrollingDown = true;

  @override
  void initState() {
    super.initState();
    _scroll();
  }

  void _scroll() async {
    while (true) {
      await Future.delayed(Duration(seconds: 3));
      if (_scrollingDown) {
        if (_scrollController.hasClients)
          await _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(seconds: 10),
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
    final size = Ssize(context);
    final channels = widget.dashPro.dashboardRes?.availableChannels;
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: size.getH(16)),
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Row(
        children: [
          if (channels != null)
            ...List.generate(channels.length, (index) {
              if (GlobalCVP.isRetailStore &&
                  (channels[index].channelEnum == "5" ||
                      channels[index].channelEnum == "6")) {
                return SizedBox.shrink();
              } else
                return _channelSection(
                  size,
                  channel: channels[index],
                  connect: widget.dashPro.loading
                      ? null
                      : () {
                          if (channels[index].channelEnum == "1" ||
                              channels[index].channelEnum == "2") {
                            MsgDia.show(
                              context,
                              headerAnimation: true,
                              diaType: DiaType.info,
                              title: "Please contact Adminstator",
                              // desc: "Please contact Adminstator",
                              autoHideSecond: 2,
                            );
                          } else {
                            _onConfigure(
                              context,
                              isConnect: true,
                              channel: channels[index],
                            );
                          }
                        },
                  config: widget.dashPro.loading
                      ? null
                      : () {
                          _onConfigure(
                            context,
                            isConnect: false,
                            channel: channels[index],
                          );
                        },
                );
            }),
        ],
      ),
    );
  }

  Widget _channelSection(
    Ssize size, {
    AvailiableChannel? channel,
    Function()? connect,
    Function()? config,
  }) {
    final isConnected = channel?.isAvailableOnChannel ?? false;
    final showConfigure =
        channel?.channelEnum != "1" && channel?.channelEnum != "2";
    return Container(
      margin: EdgeInsets.only(right: size.getW(24)),
      width: size.getW(260),
      height: size.getH(240),
      decoration: BoxDecoration(
        color: isConnected
            ? kSecondaryColor.withAlpha(7)
            : Colors.red.withAlpha(7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (channel?.imageUrl != null)
                Padding(
                  padding:
                      EdgeInsets.only(left: size.getW(12), top: size.getH(16)),
                  child: CircleAvatar(
                    backgroundColor: kSecondaryColor,
                    radius: size.getS(32),
                    child: Padding(
                        padding: EdgeInsets.all(size.getS(2)),
                        child: CachedNetworkImage(
                          imageUrl: channel?.imageUrl ?? '',
                          height: 100,
                          width: 100,
                          placeholder: ImageError.load,
                          errorWidget: ImageError.icon,
                        )
                        //  Image.asset(imageUrl),
                        ),
                  ),
                ),
              Spacer(),
              if (isConnected && showConfigure)
                InkWell(
                  onTap: config,
                  borderRadius: BorderRadius.circular(100),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.build_circle_outlined,
                        color: kSecondaryColor, size: size.getS(36)),
                  ),
                )
            ],
          ),
          SizedBox(height: size.getH(12)),
          Padding(
            padding: EdgeInsets.only(left: size.getW(12)),
            child: Text(
              channel?.channelName ?? '',
              style: TextStyle(
                fontSize: size.getS(20),
                fontFamily: kFontFRegular,
                fontWeight: FontWeight.bold,
                color: kSecondaryColor,
              ),
            ),
          ),
          SizedBox(height: size.getH(4)),
          // Text(
          //   channel?.channelName ?? '',
          //   style: TextStyle(
          //     fontSize: size.getS(16),
          //     fontFamily: kFontFRegular,
          //     color: Colors.black54,
          //   ),
          // ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(
                left: size.getW(12),
                right: size.getW(12),
                bottom: size.getH(16)),
            decoration: BoxDecoration(
              color: isConnected
                  ? kSecondaryColor.withAlpha(60)
                  : Colors.red.withAlpha(60),
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: isConnected ? null : connect,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: EdgeInsets.only(left: size.getW(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isConnected ? LN.connected : LN.notConnected,
                      style: TextStyle(
                        fontSize: size.getS(18),
                        fontFamily: kFontFMedium,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: isConnected
                              ? kSecondaryColor
                              : Colors.red.shade700,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(size.getS(12)),
                        child: Icon(
                          isConnected ? Icons.check : Icons.add,
                          color: Colors.white,
                          size: size.getS(24),
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
